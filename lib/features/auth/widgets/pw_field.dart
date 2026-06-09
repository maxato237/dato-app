import 'package:flutter/material.dart';
import 'package:dato/core/widgets/dato_text_field.dart';

/// Champ mot de passe avec bouton œil pour afficher/masquer.
class PwField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? error;
  final Key? fieldKey;

  const PwField({
    super.key,
    required this.controller,
    this.label = 'Mot de passe',
    this.hint = '••••••••',
    this.error,
    this.fieldKey,
  });

  @override
  State<PwField> createState() => _PwFieldState();
}

class _PwFieldState extends State<PwField> {
  bool _show = false;

  @override
  Widget build(BuildContext context) {
    return DatoTextField(
      key: widget.fieldKey,
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      error: widget.error,
      obscureText: !_show,
      suffix: IconButton(
        icon: Icon(_show ? Icons.visibility_off : Icons.visibility,
            size: 20),
        onPressed: () => setState(() => _show = !_show),
      ),
    );
  }
}
