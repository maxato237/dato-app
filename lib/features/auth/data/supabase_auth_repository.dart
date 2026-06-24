import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dato/features/auth/data/auth_repository.dart';
import 'package:dato/features/auth/domain/auth_status.dart';

class SupabaseAuthRepository implements AuthRepository {
  String? _pendingPhone;
  bool _isResetFlow = false;

  @override
  String? get pendingPhone => _pendingPhone;

  @override
  bool get isResetFlow => _isResetFlow;

  SupabaseClient? get _client {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  SupabaseClient get _requireClient {
    final c = _client;
    if (c == null) {
      throw Exception(
        'Supabase non configuré.\n'
        'Lancez l\'app avec --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...',
      );
    }
    return c;
  }

  @override
  AuthStatus get status {
    final c = _client;
    if (c == null) return AuthStatus.unauthenticated;
    return c.auth.currentSession != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
  }

  @override
  Stream<void> get sessionExpiredEvents => const Stream<void>.empty();

  @override
  Stream<AuthStatus> get authStateChanges {
    final c = _client;
    if (c == null) return Stream.value(AuthStatus.unauthenticated);
    return c.auth.onAuthStateChange.map(
      (e) => e.session != null
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated,
    );
  }

  @override
  Future<void> signUp({
    required String name,
    required String phone,
    required String password,
    String? email,
  }) async {
    _pendingPhone = phone;
    _isResetFlow = false;
    await _requireClient.auth.signUp(
      phone: phone,
      password: password,
      data: {'display_name': name},
    );
  }

  @override
  Future<void> verifyOtp({required String phone, required String token}) async {
    await _requireClient.auth.verifyOTP(
      phone: phone,
      token: token,
      type: OtpType.sms,
    );
  }

  @override
  Future<void> signIn({
    required String identifier,
    required String password,
  }) async {
    if (identifier.contains('@')) {
      await _requireClient.auth
          .signInWithPassword(email: identifier, password: password);
    } else {
      await _requireClient.auth
          .signInWithPassword(phone: identifier, password: password);
    }
  }

  @override
  Future<void> sendPasswordReset({required String identifier}) async {
    _pendingPhone = identifier;
    _isResetFlow = true;
    await _requireClient.auth.signInWithOtp(phone: identifier);
  }

  @override
  Future<void> resetPassword({required String newPassword}) async {
    await _requireClient.auth
        .updateUser(UserAttributes(password: newPassword));
  }

  @override
  Future<void> resendOtp({required String phone}) async {
    if (_isResetFlow) {
      await _requireClient.auth.signInWithOtp(phone: phone);
    } else {
      await _requireClient.auth.resend(type: OtpType.sms, phone: phone);
    }
  }

  @override
  Future<void> signOut() async {
    await _requireClient.auth.signOut();
  }
}
