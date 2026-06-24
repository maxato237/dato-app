import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:mocktail/mocktail.dart';

import 'package:dato/core/network/token_storage.dart';
import 'package:dato/data/local/mappers.dart';
import 'package:dato/data/local/models/article_model.dart';
import 'package:dato/data/local/models/binary_asset.dart';
import 'package:dato/data/local/models/company_model.dart';
import 'package:dato/data/local/models/pending_sync_op.dart';
import 'package:dato/data/local/models/quote_model.dart';
import 'package:dato/data/remote/quote_remote_data_source.dart';
import 'package:dato/data/sync/connectivity_service.dart';
import 'package:dato/data/sync/isar_sync_queue.dart';
import 'package:dato/data/sync/quote_sync_service.dart';
import 'package:dato/data/sync/sync_op.dart';
import 'package:dato/features/quotes/domain/quote.dart';

class _MockRemote extends Mock implements QuoteRemoteDataSource {}

class _MockTokenStorage extends Mock implements TokenStorage {}

class _OnlineConnectivity implements ConnectivityService {
  @override
  Future<bool> isOnline() async => true;
  @override
  Stream<bool> watch() => const Stream.empty();
}

Quote _q(String id) => Quote(
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

/// File de sync durable : persistance réelle via Isar natif (skip si indispo).
void main() {
  setUpAll(() => registerFallbackValue(_q('fb')));

  Isar? isar;
  var available = true;

  setUpAll(() async {
    try {
      await Isar.initializeIsarCore(download: true);
    } catch (_) {
      available = false;
    }
  });

  setUp(() async {
    if (!available) return;
    try {
      final dir = await Directory.systemTemp.createTemp('isar_queue_test');
      isar = await Isar.open(
        [
          QuoteModelSchema,
          CompanyModelSchema,
          ArticleModelSchema,
          BinaryAssetSchema,
          PendingSyncOpSchema,
        ],
        directory: dir.path,
      );
    } catch (_) {
      available = false;
    }
  });

  tearDown(() async {
    final i = isar;
    if (i != null) {
      await i.close(deleteFromDisk: true);
      isar = null;
    }
  });

  bool skip() {
    if (!available || isar == null) {
      markTestSkipped('Isar core natif indisponible');
      return true;
    }
    return false;
  }

  test('persiste les ops et survit à un « redémarrage », dans l\'ordre', () {
    if (skip()) return;
    final db = isar!;
    db.writeTxnSync(() => db.quoteModels.putByQuoteIdSync(quoteToModel(_q('q1'))));

    IsarSyncQueue(db)
      ..enqueue(UpsertQuoteOp(_q('q1')))
      ..enqueue(const DeleteQuoteOp('q2'));

    // Nouvelle instance sur la même base = simulation d'un redémarrage d'app.
    final reopened = IsarSyncQueue(db);
    expect(reopened.length, 2);
    expect(reopened.pending.map((o) => o.quoteId).toList(), ['q1', 'q2']);
    expect(reopened.head, isA<UpsertQuoteOp>());
  });

  test('coalescence : un delete remplace l\'upsert du même devis', () {
    if (skip()) return;
    final queue = IsarSyncQueue(isar!)
      ..enqueue(UpsertQuoteOp(_q('q1')))
      ..enqueue(const DeleteQuoteOp('q1'));
    expect(queue.length, 1);
    expect(queue.head, isA<DeleteQuoteOp>());
  });

  test('upsert d\'un devis disparu est auto-nettoyé', () {
    if (skip()) return;
    final queue = IsarSyncQueue(isar!)..enqueue(UpsertQuoteOp(_q('ghost')));
    expect(queue.head, isNull); // pas de QuoteModel 'ghost' → op retirée
    expect(queue.isEmpty, isTrue);
  });

  test('le service draine puis vide la file durable', () async {
    if (skip()) return;
    final db = isar!;
    db.writeTxnSync(() => db.quoteModels.putByQuoteIdSync(quoteToModel(_q('q1'))));

    final queue = IsarSyncQueue(db)
      ..enqueue(UpsertQuoteOp(_q('q1')))
      ..enqueue(const DeleteQuoteOp('q2'));

    final remote = _MockRemote();
    when(() => remote.upsert(any())).thenAnswer((_) async {});
    when(() => remote.delete(any())).thenAnswer((_) async {});
    final storage = _MockTokenStorage();
    when(() => storage.getAccessToken()).thenAnswer((_) async => 'tok');

    final service = QuoteSyncService(
      queue: queue,
      remote: remote,
      connectivity: _OnlineConnectivity(),
      tokenStorage: storage,
    );
    await service.drain();

    expect(queue.isEmpty, isTrue);
    verify(() => remote.upsert(any())).called(1);
    verify(() => remote.delete('q2')).called(1);
  }, timeout: const Timeout(Duration(minutes: 2)));
}
