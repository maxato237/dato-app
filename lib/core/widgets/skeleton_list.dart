import 'package:flutter/material.dart';
import 'package:dato/core/theme/app_theme.dart';

/// Liste de cartes « squelette » affichée pendant le chargement d'une vue de
/// liste (devis, articles). Implémentation maison (sans dépendance externe)
/// avec un léger effet de pulsation.
class SkeletonList extends StatefulWidget {
  const SkeletonList({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  State<SkeletonList> createState() => _SkeletonListState();
}

class _SkeletonListState extends State<SkeletonList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.55, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s2),
        itemBuilder: (_, __) => const _SkeletonCard(),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.width, required this.height, this.radius = 4});
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Bar(width: 140, height: 14),
                SizedBox(height: AppSpacing.s2),
                _Bar(width: 90, height: 12),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _Bar(width: 70, height: 14),
              SizedBox(height: AppSpacing.s2),
              _Bar(width: 60, height: 20, radius: 999),
            ],
          ),
        ],
      ),
    );
  }
}
