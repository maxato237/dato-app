import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api_client.dart';
import 'token_storage.dart';

// URL de base UNIQUE du backend (API REST + health). Configurée via
// --dart-define à l'exécution :
//   Déploiement : --dart-define=API_BASE_URL=https://dato-backend-00h1q.sevalla.app
//   Développement local : --dart-define=API_BASE_URL=http://localhost:5000
//   Appareil réel (si backend local) : --dart-define=API_BASE_URL=http://<ip-pc>:5000
// Les valeurs par défaut ci-dessous sont utilisées si aucune variable d'environnement
// n'est fournie au moment du build/exécution.
const kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'https://dato-backend-00h1q.sevalla.app',
);

final tokenStorageProvider = Provider<TokenStorage>(
  (_) => TokenStorage(),
);

final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.read(tokenStorageProvider);
  return ApiClient(baseUrl: kApiBaseUrl, storage: storage);
});
