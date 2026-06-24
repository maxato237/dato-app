import 'dart:async';

import 'package:dio/dio.dart';

import 'api_exception.dart';
import 'token_storage.dart';

/// Client HTTP central pour l'API Flask.
///
/// - Injecte le Bearer token sur chaque requête authentifiée.
/// - Sur 401 : tente un refresh automatique, puis rejoue la requête.
/// - Si le refresh échoue : efface les tokens, émet [sessionExpiredStream].
class ApiClient {
  final TokenStorage _storage;
  final Dio _dio;
  bool _isRefreshing = false;

  // Notifie FlaskAuthRepository quand la session est définitivement expirée.
  final _sessionExpiredCtrl = StreamController<void>.broadcast();
  Stream<void> get sessionExpiredStream => _sessionExpiredCtrl.stream;

  ApiClient({
    required TokenStorage storage,
    required String baseUrl,
    Dio? dio,
  })  : _storage = storage,
        _dio = dio ??
            Dio(BaseOptions(
              baseUrl: baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 15),
              headers: {'Accept': 'application/json'},
            )) {
    _dio.interceptors.add(_AuthInterceptor(this));
  }

  // ── Méthodes publiques ──────────────────────────────────────────────────

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParams,
    bool auth = true,
  }) =>
      _request('GET', path, queryParams: queryParams, auth: auth);

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) =>
      _request('POST', path, body: body, auth: auth);

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) =>
      _request('PUT', path, body: body, auth: auth);

  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) =>
      _request('PATCH', path, body: body, auth: auth);

  Future<void> delete(String path, {bool auth = true}) async {
    await _request('DELETE', path, auth: auth);
  }

  /// Envoie une image (multipart) vers `/api/uploads` et retourne son URL.
  Future<String> uploadImage(String filePath) async {
    try {
      final token = await _storage.getAccessToken();
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.post(
        '/api/uploads',
        data: formData,
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );
      final data = (response.data as Map<String, dynamic>)['data']
          as Map<String, dynamic>;
      return data['url'] as String;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Supprime une image précédemment uploadée (Cloudinary) à partir de son URL.
  /// Best-effort : un échec n'est pas propagé (l'orphelin sera nettoyé plus tard).
  Future<void> deleteImage(String url) async {
    if (url.isEmpty || !url.startsWith('http')) return;
    try {
      final token = await _storage.getAccessToken();
      await _dio.delete(
        '/api/uploads',
        queryParameters: {'url': url},
        data: {'url': url},
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );
    } catch (_) {
      // Best-effort : on ignore les erreurs (hors-ligne, endpoint absent…).
    }
  }

  /// Envoie un fichier Word (.doc/.docx) vers `/api/company/template`,
  /// met à jour `company.template_docx_url` côté backend, et retourne l'URL.
  Future<String> uploadTemplate(String filePath) async {
    try {
      final token = await _storage.getAccessToken();
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.post(
        '/api/company/template',
        data: formData,
        options: Options(
          headers: {if (token != null) 'Authorization': 'Bearer $token'},
        ),
      );
      final data = (response.data as Map<String, dynamic>)['data']
          as Map<String, dynamic>;
      return data['url'] as String;
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Retire le modèle Word de l'entreprise côté backend.
  Future<void> deleteTemplate() async {
    await _request('DELETE', '/api/company/template');
  }

  /// Génère le PDF d'un devis via le modèle Word de l'entreprise (backend).
  ///
  /// Renvoie les octets du PDF. Lève [ApiException] si aucun modèle n'est
  /// configuré ou si la génération échoue (l'appelant retombe alors sur le
  /// rendu local par défaut).
  Future<List<int>> generateTemplatePdf(Map<String, dynamic> payload) async {
    try {
      final token = await _storage.getAccessToken();
      final response = await _dio.post<List<int>>(
        '/api/quotes/pdf',
        data: payload,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            if (token != null) 'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.data ?? const [];
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Télécharge un fichier binaire (ex. PDF).
  Future<List<int>> download(String path) async {
    final token = await _storage.getAccessToken();
    final response = await _dio.get<List<int>>(
      path,
      options: Options(
        responseType: ResponseType.bytes,
        headers: {if (token != null) 'Authorization': 'Bearer $token'},
      ),
    );
    return response.data ?? [];
  }

  // ── Interne ─────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
    bool auth = true,
  }) async {
    try {
      Response<dynamic> response;
      final options = Options(method: method);

      if (auth) {
        final token = await _storage.getAccessToken();
        options.headers = {
          if (token != null) 'Authorization': 'Bearer $token',
        };
      }

      response = await _dio.request(
        path,
        data: body,
        queryParameters: queryParams,
        options: options,
      );

      return (response.data as Map<String, dynamic>?) ?? {};
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  /// Tente de renouveler le token d'accès avec le refresh token.
  /// Appelé par [_AuthInterceptor] sur 401.
  Future<bool> tryRefresh() async {
    if (_isRefreshing) return false;
    _isRefreshing = true;
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/api/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(headers: {}), // pas de Bearer sur le refresh endpoint
      );

      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      await _storage.saveTokens(
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String,
      );
      return true;
    } catch (_) {
      await _storage.clear();
      _sessionExpiredCtrl.add(null);
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  static ApiException _mapError(DioException e) {
    final response = e.response;
    if (response != null) {
      final body = response.data;
      final message = (body is Map && body['message'] != null)
          ? body['message'] as String
          : 'Erreur ${response.statusCode}.';
      final errors =
          (body is Map && body['errors'] != null) ? body['errors'] as Map<String, dynamic> : null;
      return ApiException(message, statusCode: response.statusCode, errors: errors);
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const ApiException('Délai de connexion dépassé. Vérifiez votre réseau.');
    }
    return ApiException(e.message ?? 'Erreur réseau inconnue.');
  }

  void dispose() {
    _sessionExpiredCtrl.close();
  }
}

/// Intercepteur Dio : rejoue la requête une fois après un refresh réussi.
class _AuthInterceptor extends Interceptor {
  final ApiClient _client;

  _AuthInterceptor(this._client);

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshed = await _client.tryRefresh();
      if (refreshed) {
        // Rejouer la requête originale avec le nouveau token
        try {
          final token = await _client._storage.getAccessToken();
          final opts = err.requestOptions.copyWith(
            headers: {
              ...err.requestOptions.headers,
              if (token != null) 'Authorization': 'Bearer $token',
            },
          );
          final response = await _client._dio.fetch(opts);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      }
    }
    handler.next(err);
  }
}
