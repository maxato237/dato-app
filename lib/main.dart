import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dato/app.dart';
import 'package:dato/data/local/isar_service.dart';

// Fournir ces valeurs via --dart-define lors du lancement :
//   flutter run --dart-define=SUPABASE_URL=https://xxx.supabase.co \
//               --dart-define=SUPABASE_ANON_KEY=eyJxxx...
const _kSupabaseUrl =
    String.fromEnvironment('SUPABASE_URL', defaultValue: '');
const _kSupabaseKey =
    String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (_kSupabaseUrl.isNotEmpty && _kSupabaseKey.isNotEmpty) {
    await Supabase.initialize(url: _kSupabaseUrl, publishableKey: _kSupabaseKey);
  }

  // Persistance locale durable (offline-first). En cas d'échec d'ouverture
  // (ex. plateforme sans binaire natif), on reste fonctionnel en mémoire.
  Isar? isar;
  try {
    isar = await openAppIsar();
  } catch (_) {
    isar = null;
  }

  // Étend l'app derrière la barre système Android (edge-to-edge).
  // Icônes système en sombre pour rester visibles au-dessus de la barre de
  // navigation blanche de l'app (sinon elles se confondent avec elle).
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runApp(
    ProviderScope(
      overrides: [
        if (isar != null) isarProvider.overrideWithValue(isar),
      ],
      child: const DatoApp(),
    ),
  );
}
