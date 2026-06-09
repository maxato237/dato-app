import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dato/core/router/app_router.dart';
import 'package:dato/core/theme/app_theme.dart';

class DatoApp extends ConsumerWidget {
  const DatoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.read intentionnel : le router est un singleton,
    // RouterNotifier.notifyListeners() rafraîchit les redirections en interne.
    final router = ref.read(appRouterProvider);

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
