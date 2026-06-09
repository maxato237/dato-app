import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import 'in_memory_quote_repository.dart';

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
/// Aujourd'hui : [InMemoryQuoteRepository] (persistance en mémoire, seedée).
/// Demain : implémentation Isar branchée ici, sans toucher au reste du code.
final quoteRepositoryProvider = Provider<QuoteRepository>((ref) {
  final repo = InMemoryQuoteRepository()..seedDemo();
  ref.onDispose(repo.dispose);
  return repo;
});
