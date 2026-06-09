# TESTING — DATO (Flutter)

> Pyramide de tests : beaucoup d'**unitaires** (logique métier), des **widgets** (écrans/interactions), des **golden** (fidélité aux maquettes), quelques **intégration** (parcours bout-en-bout). Objectif : pouvoir refactorer sans peur et livrer sur Play Store sereinement.

```
        /\        integration   (parcours critiques, lents)        ~5
       /  \       golden         (fidélité visuelle vs maquettes)  ~15
      /----\      widget         (écrans + interactions)           ~40
     /------\     unit           (domaine, utils, repos)          ~80
```

Commandes :
```bash
flutter test                          # unit + widget + golden
flutter test --update-goldens         # régénère les golden (après un changement UI assumé)
flutter test integration_test/        # parcours sur device/émulateur
flutter analyze                       # lint — doit être vert
```

---

## 1. Unitaires — la priorité (Phase 1)

C'est là que se joue la confiance : **calculs** et **montant en lettres**. À écrire AVANT/AVEC le code.

`test/unit/montant_en_lettres_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:dato/core/utils/montant_en_lettres.dart';

void main() {
  group('montantEnLettres', () {
    final cas = {
      0: 'Zéro francs CFA',
      1: 'Un francs CFA',
      80: 'Quatre-vingts francs CFA',
      81: 'Quatre-vingt-un francs CFA',
      71: 'Soixante-et-onze francs CFA',
      100: 'Cent francs CFA',
      200: 'Deux cents francs CFA',
      1000: 'Mille francs CFA',
      1025500: 'Un million vingt-cinq mille cinq cents francs CFA',
      18630000: 'Dix-huit millions six cent trente mille francs CFA',
    };
    cas.forEach((n, attendu) {
      test('$n', () => expect(montantEnLettres(n), attendu));
    });
  });
}
```

`test/unit/quote_calculs_test.dart`
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:dato/features/quotes/domain/quote.dart';

void main() {
  test('grandTotal = Σ sections + Σ rubriques (forfait + formule)', () {
    final q = Quote(
      id: '1', number: 'DV-2026-014', date: '2026-05-12',
      object: 'Test', client: 'Client X', status: QuoteStatus.draft,
      companyId: 'c1', signatures: const [],
      sections: const [
        Section(id: 's1', title: 'Matériel', lines: [
          SectionLine(id: 'l1', designation: 'Planches', qty: 60, pu: 6000), // 360000
          SectionLine(id: 'l2', designation: 'Colle', qty: 10, pu: 3000),    // 30000
        ]),
      ],
      rubriques: const [
        Rubrique(id: 'r1', label: 'Transport', lines: [
          RubriqueLine(id: 'rl1', mode: RubriqueMode.forfait, amount: 50000),
        ]),
        Rubrique(id: 'r2', label: 'Usinage', lines: [
          RubriqueLine(id: 'rl2', mode: RubriqueMode.formula, a: 1500, b: 40), // 60000
        ]),
      ],
    );
    expect(q.sections.first.total, 390000);
    expect(q.grandTotal, 500000); // 390000 + 50000 + 60000
  });
}
```

`test/unit/formatters_test.dart`
```dart
test('formatMoney groupe par espace', () {
  expect(formatMoney(1025500), '1 025 500');
  expect(formatFcfa(50000), '50 000 FCFA');
});
```

Repositories : tester avec **mocktail** (mock de l'API et/ou Isar) — ex. la file de sync rejoue dans l'ordre après reconnexion.

---

## 2. Widget — écrans & interactions (Phases 2+)

`test/widget/quote_editor_test.dart` (esprit)
```dart
testWidgets('saisir une quantité recalcule le P.T', (tester) async {
  await tester.pumpWidget(/* ProviderScope + QuoteEditorScreen avec un devis seed */);
  await tester.enterText(find.byKey(const Key('qty-l1')), '60');
  await tester.pump();
  expect(find.text('360 000'), findsOneWidget);
});

testWidgets('client vide bloque le partage', (tester) async {
  // ... vider le champ client, taper "Partager"
  expect(find.text('Le nom du client est obligatoire'), findsOneWidget);
});
```

À couvrir aussi : toggle Forfait/A×B d'une rubrique, ajout/suppression de ligne, filtres de la liste, états des 4 écrans de paiement.

---

## 3. Golden — fidélité aux maquettes (Phase 0 puis continu)

Avec **golden_toolkit**. Chaque composant clé et chaque écran rempli a une golden de référence. C'est le garde-fou « le résultat ressemble-t-il toujours à la maquette ? ».

```dart
testGoldens('DatoButton — variantes', (tester) async {
  final builder = GoldenBuilder.grid(columns: 2, widthToHeightRatio: 3)
    ..addScenario('Primaire', const DatoButton.primary(label: 'Enregistrer'))
    ..addScenario('WhatsApp', const DatoButton.whatsapp(label: 'Partager'))
    ..addScenario('Ambre', const DatoButton.amber(label: 'Ajouter'))
    ..addScenario('Danger', const DatoButton.danger(label: 'Supprimer'));
  await tester.pumpWidgetBuilder(builder.build());
  await screenMatchesGolden(tester, 'dato_button_variantes');
});
```

Golden minimales à viser : boutons, StatusBadge, carte devis, éditeur rempli, page PDF A4, paywall, 4 états de paiement.

---

## 4. Intégration — parcours critiques (Phase 5+)

Dans `integration_test/`, API et SMS **mockés**. Parcours à couvrir :
1. Inscription → OTP → onboarding → home.
2. Nouveau devis → éditeur (ajout section + rubrique) → aperçu → bottom sheet partage.
3. Paywall → plan → opérateur → succès → quota illimité.

```dart
// integration_test/parcours_devis_test.dart
testWidgets('créer et prévisualiser un devis', (tester) async {
  await tester.pumpWidget(const ProviderScope(child: DatoApp()));
  await tester.tap(find.byKey(const Key('fab-nouveau')));
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(const Key('field-objet')), 'Fabrication de 40 chaises');
  await tester.enterText(find.byKey(const Key('field-client')), 'Lycée Bilingue');
  // ... ajouter une ligne, vérifier le total, ouvrir l'aperçu
  expect(find.textContaining('francs CFA'), findsWidgets);
});
```

---

## 5. Bonnes pratiques

- **Keys stables** sur les éléments testés (`Key('qty-<lineId>')`, `Key('fab-nouveau')`…). À poser dès l'écriture des widgets.
- **Seed de données** partagé : un `Quote` d'exemple (le devis 40 chaises) dans `test/fixtures/` réutilisé partout.
- **Test d'abord la logique** (Phase 1) : un bug de calcul ou de montant en lettres est le plus coûteux en confiance utilisateur.
- **CI** (GitHub Actions) : `flutter analyze` + `flutter test` à chaque push ; bloquer le merge si rouge.
- Golden : commiter les images de référence ; les régénérer **uniquement** sur changement UI volontaire (`--update-goldens`) et les relire en revue.
```
