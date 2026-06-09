import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:dato/core/router/routes.dart';
import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/widgets/empty_state.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import 'package:dato/features/quotes/providers/quotes_list_controller.dart';
import 'package:dato/features/quotes/widgets/quote_actions_sheet.dart';
import 'package:dato/features/quotes/widgets/quote_card.dart';
import 'package:dato/features/settings/providers/company_provider.dart';

class QuotesListScreen extends ConsumerWidget {
  const QuotesListScreen({super.key});

  static const _chips = <(String, QuoteStatus?)>[
    ('Tous', null),
    ('Brouillon', QuoteStatus.draft),
    ('Envoyé', QuoteStatus.sent),
    ('Accepté', QuoteStatus.accepted),
    ('Refusé', QuoteStatus.refused),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotes = ref.watch(quotesStreamProvider).valueOrNull ?? const <Quote>[];
    final filter = ref.watch(quotesFilterProvider);
    final company = ref.watch(currentCompanyProvider);
    final filtered = filterQuotes(quotes, filter);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes devis')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: TextField(
              key: const Key('search-field'),
              onChanged: ref.read(quotesFilterProvider.notifier).setSearch,
              decoration: const InputDecoration(
                hintText: 'Rechercher un devis, un client…',
                prefixIcon: Icon(Icons.search, size: 20),
              ),
            ),
          ),
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              itemCount: _chips.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final (label, status) = _chips[i];
                final selected = filter.status == status;
                return _chip(
                  label: label,
                  selected: selected,
                  keyName: status?.name ?? 'all',
                  onTap: () =>
                      ref.read(quotesFilterProvider.notifier).setStatus(status),
                );
              },
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const EmptyState(
                    icon: Icons.search,
                    title: 'Aucun résultat',
                    subtitle: 'Essayez un autre mot-clé ou filtre.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final q = filtered[i];
                      return QuoteCard(
                        quote: q,
                        onTap: () =>
                            context.push(Routes.quoteEditorPath(q.id)),
                        onMenu: () => showQuoteActions(context, ref,
                            quote: q, company: company),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _chip({
    required String label,
    required bool selected,
    required String keyName,
    required VoidCallback onTap,
  }) {
    return Center(
      child: InkWell(
        key: Key('chip-$keyName'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        child: Container(
          decoration: BoxDecoration(
            color: selected ? AppColors.ink : AppColors.surface,
            border: Border.all(
                color: selected ? AppColors.ink : AppColors.border, width: 1.5),
            borderRadius: BorderRadius.circular(AppRadii.pill),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
