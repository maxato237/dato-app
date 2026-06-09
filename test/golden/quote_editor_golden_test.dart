import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'package:dato/data/repositories/in_memory_quote_repository.dart';
import 'package:dato/data/repositories/quote_repository.dart';
import 'package:dato/features/quotes/presentation/quote_editor_screen.dart';

import '../fixtures/sample_quote.dart';
import '../helpers/test_theme.dart';

void main() {
  testGoldens('Éditeur de devis — rempli', (tester) async {
    await tester.pumpWidgetBuilder(
      ProviderScope(
        overrides: [
          quoteRepositoryProvider.overrideWith((ref) {
            final repo = InMemoryQuoteRepository();
            unawaited(repo.save(sampleQuote()));
            ref.onDispose(repo.dispose);
            return repo;
          }),
        ],
        child: const QuoteEditorScreen(quoteId: 'fix'),
      ),
      wrapper: materialAppWrapper(theme: testTheme()),
      surfaceSize: const Size(390, 1700),
    );
    await tester.pump();
    await screenMatchesGolden(tester, 'quote_editor_rempli');
  });
}
