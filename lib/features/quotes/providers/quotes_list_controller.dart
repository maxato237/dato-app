import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dato/data/repositories/quote_repository.dart';
import 'package:dato/features/quotes/domain/quote.dart';

/// Quota mensuel du forfait gratuit (le paiement viendra en Phase 7).
const int kFreeQuota = 3;

/// Flux de tous les devis, triés du plus récent au plus ancien, réactif aux
/// écritures (création, duplication, changement de statut, suppression).
final quotesStreamProvider = StreamProvider.autoDispose<List<Quote>>((ref) {
  final repo = ref.watch(quoteRepositoryProvider);
  return repo.watchAll().map((list) {
    final sorted = [...list]..sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  });
});

/// État de filtrage de la liste : recherche libre + filtre de statut.
class QuotesFilter {
  final String search;
  final QuoteStatus? status; // null = « Tous »

  const QuotesFilter({this.search = '', this.status});

  QuotesFilter copyWith({String? search, QuoteStatus? status, bool allStatuses = false}) =>
      QuotesFilter(
        search: search ?? this.search,
        status: allStatuses ? null : (status ?? this.status),
      );
}

class QuotesFilterController extends AutoDisposeNotifier<QuotesFilter> {
  @override
  QuotesFilter build() => const QuotesFilter();

  void setSearch(String value) => state = state.copyWith(search: value);

  void setStatus(QuoteStatus? status) => state =
      status == null ? state.copyWith(allStatuses: true) : state.copyWith(status: status);
}

final quotesFilterProvider =
    NotifierProvider.autoDispose<QuotesFilterController, QuotesFilter>(
        QuotesFilterController.new);

/// Filtrage pur (testable) : statut puis recherche sur objet/client.
List<Quote> filterQuotes(List<Quote> quotes, QuotesFilter filter) {
  final q = filter.search.toLowerCase().trim();
  return quotes.where((quote) {
    if (filter.status != null && quote.status != filter.status) return false;
    if (q.isEmpty) return true;
    return quote.object.toLowerCase().contains(q) ||
        quote.client.toLowerCase().contains(q);
  }).toList();
}

/// Nombre de devis du mois courant (pour le quota et les stats).
int quotesThisMonth(List<Quote> quotes, DateTime now) =>
    quotes.where((q) => _isSameMonth(q.date, now)).length;

/// Montant total estimé des devis du mois courant.
int monthEstimatedTotal(List<Quote> quotes, DateTime now) => quotes
    .where((q) => _isSameMonth(q.date, now))
    .fold(0, (s, q) => s + q.grandTotal.round());

bool _isSameMonth(String iso, DateTime now) {
  final d = DateTime.tryParse(iso);
  return d != null && d.year == now.year && d.month == now.month;
}
