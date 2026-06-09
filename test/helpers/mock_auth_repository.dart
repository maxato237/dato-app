import 'dart:async';
import 'package:mocktail/mocktail.dart';
import 'package:dato/features/auth/data/auth_repository.dart';
import 'package:dato/features/auth/domain/auth_status.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

/// Implémentation minimale pour les tests d'intégration.
class FakeAuthRepository implements AuthRepository {
  final _ctrl = StreamController<AuthStatus>.broadcast();
  AuthStatus _status = AuthStatus.unauthenticated;
  String? _pendingPhone;
  bool _isResetFlow = false;

  @override
  AuthStatus get status => _status;

  @override
  Stream<AuthStatus> get authStateChanges => _ctrl.stream;

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
    await Future.delayed(const Duration(milliseconds: 50));
  }

  @override
  Future<void> verifyOtp({required String phone, required String token}) async {
    await Future.delayed(const Duration(milliseconds: 50));
    if (token == '000000') {
      _status = AuthStatus.authenticated;
      _ctrl.add(_status);
    } else {
      throw Exception('Code invalide');
    }
  }

  @override
  Future<void> signIn({
    required String identifier,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _status = AuthStatus.authenticated;
    _ctrl.add(_status);
  }

  @override
  Future<void> sendPasswordReset({required String identifier}) async {
    _pendingPhone = identifier;
    _isResetFlow = true;
    await Future.delayed(const Duration(milliseconds: 50));
  }

  @override
  Future<void> resetPassword({required String newPassword}) async {
    await Future.delayed(const Duration(milliseconds: 50));
  }

  @override
  Future<void> resendOtp({required String phone}) async {
    await Future.delayed(const Duration(milliseconds: 50));
  }

  @override
  Future<void> signOut() async {
    _status = AuthStatus.unauthenticated;
    _ctrl.add(_status);
  }

  void dispose() => _ctrl.close();
}
