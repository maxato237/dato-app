import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Abstraction testable au-dessus de `connectivity_plus`.
///
/// Tolérante : en cas d'erreur de plateforme (ex. environnement de test sans
/// plugin), on suppose l'appareil **en ligne** pour ne jamais bloquer l'UI.
class ConnectivityService {
  const ConnectivityService();

  Future<bool> isOnline() async {
    try {
      return _online(await Connectivity().checkConnectivity());
    } catch (_) {
      return true;
    }
  }

  /// Émet l'état courant, puis à chaque changement réseau.
  Stream<bool> watch() async* {
    yield await isOnline();
    yield* Connectivity()
        .onConnectivityChanged
        .map(_online)
        .handleError((Object _) {});
  }

  static bool _online(List<ConnectivityResult> results) =>
      results.any((r) => r != ConnectivityResult.none);
}

final connectivityServiceProvider =
    Provider<ConnectivityService>((_) => const ConnectivityService());

/// `true` quand l'appareil a une connexion réseau. Démarre optimiste.
final isOnlineProvider = StreamProvider<bool>(
  (ref) => ref.watch(connectivityServiceProvider).watch(),
);
