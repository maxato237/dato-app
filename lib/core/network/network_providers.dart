import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';
import 'token_storage.dart';

// URL de base configurée via --dart-define à l'exécution.
// Android emulator : --dart-define=API_BASE_URL=http://10.0.2.2:5000
// iOS simulator    : --dart-define=API_BASE_URL=http://localhost:5000
// Appareil réel    : valeur par défaut = IP du PC sur le réseau WiFi local
const kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://192.168.1.128:5000',
);

final tokenStorageProvider = Provider<TokenStorage>(
  (_) => TokenStorage(),
);

final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.read(tokenStorageProvider);
  return ApiClient(baseUrl: kApiBaseUrl, storage: storage);
});
