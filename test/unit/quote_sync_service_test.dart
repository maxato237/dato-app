import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:dato/core/network/api_exception.dart';
import 'package:dato/core/network/token_storage.dart';
import 'package:dato/data/remote/quote_remote_data_source.dart';
import 'package:dato/data/sync/connectivity_service.dart';
import 'package:dato/data/sync/quote_sync_service.dart';
import 'package:dato/data/sync/sync_op.dart';
import 'package:dato/data/sync/sync_queue.dart';
import 'package:dato/features/quotes/domain/quote.dart';

class _MockRemote extends Mock implements QuoteRemoteDataSource {}

class _MockTokenStorage extends Mock implements TokenStorage {}

/// Connectivité contrôlable : `online` pilote `isOnline()`.
class _FakeConnectivity implements ConnectivityService {
  _FakeConnectivity(this.online);
  bool online;
  @override
  Future<bool> isOnline() async => online;
  @override
  Stream<bool> watch() => const Stream.empty();
}

Quote _quote(String id) => Quote(
      id: id,
      number: 'DV-$id',
      date: '2026-01-01',
      object: 'Objet $id',
      client: 'Client',
      status: QuoteStatus.draft,
      companyId: 'c',
      sections: const [],
      rubriques: const [],
      signatures: const [],
    );

void main() {
  setUpAll(() => registerFallbackValue(_quote('fallback')));

  late SyncQueue queue;
  late _MockRemote remote;
  late _MockTokenStorage storage;
  late _FakeConnectivity conn;
  late List<String> calls;

  QuoteSyncService build() => QuoteSyncService(
        queue: queue,
        remote: remote,
        connectivity: conn,
        tokenStorage: storage,
      );

  setUp(() {
    queue = InMemorySyncQueue();
    remote = _MockRemote();
    storage = _MockTokenStorage();
    conn = _FakeConnectivity(true);
    calls = [];

    when(() => storage.getAccessToken()).thenAnswer((_) async => 'token');
    when(() => remote.upsert(any())).thenAnswer((inv) async {
      calls.add('upsert:${(inv.positionalArguments.first as Quote).id}');
    });
    when(() => remote.delete(any())).thenAnswer((inv) async {
      calls.add('delete:${inv.positionalArguments.first}');
    });
  });

  group('QuoteSyncService', () {
    test('rejoue les opérations en attente DANS L\'ORDRE au drain', () async {
      queue.enqueue(UpsertQuoteOp(_quote('a')));
      queue.enqueue(UpsertQuoteOp(_quote('b')));
      queue.enqueue(const DeleteQuoteOp('c'));

      await build().drain();

      expect(calls, ['upsert:a', 'upsert:b', 'delete:c']);
      expect(queue.isEmpty, isTrue);
    });

    test('hors-ligne : ne synchronise pas ; au retour réseau : vide la file',
        () async {
      conn.online = false;
      final service = build();
      queue.enqueue(UpsertQuoteOp(_quote('a')));

      await service.drain();
      expect(queue.length, 1); // resté en file
      verifyNever(() => remote.upsert(any()));

      conn.online = true;
      await service.drain();
      expect(queue.isEmpty, isTrue);
      verify(() => remote.upsert(any())).called(1);
    });

    test('non authentifié : ne synchronise pas', () async {
      when(() => storage.getAccessToken()).thenAnswer((_) async => null);
      queue.enqueue(UpsertQuoteOp(_quote('a')));

      await build().drain();

      expect(queue.length, 1);
      verifyNever(() => remote.upsert(any()));
    });

    test('coalescence : une suppression remplace l\'upsert du même devis',
        () async {
      queue.enqueue(UpsertQuoteOp(_quote('a')));
      queue.enqueue(const DeleteQuoteOp('a'));
      expect(queue.length, 1);

      await build().drain();

      expect(calls, ['delete:a']);
    });

    test(
        'erreur permanente retirée, transitoire conservée (bloque la suite)',
        () async {
      when(() => remote.upsert(any())).thenAnswer((inv) async {
        final id = (inv.positionalArguments.first as Quote).id;
        if (id == 'bad') throw const ApiException('invalide', statusCode: 422);
        if (id == 'net') throw const ApiException('réseau'); // statusCode null
        calls.add('upsert:$id');
      });

      queue.enqueue(UpsertQuoteOp(_quote('bad')));
      queue.enqueue(UpsertQuoteOp(_quote('net')));
      queue.enqueue(UpsertQuoteOp(_quote('ok')));

      await build().drain();

      // 'bad' (permanente) retirée ; 'net' (transitoire) bloque → reste [net, ok].
      expect(queue.pending.map((o) => o.quoteId).toList(), ['net', 'ok']);
      expect(calls, isEmpty); // 'ok' jamais atteint (bloqué derrière 'net')
    });
  });
}
