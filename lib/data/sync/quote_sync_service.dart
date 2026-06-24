import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dato/core/network/api_exception.dart';
import 'package:dato/core/network/network_providers.dart';
import 'package:dato/core/network/token_storage.dart';
import 'package:dato/data/local/isar_service.dart';
import 'package:dato/data/remote/quote_remote_data_source.dart';

import 'connectivity_service.dart';
import 'isar_sync_queue.dart';
import 'sync_op.dart';
import 'sync_queue.dart';

/// Rejoue la file de sync vers le backend dès que le réseau revient.
///
/// Offline-first : un échec **transitoire** (réseau, 401) laisse l'opération en
/// file pour un nouvel essai ; une erreur **permanente** (validation, conflit)
/// la retire afin de ne pas bloquer indéfiniment la file derrière une op
/// « empoisonnée ». La synchronisation n'est tentée que connecté ET authentifié.
class QuoteSyncService {
  QuoteSyncService({
    required SyncQueue queue,
    required QuoteRemoteDataSource remote,
    required ConnectivityService connectivity,
    required TokenStorage tokenStorage,
  })  : _queue = queue,
        _remote = remote,
        _connectivity = connectivity,
        _tokenStorage = tokenStorage;

  final SyncQueue _queue;
  final QuoteRemoteDataSource _remote;
  final ConnectivityService _connectivity;
  final TokenStorage _tokenStorage;

  StreamSubscription<bool>? _sub;
  bool _draining = false;

  /// Démarre l'écoute du réseau (idempotent). Au retour en ligne → [drain].
  void start() {
    _sub ??= _connectivity.watch().listen((online) {
      if (online) drain();
    });
  }

  /// Rejoue les opérations en attente, **dans l'ordre**. Ré-entrant : un appel
  /// concurrent est ignoré tant qu'un drain est en cours.
  Future<void> drain() async {
    if (_draining) return;
    _draining = true;
    try {
      if (!await _canSync()) return;
      while (_queue.head != null) {
        final op = _queue.head!;
        try {
          await _apply(op);
          _queue.removeHead();
        } on ApiException catch (e) {
          if (_isPermanent(e)) {
            _queue.removeHead(); // op empoisonnée : ne pas bloquer la file
            continue;
          }
          break; // transitoire → on réessaiera au prochain retour réseau
        } catch (_) {
          break;
        }
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

  Future<void> _apply(SyncOp op) => switch (op) {
        UpsertQuoteOp(:final quote) => _remote.upsert(quote),
        DeleteQuoteOp(:final quoteId) => _remote.delete(quoteId),
      };

  static bool _isPermanent(ApiException e) {
    final c = e.statusCode;
    return c == 400 || c == 403 || c == 409 || c == 422;
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
  }
}

/// File de sync partagée : **durable** ([IsarSyncQueue]) quand Isar est ouvert,
/// sinon en mémoire ([InMemorySyncQueue], tests / repli).
final syncQueueProvider = Provider<SyncQueue>((ref) {
  final isar = ref.watch(isarProvider);
  return isar != null ? IsarSyncQueue(isar) : InMemorySyncQueue();
});

final quoteSyncServiceProvider = Provider<QuoteSyncService>((ref) {
  final service = QuoteSyncService(
    queue: ref.watch(syncQueueProvider),
    remote: ref.watch(quoteRemoteDataSourceProvider),
    connectivity: ref.watch(connectivityServiceProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  );
  service.start();
  ref.onDispose(service.dispose);
  return service;
});
