import 'package:flutter/material.dart';

import 'package:dato/core/theme/app_theme.dart';

/// Champ texte « sans bordure » fondu dans la carte (titre de section,
/// libellé de rubrique, libellé de signature). Garde le curseur lors de la
/// frappe et se resynchronise si la valeur change de l'extérieur.
class InlineTextField extends StatefulWidget {
  const InlineTextField({
    super.key,
    required this.value,
    required this.onChanged,
    this.style,
    this.hint,
    this.textCapitalization = TextCapitalization.sentences,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final TextStyle? style;
  final String? hint;
  final TextCapitalization textCapitalization;

  @override
  State<InlineTextField> createState() => _InlineTextFieldState();
}

class _InlineTextFieldState extends State<InlineTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(InlineTextField old) {
    super.didUpdateWidget(old);
    if (widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style ??
        const TextStyle(fontSize: 15, color: AppColors.text);
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      textCapitalization: widget.textCapitalization,
      style: style,
      cursorColor: AppColors.ink,
      decoration: InputDecoration(
        isDense: true,
        filled: false,
        hintText: widget.hint,
        hintStyle: style.copyWith(color: AppColors.textLight),
        contentPadding: const EdgeInsets.symmetric(vertical: 6),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
    );
  }
}
