import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:dato/features/auth/data/auth_repository.dart';
import 'package:dato/features/auth/domain/auth_status.dart';
import 'package:dato/features/auth/presentation/reset_screen.dart';
import 'package:dato/features/auth/providers/auth_provider.dart';
import 'package:dato/core/theme/app_theme.dart';

import '../helpers/mock_auth_repository.dart';

Widget _buildReset(AuthRepository repo) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(repo),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: const ResetScreen(),
    ),
  );
}

void main() {
  late MockAuthRepository repo;

  setUp(() {
    repo = MockAuthRepository();
    when(() => repo.status).thenReturn(AuthStatus.unauthenticated);
    when(() => repo.authStateChanges)
        .thenAnswer((_) => Stream.value(AuthStatus.unauthenticated));
  });

  testWidgets('bouton Réinitialiser désactivé quand les champs sont vides',
      (tester) async {
    await tester.pumpWidget(_buildReset(repo));
    await tester.pump();

    final btn = tester.widget<FilledButton>(
        find.byKey(const Key('reset_submit')));
    expect(btn.onPressed, isNull);
  });

  testWidgets('affiche une erreur quand les mots de passe ne correspondent pas',
      (tester) async {
    await tester.pumpWidget(_buildReset(repo));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('reset_pw1')), 'password123');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('reset_pw2')), 'different456');
    await tester.pump();

    expect(
      find.text('Les mots de passe ne correspondent pas'),
      findsOneWidget,
    );

    final btn = tester.widget<FilledButton>(
        find.byKey(const Key('reset_submit')));
    expect(btn.onPressed, isNull);
  });

  testWidgets('bouton Réinitialiser actif quand les mots de passe correspondent',
      (tester) async {
    await tester.pumpWidget(_buildReset(repo));
    await tester.pump();

    await tester.enterText(find.byKey(const Key('reset_pw1')), 'password123');
    await tester.pump();
    await tester.enterText(find.byKey(const Key('reset_pw2')), 'password123');
    await tester.pump();

    expect(find.text('Les mots de passe ne correspondent pas'), findsNothing);

    final btn = tester.widget<FilledButton>(
        find.byKey(const Key('reset_submit')));
    expect(btn.onPressed, isNotNull);
  });
}
