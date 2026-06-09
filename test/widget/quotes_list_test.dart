import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dato/data/repositories/in_memory_quote_repository.dart';
import 'package:dato/data/repositories/quote_repository.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import 'package:dato/features/quotes/presentation/quotes_list_screen.dart';
import 'package:dato/features/quotes/widgets/quote_card.dart';

import '../helpers/test_theme.dart';

Quote _q(String id, String object, String client, QuoteStatus status) => Quote(
      id: id,
      number: 'DV-$id',
      date: '2026-06-10',
      object: object,
      client: client,
      status: status,
      companyId: 'c',
      sections: const [],
      rubriques: const [],
      signatures: const [],
    );

Future<void> _pumpList(WidgetTester tester, List<Quote> quotes) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        quoteRepositoryProvider.overrideWith((ref) {
          final repo = InMemoryQuoteRepository();
          for (final q in quotes) {
            unawaited(repo.save(q));
          }
          ref.onDispose(repo.dispose);
          return repo;
        }),
      ],
      child: MaterialApp(theme: testTheme(), home: const QuotesListScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  final quotes = [
    _q('1', 'Fabrication de chaises', 'Lycée Bilingue', QuoteStatus.sent),
    _q('2', 'Fourniture de madriers', 'Coopérative', QuoteStatus.accepted),
    _q('3', 'Placards sur mesure', 'Mme Atangana', QuoteStatus.accepted),
  ];

  testWidgets('affiche tous les devis au départ', (tester) async {
    await _pumpList(tester, quotes);
    expect(find.byType(QuoteCard), findsNWidgets(3));
  });

  testWidgets('filtrer « Accepté » réduit la liste', (tester) async {
    await _pumpList(tester, quotes);
    await tester.tap(find.byKey(const Key('chip-accepted')));
    await tester.pump();
    expect(find.byType(QuoteCard), findsNWidgets(2));
  });

  testWidgets('la recherche filtre par objet/client', (tester) async {
    await _pumpList(tester, quotes);
    await tester.enterText(find.byKey(const Key('search-field')), 'madriers');
    await tester.pump();
    expect(find.byType(QuoteCard), findsOneWidget);
  });

  testWidgets('état vide quand aucun résultat', (tester) async {
    await _pumpList(tester, quotes);
    await tester.enterText(find.byKey(const Key('search-field')), 'zzzzz');
    await tester.pump();
    expect(find.byType(QuoteCard), findsNothing);
    expect(find.text('Aucun résultat'), findsOneWidget);
  });
}
