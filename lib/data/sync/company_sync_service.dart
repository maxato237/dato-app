import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import 'package:dato/core/network/api_client.dart';
import 'package:dato/core/network/api_exception.dart';
import 'package:dato/core/network/network_providers.dart';
import 'package:dato/core/network/token_storage.dart';
import 'package:dato/data/local/isar_service.dart';
import 'package:dato/data/local/mappers.dart';
import 'package:dato/data/local/models/company_model.dart';

import 'connectivity_service.dart';

/// Pousse l'entreprise (infos, logo, modèle Word) vers le backend dès que le
/// réseau revient — même mécanisme offline-first que les devis.
///
/// La source de vérité est locale (Isar) ; tout changement marque la ligne
/// `dirty`. Au retour réseau (ou à chaque modification connectée), on :
///   1. envoie d'abord un éventuel logo capturé hors-ligne (upload Cloudinary),
///      puis supprime l'ancien logo distant ;
///   2. pousse l'entreprise (`PUT`, repli `POST` si 404) ;
///   3. lève le flag `dirty`.
class CompanySyncService {
  CompanySyncService({
    required Isar? isar,
    required ApiClient api,
    required ConnectivityService connectivity,
    required TokenStorage tokenStorage,
  })  : _isar = isar,
        _api = api,
        _connectivity = connectivity,
        _tokenStorage = tokenStorage;

  final Isar? _isar;
  final ApiClient _api;
  final ConnectivityService _connectivity;
  final TokenStorage _tokenStorage;

  StreamSubscription<bool>? _sub;
  bool _draining = false;

  void start() {
    _sub ??= _connectivity.watch().listen((online) {
      if (online) drain();
    });
  }

  Future<void> drain() async {
    final isar = _isar;
    if (isar == null || _draining) return;
    _draining = true;
    try {
      if (!await _canSync()) return;
      var model = isar.companyModels.where().findFirstSync();
      if (model == null || !model.dirty) return;

      // 1. Logo capturé hors-ligne : upload puis suppression de l'ancien.
      if (model.pendingLogoPath.isNotEmpty) {
        try {
          final newUrl = await _api.uploadImage(model.pendingLogoPath);
          final oldUrl = model.logoUrlToDelete;
          model = isar.companyModels.where().findFirstSync();
          if (model == null) return;
          await isar.writeTxn(() async {
            model!
              ..logoUrl = newUrl
              ..pendingLogoPath = ''
              ..logoUrlToDelete = '';
            await isar.companyModels.put(model);
          });
          if (oldUrl.isNotEmpty) await _api.deleteImage(oldUrl);
        } catch (_) {
          return; // réseau encore instable : on réessaiera.
        }
      }

      // 2. Pousser l'entreprise.
      final company = companyToDomain(model);
      try {
        await _api.put('/api/company', body: company.toJson());
      } on ApiException catch (e) {
        if (e.statusCode == 404) {
          if (company.name.trim().isEmpty) return; // rien à créer encore
          await _api.post('/api/company', body: company.toJson());
        } else if (_isPermanent(e)) {
          // op empoisonnée : on lève le flag pour ne pas boucler.
        } else {
          return; // transitoire → réessai au prochain retour réseau.
        }
      }

      // 3. Marquer synchronisé.
      final fresh = isar.companyModels.where().findFirstSync();
      if (fresh != null && fresh.pendingLogoPath.isEmpty) {
        await isar.writeTxn(() async {
          fresh.dirty = false;
          await isar.companyModels.put(fresh);
        });
      }
    } finally {
      _draining = false;
    }
  }

  Future<bool> _canSync() async {
    try {
      if (!await _connectivity.isOnline()) return false;
      final token = await _tokenStorage.getAccessToken();
      return token != null && token.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  static bool _isPermanent(ApiException e) {
    final c = e.statusCode;
    return c == 400 || c == 403 || c == 409 || c == 422;
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
  }
}

final companySyncServiceProvider = Provider<CompanySyncService>((ref) {
  final service = CompanySyncService(
    isar: ref.watch(isarProvider),
    api: ref.watch(apiClientProvider),
    connectivity: ref.watch(connectivityServiceProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  );
  service.start();
  ref.onDispose(service.dispose);
  return service;
});
