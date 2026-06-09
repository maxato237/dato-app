import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('fr')];

  /// Nom de l'application
  ///
  /// In fr, this message translates to:
  /// **'DATO'**
  String get appName;

  /// Onglet Accueil
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// Onglet Devis
  ///
  /// In fr, this message translates to:
  /// **'Devis'**
  String get navQuotes;

  /// Bouton nouveau devis
  ///
  /// In fr, this message translates to:
  /// **'Nouveau'**
  String get navNew;

  /// Onglet bibliothèque
  ///
  /// In fr, this message translates to:
  /// **'Articles'**
  String get navLibrary;

  /// Onglet réglages
  ///
  /// In fr, this message translates to:
  /// **'Réglages'**
  String get navSettings;

  /// Statut brouillon
  ///
  /// In fr, this message translates to:
  /// **'Brouillon'**
  String get statusDraft;

  /// Statut envoyé
  ///
  /// In fr, this message translates to:
  /// **'Envoyé'**
  String get statusSent;

  /// Statut accepté
  ///
  /// In fr, this message translates to:
  /// **'Accepté'**
  String get statusAccepted;

  /// Statut refusé
  ///
  /// In fr, this message translates to:
  /// **'Refusé'**
  String get statusRefused;

  /// No description provided for @buttonSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get buttonSave;

  /// No description provided for @buttonCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get buttonCancel;

  /// No description provided for @buttonConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get buttonConfirm;

  /// No description provided for @buttonDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get buttonDelete;

  /// No description provided for @buttonShare.
  ///
  /// In fr, this message translates to:
  /// **'Partager'**
  String get buttonShare;

  /// No description provided for @buttonClose.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get buttonClose;

  /// No description provided for @buttonRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get buttonRetry;

  /// No description provided for @buttonAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get buttonAdd;

  /// No description provided for @buttonEdit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get buttonEdit;

  /// No description provided for @errorRequired.
  ///
  /// In fr, this message translates to:
  /// **'Ce champ est obligatoire'**
  String get errorRequired;

  /// No description provided for @errorClientRequired.
  ///
  /// In fr, this message translates to:
  /// **'Le nom du client est obligatoire'**
  String get errorClientRequired;

  /// No description provided for @errorInvalidPhone.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de téléphone invalide'**
  String get errorInvalidPhone;

  /// No description provided for @errorNetworkUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Pas de connexion internet'**
  String get errorNetworkUnavailable;

  /// No description provided for @errorGeneric.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get errorGeneric;

  /// No description provided for @loadingText.
  ///
  /// In fr, this message translates to:
  /// **'Chargement…'**
  String get loadingText;

  /// No description provided for @savingText.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrement…'**
  String get savingText;

  /// No description provided for @savedText.
  ///
  /// In fr, this message translates to:
  /// **'Enregistré'**
  String get savedText;

  /// No description provided for @emptyQuotesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun devis'**
  String get emptyQuotesTitle;

  /// No description provided for @emptyQuotesSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Créez votre premier devis en appuyant sur +'**
  String get emptyQuotesSubtitle;

  /// No description provided for @emptyLibraryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bibliothèque vide'**
  String get emptyLibraryTitle;

  /// No description provided for @emptyLibrarySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez des articles réutilisables'**
  String get emptyLibrarySubtitle;

  /// No description provided for @dashboardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tableau de bord'**
  String get dashboardTitle;

  /// No description provided for @quotesListTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes devis'**
  String get quotesListTitle;

  /// No description provided for @libraryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Articles'**
  String get libraryTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Réglages'**
  String get settingsTitle;

  /// No description provided for @newQuoteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau devis'**
  String get newQuoteTitle;

  /// No description provided for @editQuoteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le devis'**
  String get editQuoteTitle;

  /// No description provided for @quotaFree.
  ///
  /// In fr, this message translates to:
  /// **'{used}/{total} devis ce mois'**
  String quotaFree(int used, int total);

  /// No description provided for @shareViaWhatsApp.
  ///
  /// In fr, this message translates to:
  /// **'Partager via WhatsApp'**
  String get shareViaWhatsApp;

  /// No description provided for @copyLink.
  ///
  /// In fr, this message translates to:
  /// **'Copier le lien'**
  String get copyLink;

  /// No description provided for @downloadPdf.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger le PDF'**
  String get downloadPdf;

  /// No description provided for @shareViaEmail.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer par e-mail'**
  String get shareViaEmail;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
