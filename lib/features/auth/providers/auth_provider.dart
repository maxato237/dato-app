import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dato/core/network/network_providers.dart';
import 'package:dato/features/auth/data/auth_repository.dart';
import 'package:dato/features/auth/data/flask_auth_repository.dart';
import 'package:dato/features/auth/domain/auth_status.dart';

/// Dépôt actif — [FlaskAuthRepository].
/// Remplaçable en tests via `.overrideWith(...)`.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.read(tokenStorageProvider);
  final client = ref.read(apiClientProvider);
  final repo = FlaskAuthRepository(storage: storage, client: client);

  // Abonne le apiClient à la session expirée : si le token ne peut être
  // rafraîchi, le repo émet unauthenticated via sessionExpiredStream.
  ref.onDispose(repo.dispose);
  return repo;
});

/// Notifie le router à chaque changement de session.
class RouterNotifier extends ChangeNotifier {
  StreamSubscription<AuthStatus>? _sub;

  RouterNotifier(AuthRepository repo) {
    _sub = repo.authStateChanges.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final routerNotifierProvider = ChangeNotifierProvider<RouterNotifier>((ref) {
  return RouterNotifier(ref.watch(authRepositoryProvider));
});
