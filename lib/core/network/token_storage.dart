import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persiste les tokens JWT dans le trousseau sécurisé de l'OS.
class TokenStorage {
  static const _accessKey = 'dato_access_token';
  static const _refreshKey = 'dato_refresh_token';

  final FlutterSecureStorage _store;

  TokenStorage({FlutterSecureStorage? store})
      : _store = store ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(),
            );

  Future<String?> getAccessToken() => _store.read(key: _accessKey);
  Future<String?> getRefreshToken() => _store.read(key: _refreshKey);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _store.write(key: _accessKey, value: accessToken),
      _store.write(key: _refreshKey, value: refreshToken),
    ]);
  }

  Future<void> clear() async {
    await Future.wait([
      _store.delete(key: _accessKey),
      _store.delete(key: _refreshKey),
    ]);
  }

  Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
