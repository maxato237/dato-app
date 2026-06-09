# ARCHITECTURE — DATO (Flutter)

> Architecture **feature-first**, état avec **Riverpod**, offline-first avec **Isar**, sync via API **Flask**. Objectif : code testable, écran par écran, fluide sur Android d'entrée de gamme.

---

## 1. Vue en couches

```
┌──────────────────────────────────────────────┐
│  Presentation  (features/**/presentation)     │  Écrans + widgets. Aucune logique métier.
│                 + widgets partagés (core)      │
├──────────────────────────────────────────────┤
│  Application   (features/**/providers)         │  Controllers Riverpod : état d'écran,
│                                                │  orchestration, debounce autosave.
├──────────────────────────────────────────────┤
│  Domain        (features/**/domain)            │  Entités pures + calculs (Quote, totaux,
│                                                │  montantEnLettres). Zéro dépendance Flutter.
├──────────────────────────────────────────────┤
│  Data          (data/repositories, local,      │  Repositories. Source de vérité = Isar (local).
│                 remote)                         │  Sync API Flask en arrière-plan. DTO ↔ domain.
└──────────────────────────────────────────────┘
```

**Règle d'or offline-first :** l'UI lit/écrit **toujours** le local (Isar). La synchronisation avec le backend est un effet de bord asynchrone (file d'attente). L'app reste 100 % utilisable sans réseau — exigence du brief.

---

## 2. Arborescence cible

```
dato/
├── pubspec.yaml                      # cf. starter/pubspec.yaml
├── l10n.yaml                         # config génération i18n
├── analysis_options.yaml             # flutter_lints
├── android/ …                        # config Gradle, signing, applicationId com.dato.app
│
├── lib/
│   ├── main.dart                     # bootstrap : init Isar, Supabase, ProviderScope
│   ├── app.dart                      # MaterialApp.router + thème + localizations
│   │
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_colors.dart        # ← starter/app_theme.dart (scinder)
│   │   │   ├── app_spacing.dart
│   │   │   └── app_theme.dart
│   │   ├── router/
│   │   │   ├── app_router.dart        # go_router : routes + redirections auth
│   │   │   └── routes.dart            # constantes de chemins
│   │   ├── utils/
│   │   │   ├── formatters.dart        # ← starter/formatters.dart
│   │   │   ├── montant_en_lettres.dart# ← starter/montant_en_lettres.dart
│   │   │   └── validators.dart
│   │   ├── network/
│   │   │   ├── api_client.dart        # Dio (baseUrl, intercepteurs token/erreurs)
│   │   │   └── api_exception.dart
│   │   ├── connectivity/
│   │   │   └── connectivity_service.dart   # connectivity_plus → provider
│   │   └── widgets/                   # DESIGN SYSTEM (Phase 0)
│   │       ├── dato_button.dart        # primary / secondary / amber / whatsapp / danger
│   │       ├── dato_text_field.dart
│   │       ├── money_field.dart         # saisie montant + clavier num + format espace
│   │       ├── dato_badge.dart
│   │       ├── status_badge.dart
│   │       ├── dato_bottom_sheet.dart
│   │       ├── dato_toast.dart          # via ScaffoldMessenger / overlay
│   │       ├── empty_state.dart
│   │       ├── skeleton_list.dart
│   │       └── app_icons.dart           # mapping noms → SvgPicture (assets/icons)
│   │
│   ├── data/
│   │   ├── local/
│   │   │   ├── isar_service.dart       # ouverture, schémas
│   │   │   └── models/                  # collections Isar (@collection)
│   │   │       ├── quote_entity.dart
│   │   │       ├── company_entity.dart
│   │   │       └── article_entity.dart
│   │   ├── remote/
│   │   │   ├── dto/                     # freezed + json (réponses Flask)
│   │   │   ├── quote_api.dart
│   │   │   ├── auth_api.dart
│   │   │   └── payment_api.dart         # Campay via backend
│   │   └── repositories/
│   │       ├── quote_repository.dart    # CRUD local + sync queue
│   │       ├── auth_repository.dart
│   │       ├── article_repository.dart
│   │       ├── company_repository.dart
│   │       └── billing_repository.dart
│   │
│   ├── features/
│   │   ├── shell/
│   │   │   └── app_shell.dart            # Scaffold + BottomNavigationBar + FAB central
│   │   ├── auth/
│   │   │   ├── presentation/ signup_screen.dart, login_screen.dart,
│   │   │   │                  otp_screen.dart, forgot_password_screen.dart,
│   │   │   │                  reset_password_screen.dart
│   │   │   └── providers/ auth_controller.dart
│   │   ├── onboarding/
│   │   │   └── presentation/ ob_company_screen.dart, ob_signatures_screen.dart, ob_done_screen.dart
│   │   ├── dashboard/
│   │   │   ├── presentation/ dashboard_screen.dart
│   │   │   └── widgets/ quota_card.dart, stat_card.dart, quote_card.dart
│   │   ├── quotes/
│   │   │   ├── domain/ quote.dart        # ← starter/quote.dart (entités + calculs)
│   │   │   ├── presentation/
│   │   │   │   ├── quotes_list_screen.dart
│   │   │   │   ├── quote_editor_screen.dart      # LE CŒUR
│   │   │   │   ├── quote_preview_screen.dart
│   │   │   │   └── quote_public_screen.dart      # vue publique (lien WhatsApp)
│   │   │   ├── widgets/
│   │   │   │   ├── section_card.dart
│   │   │   │   ├── section_line_tile.dart
│   │   │   │   ├── rubrique_card.dart
│   │   │   │   ├── rubrique_line_tile.dart        # toggle Forfait / A×B
│   │   │   │   ├── designation_autocomplete.dart
│   │   │   │   ├── total_card.dart
│   │   │   │   └── share_sheet.dart
│   │   │   └── providers/
│   │   │       ├── quote_editor_controller.dart   # état édité + autosave debounce
│   │   │       └── quotes_list_controller.dart
│   │   ├── library/
│   │   │   ├── presentation/ library_screen.dart
│   │   │   └── widgets/ article_tile.dart, article_modal.dart
│   │   ├── settings/
│   │   │   └── presentation/ settings_screen.dart (+ onglets entreprise/signatures/compte/num/préférences)
│   │   ├── billing/
│   │   │   ├── presentation/ paywall_screen.dart, plans_screen.dart,
│   │   │   │                  payment_operator_screen.dart, payment_waiting_screen.dart,
│   │   │   │                  payment_result_screen.dart, subscription_screen.dart
│   │   │   └── providers/ billing_controller.dart
│   │   └── pdf/
│   │       └── quote_pdf.dart            # construit le PDF A4 (package pdf) depuis Quote
│   │
│   └── l10n/
│       ├── app_fr.arb                    # FR (défaut)
│       └── app_en.arb                    # EN (prévu)
│
└── test/
    ├── unit/        # domain + utils + repositories (mocktail)
    ├── widget/      # écrans & widgets
    ├── golden/      # comparaison visuelle aux maquettes
    └── integration/ # parcours bout-en-bout (integration_test/)
```

---

## 3. Gestion d'état — Riverpod

- **Un controller par écran complexe** (`@riverpod class QuoteEditorController extends _$...`).
- L'éditeur garde un `Quote` en mémoire ; chaque édition produit une **nouvelle instance immuable** (`copyWith`) → recalcul des totaux instantané, et **debounce 800 ms** avant écriture Isar + mise en file de sync (statut « Enregistrement… » → « Enregistré »).
- Providers transverses : `connectivityProvider`, `currentCompanyProvider`, `sessionProvider`, `quotaProvider`.
- Éviter `setState` au-delà de micro-interactions locales (focus, toggle visuel).

## 4. Navigation — go_router

Routes principales (constantes dans `routes.dart`) :

```
/onboarding/*         (signup, login, otp, forgot, reset, ob1..ob3)
/                     → app_shell (redirige vers /home)
  /home               dashboard
  /quotes             liste
  /library            bibliothèque
  /settings           réglages
/quote/:id            éditeur
/quote/:id/preview    aperçu
/billing/*            paywall, plans, payment, subscription
/p/:token             VUE PUBLIQUE (deep link, sans auth) — ne s'affiche pas dans le shell
```

`redirect` global : si pas de session → `/onboarding/login` (sauf routes publiques `/p/:token`).

## 5. Drag & drop (rappel technique)

`ReorderableListView` (sections ET lignes) avec `buildDefaultDragHandles: false` et un `ReorderableDragStartListener` posé **uniquement sur la poignée ⠿** → pas de conflit avec le scroll vertical. `proxyDecorator` pour l'élévation + léger scale pendant le déplacement. Réf. comportementale : `Sortable.jsx`.

## 6. Conventions

- **UI 100 % en français.** Tout libellé passe par l10n (`AppLocalizations.of(context)`).
- **Tokens = source de vérité.** Aucune couleur/taille « en dur » hors de `core/theme`.
- **Montants** : `int` (FCFA, pas de centimes) en stockage ; `formatFcfa()` à l'affichage ; `tabularFigures` pour l'alignement.
- **Nommage fichiers** : `snake_case.dart`. Un widget public par fichier.
- **Lint** : `flutter_lints` + règles projet. `flutter analyze` doit être vert avant chaque commit.
- **Génération de code** : `dart run build_runner build --delete-conflicting-outputs` (Riverpod, freezed, Isar).
```
