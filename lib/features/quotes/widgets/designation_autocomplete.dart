import 'package:flutter/material.dart';

import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/utils/formatters.dart';
import 'package:dato/features/library/domain/article.dart';

/// Champ « Désignation » d'une ligne, avec auto-complétion depuis la
/// bibliothèque d'articles. Sélectionner une suggestion renseigne la
/// désignation **et** le prix unitaire (via [onPick]).
class DesignationAutocomplete extends StatefulWidget {
  const DesignationAutocomplete({
    super.key,
    required this.value,
    required this.articles,
    required this.onChanged,
    required this.onPick,
  });

  final String value;
  final List<Article> articles;
  final ValueChanged<String> onChanged;
  final ValueChanged<Article> onPick;

  @override
  State<DesignationAutocomplete> createState() =>
      _DesignationAutocompleteState();
}

class _DesignationAutocompleteState extends State<DesignationAutocomplete> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(DesignationAutocomplete old) {
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
    _focusNode.dispose();
    super.dispose();
  }

  Iterable<Article> _optionsFor(TextEditingValue value) {
    final q = value.text.toLowerCase().trim();
    if (q.isEmpty) return const Iterable<Article>.empty();
    return widget.articles
        .where((a) {
          final n = a.name.toLowerCase();
          return n.contains(q) && n != q;
        })
        .take(5);
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<Article>(
      textEditingController: _controller,
      focusNode: _focusNode,
      displayStringForOption: (a) => a.name,
      optionsBuilder: _optionsFor,
      onSelected: widget.onPick,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: widget.onChanged,
          onSubmitted: (_) => onFieldSubmitted(),
          textInputAction: TextInputAction.next,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
            color: AppColors.text,
          ),
          decoration: const InputDecoration(
            isDense: true,
            hintText: 'Désignation…',
            hintStyle: TextStyle(color: AppColors.textLight),
            filled: false,
            contentPadding: EdgeInsets.symmetric(vertical: 6),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.ink, width: 1.5),
            ),
          ),
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(AppRadii.md),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 210,
                minWidth: 220,
                maxWidth: 340,
              ),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: AppColors.border),
                itemBuilder: (context, i) {
                  final a = options.elementAt(i);
                  return InkWell(
                    onTap: () => onSelected(a),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 11),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              a.name,
                              style: const TextStyle(
                                  fontSize: 14, color: AppColors.text),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            formatMoney(a.pu),
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
