import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import 'package:dato/core/network/network_providers.dart';
import 'package:dato/core/network/token_storage.dart';
import 'package:dato/data/local/isar_service.dart';
import 'package:dato/data/local/mappers.dart';
import 'package:dato/data/local/models/quote_model.dart';
import 'package:dato/data/remote/quote_remote_data_source.dart';
import 'package:dato/features/auth/domain/auth_status.dart';
import 'package:dato/features/auth/providers/auth_provider.dart';
import 'package:dato/features/settings/providers/company_provider.dart';

import 'connectivity_service.dart';

/// Recharge depuis le serveur les devis **absents en local** (restore
/// offline-first, p.ex. après réinstallation ou sur un nouvel appareil).
///
/// - N'écrase **jamais** un devis déjà présent localement → aucune perte
///   d'édition hors-ligne (la fusion multi-appareils fine est hors périmètre).
/// - Écrit **directement dans Isar** (pas via le dépôt synchronisé) pour ne pas
///   re-déclencher la file de push.
/// - Sans Isar (tests / repli mémoire) : no-op.
class QuotePullService {
  QuotePullService({
    required QuoteRemoteDataSource remote,
    required Isar? isar,
    required ConnectivityService connectivity,
    required TokenStorage tokenStorage,
  })  : _remote = remote,
        _isar = isar,
        _connectivity = connectivity,
        _tokenStorage = tokenStorage;

  final QuoteRemoteDataSource _remote;
  final Isar? _isar;
  final ConnectivityService _connectivity;
  final TokenStorage _tokenStorage;

  bool _running = false;

  Future<void> pull({required String companyId}) async {
    final isar = _isar;
    if (isar == null || _running) return;
    _running = true;
    try {
      if (!await _canSync()) return;
      final summaries = await _remote.fetchSummaries();
      for (final s in summaries) {
        final id = s['id'] as String?;
        if (id == null) continue;
        if (isar.quoteModels.getByQuoteIdSync(id) != null) continue; // déjà local
        final full = await _remote.fetchOne(id, companyId: companyId);
        await isar.writeTxn(
          () => isar.quoteModels.putByQuoteId(quoteToModel(full)),
        );
      }
    } catch (_) {
      // Best-effort : un échec réseau sera retenté au prochain login/démarrage.
    } finally {
      _running = false;
    }
  }

  Future<bool> _canSync() async {
    try {
      if (!await _connectivity.isOnline()) return false;
      final t = await _tokenStorage.getAccessToken();
      return t != null && t.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}

final quotePullServiceProvider = Provider<QuotePullService>(
  (ref) => QuotePullService(
    remote: ref.watch(quoteRemoteDataSourceProvider),
    isar: ref.watch(isarProvider),
    connectivity: ref.watch(connectivityServiceProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  ),
);

/// Déclenche un pull à chaque passage en état **authentifié** (login + au
/// démarrage si une session valide existe déjà).
class QuotePullCoordinator {
  QuotePullCoordinator(this._ref);

  final Ref _ref;
  StreamSubscription<AuthStatus>? _sub;

  void start() {
    final repo = _ref.read(authRepositoryProvider);
    if (repo.status == AuthStatus.authenticated) _pull();
    _sub = repo.authStateChanges.listen((status) {
      if (status == AuthStatus.authenticated) _pull();
    });
  }

  void _pull() {
    final companyId = _ref.read(currentCompanyProvider).id;
    _ref.read(quotePullServiceProvider).pull(companyId: companyId);
  }

  void dispose() => _sub?.cancel();
}

final quotePullCoordinatorProvider = Provider<QuotePullCoordinator>((ref) {
  final coordinator = QuotePullCoordinator(ref)..start();
  ref.onDispose(coordinator.dispose);
  return coordinator;
});
