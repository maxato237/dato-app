import 'dart:async';

import 'package:dato/core/utils/id.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import 'quote_repository.dart';

/// Dépôt de devis en mémoire (offline, non durable).
///
/// Suffisant pour la Phase 2 : l'éditeur lit/écrit ici, l'auto-enregistrement
/// fonctionne réellement (debounce + indicateur). Une implémentation Isar
/// prendra le relais derrière [QuoteRepository] sans changer l'UI.
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

  /// Insère un jeu de devis d'exemple (MILLENAIRE DECOR), dont le devis complet
  /// « 40 chaises » accessible via la route `/quote/demo`. Dates relatives au
  /// mois courant pour que le tableau de bord reste vivant.
  void seedDemo() {
    if (_store.isNotEmpty) return;
    final now = DateTime.now();
    String d(int monthsAgo, int day) =>
        _iso(DateTime(now.year, now.month - monthsAgo, day));

    final quotes = <Quote>[
      _demoQuote(d(0, 8)),
      _seed('q13', 'DV-2026-013',
          'Fourniture de madriers et planches Talli/Azobé',
          'Coopérative La Longue Caniche', d(0, 4),
          QuoteStatus.accepted, 18630000),
      _seed('q12', 'DV-2026-012', 'Achat parquet et pose, Hôtel',
          "Œil d'Aigle Village", d(1, 26), QuoteStatus.accepted, 1805000),
      _seed('q11', 'DV-2026-011', 'Rénovation du comptoir de bar',
          'Restaurant Le Palmier', d(1, 18), QuoteStatus.refused, 640000),
      _seed('q10', 'DV-2026-010', 'Placards de chambre sur mesure',
          'Mme Atangana', d(1, 12), QuoteStatus.draft, 480000),
      _seed('q09', 'DV-2026-009', 'Portes intérieures en bois massif (×6)',
          'Villa Bastos', d(2, 15), QuoteStatus.sent, 1350000),
    ];
    for (final q in quotes) {
      _store[q.id] = q;
    }
  }

  static String _iso(DateTime dt) {
    final m = dt.month.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    return '${dt.year}-$m-$day';
  }

  static Quote _seed(String id, String number, String object, String client,
          String date, QuoteStatus status, int total) =>
      Quote(
        id: id,
        number: number,
        date: date,
        object: object,
        client: client,
        status: status,
        companyId: 'demo-company',
        sections: const [],
        rubriques: [
          Rubrique(id: 'r-$id', label: 'Montant', lines: [
            RubriqueLine(
                id: 'rl-$id',
                mode: RubriqueMode.forfait,
                amount: total.toDouble()),
          ]),
        ],
        signatures: const [
          Signature(id: 'sg1', label: 'Le Technicien'),
          Signature(id: 'sg2', label: 'Le Client'),
        ],
      );

  static Quote _demoQuote(String date) => Quote(
        id: 'demo',
        number: 'DV-2026-014',
        date: date,
        object:
            'Fabrication de 40 chaises pour la salle de réunion des enseignants',
        client: 'Lycée Bilingue de Yaoundé',
        status: QuoteStatus.draft,
        companyId: 'demo-company',
        sections: [
          Section(
            id: newId(),
            title: 'Matériel',
            lines: [
              SectionLine(id: newId(), designation: 'Planches', qty: 60, pu: 6000),
              SectionLine(id: newId(), designation: 'Litres de colle', qty: 10, pu: 3000),
              SectionLine(id: newId(), designation: 'Bandes à poncer', qty: 2, pu: 24000),
              SectionLine(id: newId(), designation: 'Litres de fond-dur', qty: 30, pu: 5000),
              SectionLine(id: newId(), designation: 'Litres de diluant', qty: 60, pu: 1500),
              SectionLine(id: newId(), designation: 'Teintes', qty: 2, pu: 12000),
              SectionLine(id: newId(), designation: 'Paquets de vis', qty: 10, pu: 8000),
              SectionLine(id: newId(), designation: 'Paquets de pointe', qty: 3, pu: 4500),
            ],
          ),
        ],
        rubriques: [
          Rubrique(id: newId(), label: 'Usinage', lines: [
            RubriqueLine(id: newId(), mode: RubriqueMode.formula, a: 1500, b: 40),
          ]),
          Rubrique(id: newId(), label: 'Transport', lines: [
            RubriqueLine(id: newId(), mode: RubriqueMode.forfait, amount: 50000),
          ]),
          Rubrique(id: newId(), label: "Main d'œuvre", lines: [
            RubriqueLine(id: newId(), mode: RubriqueMode.formula, a: 3000, b: 40),
          ]),
        ],
        signatures: [
          Signature(id: newId(), label: 'Le Technicien'),
          Signature(id: newId(), label: 'Le Client'),
        ],
      );
}
