import 'package:flutter/material.dart';

import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/utils/dates.dart';
import 'package:dato/core/utils/formatters.dart';
import 'package:dato/core/widgets/status_badge.dart';
import 'package:dato/features/quotes/domain/quote.dart';

/// Carte d'un devis (tableau de bord + liste). Tap = ouvrir l'éditeur,
/// bouton ⋮ = menu d'actions.
class QuoteCard extends StatelessWidget {
  const QuoteCard({
    super.key,
    required this.quote,
    required this.onTap,
    required this.onMenu,
  });

  final Quote quote;
  final VoidCallback onTap;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final head = Theme.of(context).textTheme.titleLarge!;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quote.object.isEmpty ? 'Sans objet' : quote.object,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: head.copyWith(
                              fontSize: 14.5, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.person_outline,
                                size: 13, color: AppColors.textMuted),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                quote.client.isEmpty
                                    ? 'Client non renseigné'
                                    : quote.client,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 12.5,
                                    color: AppColors.textMuted),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  StatusBadge(status: quote.status),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 13),
                padding: const EdgeInsets.only(top: 11),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        '${quote.number} · ${frenchShortDate(quote.date)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 11.5, color: AppColors.textLight),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formatMoney(quote.grandTotal),
                      style: head.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      height: 32,
                      child: IconButton(
                        key: Key('quote-menu-${quote.id}'),
                        padding: EdgeInsets.zero,
                        iconSize: 18,
                        color: AppColors.textMuted,
                        icon: const Icon(Icons.more_vert),
                        onPressed: onMenu,
                        tooltip: 'Actions',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
