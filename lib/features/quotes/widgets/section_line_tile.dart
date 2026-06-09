import 'package:flutter/material.dart';

import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/utils/formatters.dart';
import 'package:dato/features/library/domain/article.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import 'compact_inputs.dart';
import 'designation_autocomplete.dart';

/// Une ligne de section (matériel) : désignation, Qté × P.U, P.T calculé.
class SectionLineTile extends StatelessWidget {
  const SectionLineTile({
    super.key,
    required this.line,
    required this.articles,
    required this.index,
    required this.onDesignationChanged,
    required this.onPick,
    required this.onQtyChanged,
    required this.onPuChanged,
    required this.onDelete,
  });

  final SectionLine line;
  final List<Article> articles;
  final int index;
  final ValueChanged<String> onDesignationChanged;
  final ValueChanged<Article> onPick;
  final ValueChanged<int> onQtyChanged;
  final ValueChanged<int> onPuChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.only(left: 2, right: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ReorderableDragStartListener(
            index: index,
            child: SizedBox(
              key: Key('drag-line-${line.id}'),
              width: 26,
              height: 56,
              child: const Icon(Icons.drag_indicator,
                  size: 18, color: AppColors.borderStrong),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DesignationAutocomplete(
                    value: line.designation,
                    articles: articles,
                    onChanged: onDesignationChanged,
                    onPick: onPick,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _mini(
                        label: 'Qté',
                        child: CompactNumberField(
                          key: Key('qty-${line.id}'),
                          value: line.qty.round(),
                          width: 58,
                          onChanged: onQtyChanged,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 8, left: 6, right: 6),
                        child: Text('×',
                            style: TextStyle(color: AppColors.textLight)),
                      ),
                      _mini(
                        label: 'P.U',
                        child: CompactNumberField(
                          key: Key('pu-${line.id}'),
                          value: line.pu.round(),
                          width: 84,
                          money: true,
                          onChanged: onPuChanged,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _mini(
                          label: 'P.T',
                          align: CrossAxisAlignment.end,
                          child: SizedBox(
                            height: 34,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                key: Key('pt-${line.id}'),
                                formatMoney(line.pt),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13.5,
                                  color: AppColors.ink,
                                  fontFeatures: [FontFeature.tabularFigures()],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 30,
            height: 56,
            child: IconButton(
              key: Key('del-line-${line.id}'),
              padding: EdgeInsets.zero,
              iconSize: 17,
              color: AppColors.textLight,
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
              tooltip: 'Supprimer la ligne',
            ),
          ),
        ],
      ),
    );
  }

  Widget _mini({
    required String label,
    required Widget child,
    CrossAxisAlignment align = CrossAxisAlignment.start,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: align,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 2, left: 2),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
              letterSpacing: 0.3,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
