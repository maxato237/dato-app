import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/utils/formatters.dart';

/// Champ de saisie de montant entier FCFA.
/// Affiche le montant formaté avec séparateurs d'espace, clavier numérique.
class MoneyField extends StatefulWidget {
  const MoneyField({
    super.key,
    this.label,
    this.initialValue,
    this.onChanged,
    this.enabled = true,
    this.validator,
  });

  final String? label;
  final int? initialValue;
  final ValueChanged<int>? onChanged;
  final bool enabled;
  final FormFieldValidator<String>? validator;

  @override
  State<MoneyField> createState() => _MoneyFieldState();
}

class _MoneyFieldState extends State<MoneyField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue != null ? formatMoney(widget.initialValue!) : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    final value = int.tryParse(digits) ?? 0;
    final formatted = value > 0 ? formatMoney(value) : '';

    if (formatted != raw) {
      _controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: AppSpacing.s1),
        ],
        TextFormField(
          controller: _controller,
          enabled: widget.enabled,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d\s]'))],
          validator: widget.validator,
          onChanged: _onChanged,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.text,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
          decoration: const InputDecoration(
            suffixText: 'FCFA',
            suffixStyle: TextStyle(
              fontSize: 14,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
