import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dato/core/router/app_router.dart';
import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/data/sync/company_sync_service.dart';
import 'package:dato/data/sync/quote_pull_service.dart';
import 'package:dato/data/sync/quote_sync_service.dart';
import 'package:dato/features/auth/providers/auth_provider.dart';

class DatoApp extends ConsumerStatefulWidget {
  const DatoApp({super.key});

  @override
  ConsumerState<DatoApp> createState() => _DatoAppState();
}

class _DatoAppState extends ConsumerState<DatoApp> {
  StreamSubscription<void>? _sessionExpiredSub;

  @override
  void initState() {
    super.initState();
    // S'abonner après le premier frame pour que le router soit monté.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sessionExpiredSub = ref
          .read(authRepositoryProvider)
          .sessionExpiredEvents
          .listen((_) => _showSessionExpiredDialog());
    });
  }

  @override
  void dispose() {
    _sessionExpiredSub?.cancel();
    super.dispose();
  }

  void _showSessionExpiredDialog() {
    final router = ref.read(appRouterProvider);
    final ctx = router.routerDelegate.navigatorKey.currentContext;
    if (ctx == null || !ctx.mounted) return;
    showDialog<void>(
      context: ctx,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Session expirée'),
        content: const Text(
          'Votre session a expiré. '
          'Veuillez vous reconnecter pour continuer.',
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(ctx, rootNavigator: true).pop(),
            child: const Text('Se reconnecter'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.read(appRouterProvider);

    ref.watch(quotePullCoordinatorProvider);
    ref.watch(quoteSyncServiceProvider);
    ref.watch(companySyncServiceProvider);

    return MaterialApp.router(
      title: 'DATO',
      theme: AppTheme.light(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr')],
    );
  }
}
