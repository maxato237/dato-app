import 'dart:async';

import 'package:dato/core/network/api_client.dart';
import 'package:dato/core/network/api_exception.dart';
import 'package:dato/core/network/token_storage.dart';
import 'package:dato/features/auth/data/auth_repository.dart';
import 'package:dato/features/auth/domain/auth_status.dart';

/// Implémentation de [AuthRepository] qui parle au backend Flask.
///
/// Responsabilités :
/// - Appels REST auth (register, verify-otp, login, refresh, logout, reset)
/// - Stockage des JWT dans [TokenStorage]
/// - Émission d'[AuthStatus] via [authStateChanges]
/// - Rafraîchissement automatique des tokens (délégué à [ApiClient])
class FlaskAuthRepository implements AuthRepository {
  final TokenStorage _storage;
  final ApiClient _client;

  final _authCtrl = StreamController<AuthStatus>.broadcast();
  final _sessionExpiredCtrl = StreamController<void>.broadcast();
  AuthStatus _currentStatus = AuthStatus.loading;

  String? _pendingPhone;
  bool _isResetFlow = false;

  FlaskAuthRepository({required TokenStorage storage, required ApiClient client})
      : _storage = storage,
        _client = client {
    // Token non renouvelable → session expirée (pas un logout volontaire).
    _client.sessionExpiredStream.listen((_) {
      _sessionExpiredCtrl.add(null);
      _currentStatus = AuthStatus.unauthenticated;
      _authCtrl.add(_currentStatus);
    });
    // Vérification initiale asynchrone : token en storage → authenticated ?
    _initStatus();
  }

  Future<void> _initStatus() async {
    final hasToken = await _storage.hasValidToken();
    _currentStatus = hasToken ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    _authCtrl.add(_currentStatus);
  }

  // ── AuthRepository ──────────────────────────────────────────────────────

  @override
  AuthStatus get status => _currentStatus;

  @override
  Stream<AuthStatus> get authStateChanges => _authCtrl.stream;

  @override
  Stream<void> get sessionExpiredEvents => _sessionExpiredCtrl.stream;

  @override
  String? get pendingPhone => _pendingPhone;

  @override
  bool get isResetFlow => _isResetFlow;

  @override
  Future<void> signUp({
    required String name,
    required String phone,
    required String password,
    String? email,
  }) async {
    _pendingPhone = phone;
    _isResetFlow = false;
    final resp = await _client.post('/api/auth/register', body: {
      'phone': phone,
      'name': name,
      'password': password,
      if (email != null && email.isNotEmpty) 'email': email,
    }, auth: false);
    // Si le backend a retourné des tokens (REQUIRE_OTP=false), on est déjà
    // authentifié — pas besoin de passer par l'écran OTP.
    final data = resp['data'] as Map<String, dynamic>?;
    if (data != null && data.containsKey('access_token')) {
      await _storeTokens(data);
      _currentStatus = AuthStatus.authenticated;
      _authCtrl.add(_currentStatus);
    }
  }

  @override
  Future<void> verifyOtp({required String phone, required String token}) async {
    final purpose = _isResetFlow ? 'reset' : 'registration';
    final data = await _client.post('/api/auth/verify-otp', body: {
      'phone': phone,
      'code': token,
      'purpose': purpose,
    }, auth: false);

    if (!_isResetFlow) {
      // Flux inscription : stocker les tokens → authentifié.
      await _storeTokens(data['data'] as Map<String, dynamic>);
      _currentStatus = AuthStatus.authenticated;
      _authCtrl.add(_currentStatus);
    }
    // Flux reset : on ne stocke pas les tokens ici.
    // L'utilisateur restera non authentifié jusqu'au login avec le nouveau mdp.
  }

  @override
  Future<void> signIn({required String identifier, required String password}) async {
    final data = await _client.post('/api/auth/login', body: {
      'identifier': identifier,
      'password': password,
    }, auth: false);
    await _storeTokens(data['data'] as Map<String, dynamic>);
    _currentStatus = AuthStatus.authenticated;
    _authCtrl.add(_currentStatus);
  }

  @override
  Future<void> sendPasswordReset({required String identifier}) async {
    _pendingPhone = identifier;
    _isResetFlow = true;
    await _client.post('/api/auth/forgot-password', body: {
      'identifier': identifier,
    }, auth: false);
  }

  @override
  Future<void> resetPassword({required String newPassword}) async {
    if (_pendingPhone == null) {
      throw const ApiException('Numéro de téléphone manquant. Recommencez la procédure.');
    }
    await _client.post('/api/auth/reset-password', body: {
      'phone': _pendingPhone,
      'new_password': newPassword,
    }, auth: false);
    _isResetFlow = false;
    _pendingPhone = null;
  }

  @override
  Future<void> resendOtp({required String phone}) async {
    final purpose = _isResetFlow ? 'reset' : 'registration';
    await _client.post('/api/auth/resend-otp', body: {
      'phone': phone,
      'purpose': purpose,
    }, auth: false);
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.post('/api/auth/logout', body: {});
    } catch (_) {
      // On déconnecte localement même si le backend est inaccessible.
    }
    await _storage.clear();
    _currentStatus = AuthStatus.unauthenticated;
    _authCtrl.add(_currentStatus);
  }

  // ── Utilitaire ──────────────────────────────────────────────────────────

  Future<void> _storeTokens(Map<String, dynamic> data) async {
    await _storage.saveTokens(
      accessToken: data['access_token'] as String,
      refreshToken: data['refresh_token'] as String,
    );
  }

  void dispose() {
    _authCtrl.close();
    _sessionExpiredCtrl.close();
  }
}
