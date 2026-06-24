import 'package:isar/isar.dart';

part 'article_model.g.dart';

/// Article de la bibliothèque (désignation réutilisable + prix unitaire FCFA).
@collection
class ArticleModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String articleId;

  late String name;

  late int pu;
}
