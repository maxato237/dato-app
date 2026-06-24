import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'backend_api_client.dart';
import 'network_providers.dart';

/// URL du backend pour le client « brut » (health check). Pointe sur la **même**
/// adresse que l'API REST authentifiée ([kApiBaseUrl]) afin d'éviter toute
/// divergence d'hôte. Configurez via `--dart-define=API_BASE_URL=...`.
final backendBaseUrlProvider = Provider<String>((_) => kApiBaseUrl);

final backendApiClientProvider = Provider<BackendApiClient>((ref) {
  return BackendApiClient(ref.read(backendBaseUrlProvider));
});
