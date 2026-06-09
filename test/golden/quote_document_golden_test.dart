import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'package:dato/features/quotes/widgets/quote_document.dart';

import '../fixtures/sample_quote.dart';
import '../helpers/test_theme.dart';

void main() {
  testGoldens('Document de devis — gabarit A4', (tester) async {
    await tester.pumpWidgetBuilder(
      QuoteDocument(company: sampleCompany(), quote: sampleQuote()),
      wrapper: materialAppWrapper(theme: testTheme()),
      surfaceSize: const Size(595, 842), // A4 à 72 dpi
    );
    await tester.pump();
    await screenMatchesGolden(tester, 'quote_document_a4');
  });
}
