import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dato/data/repositories/in_memory_quote_repository.dart';
import 'package:dato/data/repositories/quote_repository.dart';
import 'package:dato/features/quotes/presentation/quote_editor_screen.dart';
import 'package:dato/features/quotes/widgets/rubrique_card.dart';
import 'package:dato/features/quotes/widgets/section_line_tile.dart';

import '../fixtures/sample_quote.dart';
import '../helpers/test_theme.dart';

Future<void> _pumpEditor(WidgetTester tester) async {
  tester.view.physicalSize = const Size(420, 2200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        quoteRepositoryProvider.overrideWith((ref) {
          final repo = InMemoryQuoteRepository();
          unawaited(repo.save(sampleQuote()));
          ref.onDispose(repo.dispose);
          return repo;
        }),
      ],
      child: MaterialApp(
        theme: testTheme(),
        home: const QuoteEditorScreen(quoteId: 'fix'),
      ),
    ),
  );
  await tester.pump();
}

/// Laisse le debounce d'auto-enregistrement se déclencher puis se terminer,
/// pour ne pas laisser de Timer en attente à la fin du test.
Future<void> _flushAutosave(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 850));
  await tester.pump();
}

String? _textOf(WidgetTester tester, String key) =>
    tester.widget<Text>(find.byKey(Key(key))).data;

void main() {
  testWidgets('saisir une quantité recalcule le P.T en direct', (tester) async {
    await _pumpEditor(tester);

    await tester.enterText(find.byKey(const Key('qty-l1')), '60');
    await tester.pump();

    // 60 × 6 000 = 360 000
    expect(find.text('360 000'), findsOneWidget);
    await _flushAutosave(tester);
  });

  testWidgets('modifier B recalcule la formule a × b en direct', (tester) async {
    await _pumpEditor(tester);

    // État initial : 1 500 × 40 = 60 000
    expect(_textOf(tester, 'res-rl-form'), '60 000');

    await tester.enterText(find.byKey(const Key('b-rl-form')), '50');
    await tester.pump();

    // 1 500 × 50 = 75 000
    expect(_textOf(tester, 'res-rl-form'), '75 000');
    await _flushAutosave(tester);
  });

  testWidgets('basculer une ligne en A × B affiche les champs de formule',
      (tester) async {
    await _pumpEditor(tester);

    expect(find.byKey(const Key('amount-rl-forf')), findsOneWidget);

    await tester.tap(find.byKey(const Key('formula-rl-forf')));
    await tester.pump();

    expect(find.byKey(const Key('a-rl-forf')), findsOneWidget);
    expect(find.byKey(const Key('b-rl-forf')), findsOneWidget);
    expect(find.byKey(const Key('amount-rl-forf')), findsNothing);
    await _flushAutosave(tester);
  });

  testWidgets('client vide n\'empêche pas le partage', (tester) async {
    await _pumpEditor(tester);

    await tester.enterText(find.byKey(const Key('field-client')), '');
    await tester.pump();
    await _flushAutosave(tester);

    await tester.tap(find.text('Partager'));
    await tester.pumpAndSettle(); // ouvre le bottom sheet de partage

    // Plus de blocage : aucune erreur, le sheet de partage s'ouvre.
    expect(find.text('Le nom du client est obligatoire'), findsNothing);
    expect(find.text('Partager sur WhatsApp'), findsOneWidget);
  });

  testWidgets('auto-enregistrement : Enregistré → Enregistrement… → Enregistré',
      (tester) async {
    await _pumpEditor(tester);
    expect(find.text('Enregistré'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('qty-l1')), '5');
    await tester.pump();
    expect(find.text('Enregistrement…'), findsOneWidget);

    await _flushAutosave(tester);
    expect(find.text('Enregistré'), findsOneWidget);
  });

  testWidgets('ajouter une ligne ajoute une ligne à la section',
      (tester) async {
    await _pumpEditor(tester);
    expect(find.byType(SectionLineTile), findsNWidgets(3));

    await tester.tap(find.byKey(const Key('add-line-s1')));
    await tester.pump();

    expect(find.byType(SectionLineTile), findsNWidgets(4));
    await _flushAutosave(tester);
  });

  testWidgets('réordonner les rubriques par la poignée', (tester) async {
    await _pumpEditor(tester);

    List<String> labels() => tester
        .widgetList<RubriqueCard>(find.byType(RubriqueCard))
        .map((c) => c.rubrique.label)
        .toList();

    expect(labels(), ['Usinage', 'Transport']);

    // Glisse la poignée d'« Usinage » vers le bas, au-delà de « Transport ».
    final handle = find.byKey(const Key('drag-rubrique-r1'));
    final gesture = await tester.startGesture(tester.getCenter(handle));
    await tester.pump(const Duration(milliseconds: 80));
    for (var i = 0; i < 4; i++) {
      await gesture.moveBy(const Offset(0, 50));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await gesture.up();
    await tester.pump();

    expect(labels(), ['Transport', 'Usinage']);
    await _flushAutosave(tester);
  });
}
