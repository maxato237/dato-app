/// En-tête entreprise (modifiable dans Réglages).
/// L'éditeur et l'aperçu l'affichent en haut/bas du document de devis.
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

  /// URL de l'image de couverture affichée en haut du devis (bannière).
  final String headerImageUrl;

  /// URL de la bannière de pied de page (ex. texture « Situé à … »).
  final String footerImageUrl;

  /// Texte de localisation affiché dans la bannière de pied de page.
  final String location;

  const Company({
    required this.id,
    required this.name,
    required this.activity,
    this.address = '',
    this.phones = '',
    this.city = '',
    this.currency = 'FCFA',
    this.logoUrl = '',
    this.headerImageUrl = '',
    this.footerImageUrl = '',
    this.location = '',
  });

  /// Initiale affichée dans le logo carré (fallback historique, plus utilisé
  /// pour le rendu document mais conservé pour d'éventuels usages).
  String get initial => name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

  bool get hasLogo => logoUrl.trim().isNotEmpty;
  bool get hasHeaderImage => headerImageUrl.trim().isNotEmpty;
  bool get hasFooterImage => footerImageUrl.trim().isNotEmpty;
  bool get hasLocation => location.trim().isNotEmpty;

  Company copyWith({
    String? name,
    String? activity,
    String? address,
    String? phones,
    String? city,
    String? currency,
    String? logoUrl,
    String? headerImageUrl,
    String? footerImageUrl,
    String? location,
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
        headerImageUrl: headerImageUrl ?? this.headerImageUrl,
        footerImageUrl: footerImageUrl ?? this.footerImageUrl,
        location: location ?? this.location,
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
      headerImageUrl: json['header_image_url']?.toString() ?? '',
      footerImageUrl: json['footer_image_url']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
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
        'header_image_url': headerImageUrl,
        'footer_image_url': footerImageUrl,
        'location': location,
      };
}
