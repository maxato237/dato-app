import 'package:isar/isar.dart';

import 'package:dato/data/local/mappers.dart';
import 'package:dato/data/local/models/pending_sync_op.dart';
import 'package:dato/data/local/models/quote_model.dart';

import 'sync_op.dart';
import 'sync_queue.dart';

/// File de sync **durable** (outbox dans Isar). Les opérations survivent à un
/// redémarrage ; elles sont rejouées au prochain retour réseau / démarrage.
///
/// Pour un upsert, seul le `quoteId` est stocké : le contenu poussé est **relu**
/// depuis `QuoteModel` au moment du push (donc toujours l'état local le plus
/// récent). Si le devis a disparu localement, l'op upsert est auto-nettoyée.
class IsarSyncQueue implements SyncQueue {
  IsarSyncQueue(this._isar);

  final Isar _isar;

  List<PendingSyncOp> _allBySeq() {
    final ops = _isar.pendingSyncOps.where().anyId().findAllSync();
    // Tri FIFO par seq, départage par id auto-incrémenté (ordre d'insertion)
    // pour un ordre totalement déterministe même en cas d'égalité de seq.
    ops.sort((a, b) {
      final c = a.seq.compareTo(b.seq);
      return c != 0 ? c : a.id.compareTo(b.id);
    });
    return ops;
  }

  SyncOp? _toSyncOp(PendingSyncOp op) {
    if (op.type == 'delete') return DeleteQuoteOp(op.quoteId);
    final qm = _isar.quoteModels.getByQuoteIdSync(op.quoteId);
    if (qm == null) {
      // Devis disparu → op obsolète : on la retire.
      _isar.writeTxnSync(() => _isar.pendingSyncOps.deleteSync(op.id));
      return null;
    }
    return UpsertQuoteOp(quoteToDomain(qm));
  }

  @override
  void enqueue(SyncOp op) {
    final type = op is DeleteQuoteOp ? 'delete' : 'upsert';
    _isar.writeTxnSync(
      () => _isar.pendingSyncOps.putByQuoteIdSync(
        PendingSyncOp()
          ..quoteId = op.quoteId
          ..type = type
          ..seq = DateTime.now().microsecondsSinceEpoch,
      ),
    );
  }

  @override
  SyncOp? get head {
    for (final op in _allBySeq()) {
      final syncOp = _toSyncOp(op);
      if (syncOp != null) return syncOp; // sinon op auto-nettoyée, on continue
    }
    return null;
  }

  @override
  void removeHead() {
    final ops = _allBySeq();
    if (ops.isNotEmpty) {
      final firstId = ops.first.id;
      _isar.writeTxnSync(() => _isar.pendingSyncOps.deleteSync(firstId));
    }
  }

  @override
  List<SyncOp> get pending {
    final result = <SyncOp>[];
    for (final op in _allBySeq()) {
      final syncOp = _toSyncOp(op);
      if (syncOp != null) result.add(syncOp);
    }
    return result;
  }

  @override
  bool get isEmpty => _isar.pendingSyncOps.countSync() == 0;
  @override
  bool get isNotEmpty => !isEmpty;
  @override
  int get length => _isar.pendingSyncOps.countSync();
}
