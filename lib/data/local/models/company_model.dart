import 'package:isar/isar.dart';

part 'company_model.g.dart';

/// En-tête entreprise persisté (singleton applicatif, clé `companyId`).
@collection
class CompanyModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String companyId;

  late String name;
  late String activity;
  late String address;
  late String phones;
  late String city;
  late String currency;
  late String logoUrl;
  late String location;
  late String templateDocxUrl;
  // Phase 8 — champs ajoutés avec valeur par défaut pour la migration Isar
  String signatureLeft = 'Le Client :';
  String signatureRight = 'Le Prestataire :';
  String quotePrefix = 'DV';
  bool quoteNumberByObject = false;

  // ── État de synchronisation (offline-first) ──────────────────────────────
  /// `true` quand des changements locaux n'ont pas encore été poussés au backend.
  bool dirty = false;

  /// Chemin local d'un logo en attente d'upload (capturé hors-ligne). Vide sinon.
  String pendingLogoPath = '';

  /// Ancienne URL de logo à supprimer côté Cloudinary après remplacement réussi.
  String logoUrlToDelete = '';
}
