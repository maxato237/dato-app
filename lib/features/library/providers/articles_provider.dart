import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import 'package:dato/core/utils/id.dart';
import 'package:dato/data/local/isar_service.dart';
import 'package:dato/data/local/mappers.dart';
import 'package:dato/data/local/models/article_model.dart';
import 'package:dato/features/library/domain/article.dart';

/// Bibliothèque d'articles de l'utilisateur. État exposé en [AsyncValue] pour
/// permettre l'affichage d'un squelette de chargement avant le contenu.
///
/// Aucune donnée de démonstration : la liste ne contient que ce que
/// l'utilisateur a créé (manuellement ou via l'auto-enregistrement depuis
/// l'éditeur de devis).
class ArticlesNotifier extends StateNotifier<AsyncValue<List<Article>>> {
  ArticlesNotifier(this._isar) : super(const AsyncValue.loading()) {
    _init();
  }

  final Isar? _isar;

  List<Article> get _current => state.valueOrNull ?? const [];

  Future<void> _init() async {
    // Laisse un frame au squelette de s'afficher même si la lecture Isar est
    // synchrone et quasi instantanée.
    await Future<void>.delayed(Duration.zero);
    state = AsyncValue.data(_load(_isar));
  }

  static List<Article> _load(Isar? isar) {
    if (isar == null) return const [];
    final rows = isar.articleModels.where().anyIsarId().findAllSync();
    final list = rows.map(articleToDomain).toList();
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }

  void _persist(List<Article> articles) {
    final isar = _isar;
    if (isar == null) return;
    isar.writeTxnSync(() {
      isar.articleModels.clearSync();
      isar.articleModels.putAllSync(articles.map(articleToModel).toList());
    });
  }

  void _setSorted(List<Article> list) {
    final sorted = [...list]
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    state = AsyncValue.data(sorted);
    _persist(sorted);
  }

  void add(Article article) => _setSorted([..._current, article]);

  void update(Article article) => _setSorted(
      _current.map((a) => a.id == article.id ? article : a).toList());

  void delete(String id) =>
      _setSorted(_current.where((a) => a.id != id).toList());

  /// Enregistre [name] (avec son [pu]) dans la bibliothèque s'il n'existe pas
  /// déjà (comparaison insensible à la casse). Utilisé par l'éditeur de devis
  /// pour mémoriser automatiquement les nouveaux articles saisis.
  void ensure(String name, int pu) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    final exists =
        _current.any((a) => a.name.trim().toLowerCase() == trimmed.toLowerCase());
    if (exists) return;
    add(Article(id: newId(), name: trimmed, pu: pu));
  }
}

final articlesNotifierProvider =
    StateNotifierProvider<ArticlesNotifier, AsyncValue<List<Article>>>(
  (ref) => ArticlesNotifier(ref.watch(isarProvider)),
);

/// Alias read-only (liste résolue) — utilisé par l'auto-complétion de l'éditeur.
final articlesProvider = Provider<List<Article>>(
  (ref) => ref.watch(articlesNotifierProvider).valueOrNull ?? const [],
);
