import 'sync_op.dart';

/// File des écritures locales en attente de synchronisation serveur.
///
/// **Coalescence par devis** : enfiler une opération pour un `quoteId` déjà
/// présent remplace l'ancienne (le dernier état gagne). Deux implémentations :
/// [InMemorySyncQueue] (repli/tests) et `IsarSyncQueue` (durable, survit au
/// redémarrage).
abstract class SyncQueue {
  void enqueue(SyncOp op);

  /// Première opération à rejouer (FIFO), ou `null` si vide.
  SyncOp? get head;

  /// Retire l'opération de tête (après push réussi).
  void removeHead();

  List<SyncOp> get pending;
  bool get isEmpty;
  bool get isNotEmpty;
  int get length;
}

/// File en mémoire (non durable) — utilisée quand Isar est indisponible.
class InMemorySyncQueue implements SyncQueue {
  final List<SyncOp> _ops = [];

  @override
  List<SyncOp> get pending => List.unmodifiable(_ops);
  @override
  bool get isEmpty => _ops.isEmpty;
  @override
  bool get isNotEmpty => _ops.isNotEmpty;
  @override
  int get length => _ops.length;

  @override
  void enqueue(SyncOp op) {
    _ops.removeWhere((o) => o.quoteId == op.quoteId);
    _ops.add(op);
  }

  @override
  SyncOp? get head => _ops.isEmpty ? null : _ops.first;

  @override
  void removeHead() {
    if (_ops.isNotEmpty) _ops.removeAt(0);
  }
}
