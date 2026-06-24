import 'package:isar/isar.dart';

import 'package:dato/data/repositories/quote_repository.dart';
import 'package:dato/features/quotes/domain/quote.dart';

import 'mappers.dart';
import 'models/quote_model.dart';

/// Dépôt de devis **durable** sur Isar. Lectures synchrones (l'éditeur n'a pas
/// d'état de chargement), écritures transactionnelles, flux réactif via
/// `watchLazy`. Implémente la même [QuoteRepository] que la version en mémoire.
class IsarQuoteRepository implements QuoteRepository {
  IsarQuoteRepository(this._isar);

  final Isar _isar;

  @override
  Quote? getById(String id) {
    final m = _isar.quoteModels.getByQuoteIdSync(id);
    return m == null ? null : quoteToDomain(m);
  }

  @override
  List<Quote> getAll() => _isar.quoteModels
      .where()
      .anyIsarId()
      .findAllSync()
      .map(quoteToDomain)
      .toList();

  @override
  Stream<List<Quote>> watchAll() =>
      _isar.quoteModels.watchLazy(fireImmediately: true).map((_) => getAll());

  @override
  Future<void> save(Quote quote) async {
    await _isar.writeTxn(() => _isar.quoteModels.putByQuoteId(quoteToModel(quote)));
  }

  @override
  Future<void> delete(String id) async {
    await _isar.writeTxn(() => _isar.quoteModels.deleteByQuoteId(id));
  }
}
