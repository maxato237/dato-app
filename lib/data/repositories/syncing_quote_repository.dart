import 'package:dato/data/sync/sync_op.dart';
import 'package:dato/data/sync/sync_queue.dart';
import 'package:dato/features/quotes/domain/quote.dart';

import 'quote_repository.dart';

/// Décore un [QuoteRepository] local : chaque écriture est appliquée
/// **localement d'abord** (offline-first), puis mise en [SyncQueue] ; un
/// callback déclenche le drain (best-effort, sans bloquer l'UI). Les lectures
/// sont déléguées telles quelles.
class SyncingQuoteRepository implements QuoteRepository {
  SyncingQuoteRepository(
    this._local,
    this._queue, {
    void Function()? onEnqueued,
  }) : _onEnqueued = onEnqueued;

  final QuoteRepository _local;
  final SyncQueue _queue;
  final void Function()? _onEnqueued;

  @override
  Quote? getById(String id) => _local.getById(id);

  @override
  List<Quote> getAll() => _local.getAll();

  @override
  Stream<List<Quote>> watchAll() => _local.watchAll();

  @override
  Future<void> save(Quote quote) async {
    await _local.save(quote);
    _queue.enqueue(UpsertQuoteOp(quote));
    _onEnqueued?.call();
  }

  @override
  Future<void> delete(String id) async {
    await _local.delete(id);
    _queue.enqueue(DeleteQuoteOp(id));
    _onEnqueued?.call();
  }
}
