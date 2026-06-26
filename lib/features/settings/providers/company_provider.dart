import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import 'package:dato/data/local/isar_service.dart';
import 'package:dato/data/local/mappers.dart';
import 'package:dato/data/local/models/company_model.dart';
import 'package:dato/data/sync/company_sync_service.dart';
import 'package:dato/features/settings/domain/company.dart';

/// Entreprise vierge tant que l'utilisateur n'a rien saisi (aucune donnée de
/// démonstration). Les champs vides s'affichent en placeholder dans les
/// formulaires.
const Company _emptyCompany = Company(
  id: 'company',
  name: '',
  activity: '',
);

class CompanyNotifier extends StateNotifier<Company> {
  CompanyNotifier(this._isar, {this.onChanged}) : super(_load(_isar));

  final Isar? _isar;

  /// Appelé après une modification locale « sale » (à pousser au backend).
  final VoidCallback? onChanged;

  static Company _load(Isar? isar) {
    if (isar != null) {
      final m = isar.companyModels.where().findFirstSync();
      if (m != null) return companyToDomain(m);
    }
    return _emptyCompany;
  }

  /// Met à jour l'entreprise courante et la persiste localement (singleton).
  ///
  /// [markDirty] = `true` (défaut) marque la ligne à synchroniser et déclenche
  /// une tentative de push. Mettre `false` lors d'un *pull* depuis le backend
  /// (l'état local reflète déjà le serveur, rien à repousser).
  void update(Company company, {bool markDirty = true}) {
    state = company;
    _writeModel(company, markDirty: markDirty);
    if (markDirty) onChanged?.call();
  }

  /// Enregistre un logo capturé hors-ligne (chemin local), à uploader dès le
  /// retour réseau ; mémorise l'ancienne URL distante pour la supprimer ensuite.
  void queuePendingLogo(String localPath, {required String previousRemoteUrl}) {
    _writeModel(state, markDirty: true,
        pendingLogoPath: localPath, logoUrlToDelete: previousRemoteUrl);
    onChanged?.call();
  }

  /// Enregistre un modèle Word à uploader dès que le réseau / le stockage
  /// distant redeviennent disponibles.
  void queuePendingTemplate(String localPath) {
    _writeModel(state, markDirty: true, pendingTemplatePath: localPath);
    onChanged?.call();
  }

  void _writeModel(
    Company company, {
    required bool markDirty,
    String? pendingLogoPath,
    String? logoUrlToDelete,
    String? pendingTemplatePath,
  }) {
    final isar = _isar;
    if (isar == null) return;
    isar.writeTxnSync(() {
      final existing = isar.companyModels.where().findFirstSync();
      final model = companyToModel(company)
        ..dirty = markDirty || (existing?.dirty ?? false)
        ..pendingLogoPath =
            pendingLogoPath ?? existing?.pendingLogoPath ?? ''
        ..logoUrlToDelete =
            logoUrlToDelete ?? existing?.logoUrlToDelete ?? ''
        ..pendingTemplatePath =
            pendingTemplatePath ?? existing?.pendingTemplatePath ?? '';
      isar.companyModels.clearSync();
      isar.companyModels.putSync(model);
    });
  }
}

/// Entreprise courante (en-tête des devis). Durable via Isar quand disponible,
/// sinon vierge en mémoire (l'utilisateur la renseigne à l'onboarding).
final currentCompanyProvider = StateNotifierProvider<CompanyNotifier, Company>(
  (ref) => CompanyNotifier(
    ref.watch(isarProvider),
    onChanged: () => ref.read(companySyncServiceProvider).drain(),
  ),
);
