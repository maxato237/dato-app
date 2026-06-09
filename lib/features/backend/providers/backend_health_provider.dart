import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dato/core/network/backend_providers.dart';

final backendHealthProvider = FutureProvider<bool>((ref) async {
  final client = ref.read(backendApiClientProvider);
  final response = await client.get('/health');
  return response.statusCode == 200;
});
