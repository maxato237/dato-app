// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'DATO';

  @override
  String get navHome => 'Accueil';

  @override
  String get navQuotes => 'Devis';

  @override
  String get navNew => 'Nouveau';

  @override
  String get navLibrary => 'Articles';

  @override
  String get navSettings => 'Réglages';

  @override
  String get statusDraft => 'Brouillon';

  @override
  String get statusSent => 'Envoyé';

  @override
  String get statusAccepted => 'Accepté';

  @override
  String get statusRefused => 'Refusé';

  @override
  String get buttonSave => 'Enregistrer';

  @override
  String get buttonCancel => 'Annuler';

  @override
  String get buttonConfirm => 'Confirmer';

  @override
  String get buttonDelete => 'Supprimer';

  @override
  String get buttonShare => 'Partager';

  @override
  String get buttonClose => 'Fermer';

  @override
  String get buttonRetry => 'Réessayer';

  @override
  String get buttonAdd => 'Ajouter';

  @override
  String get buttonEdit => 'Modifier';

  @override
  String get errorRequired => 'Ce champ est obligatoire';

  @override
  String get errorClientRequired => 'Le nom du client est obligatoire';

  @override
  String get errorInvalidPhone => 'Numéro de téléphone invalide';

  @override
  String get errorNetworkUnavailable => 'Pas de connexion internet';

  @override
  String get errorGeneric => 'Une erreur est survenue';

  @override
  String get loadingText => 'Chargement…';

  @override
  String get savingText => 'Enregistrement…';

  @override
  String get savedText => 'Enregistré';

  @override
  String get emptyQuotesTitle => 'Aucun devis';

  @override
  String get emptyQuotesSubtitle =>
      'Créez votre premier devis en appuyant sur +';

  @override
  String get emptyLibraryTitle => 'Bibliothèque vide';

  @override
  String get emptyLibrarySubtitle => 'Ajoutez des articles réutilisables';

  @override
  String get dashboardTitle => 'Tableau de bord';

  @override
  String get quotesListTitle => 'Mes devis';

  @override
  String get libraryTitle => 'Articles';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get newQuoteTitle => 'Nouveau devis';

  @override
  String get editQuoteTitle => 'Modifier le devis';

  @override
  String quotaFree(int used, int total) {
    return '$used/$total devis ce mois';
  }

  @override
  String get shareViaWhatsApp => 'Partager via WhatsApp';

  @override
  String get copyLink => 'Copier le lien';

  @override
  String get downloadPdf => 'Télécharger le PDF';

  @override
  String get shareViaEmail => 'Envoyer par e-mail';
}
