import 'package:flutter/material.dart';

import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/utils/formatters.dart';
import 'package:dato/core/utils/montant_en_lettres.dart';

/// Carte « Total général » (bandeau encre) + montant en toutes lettres généré
/// automatiquement à partir du total.
class TotalCard extends StatelessWidget {
  const TotalCard({super.key, required this.total});

  final num total;

  @override
  Widget build(BuildContext context) {
    final head = Theme.of(context).textTheme.titleLarge!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.ink,
            borderRadius: BorderRadius.circular(AppRadii.lg),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL GÉNÉRAL',
                style: head.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.8),
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                key: const Key('grand-total'),
                formatFcfa(total),
                style: head.copyWith(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.ink050,
            border: Border.all(color: AppColors.ink100),
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.green100,
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, size: 12, color: AppColors.green700),
                    SizedBox(width: 4),
                    Text(
                      'Généré automatiquement',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.green700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text.rich(
                TextSpan(
                  text: 'Arrêté le présent devis à la somme de ',
                  children: [
                    TextSpan(
                      text: montantEnLettres(total).toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
                key: const Key('montant-lettres'),
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 13,
                  color: AppColors.text,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
