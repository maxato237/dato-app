import 'package:flutter/material.dart';
import 'package:dato/core/theme/app_theme.dart';

enum DatoToastVariant { success, error, info, warning }

class DatoToast {
  static void show(
    BuildContext context, {
    required String message,
    DatoToastVariant variant = DatoToastVariant.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final (bg, icon) = _resolve(variant);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          content: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s4,
              vertical: AppSpacing.s3,
            ),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(AppRadii.md),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: AppSpacing.s2),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  static (Color, IconData) _resolve(DatoToastVariant v) {
    switch (v) {
      case DatoToastVariant.success:
        return (AppColors.green700, Icons.check_circle_outline);
      case DatoToastVariant.error:
        return (AppColors.danger, Icons.error_outline);
      case DatoToastVariant.warning:
        return (AppColors.amber700, Icons.warning_amber_outlined);
      case DatoToastVariant.info:
        return (AppColors.ink, Icons.info_outline);
    }
  }
}
