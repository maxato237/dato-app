import 'package:flutter/material.dart';

import 'package:dato/core/theme/app_theme.dart';

/// Carte du forfait affichée en haut du tableau de bord.
///
/// Deux modes :
/// - **Accès libre** ([unlimited] = true, défaut au lancement) : pas de quota,
///   pas de CTA Pro — message neutre « créez autant de devis que vous voulez ».
/// - **Freemium** ([unlimited] = false) : X / limite + barre + CTA « Passer à
///   Pro » (réactivé quand la monétisation revient, cf. `kBillingEnabled`).
class QuotaCard extends StatelessWidget {
  const QuotaCard({
    super.key,
    required this.used,
    required this.limit,
    this.unlimited = false,
    this.onUpgrade,
  });

  final int used;
  final int limit;
  final bool unlimited;
  final VoidCallback? onUpgrade;

  @override
  Widget build(BuildContext context) {
    final head = Theme.of(context).textTheme.titleLarge!;
    final remaining = (limit - used).clamp(0, limit);
    final fraction = limit == 0 ? 0.0 : (used / limit).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.ink, AppColors.ink600],
        ),
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(unlimited ? Icons.lock_open_outlined : Icons.info_outline,
                        size: 14, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(unlimited ? 'Accès libre' : 'Forfait Gratuit',
                        style: head.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ],
                ),
              ),
              Text(unlimited ? '$used' : '$used / $limit',
                  style: head.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  )),
            ],
          ),
          if (!unlimited)
            Container(
              height: 8,
              margin: const EdgeInsets.only(top: 12, bottom: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                widthFactor: fraction,
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.amber,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            )
          else
            const SizedBox(height: 10),
          Text(
            unlimited
                ? 'Créez autant de devis que vous voulez — c\'est gratuit.'
                : (remaining > 0
                    ? 'Il vous reste $remaining devis gratuit${remaining > 1 ? 's' : ''} ce mois-ci.'
                    : 'Quota atteint — passez à Pro pour continuer.'),
            style: TextStyle(
                fontSize: 12, color: Colors.white.withValues(alpha: 0.85)),
          ),
          if (!unlimited && onUpgrade != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onUpgrade,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.amber,
                  foregroundColor: const Color(0xFF3A2A00),
                  minimumSize: const Size.fromHeight(44),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadii.md)),
                  textStyle:
                      head.copyWith(fontSize: 14, fontWeight: FontWeight.w700),
                ),
                icon: const Icon(Icons.workspace_premium_outlined, size: 17),
                label: const Text('Passer à DATO Pro'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
