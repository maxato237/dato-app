import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/utils/formatters.dart';

/// Petit champ numérique entier des lignes de devis (Qté, P.U, A, B, montant).
///
/// - [money] : formate en direct avec séparateurs d'espace (P.U, montant, A).
/// - Se resynchronise sur [value] quand il change de l'extérieur
///   (ex. auto-complétion qui renseigne le P.U), sans déplacer le curseur
///   pendant la frappe.
class CompactNumberField extends StatefulWidget {
  const CompactNumberField({
    super.key,
    required this.value,
    required this.onChanged,
    this.money = false,
    this.width,
    this.hint,
    this.enabled = true,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final bool money;
  final double? width;
  final String? hint;
  final bool enabled;

  @override
  State<CompactNumberField> createState() => _CompactNumberFieldState();
}

class _CompactNumberFieldState extends State<CompactNumberField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _format(widget.value));
  }

  @override
  void didUpdateWidget(CompactNumberField old) {
    super.didUpdateWidget(old);
    // Resynchronise seulement si la valeur diffère de ce que le champ contient
    // déjà (évite le saut de curseur sur le simple écho d'une frappe).
    if (widget.value != _parse(_controller.text)) {
      final text = _format(widget.value);
      _controller.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _parse(String s) => int.tryParse(s.replaceAll(RegExp(r'\D'), '')) ?? 0;

  String _format(int v) {
    if (v == 0) return '';
    return widget.money ? formatMoney(v) : v.toString();
  }

  void _onChanged(String raw) {
    final value = _parse(raw);
    final formatted = _format(value);
    if (formatted != raw) {
      _controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final field = TextField(
      controller: _controller,
      enabled: widget.enabled,
      onChanged: _onChanged,
      textAlign: TextAlign.right,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d\s]'))],
      style: const TextStyle(
        fontSize: 13.5,
        color: AppColors.text,
        fontFeatures: [FontFeature.tabularFigures()],
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: widget.hint,
        hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 13),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: const BorderSide(color: AppColors.ink, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
      ),
    );
    return SizedBox(width: widget.width, child: field);
  }
}
