import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'backend_api_client.dart';

const _kBackendBaseUrl = String.fromEnvironment(
  'BACKEND_BASE_URL',
  defaultValue: 'http://10.0.2.2:5000',
);

/// Adresse du backend Flask. En dev, utilisez :
///   --dart-define=BACKEND_BASE_URL=http://localhost:5000
final backendBaseUrlProvider = Provider<String>((_) => _kBackendBaseUrl);

final backendApiClientProvider = Provider<BackendApiClient>((ref) {
  final baseUrl = ref.read(backendBaseUrlProvider);
  return BackendApiClient(baseUrl);
});
