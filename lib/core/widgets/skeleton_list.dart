import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:dato/core/theme/app_theme.dart';

class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s2),
        itemBuilder: (_, __) => const _SkeletonQuoteCard(),
      ),
    );
  }
}

class _SkeletonQuoteCard extends StatelessWidget {
  const _SkeletonQuoteCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 14,
                  color: AppColors.border,
                ),
                const SizedBox(height: AppSpacing.s2),
                Container(
                  width: 80,
                  height: 12,
                  color: AppColors.border,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(width: 70, height: 14, color: AppColors.border),
              const SizedBox(height: AppSpacing.s2),
              Container(
                width: 60,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
