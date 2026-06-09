import 'package:flutter_test/flutter_test.dart';
import 'package:dato/features/pdf/quote_pdf.dart';

import '../fixtures/sample_quote.dart';

void main() {
  test('buildQuotePdf produit un PDF non vide et valide', () async {
    final bytes = await buildQuotePdf(
      quote: sampleQuote(),
      company: sampleCompany(),
    );

    expect(bytes.length, greaterThan(1000));
    // Signature de fichier PDF : "%PDF"
    expect(String.fromCharCodes(bytes.sublist(0, 4)), '%PDF');
  });

  test('le tableau (lignes + rubriques) est bien rendu, pas seulement l\'en-tête',
      () async {
    final full = await buildQuotePdf(
      quote: sampleQuote(),
      company: sampleCompany(),
    );
    final headerOnly = await buildQuotePdf(
      quote: sampleQuote().copyWith(sections: [], rubriques: []),
      company: sampleCompany(),
    );
    // Si le tableau s'effondrait (cf. bug `stretch`), les deux feraient la
    // même taille. Le contenu des lignes/rubriques doit peser plus lourd.
    expect(full.length, greaterThan(headerOnly.length));
  });
}
