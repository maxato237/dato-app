import 'package:flutter/material.dart';

import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/utils/formatters.dart';
import 'package:dato/features/library/domain/article.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import 'package:dato/features/quotes/providers/quote_editor_controller.dart';
import 'inline_text_field.dart';
import 'section_line_tile.dart';

/// Carte d'une section de devis (ex. « Matériel ») : titre, lignes
/// réordonnables par poignée, ajout de ligne et sous-total recalculé en direct.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.section,
    required this.sectionIndex,
    required this.articles,
    required this.controller,
    this.showSubtotal = true,
  });

  final Section section;
  final int sectionIndex;
  final List<Article> articles;
  final QuoteEditorController controller;

  /// Affiche le sous-total de la section : uniquement utile dès qu'il y a
  /// au moins deux sections (sinon le total général suffit).
  final bool showSubtotal;

  @override
  Widget build(BuildContext context) {
    final headStyle = Theme.of(context)
        .textTheme
        .titleLarge!
        .copyWith(fontSize: 14, fontWeight: FontWeight.w700);

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
          // En-tête de section
          Container(
            decoration: const BoxDecoration(
              color: AppColors.bg,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            padding: const EdgeInsets.only(left: 2, right: 6),
            child: Row(
              children: [
                ReorderableDragStartListener(
                  index: sectionIndex,
                  child: SizedBox(
                    key: Key('drag-section-${section.id}'),
                    width: 34,
                    height: 40,
                    child: const Icon(Icons.drag_indicator,
                        size: 19, color: AppColors.textLight),
                  ),
                ),
                Expanded(
                  child: InlineTextField(
                    value: section.title,
                    hint: 'Nom de la section',
                    style: headStyle,
                    onChanged: (v) =>
                        controller.setSectionTitle(section.id, v),
                  ),
                ),
                IconButton(
                  key: Key('del-section-${section.id}'),
                  iconSize: 18,
                  color: AppColors.textLight,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => controller.deleteSection(section.id),
                  tooltip: 'Supprimer la section',
                ),
              ],
            ),
          ),

          // Visibilité du titre comme en-tête dans le devis rendu
          InkWell(
            key: Key('toggle-section-title-${section.id}'),
            onTap: () =>
                controller.setSectionShowTitle(section.id, !section.showTitle),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 12, 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: section.showTitle,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (v) => controller.setSectionShowTitle(
                          section.id, v ?? true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    child: Text(
                      'Afficher le titre dans le devis',
                      style: TextStyle(
                          fontSize: 12.5, color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Lignes (réordonnables par poignée)
          ReorderableListView.builder(
            buildDefaultDragHandles: false,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: section.lines.length,
            onReorder: (oldIndex, newIndex) =>
                controller.reorderLines(section.id, oldIndex, newIndex),
            itemBuilder: (context, i) {
              final line = section.lines[i];
              return SectionLineTile(
                key: ValueKey(line.id),
                line: line,
                articles: articles,
                index: i,
                onDesignationChanged: (v) =>
                    controller.setLine(section.id, line.id, designation: v),
                onPick: (a) =>
                    controller.pickArticle(section.id, line.id, a),
                onQtyChanged: (v) => controller.setLine(section.id, line.id,
                    qty: v.toDouble()),
                onPuChanged: (v) =>
                    controller.setLine(section.id, line.id, pu: v.toDouble()),
                onDelete: () => controller.deleteLine(section.id, line.id),
              );
            },
          ),

          // Ajouter une ligne
          InkWell(
            key: Key('add-line-${section.id}'),
            onTap: () => controller.addLine(section.id),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              child: Row(
                children: [
                  const Icon(Icons.add, size: 17, color: AppColors.ink),
                  const SizedBox(width: 7),
                  Flexible(
                    child: Text('Ajouter une ligne',
                        overflow: TextOverflow.ellipsis,
                        style: headStyle.copyWith(
                            fontSize: 13.5, color: AppColors.ink)),
                  ),
                ],
              ),
            ),
          ),

          // Sous-total (affiché seulement à partir de la 2e section)
          if (showSubtotal)
            Container(
              color: AppColors.ink050,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Total ${section.title.isEmpty ? 'section' : section.title}',
                      style:
                          headStyle.copyWith(fontSize: 13, color: AppColors.ink),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    formatFcfa(section.total),
                    style: headStyle.copyWith(
                      fontSize: 14,
                      color: AppColors.ink,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
