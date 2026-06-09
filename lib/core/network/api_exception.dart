/// Exception métier renvoyée par [ApiClient].
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  const ApiException(this.message, {this.statusCode, this.errors});

  @override
  String toString() => message;
}

/// Le token d'accès et le refresh token sont tous deux invalides / révoqués.
class SessionExpiredException extends ApiException {
  const SessionExpiredException()
      : super('Session expirée. Veuillez vous reconnecter.', statusCode: 401);
}
