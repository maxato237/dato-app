import 'package:isar/isar.dart';

part 'binary_asset.g.dart';

/// Octets d'une image (logo, photo) mis en cache **localement** par URL, pour
/// que les documents de devis s'affichent hors-ligne. Clé = URL distante.
@collection
class BinaryAsset {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String url;

  /// Contenu binaire compact (1 octet par valeur).
  late List<byte> bytes;

  String? contentType;
  late DateTime cachedAt;
}
