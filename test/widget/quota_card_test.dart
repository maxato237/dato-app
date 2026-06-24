import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dato/features/dashboard/widgets/quota_card.dart';

import '../helpers/test_theme.dart';

void main() {
  Widget wrap(Widget child) =>
      MaterialApp(theme: testTheme(), home: Scaffold(body: child));

  testWidgets('accès libre : « Accès libre », sans quota ni CTA Pro',
      (tester) async {
    await tester.pumpWidget(
      wrap(const QuotaCard(used: 7, limit: 3, unlimited: true)),
    );

    expect(find.text('Accès libre'), findsOneWidget);
    expect(find.text('7'), findsOneWidget); // compteur sans limite
    expect(find.textContaining('/'), findsNothing); // pas de « 7 / 3 »
    expect(find.text('Passer à DATO Pro'), findsNothing);
  });

  testWidgets('freemium : X / limite + CTA Pro cliquable', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(QuotaCard(used: 2, limit: 3, onUpgrade: () => tapped = true)),
    );

    expect(find.text('Forfait Gratuit'), findsOneWidget);
    expect(find.text('2 / 3'), findsOneWidget);
    expect(find.text('Passer à DATO Pro'), findsOneWidget);

    await tester.tap(find.text('Passer à DATO Pro'));
    expect(tapped, isTrue);
  });
}
