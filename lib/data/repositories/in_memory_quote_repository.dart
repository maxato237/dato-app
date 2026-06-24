import 'dart:async';

import 'package:dato/features/quotes/domain/quote.dart';
import 'quote_repository.dart';

/// Dépôt de devis en mémoire (offline, non durable).
///
/// Utilisé en repli quand Isar n'est pas disponible (tests, ou si l'ouverture
/// de la base échoue). En production, [IsarQuoteRepository] prend le relais
/// derrière la même interface [QuoteRepository].
class InMemoryQuoteRepository implements QuoteRepository {
  final Map<String, Quote> _store = {};
  final Set<StreamController<List<Quote>>> _sinks = {};

  void _emit() {
    final snapshot = getAll();
    for (final sink in _sinks) {
      sink.add(snapshot);
    }
  }

  @override
  Quote? getById(String id) => _store[id];

  @override
  List<Quote> getAll() => _store.values.toList(growable: false);

  @override
  Stream<List<Quote>> watchAll() {
    late final StreamController<List<Quote>> controller;
    controller = StreamController<List<Quote>>(
      onListen: () => controller.add(getAll()),
      onCancel: () {
        _sinks.remove(controller);
        controller.close();
      },
    );
    _sinks.add(controller);
    return controller.stream;
  }

  @override
  Future<void> save(Quote quote) async {
    _store[quote.id] = quote;
    _emit();
  }

  @override
  Future<void> delete(String id) async {
    _store.remove(id);
    _emit();
  }

  void dispose() {
    for (final sink in _sinks.toList()) {
      sink.close();
    }
    _sinks.clear();
  }
}
