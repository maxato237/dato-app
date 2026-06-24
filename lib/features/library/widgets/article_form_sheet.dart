import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/utils/id.dart';
import 'package:dato/core/widgets/dato_text_field.dart';
import 'package:dato/core/widgets/money_field.dart';
import 'package:dato/features/library/domain/article.dart';
import 'package:dato/features/library/providers/articles_provider.dart';

/// Ouvre le bottom sheet d'ajout ou de modification d'un article.
Future<void> showArticleForm(
  BuildContext context, {
  Article? article,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.bg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder: (_) => _ArticleFormSheet(article: article),
  );
}

class _ArticleFormSheet extends ConsumerStatefulWidget {
  const _ArticleFormSheet({this.article});

  final Article? article;

  @override
  ConsumerState<_ArticleFormSheet> createState() => _ArticleFormSheetState();
}

class _ArticleFormSheetState extends ConsumerState<_ArticleFormSheet> {
  late final TextEditingController _nameCtrl;
  late int _pu;
  String? _nameErr;

  bool get _isEdit => widget.article != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.article?.name ?? '');
    _pu = widget.article?.pu ?? 0;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => _nameErr = 'La désignation est obligatoire.');
      return;
    }
    final notifier = ref.read(articlesNotifierProvider.notifier);
    if (_isEdit) {
      notifier.update(widget.article!.copyWith(name: name, pu: _pu));
    } else {
      notifier.add(Article(id: newId(), name: name, pu: _pu));
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                _isEdit ? 'Modifier l\'article' : 'Nouvel article',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DatoTextField(
            key: const Key('article_name'),
            controller: _nameCtrl,
            label: 'Désignation',
            hint: 'Ex. Peinture acrylique blanche',
            error: _nameErr,
            textInputAction: TextInputAction.next,
            onChanged: (_) {
              if (_nameErr != null) setState(() => _nameErr = null);
            },
          ),
          const SizedBox(height: 14),
          MoneyField(
            key: const Key('article_pu'),
            label: 'Prix unitaire (FCFA)',
            initialValue: _pu,
            onChanged: (v) => _pu = v,
          ),
          const SizedBox(height: 20),
          FilledButton(
            key: const Key('article_save'),
            onPressed: _save,
            child: Text(_isEdit ? 'Enregistrer' : 'Ajouter'),
          ),
        ],
      ),
    );
  }
}
