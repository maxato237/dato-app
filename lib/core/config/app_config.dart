/// Configuration produit.
///
/// **Lancement en accès libre** : pas de quota freemium ni de paiement. Tout le
/// code de monétisation (quota mensuel, paywall Phase 7) reste en place mais
/// **désactivé** derrière ce flag — pour le réactiver plus tard, il suffit de
/// passer le défaut à `true` ou de lancer avec :
///   flutter run --dart-define=BILLING_ENABLED=true
const bool kBillingEnabled =
    bool.fromEnvironment('BILLING_ENABLED', defaultValue: false);

/// SMS / OTP activé (Twilio configuré côté backend).
///
/// Quand `false` (défaut au lancement) : la réinitialisation de mot de passe
/// par SMS est désactivée — « Mot de passe oublié ? » affiche un dialog de
/// contact au lieu de l'écran reset. Activer quand Twilio est prêt :
///   flutter run --dart-define=SMS_ENABLED=true
const bool kSmsEnabled =
    bool.fromEnvironment('SMS_ENABLED', defaultValue: false);

/// Numéro WhatsApp support affiché quand [kSmsEnabled] est false.
/// À mettre à jour avant le lancement.
const String kSupportWhatsApp = '+237 6 98 91 61 50';
