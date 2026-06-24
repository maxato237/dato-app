import 'package:dato/features/quotes/domain/quote.dart';

/// Opération de synchronisation en attente de rejeu vers le backend.
sealed class SyncOp {
  const SyncOp();

  /// Devis concerné — clé de coalescence dans la [SyncQueue].
  String get quoteId;
}

/// Création ou mise à jour d'un devis (upsert idempotent par `id`).
class UpsertQuoteOp extends SyncOp {
  final Quote quote;
  const UpsertQuoteOp(this.quote);

  @override
  String get quoteId => quote.id;
}

/// Suppression d'un devis.
class DeleteQuoteOp extends SyncOp {
  @override
  final String quoteId;
  const DeleteQuoteOp(this.quoteId);
}
