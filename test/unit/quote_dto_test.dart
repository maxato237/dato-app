import 'package:flutter_test/flutter_test.dart';

import 'package:dato/features/quotes/data/quote_dto.dart';
import 'package:dato/features/quotes/domain/quote.dart';

import '../fixtures/sample_quote.dart';

void main() {
  group('Sérialisation devis ↔ backend', () {
    test('document_json round-trip : structure et statut conservés', () {
      final q = sampleQuote().copyWith(status: QuoteStatus.refused);
      final back =
          quoteFromDocumentJson(q.toDocumentJson(), companyId: q.companyId);

      expect(back.id, q.id);
      expect(back.number, q.number);
      expect(back.status, QuoteStatus.refused);
      expect(back.sections.length, 1);
      expect(back.sections.first.lines.length, 3);
      expect(back.rubriques.length, 2);
      expect(back.grandTotal, q.grandTotal);

      final formula = back.rubriques.first.lines.first;
      expect(formula.mode, RubriqueMode.formula);
      expect(formula.a, 1500);
      expect(formula.b, 40);
      final forfait = back.rubriques.last.lines.first;
      expect(forfait.mode, RubriqueMode.forfait);
      expect(forfait.amount, 50000);
    });

    test('statut refused ↦ rejected (et retour)', () {
      expect(quoteStatusToServer(QuoteStatus.refused), 'rejected');
      expect(quoteStatusFromServer('rejected'), QuoteStatus.refused);
      expect(quoteStatusFromServer(null), QuoteStatus.draft);
    });

    test('toFlatItems : somme des lignes = grandTotal', () {
      final q = sampleQuote();
      final items = q.toFlatItems();
      expect(items.length, 5); // 3 lignes section + 2 rubriques

      final total = items.fold<double>(
        0,
        (s, it) => s + (it['quantity'] as num) * (it['unit_price'] as num),
      );
      expect(total, q.grandTotal);
    });

    test('PublicQuote.fromJson privilégie document_json', () {
      final q = sampleQuote();
      final payload = {
        ...q.toUpdateBody(), // contient document_json + items
        'number': q.number,
        'company': {
          'id': 'c1',
          'name': 'ACME',
          'phones': ['+237600000000'],
        },
      };

      final pq = PublicQuote.fromJson(payload);
      expect(pq.company.name, 'ACME');
      expect(pq.quote.sections.first.lines.length, 3);
      expect(pq.quote.rubriques.length, 2);
      expect(pq.quote.grandTotal, q.grandTotal);
    });

    test('PublicQuote.fromJson : repli sur items plats si pas de snapshot', () {
      final payload = {
        'id': 'x1',
        'number': 'DEV-001',
        'title': 'Travaux',
        'status': 'sent',
        'created_at': '2026-02-03T10:00:00',
        'items': [
          {'description': 'Pose', 'quantity': 2, 'unit_price': 1500},
        ],
        'company': {'id': 'c', 'name': 'Boîte', 'phones': <String>[]},
      };

      final pq = PublicQuote.fromJson(payload);
      expect(pq.quote.object, 'Travaux');
      expect(pq.quote.status, QuoteStatus.sent);
      expect(pq.quote.sections.first.lines.single.designation, 'Pose');
      expect(pq.quote.grandTotal, 3000);
    });

    test('quoteFromServerDict privilégie document_json', () {
      final q = sampleQuote();
      final data = {...q.toUpdateBody(), 'number': q.number};
      final back = quoteFromServerDict(data, companyId: 'c');
      expect(back.sections.first.lines.length, 3);
      expect(back.rubriques.length, 2);
      expect(back.grandTotal, q.grandTotal);
    });

    test('quoteFromServerDict : repli sur items plats', () {
      final data = {
        'id': 'x',
        'number': 'DEV-009',
        'title': 'Travaux',
        'status': 'draft',
        'created_at': '2026-01-01T00:00:00',
        'items': [
          {'description': 'Pose', 'quantity': 2, 'unit_price': 1000},
        ],
      };
      final back = quoteFromServerDict(data, companyId: 'c');
      expect(back.sections.first.lines.single.designation, 'Pose');
      expect(back.grandTotal, 2000);
    });
  });
}
