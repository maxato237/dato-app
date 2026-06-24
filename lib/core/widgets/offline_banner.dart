import 'package:flutter/material.dart';

import 'package:dato/core/theme/app_theme.dart';

/// Bandeau persistant « hors-ligne ». L'appelant décide de l'afficher (selon
/// [isOnlineProvider]) ; le widget gère son propre inset de barre de statut.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return Container(
      key: const Key('offline-banner'),
      width: double.infinity,
      color: AppColors.amber,
      padding: EdgeInsets.only(top: topInset + 6, bottom: 6, left: 12, right: 12),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off_outlined, size: 16, color: Colors.white),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              'Hors-ligne — vos modifications seront synchronisées',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
