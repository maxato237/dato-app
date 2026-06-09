String? validateRequired(String? value, {String message = 'Ce champ est obligatoire'}) {
  if (value == null || value.trim().isEmpty) return message;
  return null;
}

String? validateClient(String? value) =>
    validateRequired(value, message: 'Le nom du client est obligatoire');

String? validatePhone(String? value) {
  if (value == null || value.trim().isEmpty) return 'Ce champ est obligatoire';
  final digits = value.replaceAll(RegExp(r'\D'), '');
  if (digits.length < 9) return 'Numéro de téléphone invalide';
  return null;
}
