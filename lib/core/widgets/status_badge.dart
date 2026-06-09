import 'package:flutter/material.dart';
import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/features/quotes/domain/quote.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final QuoteStatus status;

  @override
  Widget build(BuildContext context) {
    final (fg, bg, label) = _resolve(status);
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

  static (Color, Color, String) _resolve(QuoteStatus s) {
    switch (s) {
      case QuoteStatus.draft:
        return (StatusColors.draftFg, StatusColors.draftBg, 'Brouillon');
      case QuoteStatus.sent:
        return (StatusColors.sentFg, StatusColors.sentBg, 'Envoyé');
      case QuoteStatus.accepted:
        return (StatusColors.acceptedFg, StatusColors.acceptedBg, 'Accepté');
      case QuoteStatus.refused:
        return (StatusColors.refusedFg, StatusColors.refusedBg, 'Refusé');
    }
  }
}
