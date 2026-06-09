import 'package:flutter/material.dart';
import 'package:dato/core/theme/app_theme.dart';

enum DatoButtonVariant { primary, secondary, amber, whatsapp, danger }

class DatoButton extends StatelessWidget {
  const DatoButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = DatoButtonVariant.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.expand = true,
  });

  const DatoButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.expand = true,
  }) : variant = DatoButtonVariant.primary;

  const DatoButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.expand = true,
  }) : variant = DatoButtonVariant.secondary;

  const DatoButton.amber({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.expand = true,
  }) : variant = DatoButtonVariant.amber;

  const DatoButton.whatsapp({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.expand = true,
  }) : variant = DatoButtonVariant.whatsapp;

  const DatoButton.danger({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.expand = true,
  }) : variant = DatoButtonVariant.danger;

  final String label;
  final VoidCallback? onPressed;
  final DatoButtonVariant variant;
  final bool isLoading;
  final bool isDisabled;
  final Widget? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final effectiveCallback = (isDisabled || isLoading) ? null : onPressed;

    Widget child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon!,
                  const SizedBox(width: AppSpacing.s2),
                  Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
                ],
              )
            : Text(label);

    final minSize = expand
        ? const Size(double.infinity, kMinTapTarget)
        : const Size(0, kMinTapTarget);

    switch (variant) {
      case DatoButtonVariant.primary:
        return _buildFilled(child, effectiveCallback, AppColors.ink, Colors.white, minSize);
      case DatoButtonVariant.secondary:
        return _buildOutlined(child, effectiveCallback, AppColors.ink, minSize);
      case DatoButtonVariant.amber:
        return _buildFilled(child, effectiveCallback, AppColors.amber, Colors.white, minSize);
      case DatoButtonVariant.whatsapp:
        return _buildFilled(child, effectiveCallback, AppColors.whatsapp, Colors.white, minSize);
      case DatoButtonVariant.danger:
        return _buildFilled(child, effectiveCallback, AppColors.danger, Colors.white, minSize);
    }
  }

  Widget _buildFilled(Widget child, VoidCallback? cb, Color bg, Color fg, Size minSize) {
    return FilledButton(
      key: key,
      onPressed: cb,
      style: FilledButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        disabledBackgroundColor: bg.withValues(alpha: 0.5),
        disabledForegroundColor: fg.withValues(alpha: 0.7),
        minimumSize: minSize,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      child: child,
    );
  }

  Widget _buildOutlined(Widget child, VoidCallback? cb, Color fg, Size minSize) {
    return OutlinedButton(
      key: key,
      onPressed: cb,
      style: OutlinedButton.styleFrom(
        foregroundColor: fg,
        disabledForegroundColor: fg.withValues(alpha: 0.5),
        minimumSize: minSize,
        side: BorderSide(color: isDisabled ? AppColors.borderStrong.withValues(alpha: 0.5) : AppColors.borderStrong, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      child: child,
    );
  }
}
