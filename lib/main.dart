import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dato/app.dart';

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

  // Étend l'app derrière la barre système Android (edge-to-edge)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  runApp(
    const ProviderScope(
      child: DatoApp(),
    ),
  );
}
