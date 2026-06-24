import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dato/data/local/isar_quote_repository.dart';
import 'package:dato/data/local/isar_service.dart';
import 'package:dato/data/sync/quote_sync_service.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import 'in_memory_quote_repository.dart';
import 'syncing_quote_repository.dart';

/// Source de vérité locale des devis (offline-first).
///
/// L'UI lit/écrit **toujours** ce dépôt ; la synchronisation serveur sera un
/// effet de bord branché derrière la même interface (cf. ARCHITECTURE.md).
///
/// Les lectures sont **synchrones** (Isar expose `getSync`/`watch` ; l'éditeur
/// n'a donc pas besoin d'état de chargement). Les écritures sont asynchrones
/// pour laisser la place à la file de sync (Phase 6).
abstract class QuoteRepository {
  /// Renvoie le devis [id] ou `null` s'il n'existe pas.
  Quote? getById(String id);

  /// Tous les devis (les plus récents d'abord, selon l'implémentation).
  List<Quote> getAll();

  /// Flux des devis, ré-émis à chaque écriture.
  Stream<List<Quote>> watchAll();

  /// Crée ou met à jour le devis (upsert par `id`).
  Future<void> save(Quote quote);

  /// Supprime le devis [id] (sans effet s'il n'existe pas).
  Future<void> delete(String id);
}

/// Implémentation active du dépôt de devis.
///
/// Local durable : [IsarQuoteRepository] quand Isar est ouvert (cf.
/// [isarProvider], injecté dans `main`). Repli : [InMemoryQuoteRepository]
/// (seedé) pour les tests ou si l'ouverture d'Isar échoue. Dans les deux cas,
/// décoré par [SyncingQuoteRepository] (file de sync + rejeu serveur).
final quoteRepositoryProvider = Provider<QuoteRepository>((ref) {
  final isar = ref.watch(isarProvider);
  final QuoteRepository local;
  if (isar != null) {
    local = IsarQuoteRepository(isar);
  } else {
    final mem = InMemoryQuoteRepository();
    ref.onDispose(mem.dispose);
    local = mem;
  }
  return SyncingQuoteRepository(
    local,
    ref.watch(syncQueueProvider),
    onEnqueued: () => ref.read(quoteSyncServiceProvider).drain(),
  );
});
