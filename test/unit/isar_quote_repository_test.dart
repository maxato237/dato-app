import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

import 'package:dato/data/local/isar_quote_repository.dart';
import 'package:dato/data/local/mappers.dart';
import 'package:dato/data/local/models/article_model.dart';
import 'package:dato/data/local/models/binary_asset.dart';
import 'package:dato/data/local/models/company_model.dart';
import 'package:dato/data/local/models/quote_model.dart';
import 'package:dato/features/library/domain/article.dart';

import '../fixtures/sample_quote.dart';

/// Round-trip Isar **réel** (binaire natif). Téléchargé à la volée via
/// `initializeIsarCore` ; le test est ignoré proprement si indisponible
/// (environnement hors-ligne), sans faire échouer la suite.
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
      final dir = await Directory.systemTemp.createTemp('isar_dato_test');
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

  test('persiste et relit un devis riche complet', () async {
    if (!available || isar == null) {
      markTestSkipped('Isar core natif indisponible');
      return;
    }
    final repo = IsarQuoteRepository(isar!);
    final q = sampleQuote();

    await repo.save(q);

    final read = repo.getById(q.id);
    expect(read, isNotNull);
    expect(read!.client, 'Client Démo');
    expect(read.sections.first.lines.length, 3);
    expect(read.rubriques.length, 2);
    expect(read.grandTotal, q.grandTotal);

    // upsert (pas de doublon) + lecture liste
    await repo.save(q.copyWith(client: 'Nouveau Client'));
    expect(repo.getAll().length, 1);
    expect(repo.getById(q.id)!.client, 'Nouveau Client');

    await repo.delete(q.id);
    expect(repo.getById(q.id), isNull);
    expect(repo.getAll(), isEmpty);
  }, timeout: const Timeout(Duration(minutes: 2)));

  test('persiste une entreprise et des articles', () async {
    if (!available || isar == null) {
      markTestSkipped('Isar core natif indisponible');
      return;
    }
    final db = isar!;
    await db.writeTxn(() async {
      await db.companyModels.putByCompanyId(companyToModel(sampleCompany()));
      await db.articleModels.putAll([
        articleToModel(const Article(id: 'a1', name: 'Planches', pu: 6000)),
      ]);
    });
    expect(db.companyModels.where().findFirstSync()!.name, 'ATELIER DÉMO');
    expect(db.articleModels.getByArticleIdSync('a1')!.pu, 6000);
  }, timeout: const Timeout(Duration(minutes: 2)));
}
