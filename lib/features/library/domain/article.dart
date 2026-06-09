/// Article de la bibliothèque (désignation réutilisable + prix unitaire FCFA).
/// Sert l'auto-complétion de désignation dans l'éditeur de devis (Phase 2)
/// et la bibliothèque d'articles complète (Phase 8).
class Article {
  final String id;
  final String name;
  final int pu;

  const Article({required this.id, required this.name, required this.pu});

  Article copyWith({String? name, int? pu}) =>
      Article(id: id, name: name ?? this.name, pu: pu ?? this.pu);
}
