import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:dato/core/config/app_config.dart';
import 'package:dato/core/router/routes.dart';
import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/utils/formatters.dart';
import 'package:dato/core/widgets/dato_button.dart';
import 'package:dato/core/widgets/dato_toast.dart';
import 'package:dato/core/widgets/skeleton_list.dart';
import 'package:dato/features/dashboard/widgets/quota_card.dart';
import 'package:dato/features/dashboard/widgets/stat_card.dart';
import 'package:dato/features/quotes/domain/quote.dart';
import 'package:dato/features/quotes/providers/quotes_list_controller.dart';
import 'package:dato/features/quotes/widgets/quote_actions_sheet.dart';
import 'package:dato/features/quotes/widgets/quote_card.dart';
import 'package:dato/features/settings/domain/company.dart';
import 'package:dato/features/settings/providers/company_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotesAsync = ref.watch(quotesStreamProvider);
    final quotes = quotesAsync.valueOrNull ?? const <Quote>[];
    final company = ref.watch(currentCompanyProvider);
    final now = DateTime.now();
    final monthCount = quotesThisMonth(quotes, now); // quota mensuel du forfait
    final totalCount = quotes.length;
    final totalAmount =
        quotes.fold<int>(0, (s, q) => s + q.grandTotal.round());
    final recents = quotes.take(3).toList();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _dashTop(context, company),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      QuotaCard(
                        used: monthCount,
                        limit: kFreeQuota,
                        // Lancement en accès libre : pas de quota ni de CTA Pro.
                        unlimited: !kBillingEnabled,
                        onUpgrade: kBillingEnabled
                            ? () => DatoToast.show(context,
                                message: 'Le passage à Pro arrive en Phase 7',
                                variant: DatoToastVariant.info)
                            : null,
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              icon: Icons.description_outlined,
                              label: 'Total devis',
                              value: '$totalCount',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: StatCard(
                              icon: Icons.calculate_outlined,
                              label: 'Montant estimé',
                              value: formatMoney(totalAmount),
                              unit: 'FCFA',
                              small: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _sectionTitle(context, 'Devis récents',
                          onSeeAll: () => context.go(Routes.quotes)),
                      const SizedBox(height: 12),
                      if (quotesAsync.isLoading)
                        const SkeletonList(itemCount: 3)
                      else if (recents.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Aucun devis pour l’instant.',
                              style: TextStyle(color: AppColors.textMuted)),
                        )
                      else
                        for (final q in recents) ...[
                          QuoteCard(
                            quote: q,
                            onTap: () =>
                                context.push(Routes.quoteEditorPath(q.id)),
                            onMenu: () => showQuoteActions(context, ref,
                                quote: q, company: company),
                          ),
                          const SizedBox(height: 12),
                        ],
                      const SizedBox(height: 4),
                      DatoButton.primary(
                        label: 'Nouveau devis',
                        icon: const Icon(Icons.add, size: 20),
                        onPressed: () =>
                            context.push(Routes.quoteEditorPath('new')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dashTop(BuildContext context, Company company) {
    final Widget avatar = company.hasLogo
        ? ClipOval(
            child: Image.network(
              company.logoUrl,
              width: 46,
              height: 46,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _letterAvatar(context, company.initial),
            ),
          )
        : _letterAvatar(context, company.initial);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          avatar,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Bonjour,',
                    style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                Text(company.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 18, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: IconButton(
              icon: const Icon(Icons.settings_outlined, size: 20),
              color: AppColors.textMuted,
              onPressed: () => context.go(Routes.settings),
              tooltip: 'Réglages',
            ),
          ),
        ],
      ),
    );
  }

  Widget _letterAvatar(BuildContext context, String initial) {
    return Container(
      width: 46,
      height: 46,
      decoration:
          const BoxDecoration(color: AppColors.ink, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title,
      {required VoidCallback onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontSize: 16, fontWeight: FontWeight.w700)),
        TextButton(
          onPressed: onSeeAll,
          style: TextButton.styleFrom(
              foregroundColor: AppColors.ink,
              padding: const EdgeInsets.symmetric(horizontal: 8)),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tout voir',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              Icon(Icons.chevron_right, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}
