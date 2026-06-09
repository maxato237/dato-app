import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:dato/features/auth/data/auth_repository.dart';
import 'package:dato/features/auth/domain/auth_status.dart';
import 'package:dato/features/auth/presentation/otp_screen.dart';
import 'package:dato/features/auth/providers/auth_provider.dart';
import 'package:dato/core/theme/app_theme.dart';

import '../helpers/mock_auth_repository.dart';

Widget _buildOtp(AuthRepository repo) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(repo),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: const OtpScreen(),
    ),
  );
}

void main() {
  late MockAuthRepository repo;

  setUp(() {
    repo = MockAuthRepository();
    when(() => repo.pendingPhone).thenReturn('+237674702037');
    when(() => repo.isResetFlow).thenReturn(false);
    when(() => repo.status).thenReturn(AuthStatus.unauthenticated);
    when(() => repo.authStateChanges)
        .thenAnswer((_) => Stream.value(AuthStatus.unauthenticated));
  });

  testWidgets('bouton Vérifier désactivé tant que les 6 cases ne sont pas remplies',
      (tester) async {
    await tester.pumpWidget(_buildOtp(repo));
    await tester.pump();

    // Bouton présent mais inactif (opacité + onPressed null)
    final btn = tester.widget<FilledButton>(find.byKey(const Key('otp_verify_btn')));
    expect(btn.onPressed, isNull);
  });

  testWidgets('bouton Vérifier activé quand les 6 cases sont remplies',
      (tester) async {
    await tester.pumpWidget(_buildOtp(repo));
    await tester.pump();

    // Saisir un chiffre dans chaque case
    for (int i = 0; i < 6; i++) {
      await tester.enterText(find.byKey(Key('otp_field_$i')), '$i');
      await tester.pump();
    }

    final btn = tester.widget<FilledButton>(find.byKey(const Key('otp_verify_btn')));
    expect(btn.onPressed, isNotNull);
  });

  testWidgets('le compte à rebours s\'affiche et se décrémente',
      (tester) async {
    await tester.pumpWidget(_buildOtp(repo));
    await tester.pump();

    expect(find.textContaining('0:42'), findsOneWidget);

    // Avancer d'1 seconde
    await tester.pump(const Duration(seconds: 1));
    expect(find.textContaining('0:41'), findsOneWidget);
  });
}
