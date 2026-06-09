import 'package:flutter/material.dart';
import 'package:dato/core/theme/app_theme.dart';

enum DatoBadgeVariant { neutral, info, success, warning, danger }

class DatoBadge extends StatelessWidget {
  const DatoBadge({
    super.key,
    required this.label,
    this.variant = DatoBadgeVariant.neutral,
  });

  final String label;
  final DatoBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final (fg, bg) = _colors(variant);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fg,
          height: 1.3,
        ),
      ),
    );
  }

  static (Color, Color) _colors(DatoBadgeVariant v) {
    switch (v) {
      case DatoBadgeVariant.neutral:
        return (StatusColors.draftFg, StatusColors.draftBg);
      case DatoBadgeVariant.info:
        return (AppColors.ink, AppColors.ink100);
      case DatoBadgeVariant.success:
        return (AppColors.green700, AppColors.green100);
      case DatoBadgeVariant.warning:
        return (AppColors.amber700, AppColors.amber100);
      case DatoBadgeVariant.danger:
        return (AppColors.danger, AppColors.danger100);
    }
  }
}
