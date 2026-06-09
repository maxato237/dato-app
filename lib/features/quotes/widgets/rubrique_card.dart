import 'package:flutter/material.dart';

import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/utils/formatters.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import 'package:dato/features/quotes/providers/quote_editor_controller.dart';
import 'inline_text_field.dart';
import 'rubrique_line_tile.dart';

/// Carte d'une rubrique (transport, usinage, main d'œuvre…) : libellé, lignes
/// forfait/formule, total recalculé en direct, ajout de sous-lignes.
class RubriqueCard extends StatelessWidget {
  const RubriqueCard({
    super.key,
    required this.rubrique,
    required this.rubriqueIndex,
    required this.controller,
  });

  final Rubrique rubrique;
  final int rubriqueIndex;
  final QuoteEditorController controller;

  @override
  Widget build(BuildContext context) {
    final headStyle = Theme.of(context)
        .textTheme
        .titleLarge!
        .copyWith(fontSize: 14, fontWeight: FontWeight.w700);

    final showAddSub = rubrique.lines.isNotEmpty &&
        rubrique.lines.any((l) => l.mode == RubriqueMode.formula);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // En-tête de rubrique
          Padding(
            padding: const EdgeInsets.only(left: 2, right: 4),
            child: Row(
              children: [
                ReorderableDragStartListener(
                  index: rubriqueIndex,
                  child: SizedBox(
                    key: Key('drag-rubrique-${rubrique.id}'),
                    width: 32,
                    height: 40,
                    child: const Icon(Icons.drag_indicator,
                        size: 19, color: AppColors.textLight),
                  ),
                ),
                Expanded(
                  child: InlineTextField(
                    value: rubrique.label,
                    hint: "Ex. Transport, Usinage, Main d'œuvre…",
                    style: headStyle.copyWith(letterSpacing: 0.3),
                    textCapitalization: TextCapitalization.characters,
                    onChanged: (v) =>
                        controller.setRubriqueLabel(rubrique.id, v),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    formatMoney(rubrique.total),
                    style: headStyle.copyWith(
                      color: AppColors.ink,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                IconButton(
                  key: Key('del-rubrique-${rubrique.id}'),
                  iconSize: 18,
                  color: AppColors.textLight,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => controller.deleteRubrique(rubrique.id),
                  tooltip: 'Supprimer la rubrique',
                ),
              ],
            ),
          ),

          // Lignes (forfait / formule)
          for (final line in rubrique.lines)
            RubriqueLineTile(
              key: ValueKey(line.id),
              line: line,
              canDelete: rubrique.lines.length > 1,
              onModeChanged: (m) =>
                  controller.setRubriqueLineMode(rubrique.id, line.id, m),
              onAmountChanged: (v) => controller.setRubriqueLineAmount(
                  rubrique.id, line.id, v.toDouble()),
              onAChanged: (v) => controller.setRubriqueLineA(
                  rubrique.id, line.id, v.toDouble()),
              onBChanged: (v) => controller.setRubriqueLineB(
                  rubrique.id, line.id, v.toDouble()),
              onDelete: () =>
                  controller.deleteSubLine(rubrique.id, line.id),
            ),

          // Ajouter une sous-ligne (formule)
          if (showAddSub)
            InkWell(
              key: Key('add-subline-${rubrique.id}'),
              onTap: () => controller.addSubLine(rubrique.id),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                child: Row(
                  children: [
                    const Icon(Icons.add, size: 15, color: AppColors.ink),
                    const SizedBox(width: 7),
                    Flexible(
                      child: Text(
                        'Sous-ligne (ex. Planches, Madriers…)',
                        overflow: TextOverflow.ellipsis,
                        style: headStyle.copyWith(
                            fontSize: 12.5, color: AppColors.ink),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
