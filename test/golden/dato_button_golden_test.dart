import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:dato/core/widgets/dato_button.dart';
import '../helpers/test_theme.dart';

void main() {
  testGoldens('DatoButton — toutes les variantes', (tester) async {
    final builder = GoldenBuilder.column()
      ..addScenario(
        'Primaire',
        const DatoButton.primary(label: 'Enregistrer'),
      )
      ..addScenario(
        'Secondaire',
        const DatoButton.secondary(label: 'Annuler'),
      )
      ..addScenario(
        'Ambre',
        const DatoButton.amber(label: 'Ajouter'),
      )
      ..addScenario(
        'WhatsApp',
        const DatoButton.whatsapp(label: 'Partager via WhatsApp'),
      )
      ..addScenario(
        'Danger',
        const DatoButton.danger(label: 'Supprimer'),
      )
      ..addScenario(
        'Primaire — Désactivé',
        const DatoButton.primary(label: 'Enregistrer', isDisabled: true),
      );

    await tester.pumpWidgetBuilder(
      builder.build(),
      wrapper: materialAppWrapper(theme: testTheme()),
      surfaceSize: const Size(360, 900),
    );
    await screenMatchesGolden(tester, 'dato_button_variantes');
  });
}
