import 'package:flutter_test/flutter_test.dart';
import 'package:dato/features/quotes/domain/quote.dart';

void main() {
  group('Calculs de devis', () {
    test('grandTotal = Σ sections + Σ rubriques (forfait + formule)', () {
      const q = Quote(
        id: '1',
        number: 'DV-2026-014',
        date: '2026-05-12',
        object: 'Test',
        client: 'Client X',
        status: QuoteStatus.draft,
        companyId: 'c1',
        signatures: [],
        sections: [
          Section(id: 's1', title: 'Matériel', lines: [
            SectionLine(id: 'l1', designation: 'Planches', qty: 60, pu: 6000), // 360000
            SectionLine(id: 'l2', designation: 'Colle', qty: 10, pu: 3000), // 30000
          ]),
        ],
        rubriques: [
          Rubrique(id: 'r1', label: 'Transport', lines: [
            RubriqueLine(id: 'rl1', mode: RubriqueMode.forfait, amount: 50000),
          ]),
          Rubrique(id: 'r2', label: 'Usinage', lines: [
            RubriqueLine(id: 'rl2', mode: RubriqueMode.formula, a: 1500, b: 40), // 60000
          ]),
        ],
      );

      expect(q.sections.first.total, 390000);
      expect(q.grandTotal, 500000); // 390000 + 50000 + 60000
    });

    test('pt d\'une ligne = qty × pu', () {
      const line = SectionLine(id: 'x', designation: 'D', qty: 7, pu: 1500);
      expect(line.pt, 10500);
    });

    test('rubrique multi-lignes : forfait + formule additionnés', () {
      const r = Rubrique(id: 'r', label: 'Mixte', lines: [
        RubriqueLine(id: 'a', mode: RubriqueMode.forfait, amount: 25000),
        RubriqueLine(id: 'b', mode: RubriqueMode.formula, a: 2000, b: 12), // 24000
      ]);
      expect(r.total, 49000);
    });

    test('isValid exige un client non vide', () {
      const base = Quote(
        id: '1', number: 'n', date: 'd', object: 'o', client: '  ',
        status: QuoteStatus.draft, companyId: 'c1',
        sections: [], rubriques: [], signatures: [],
      );
      expect(base.isValid, isFalse);
      expect(base.copyWith(client: 'Jean').isValid, isTrue);
    });

    test('copyWith remplace sections sans muter l\'original', () {
      const q = Quote(
        id: '1', number: 'n', date: 'd', object: 'o', client: 'c',
        status: QuoteStatus.draft, companyId: 'c1',
        sections: [
          Section(id: 's1', title: 'A', lines: [
            SectionLine(id: 'l1', designation: 'x', qty: 1, pu: 1000),
          ]),
        ],
        rubriques: [], signatures: [],
      );
      final q2 = q.copyWith(sections: []);
      expect(q.grandTotal, 1000);
      expect(q2.grandTotal, 0);
      expect(q2.id, '1');
    });
  });
}
