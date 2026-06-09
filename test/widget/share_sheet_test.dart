import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dato/features/quotes/widgets/share_sheet.dart';

import '../fixtures/sample_quote.dart';
import '../helpers/test_theme.dart';

void main() {
  testWidgets('le sheet de partage liste WhatsApp en premier', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: testTheme(),
        home: Scaffold(
          body: ShareSheetContent(
            quote: sampleQuote(),
            company: sampleCompany(),
          ),
        ),
      ),
    );

    // Les quatre actions sont présentes.
    expect(find.text('Partager sur WhatsApp'), findsOneWidget);
    expect(find.text('Copier le lien'), findsOneWidget);
    expect(find.text('Télécharger le PDF'), findsOneWidget);
    expect(find.text('Envoyer par e-mail'), findsOneWidget);

    // … et dans cet ordre vertical (WhatsApp en tête).
    double top(String label) => tester.getTopLeft(find.text(label)).dy;
    expect(top('Partager sur WhatsApp'), lessThan(top('Copier le lien')));
    expect(top('Copier le lien'), lessThan(top('Télécharger le PDF')));
    expect(top('Télécharger le PDF'), lessThan(top('Envoyer par e-mail')));
  });
}
