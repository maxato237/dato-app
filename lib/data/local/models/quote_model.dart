import 'package:isar/isar.dart';

part 'quote_model.g.dart';

/// Ligne Isar d'un devis. Les parties imbriquées riches (sections, rubriques
/// forfait/formule, signatures) sont stockées dans [documentJson] — même
/// approche que le snapshot serveur — ce qui réduit la génération de code à une
/// seule collection plate, tout en gardant des colonnes indexées pour les
/// listes, le tri et les filtres.
@collection
class QuoteModel {
  Id isarId = Isar.autoIncrement;

  /// Identifiant métier (UUID local) — clé d'upsert (`putByQuoteId`).
  @Index(unique: true, replace: true)
  late String quoteId;

  late String number;
  late String object;
  late String client;

  @Index()
  late String status;

  /// Date ISO `yyyy-MM-dd` (indexée pour le tri / stats du mois).
  @Index()
  late String date;

  late double grandTotal;
  late String companyId;

  /// Snapshot JSON du devis riche (cf. `quote_dto.dart`).
  late String documentJson;
}
