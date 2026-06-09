import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:dato/features/auth/domain/auth_status.dart';
import 'package:dato/features/auth/presentation/forgot_screen.dart';
import 'package:dato/features/auth/presentation/login_screen.dart';
import 'package:dato/features/auth/presentation/otp_screen.dart';
import 'package:dato/features/auth/presentation/reset_screen.dart';
import 'package:dato/features/auth/presentation/signup_screen.dart';
import 'package:dato/features/auth/providers/auth_provider.dart';
import 'package:dato/features/dashboard/presentation/dashboard_screen.dart';
import 'package:dato/features/library/presentation/library_screen.dart';
import 'package:dato/features/onboarding/presentation/onboarding_screen.dart';
import 'package:dato/features/quotes/presentation/quote_editor_screen.dart';
import 'package:dato/features/quotes/presentation/quote_preview_screen.dart';
import 'package:dato/features/quotes/presentation/quotes_list_screen.dart';
import 'package:dato/features/settings/presentation/settings_screen.dart';
import 'package:dato/features/shell/app_shell.dart';
import 'routes.dart';

/// Chemins auth que le router redirige vers /home quand l'utilisateur
/// est déjà authentifié.
const _redirectedAuthPaths = {
  Routes.onboardingLogin,
  Routes.onboardingSignup,
  Routes.onboardingForgot,
};

/// Provider du router — réactif à [routerNotifierProvider].
///
/// Le router est créé une seule fois et rafraîchit son `redirect` à chaque
/// changement de session (via `refreshListenable`).
final appRouterProvider = Provider<GoRouter>((ref) {
  // ref.read intentionnel : le router est un singleton.
  // ref.watch causerait un nouveau GoRouter à chaque notifyListeners().
  final notifier = ref.read(routerNotifierProvider);

  return GoRouter(
    refreshListenable: notifier,
    initialLocation: Routes.home,
    redirect: (context, state) {
      final repo = ref.read(authRepositoryProvider);
      final status = repo.status;
      final path = state.uri.path;

      if (status == AuthStatus.unauthenticated) {
        // Laisser passer les écrans auth ; bloquer le reste.
        if (_redirectedAuthPaths.contains(path)) return null;
        // OTP et Reset : états intermédiaires, pas de redirection.
        if (path == Routes.onboardingOtp) return null;
        if (path == Routes.onboardingReset) return null;
        return Routes.onboardingLogin;
      }

      // Authentifié → quitter les écrans de connexion/inscription/oubli.
      if (_redirectedAuthPaths.contains(path)) return Routes.home;
      return null;
    },
    routes: [
      // ── Shell (app principale avec bottom nav) ──────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.home,
              builder: (_, __) => const DashboardScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.quotes,
              builder: (_, __) => const QuotesListScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.library,
              builder: (_, __) => const LibraryScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.settings,
              builder: (_, __) => const SettingsScreen(),
            ),
          ]),
        ],
      ),

      // ── Éditeur & aperçu ───────────────────────────────────────────────
      GoRoute(
        path: '/quote/:id',
        builder: (_, state) =>
            QuoteEditorScreen(quoteId: state.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'preview',
            builder: (_, state) =>
                QuotePreviewScreen(quoteId: state.pathParameters['id']!),
          ),
        ],
      ),

      // ── Auth ────────────────────────────────────────────────────────────
      GoRoute(
        path: Routes.onboardingLogin,
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.onboardingSignup,
        builder: (_, __) => const SignupScreen(),
      ),
      GoRoute(
        path: Routes.onboardingOtp,
        builder: (_, __) => const OtpScreen(),
      ),
      GoRoute(
        path: Routes.onboardingForgot,
        builder: (_, __) => const ForgotScreen(),
      ),
      GoRoute(
        path: Routes.onboardingReset,
        builder: (_, __) => const ResetScreen(),
      ),

      // ── Onboarding ──────────────────────────────────────────────────────
      GoRoute(
        path: Routes.onboarding1,
        builder: (_, __) => const OnboardingScreen(step: 1),
      ),
      GoRoute(
        path: Routes.onboarding2,
        builder: (_, __) => const OnboardingScreen(step: 2),
      ),
      GoRoute(
        path: Routes.onboarding3,
        builder: (_, __) => const OnboardingScreen(step: 3),
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      body: Center(child: Text('Page introuvable : ${state.uri}')),
    ),
  );
});
