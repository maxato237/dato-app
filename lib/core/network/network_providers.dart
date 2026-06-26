import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';
import 'token_storage.dart';

// URL de base UNIQUE du backend (API REST + health). Configurée via
// --dart-define à l'exécution :
//   Appareil réel (défaut) : IP LAN du PC, ex. http://192.168.1.128:5000
//   Émulateur Android      : --dart-define=API_BASE_URL=http://10.0.2.2:5000
//   Simulateur iOS         : --dart-define=API_BASE_URL=http://localhost:5000
// Défaut = IP LAN du PC car la cible de dev ici est un TÉLÉPHONE PHYSIQUE sur
// le même WiFi (10.0.2.2 ne marche QUE sur l'émulateur). Si l'IP du PC change
// (DHCP), relancer avec --dart-define=API_BASE_URL=http://<nouvelle-IP>:5000.
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
