/// En-tête entreprise (modifiable dans Réglages).
/// L'éditeur et l'aperçu l'affichent en haut du document de devis.
class Company {
  final String id;
  final String name;
  final String activity;
  final String address;
  final String phones;
  final String city;
  final String currency;

  /// URL du logo (uploadé via le backend). Vide ⇒ pas de logo affiché.
  final String logoUrl;

  /// Texte de localisation affiché dans le pied de page du devis.
  final String location;

  /// URL du modèle Word (.docx) utilisé pour générer les PDF de devis.
  /// Quand défini, le backend utilise ce template (en-tête/pied de page Word
  /// préservés) au lieu du rendu ReportLab.
  final String templateDocxUrl;

  /// Étiquettes des blocs de signature (bas du devis).
  final String signatureLeft;
  final String signatureRight;

  /// Préfixe du numéro de devis (ex. "DV" → "DV-2026-001").
  final String quotePrefix;

  /// Quand `true`, le numéro de devis devient « PRÉFIXE-OBJET » : l'objet du
  /// devis remplace la partie année-séquence, juste après le préfixe.
  final bool quoteNumberByObject;

  const Company({
    required this.id,
    required this.name,
    required this.activity,
    this.address = '',
    this.phones = '',
    this.city = '',
    this.currency = 'FCFA',
    this.logoUrl = '',
    this.location = '',
    this.templateDocxUrl = '',
    this.signatureLeft = '',
    this.signatureRight = '',
    this.quotePrefix = 'DV',
    this.quoteNumberByObject = false,
  });

  /// Initiale affichée dans le logo carré (fallback quand pas de logo).
  String get initial => name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

  bool get hasLogo => logoUrl.trim().isNotEmpty;
  bool get hasLocation => location.trim().isNotEmpty;
  bool get hasTemplate => templateDocxUrl.trim().isNotEmpty;

  Company copyWith({
    String? name,
    String? activity,
    String? address,
    String? phones,
    String? city,
    String? currency,
    String? logoUrl,
    String? location,
    String? templateDocxUrl,
    String? signatureLeft,
    String? signatureRight,
    String? quotePrefix,
    bool? quoteNumberByObject,
  }) =>
      Company(
        id: id,
        name: name ?? this.name,
        activity: activity ?? this.activity,
        address: address ?? this.address,
        phones: phones ?? this.phones,
        city: city ?? this.city,
        currency: currency ?? this.currency,
        logoUrl: logoUrl ?? this.logoUrl,
        location: location ?? this.location,
        templateDocxUrl: templateDocxUrl ?? this.templateDocxUrl,
        signatureLeft: signatureLeft ?? this.signatureLeft,
        signatureRight: signatureRight ?? this.signatureRight,
        quotePrefix: quotePrefix ?? this.quotePrefix,
        quoteNumberByObject: quoteNumberByObject ?? this.quoteNumberByObject,
      );

  /// Construit une [Company] depuis la réponse JSON du backend Flask.
  /// `phones` est une liste côté backend → jointe en chaîne « a / b ».
  factory Company.fromJson(Map<String, dynamic> json) {
    final rawPhones = json['phones'];
    final phonesStr = rawPhones is List
        ? rawPhones.map((e) => e.toString()).join(' / ')
        : (rawPhones?.toString() ?? '');
    return Company(
      id: json['id']?.toString() ?? 'company',
      name: json['name']?.toString() ?? '',
      activity: json['activity']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      phones: phonesStr,
      city: json['city']?.toString() ?? '',
      currency: json['currency']?.toString() ?? 'FCFA',
      logoUrl: json['logo_url']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      templateDocxUrl: json['template_docx_url']?.toString() ?? '',
      signatureLeft: json['signature_left']?.toString() ?? '',
      signatureRight: json['signature_right']?.toString() ?? '',
      quotePrefix: json['quote_prefix']?.toString() ?? 'DV',
      quoteNumberByObject: json['quote_number_by_object'] == true,
    );
  }

  /// Sérialise pour `POST/PUT /api/company`. `phones` est éclatée en liste.
  Map<String, dynamic> toJson() => {
        'name': name,
        'activity': activity,
        'address': address,
        'city': city,
        'phones': phones
            .split(RegExp(r'[/,]'))
            .map((p) => p.trim())
            .where((p) => p.isNotEmpty)
            .toList(),
        'currency': currency,
        'logo_url': logoUrl,
        'location': location,
        'template_docx_url': templateDocxUrl,
        'signature_left': signatureLeft,
        'signature_right': signatureRight,
        'quote_prefix': quotePrefix,
        'quote_number_by_object': quoteNumberByObject,
      };
}
