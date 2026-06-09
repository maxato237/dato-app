import 'package:dato/features/auth/domain/auth_status.dart';

/// Contrat du dépôt d'authentification.
///
/// Implémentation active : [FlaskAuthRepository] (backend Flask JWT).
/// En tests : remplacé par [FakeAuthRepository] via overrideWith.
abstract class AuthRepository {
  AuthStatus get status;
  Stream<AuthStatus> get authStateChanges;

  /// Numéro saisi dans le formulaire précédent (pour l'afficher dans l'écran OTP).
  String? get pendingPhone;

  /// `true` si on est dans le flux « mot de passe oublié » (OTP → reset).
  bool get isResetFlow;

  Future<void> signUp({
    required String name,
    required String phone,
    required String password,
    String? email, // optionnel
  });

  Future<void> verifyOtp({required String phone, required String token});

  Future<void> signIn({required String identifier, required String password});

  Future<void> sendPasswordReset({required String identifier});

  Future<void> resetPassword({required String newPassword});

  Future<void> resendOtp({required String phone});

  Future<void> signOut();
}
