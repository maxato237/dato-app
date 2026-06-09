import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/widgets/app_icons.dart';
import 'package:dato/core/router/routes.dart';

const _kBarHeight = 72.0;
const _kFabSize = 56.0; // outer diameter (white ring is part of the element)
const _kFabBorder = 4.0; // white ring thickness
// Bouton entièrement dans la barre, centré verticalement
const _kFabTopOffset = (_kBarHeight - _kFabSize) / 2; // = 8px

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  void _onNewQuote(BuildContext context) {
    context.push(Routes.quoteEditorPath('new'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _DatoBottomBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (i) => _onTap(context, i),
        onNewQuote: () => _onNewQuote(context),
      ),
    );
  }
}

class _DatoBottomBar extends StatelessWidget {
  const _DatoBottomBar({
    required this.currentIndex,
    required this.onTap,
    required this.onNewQuote,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onNewQuote;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final totalHeight = _kBarHeight + bottomPadding;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // White bar (flat, no notch)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: _kBarHeight + bottomPadding,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0F101828),
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
            ),
          ),
          // Nav row
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: _kBarHeight + bottomPadding,
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _NavItem(
                          icon: AppIcons.home,
                          label: 'Accueil',
                          isActive: currentIndex == 0,
                          onTap: () => onTap(0),
                        ),
                        _NavItem(
                          icon: AppIcons.quotes,
                          label: 'Devis',
                          isActive: currentIndex == 1,
                          onTap: () => onTap(1),
                        ),
                        // FAB placeholder — same width as FAB + small side padding
                        const SizedBox(width: _kFabSize + 8),
                        _NavItem(
                          icon: AppIcons.library,
                          label: 'Articles',
                          isActive: currentIndex == 2,
                          onTap: () => onTap(2),
                        ),
                        _NavItem(
                          icon: AppIcons.settings,
                          label: 'Réglages',
                          isActive: currentIndex == 3,
                          onTap: () => onTap(3),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: bottomPadding),
                ],
              ),
            ),
          ),
          // FAB — centré verticalement dans la barre
          Positioned(
            top: _kFabTopOffset,
            left: 0,
            right: 0,
            child: Center(child: _FabButton(onTap: onNewQuote)),
          ),
        ],
      ),
    );
  }
}

class _FabButton extends StatelessWidget {
  const _FabButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _kFabSize,
        height: _kFabSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surface, // white ring
        ),
        padding: const EdgeInsets.all(_kFabBorder),
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.green,
            boxShadow: [
              BoxShadow(
                color: AppColors.green.withValues(alpha: 0.42),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(AppIcons.add, color: Colors.white, size: 25),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Maquette: l'icône active ne change pas de forme, seulement de couleur.
    final color = isActive ? AppColors.ink : AppColors.textLight;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 25),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Sora',
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
