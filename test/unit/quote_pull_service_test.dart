import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:mocktail/mocktail.dart';

import 'package:dato/core/network/token_storage.dart';
import 'package:dato/data/local/mappers.dart';
import 'package:dato/data/local/models/article_model.dart';
import 'package:dato/data/local/models/binary_asset.dart';
import 'package:dato/data/local/models/company_model.dart';
import 'package:dato/data/local/models/quote_model.dart';
import 'package:dato/data/remote/quote_remote_data_source.dart';
import 'package:dato/data/sync/connectivity_service.dart';
import 'package:dato/data/sync/quote_pull_service.dart';
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

/// Pull = restore réel via Isar natif (skip propre si binaire indisponible).
void main() {
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
      final dir = await Directory.systemTemp.createTemp('isar_pull_test');
      isar = await Isar.open(
        [
          QuoteModelSchema,
          CompanyModelSchema,
          ArticleModelSchema,
          BinaryAssetSchema,
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

  test('restaure les devis manquants, ignore ceux déjà locaux', () async {
    if (!available || isar == null) {
      markTestSkipped('Isar core natif indisponible');
      return;
    }
    final db = isar!;
    // 's1' existe déjà localement.
    await db.writeTxn(() => db.quoteModels.putByQuoteId(quoteToModel(_q('s1'))));

    final remote = _MockRemote();
    when(() => remote.fetchSummaries()).thenAnswer(
      (_) async => [
        {'id': 's1'},
        {'id': 's2'},
      ],
    );
    when(() => remote.fetchOne(any(), companyId: any(named: 'companyId')))
        .thenAnswer((inv) async => _q(inv.positionalArguments.first as String));

    final storage = _MockTokenStorage();
    when(() => storage.getAccessToken()).thenAnswer((_) async => 'tok');

    final service = QuotePullService(
      remote: remote,
      isar: db,
      connectivity: _OnlineConnectivity(),
      tokenStorage: storage,
    );
    await service.pull(companyId: 'c');

    expect(db.quoteModels.getByQuoteIdSync('s1'), isNotNull);
    expect(db.quoteModels.getByQuoteIdSync('s2'), isNotNull);
    // Un seul fetch complet : 's1' (déjà local) a été ignoré.
    verify(() => remote.fetchOne(any(), companyId: any(named: 'companyId')))
        .called(1);
  }, timeout: const Timeout(Duration(minutes: 2)));

  test('non authentifié : ne contacte pas le serveur', () async {
    if (!available || isar == null) {
      markTestSkipped('Isar core natif indisponible');
      return;
    }
    final remote = _MockRemote();
    final storage = _MockTokenStorage();
    when(() => storage.getAccessToken()).thenAnswer((_) async => null);

    final service = QuotePullService(
      remote: remote,
      isar: isar!,
      connectivity: _OnlineConnectivity(),
      tokenStorage: storage,
    );
    await service.pull(companyId: 'c');

    verifyNever(() => remote.fetchSummaries());
  }, timeout: const Timeout(Duration(minutes: 2)));
}
