import 'package:flutter_test/flutter_test.dart';

import 'package:dato/data/local/mappers.dart';
import 'package:dato/features/library/domain/article.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import 'package:dato/features/settings/domain/company.dart';

import '../fixtures/sample_quote.dart';

void main() {
  group('Mappers domaine ↔ Isar', () {
    test('Quote → model → Quote conserve la structure riche et le statut', () {
      final q = sampleQuote().copyWith(status: QuoteStatus.refused);
      final m = quoteToModel(q);

      // Colonnes dénormalisées (listes/tri/filtre).
      expect(m.quoteId, q.id);
      expect(m.number, q.number);
      expect(m.status, 'rejected');
      expect(m.grandTotal, q.grandTotal);

      // Reconstruction depuis le snapshot documentJson.
      final back = quoteToDomain(m);
      expect(back.id, q.id);
      expect(back.status, QuoteStatus.refused);
      expect(back.sections.first.lines.length, 3);
      expect(back.rubriques.length, 2);
      expect(back.grandTotal, q.grandTotal);
      expect(back.rubriques.first.lines.first.mode, RubriqueMode.formula);
      expect(back.rubriques.first.lines.first.a, 1500);
      expect(back.rubriques.last.lines.first.amount, 50000);
    });

    test('Company round-trip', () {
      const c = Company(
        id: 'c1',
        name: 'ACME',
        activity: 'BTP',
        address: 'Rue X',
        phones: '600 / 601',
        city: 'Yaoundé',
        currency: 'FCFA',
        logoUrl: 'http://h/logo.png',
        location: 'Nkolfoulou',
        templateDocxUrl: 'http://h/t.docx',
      );
      final back = companyToDomain(companyToModel(c));
      expect(back.id, 'c1');
      expect(back.name, 'ACME');
      expect(back.phones, '600 / 601');
      expect(back.logoUrl, 'http://h/logo.png');
      expect(back.templateDocxUrl, 'http://h/t.docx');
    });

    test('Article round-trip', () {
      const a = Article(id: 'a1', name: 'Planches', pu: 6000);
      final back = articleToDomain(articleToModel(a));
      expect(back.id, 'a1');
      expect(back.name, 'Planches');
      expect(back.pu, 6000);
    });
  });
}
