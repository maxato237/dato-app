# PROMPT_ANDROID_STUDIO — DATO (Flutter)

> Comment lancer l'implémentation avec l'assistant IA dans **Android Studio** (ou Claude Code en terminal). Tu colles le **prompt maître** une fois, puis **un prompt de phase** à la fois.

---

## A. Mise en place (à faire une seule fois)

1. **Installer** : Flutter SDK + Android Studio + plugins *Flutter* et *Dart*. Vérifier : `flutter doctor` tout vert.
2. **Créer le projet** :
   ```bash
   flutter create --org com.dato --project-name dato dato
   cd dato
   ```
3. **Copier les fichiers de démarrage** de ce paquet dans le projet :
   - `starter/pubspec.yaml` → remplace `pubspec.yaml` puis `flutter pub get`
   - `starter/app_theme.dart` → `lib/core/theme/app_theme.dart`
   - `starter/montant_en_lettres.dart` → `lib/core/utils/montant_en_lettres.dart`
   - `starter/formatters.dart` → `lib/core/utils/formatters.dart`
   - `starter/quote.dart` → `lib/features/quotes/domain/quote.dart`
4. **Placer la doc et les maquettes à la racine** du projet (pour que l'IA y accède) :
   - `README.md`, `ARCHITECTURE.md`, `ROADMAP.md`, `TESTING.md`
   - le dossier `maquettes/` (les `.html`)
5. **Assistant IA** :
   - *Android Studio* : ouvre l'assistant (Gemini/Copilot/Continue/Claude selon ton plugin) et colle le **prompt maître** ci-dessous.
   - *Claude Code* (recommandé pour le multi-fichiers) : ouvre un terminal à la racine, lance `claude`, colle le prompt maître.

---

## B. PROMPT MAÎTRE (à coller en premier)

```
Tu es développeur Flutter senior. On construit DATO, une application Android
de génération de devis pour artisans d'Afrique francophone (Cameroun d'abord).
L'UI est 100 % en français.

AVANT TOUT, lis ces fichiers à la racine et considère-les comme la source de vérité :
- README.md         → contexte produit, modèle de données, intégrations
- ARCHITECTURE.md   → arborescence, couches, Riverpod, go_router, offline-first
- ROADMAP.md        → phases d'implémentation, écran par écran, avec Definition of Done
- TESTING.md        → stratégie et exemples de tests
- maquettes/*.html  → référence visuelle PIXEL-PRÈS de chaque écran

Stack imposée : Flutter + Dart, Riverpod (state), go_router (nav), Isar (offline),
Dio (API Flask), Supabase (auth OTP), package pdf/printing (PDF), share_plus (WhatsApp),
Campay (Mobile Money via backend). Ne propose pas une autre stack.

Règles non négociables :
1. Respecte l'arborescence d'ARCHITECTURE.md. Feature-first.
2. Tokens = source de vérité : aucune couleur/taille en dur hors de core/theme.
   Réutilise app_theme.dart déjà fourni.
3. Offline-first : l'UI lit/écrit Isar ; la sync API est un effet de bord.
4. Tout libellé visible passe par l10n (FR par défaut).
5. Montants en int FCFA, affichés via formatFcfa(), chiffres tabulaires.
   N'invente pas de logique de calcul : réutilise quote.dart, montant_en_lettres.dart, formatters.dart.
6. Pose des Key stables sur les éléments interactifs (pour les tests).
7. À CHAQUE phase : écris le code PUIS les tests de la porte (cf. TESTING.md),
   lance `flutter analyze` et `flutter test`, et n'avance pas tant que ce n'est pas vert.

On avance UNE phase à la fois, dans l'ordre de ROADMAP.md. Ne code pas en avance
sur les phases suivantes. Commence par me confirmer que tu as lu les 4 docs et
résume en 5 lignes le plan de la Phase 0. Attends mon "go" avant d'écrire du code.
```

---

## C. PROMPTS PAR PHASE (un à la fois, après le précédent validé)

**Phase 0 — Fondations & Design System**
```
Go Phase 0 (ROADMAP.md). Mets en place main.dart, app.dart (MaterialApp.router,
thème, localizations), le go_router avec le shell bottom-nav (Accueil/Devis/+/Articles/
Réglages) et 4 écrans placeholder. Implémente les widgets du design system listés
(DatoButton 5 variantes + états, DatoTextField, MoneyField, StatusBadge, DatoBottomSheet,
DatoToast, EmptyState, SkeletonList) d'après Design System.html. Ajoute les golden
tests des boutons, du StatusBadge et d'une carte de devis. Termine par flutter analyze + flutter test.
```

**Phase 1 — Domaine & logique métier**
```
Go Phase 1. Intègre quote.dart (domaine) et configure Isar (isar_service + collections
miroir + mapping). Implémente QuoteRepository (CRUD + watchAll en local). Écris les tests
unitaires EXHAUSTIFS de TESTING.md : montantEnLettres (tous les cas), grandTotal
(multi-sections, forfait + formule), formatMoney, et un round-trip Isar. Tout doit être vert.
```

**Phase 2 — Éditeur de devis (cœur)**
```
Go Phase 2. Implémente quote_editor_screen + quote_editor_controller (Riverpod) et les
widgets (section_card, section_line_tile, rubrique_card, rubrique_line_tile, designation_
autocomplete, total_card), fidèlement à Éditeur de devis.html. Exigences : drag & drop
sections ET lignes via poignée (ReorderableListView, handle dédié, pas de conflit scroll) ;
toggle Forfait/A×B par ligne ; sous-lignes ; recalcul live ; client obligatoire ; autosave
Isar debounce 800ms avec indicateur ; total + montant en lettres auto. Ajoute les widget tests
et une golden de l'éditeur rempli.
```

**Phase 3 — Aperçu, PDF & partage**
```
Go Phase 3. Implémente quote_preview_screen (fidèle au Gabarit PDF A4.html), quote_pdf.dart
(package pdf, A4 crédible en N&B) et share_sheet.dart (WhatsApp en premier, Copier lien,
PDF, e-mail). Branche printing (aperçu/impression) et share_plus (whatsapp://). Golden de
la page PDF + widget test du bottom sheet.
```

**Phase 4 — Dashboard & Liste**
```
Go Phase 4. Implémente dashboard_screen (quota, stats, 3 récents) et quotes_list_screen
(recherche, filtres statut, carte devis, menu d'actions) d'après Application DATO.html.
Relie FAB + tap carte → éditeur. Widget tests : filtre statut, recherche, état vide.
```

**Phase 5 — Auth + OTP + Onboarding**
```
Go Phase 5. Intègre supabase_flutter (auth téléphone + OTP SMS). Implémente signup/login/otp/
forgot/reset et l'onboarding 3 étapes d'après Auth & Onboarding.html. Redirections go_router
selon session. Widget tests (OTP, mismatch mot de passe) + un integration test signup→home (mock).
```

**Phase 6 — Backend Flask, sync & vue publique**
```
Go Phase 6. Implémente la couche remote (Dio) vers l'API Flask, la file de sync offline-first
(rejeu au retour réseau via connectivity_plus, bandeau hors-ligne) et quote_public_screen +
route /p/:token (deep link, sans auth, révocable). Test unitaire de la file de sync (repo mocké).
```

**Phase 7 — Paiement Mobile Money**
```
Go Phase 7. Implémente le flux billing (paywall, plans mensuel/annuel, opérateur MTN/Orange +
numéro, écran "validez sur votre téléphone" avec polling, succès/échec, abonnement + historique)
d'après Paiement & Abonnement.html, via Campay côté backend. Déblocage Pro sur webhook confirmé.
Widget tests des 4 états + integration test paywall→succès (API mockée).
```

**Phase 8 — Bibliothèque, Réglages, états & polish**
```
Go Phase 8. Implémente la bibliothèque d'articles (CRUD + modal), les réglages 5 onglets, tous
les modals restants et les états (skeleton, vide, alertes, 404, hors-réseau, 500, légal) d'après
Modals & États.html. Passe la suite golden complète + un integration test "inscription→premier
devis→partage". Prépare un build release signé pour le Play Store.
```

---

## D. Rappels utiles à redonner si l'IA dérive

- « Reste sur Flutter/Riverpod/Isar — ne change pas la stack. »
- « Réutilise les tokens de core/theme, pas de couleur en dur. »
- « Compare ton écran à maquettes/<fichier>.html avant de dire que c'est fini. »
- « Écris les tests de la porte (TESTING.md) avant de passer à la phase suivante. »
- « Régénère le code : `dart run build_runner build --delete-conflicting-outputs`. »

---

## E. Astuce workflow Android Studio
- Garde un onglet navigateur ouvert sur la maquette `.html` de la phase en cours (double-clic sur le fichier dans `maquettes/`).
- Ouvre l'émulateur Android (un profil **low-end**, ex. Pixel 4a, API 30) pour tester la fluidité réelle du drag & drop et des saisies — c'est ta cible.
- Commit après chaque phase verte (`git commit -m "Phase N — …"`).
```
