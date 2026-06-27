import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';

import 'package:dato/core/router/routes.dart';
import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/features/auth/providers/auth_provider.dart';
import 'package:dato/features/auth/domain/auth_status.dart';

import '../helpers/mock_auth_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('signup → OTP → onboarding step1 → step2 → step3 → home',
      (tester) async {
    final fakeRepo = FakeAuthRepository();

    // Router minimal pour le test : on câble les routes auth + onboarding + home
    final router = GoRouter(
      initialLocation: Routes.onboardingSignup,
      redirect: (context, state) {
        final status = fakeRepo.status;
        final path = state.uri.path;
        const authOnly = {Routes.onboardingLogin, Routes.onboardingSignup,
            Routes.onboardingForgot};
        if (status == AuthStatus.unauthenticated) {
          if (authOnly.contains(path)) return null;
          if (path == Routes.onboardingOtp) return null;
          return Routes.onboardingSignup;
        }
        if (authOnly.contains(path)) return Routes.home;
        return null;
      },
      routes: [
        GoRoute(path: Routes.home,
            builder: (_, __) => const Scaffold(
                body: Center(child: Text('Tableau de bord')))),
        GoRoute(path: Routes.onboardingSignup,
            builder: (_, __) => const Scaffold(
                body: Center(child: Text('Inscription')))),
        GoRoute(path: Routes.onboardingOtp,
            builder: (_, __) => const Scaffold(
                body: Center(child: Text('OTP')))),
        GoRoute(path: Routes.onboarding1,
            builder: (_, __) => const Scaffold(
                body: Center(child: Text('Étape 1')))),
        GoRoute(path: Routes.onboarding2,
            builder: (_, __) => const Scaffold(
                body: Center(child: Text('Étape 2')))),
        GoRoute(path: Routes.onboarding3,
            builder: (context, __) => Scaffold(
                body: Column(children: [
                  const Text('Tout est prêt !'),
                  ElevatedButton(
                    key: const Key('ob3_dashboard'),
                    onPressed: () => context.go(Routes.home),
                    child: const Text('Aller au tableau de bord'),
                  ),
                ]))),
        GoRoute(path: Routes.onboardingLogin,
            builder: (_, __) => const Scaffold(
                body: Center(child: Text('Connexion')))),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(fakeRepo)],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: router,
        ),
      ),
    );
    await tester.pump();

    // 1. On est sur l'écran Inscription
    expect(find.text('Inscription'), findsOneWidget);

    // 2. Simuler la navigation vers OTP (comme après signUp)
    router.go(Routes.onboardingOtp);
    await tester.pump();
    expect(find.text('OTP'), findsOneWidget);

    // 3. Simuler la vérification OTP réussie → onboarding step 1
    await fakeRepo.verifyOtp(phone: '+237600000000', token: '000000');
    router.go(Routes.onboarding1);
    await tester.pump();
    expect(find.text('Étape 1'), findsOneWidget);

    // 4. → Step 2
    router.go(Routes.onboarding2);
    await tester.pump();
    expect(find.text('Étape 2'), findsOneWidget);

    // 5. → Step 3
    router.go(Routes.onboarding3);
    await tester.pump();
    expect(find.text('Tout est prêt !'), findsOneWidget);

    // 6. → Home
    await tester.tap(find.byKey(const Key('ob3_dashboard')));
    await tester.pump();
    expect(find.text('Tableau de bord'), findsOneWidget);

    fakeRepo.dispose();
  });
}
