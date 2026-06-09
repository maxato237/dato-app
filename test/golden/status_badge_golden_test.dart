import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:dato/core/widgets/status_badge.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import '../helpers/test_theme.dart';

void main() {
  testGoldens('StatusBadge — tous les statuts', (tester) async {
    final builder = GoldenBuilder.column()
      ..addScenario('Brouillon', const StatusBadge(status: QuoteStatus.draft))
      ..addScenario('Envoyé', const StatusBadge(status: QuoteStatus.sent))
      ..addScenario('Accepté', const StatusBadge(status: QuoteStatus.accepted))
      ..addScenario('Refusé', const StatusBadge(status: QuoteStatus.refused));

    await tester.pumpWidgetBuilder(
      builder.build(),
      wrapper: materialAppWrapper(theme: testTheme()),
      surfaceSize: const Size(200, 300),
    );
    await screenMatchesGolden(tester, 'status_badge_statuts');
  });
}
