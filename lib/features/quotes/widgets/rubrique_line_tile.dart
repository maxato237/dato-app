import 'package:flutter/material.dart';

import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/utils/formatters.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import 'compact_inputs.dart';

/// Une ligne de rubrique : bascule **Forfait** (montant direct) ou **A × B**
/// (formule), avec résultat recalculé en direct.
class RubriqueLineTile extends StatelessWidget {
  const RubriqueLineTile({
    super.key,
    required this.line,
    required this.canDelete,
    required this.onModeChanged,
    required this.onAmountChanged,
    required this.onAChanged,
    required this.onBChanged,
    required this.onDelete,
  });

  final RubriqueLine line;
  final bool canDelete;
  final ValueChanged<RubriqueMode> onModeChanged;
  final ValueChanged<int> onAmountChanged;
  final ValueChanged<int> onAChanged;
  final ValueChanged<int> onBChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final segStyle = Theme.of(context)
        .textTheme
        .titleLarge!
        .copyWith(fontSize: 11, fontWeight: FontWeight.w600);

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
      child: Row(
        children: [
          _segmented(segStyle),
          const SizedBox(width: 8),
          Expanded(
            child: line.mode == RubriqueMode.forfait
                ? _forfait()
                : _formula(),
          ),
          if (canDelete)
            IconButton(
              key: Key('del-subline-${line.id}'),
              iconSize: 16,
              visualDensity: VisualDensity.compact,
              color: AppColors.textLight,
              icon: const Icon(Icons.close),
              onPressed: onDelete,
              tooltip: 'Supprimer la sous-ligne',
            ),
        ],
      ),
    );
  }

  Widget _segmented(TextStyle segStyle) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadii.sm),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _segButton(segStyle, 'Forfait', RubriqueMode.forfait),
          const SizedBox(width: 2),
          _segButton(segStyle, 'A × B', RubriqueMode.formula),
        ],
      ),
    );
  }

  Widget _segButton(TextStyle segStyle, String label, RubriqueMode mode) {
    final selected = line.mode == mode;
    return InkWell(
      key: Key('${mode == RubriqueMode.forfait ? 'forfait' : 'formula'}-${line.id}'),
      borderRadius: BorderRadius.circular(6),
      onTap: () => onModeChanged(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: selected
            ? BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              )
            : null,
        child: Text(
          label,
          style: segStyle.copyWith(
              color: selected ? AppColors.ink : AppColors.textMuted),
        ),
      ),
    );
  }

  Widget _forfait() {
    return Align(
      alignment: Alignment.centerRight,
      child: CompactNumberField(
        key: Key('amount-${line.id}'),
        value: (line.amount ?? 0).round(),
        width: 96,
        money: true,
        hint: 'Montant',
        onChanged: onAmountChanged,
      ),
    );
  }

  Widget _formula() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CompactNumberField(
          key: Key('a-${line.id}'),
          value: (line.a ?? 0).round(),
          width: 58,
          money: true,
          hint: 'A',
          onChanged: onAChanged,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text('×',
              style: TextStyle(
                  color: AppColors.textLight, fontWeight: FontWeight.w600)),
        ),
        CompactNumberField(
          key: Key('b-${line.id}'),
          value: (line.b ?? 0).round(),
          width: 42,
          hint: 'B',
          onChanged: onBChanged,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text('=',
              style: TextStyle(
                  color: AppColors.textLight, fontWeight: FontWeight.w600)),
        ),
        // Le résultat reste entier et lisible : il se réduit légèrement si la
        // place manque (gros montants / petits écrans) plutôt que de déborder.
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              key: Key('res-${line.id}'),
              formatMoney(line.total),
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
                color: AppColors.ink,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
