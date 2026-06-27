import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dato/core/network/api_exception.dart';
import 'package:dato/features/quotes/data/quote_dto.dart';
import 'package:dato/features/quotes/presentation/quote_public_screen.dart';

import '../fixtures/sample_quote.dart';
import '../helpers/test_theme.dart';

void main() {
  testWidgets('affiche le document du devis (sans auth)', (tester) async {
    final pq = PublicQuote(quote: sampleQuote(), company: sampleCompany());

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          publicQuoteProvider('tok').overrideWith((ref) async => pq),
        ],
        child: MaterialApp(
          theme: testTheme(),
          home: const QuotePublicScreen(token: 'tok'),
        ),
      ),
    );
    await tester.pump(); // résout le FutureProvider

    expect(find.textContaining('DOIT'), findsOneWidget);
    expect(find.textContaining('Client Démo'), findsWidgets);
  });

  testWidgets('lien révoqué/inconnu (404) → message indisponible',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          publicQuoteProvider('x').overrideWith(
            (ref) async =>
                throw const ApiException('introuvable', statusCode: 404),
          ),
        ],
        child: MaterialApp(
          theme: testTheme(),
          home: const QuotePublicScreen(token: 'x'),
        ),
      ),
    );
    await tester.pump();

    expect(find.textContaining('plus disponible'), findsOneWidget);
  });
}
