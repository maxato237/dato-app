import 'package:flutter_test/flutter_test.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import 'package:dato/features/quotes/providers/quotes_list_controller.dart';

Quote _q(String id, String object, String client, QuoteStatus status,
        {String date = '2026-06-10', int total = 0}) =>
    Quote(
      id: id,
      number: 'DV-$id',
      date: date,
      object: object,
      client: client,
      status: status,
      companyId: 'c',
      sections: const [],
      rubriques: [
        Rubrique(id: 'r-$id', label: 'M', lines: [
          RubriqueLine(
              id: 'rl-$id',
              mode: RubriqueMode.forfait,
              amount: total.toDouble()),
        ]),
      ],
      signatures: const [],
    );

void main() {
  final quotes = [
    _q('1', 'Fabrication de chaises', 'Client Alpha', QuoteStatus.sent),
    _q('2', 'Fourniture de madriers', 'Client Beta', QuoteStatus.accepted),
    _q('3', 'Placards sur mesure', 'Client Gamma', QuoteStatus.accepted),
  ];

  group('filterQuotes', () {
    test('sans filtre : tout est renvoyé', () {
      expect(filterQuotes(quotes, const QuotesFilter()).length, 3);
    });

    test('filtre de statut réduit la liste', () {
      final r = filterQuotes(
          quotes, const QuotesFilter(status: QuoteStatus.accepted));
      expect(r.length, 2);
      expect(r.every((q) => q.status == QuoteStatus.accepted), isTrue);
    });

    test('recherche sur l\'objet (insensible à la casse)', () {
      final r = filterQuotes(quotes, const QuotesFilter(search: 'MADRIERS'));
      expect(r.single.id, '2');
    });

    test('recherche sur le client', () {
      final r = filterQuotes(quotes, const QuotesFilter(search: 'gamma'));
      expect(r.single.id, '3');
    });

    test('statut + recherche combinés', () {
      final r = filterQuotes(quotes,
          const QuotesFilter(status: QuoteStatus.accepted, search: 'placards'));
      expect(r.single.id, '3');
    });
  });

  group('stats du mois', () {
    final now = DateTime(2026, 6, 15);
    final dataset = [
      _q('a', 'A', 'X', QuoteStatus.draft, date: '2026-06-02', total: 100000),
      _q('b', 'B', 'Y', QuoteStatus.sent, date: '2026-06-12', total: 50000),
      _q('c', 'C', 'Z', QuoteStatus.accepted, date: '2026-05-30', total: 999999),
    ];

    test('quotesThisMonth ne compte que le mois courant', () {
      expect(quotesThisMonth(dataset, now), 2);
    });

    test('monthEstimatedTotal somme le mois courant', () {
      expect(monthEstimatedTotal(dataset, now), 150000);
    });
  });
}
