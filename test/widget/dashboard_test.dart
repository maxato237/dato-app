import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dato/data/repositories/in_memory_quote_repository.dart';
import 'package:dato/data/repositories/quote_repository.dart';
import 'package:dato/features/dashboard/presentation/dashboard_screen.dart';
import 'package:dato/features/dashboard/widgets/stat_card.dart';
import 'package:dato/features/quotes/domain/quote.dart';

import '../helpers/test_theme.dart';

Quote _q(String id,
        {required String date,
        int total = 0,
        QuoteStatus status = QuoteStatus.draft}) =>
    Quote(
      id: id,
      number: 'DV-$id',
      date: date,
      object: 'Objet $id',
      client: 'Client $id',
      status: status,
      companyId: 'c',
      sections: const [],
      rubriques: total == 0
          ? const []
          : [
              Rubrique(id: 'r$id', label: 'M', lines: [
                RubriqueLine(
                    id: 'rl$id',
                    mode: RubriqueMode.forfait,
                    amount: total.toDouble()),
              ]),
            ],
      signatures: const [],
    );

String _statValue(WidgetTester tester, String label) => tester
    .widgetList<StatCard>(find.byType(StatCard))
    .firstWhere((c) => c.label == label)
    .value;

Future<void> _pumpDashboard(WidgetTester tester, QuoteRepository repo) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [quoteRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(theme: testTheme(), home: const DashboardScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('« Total devis » compte tous les devis (réactif, tous mois)',
      (tester) async {
    final repo = InMemoryQuoteRepository();
    addTearDown(repo.dispose);

    await _pumpDashboard(tester, repo);
    expect(_statValue(tester, 'Total devis'), '0');

    // Même un devis d'un mois passé compte dans le total.
    await repo.save(_q('a', date: '2025-01-15', total: 100000));
    await tester.pumpAndSettle();

    expect(_statValue(tester, 'Total devis'), '1');
  });

  testWidgets('« Montant estimé » somme tous les devis et réagit aux ajouts',
      (tester) async {
    final repo = InMemoryQuoteRepository();
    addTearDown(repo.dispose);

    await _pumpDashboard(tester, repo);
    expect(_statValue(tester, 'Montant estimé'), '0');

    await repo.save(_q('a', date: '2025-01-15', total: 100000));
    await tester.pumpAndSettle();

    expect(_statValue(tester, 'Montant estimé'), '100 000');
  });
}
