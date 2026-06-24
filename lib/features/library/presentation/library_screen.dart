import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/utils/formatters.dart';
import 'package:dato/core/widgets/dato_toast.dart';
import 'package:dato/core/widgets/empty_state.dart';
import 'package:dato/core/widgets/skeleton_list.dart';
import 'package:dato/features/library/domain/article.dart';
import 'package:dato/features/library/providers/articles_provider.dart';
import 'package:dato/features/library/widgets/article_form_sheet.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  bool _showSearch = false;

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Article> _filtered(List<Article> all) {
    if (_query.isEmpty) return all;
    final q = _query.toLowerCase();
    return all.where((a) => a.name.toLowerCase().contains(q)).toList();
  }

  Future<void> _delete(Article article) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer cet article ?'),
        content: Text(
            '« ${article.name} » sera retiré de la bibliothèque.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    ref.read(articlesNotifierProvider.notifier).delete(article.id);
    if (mounted) {
      DatoToast.show(context,
          message: 'Article supprimé', variant: DatoToastVariant.success);
    }
  }

  @override
  Widget build(BuildContext context) {
    final articlesAsync = ref.watch(articlesNotifierProvider);
    final articles = articlesAsync.valueOrNull ?? const <Article>[];
    final visible = _filtered(articles);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: _showSearch
            ? TextField(
                key: const Key('library_search'),
                controller: _searchCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Rechercher un article…',
                  border: InputBorder.none,
                ),
                onChanged: (v) => setState(() => _query = v),
              )
            : const Text('Articles'),
        actions: [
          IconButton(
            key: const Key('library_search_toggle'),
            icon: Icon(_showSearch ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _showSearch = !_showSearch;
                if (!_showSearch) {
                  _query = '';
                  _searchCtrl.clear();
                }
              });
            },
          ),
        ],
      ),
      body: articlesAsync.isLoading
          ? const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: SkeletonList(),
            )
          : articles.isEmpty
              ? const EmptyState(
                  icon: Icons.inventory_2_outlined,
                  title: 'Bibliothèque vide',
                  subtitle:
                      'Ajoutez vos articles et tarifs habituels pour les retrouver rapidement dans l\'éditeur.',
                )
              : visible.isEmpty
                  ? const EmptyState(
                      icon: Icons.search_off,
                      title: 'Aucun résultat',
                      subtitle: 'Essayez un autre mot-clé.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                      itemCount: visible.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 2),
                      itemBuilder: (_, i) => _ArticleTile(
                        article: visible[i],
                        onEdit: () =>
                            showArticleForm(context, article: visible[i]),
                        onDelete: () => _delete(visible[i]),
                      ),
                    ),
      floatingActionButton: FloatingActionButton(
        key: const Key('library_add'),
        onPressed: () => showArticleForm(context),
        backgroundColor: AppColors.ink,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ArticleTile extends StatelessWidget {
  const _ArticleTile({
    required this.article,
    required this.onEdit,
    required this.onDelete,
  });

  final Article article;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        key: Key('article_tile_${article.id}'),
        onTap: onEdit,
        borderRadius: BorderRadius.circular(AppRadii.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.name,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    if (article.pu > 0) ...[
                      const SizedBox(height: 2),
                      Text(
                        '${formatMoney(article.pu)} FCFA',
                        style: const TextStyle(
                            fontSize: 12.5, color: AppColors.textMuted),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                key: Key('article_edit_${article.id}'),
                icon: const Icon(Icons.edit_outlined,
                    size: 18, color: AppColors.textMuted),
                onPressed: onEdit,
                tooltip: 'Modifier',
              ),
              IconButton(
                key: Key('article_delete_${article.id}'),
                icon: const Icon(Icons.delete_outline,
                    size: 18, color: AppColors.danger),
                onPressed: onDelete,
                tooltip: 'Supprimer',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
