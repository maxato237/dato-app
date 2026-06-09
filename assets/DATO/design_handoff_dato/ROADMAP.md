# ROADMAP — DATO (Flutter)

> Implémentation **par phases**, du fondamental vers le périphérique. Chaque phase a une **Definition of Done (DoD)** et une **porte de tests** à passer avant de continuer. Garde la maquette `.html` correspondante ouverte comme référence pixel-près.

Légende : 🎯 objectif · 📁 fichiers · 🔌 dépend de · ✅ DoD · 🧪 tests (cf. TESTING.md)

---

## Phase 0 — Fondations & Design System
🎯 Projet qui démarre, thème appliqué, composants réutilisables prêts, navigation shell vide.
📁 `main.dart`, `app.dart`, `core/theme/*`, `core/router/*`, `core/widgets/*`, `features/shell/app_shell.dart`, `l10n/*`
🔌 starter : `app_theme.dart`, `pubspec.yaml`
✅ DoD :
- `flutter run` lance une app avec la bottom nav (Accueil/Devis/+/Articles/Réglages) et 4 écrans placeholder.
- Tous les composants du `Design System.html` existent en widgets : `DatoButton` (5 variantes + états loading/disabled), `DatoTextField`, `MoneyField`, `StatusBadge` (4 statuts), `DatoBottomSheet`, `DatoToast`, `EmptyState`, `SkeletonList`.
- Police Sora/Inter chargée, couleurs = tokens.
🧪 `golden/` : une golden par variante de bouton + `StatusBadge` + une carte de devis, comparées à la maquette.

---

## Phase 1 — Domaine & logique métier (cœur invisible)
🎯 Modèle de données + tous les calculs, testés à fond. **Rien d'visuel, mais c'est la fondation critique.**
📁 `features/quotes/domain/quote.dart` (← starter/quote.dart), `core/utils/montant_en_lettres.dart`, `core/utils/formatters.dart`, `data/local/isar_service.dart`, `data/local/models/*`, `data/repositories/quote_repository.dart`
🔌 Phase 0
✅ DoD :
- Entités `Quote/Section/Rubrique/RubriqueLine` avec getters `total`/`pt`/`grandTotal`.
- `montantEnLettres()` et `formatFcfa()` opérationnels.
- Isar ouvre, persiste et relit un `Quote` complet (sections + rubriques imbriquées).
- `QuoteRepository` : create / read / update / delete / watchAll en local.
🧪 `unit/` **exhaustifs** :
- `grandTotal` = Σ sections + Σ rubriques (cas multi-sections, forfait + formule mélangés).
- `montantEnLettres` : jeu de cas `0, 1, 80, 81, 100, 200, 1000, 1025500, 18630000, 1_000_000_000` → valeurs françaises exactes.
- `formatMoney(1025500) == "1 025 500"`.
- round-trip Isar (écrire puis relire == identique).

---

## Phase 2 — Éditeur de devis (LE CŒUR)
🎯 L'écran central, pleinement interactif et offline.
📁 `quote_editor_screen.dart`, `quote_editor_controller.dart`, `widgets/section_card.dart`, `section_line_tile.dart`, `rubrique_card.dart`, `rubrique_line_tile.dart`, `designation_autocomplete.dart`, `total_card.dart`
🔌 Phases 0–1 · maquette `Éditeur de devis.html`
✅ DoD :
- En-tête (objet, client obligatoire avec validation « DOIT », date, n° auto).
- Sections : ajouter/supprimer lignes, éditer désignation/Qté/P.U, **P.T et sous-total recalculés en direct**.
- Rubriques libres : ajouter, choisir **Forfait** ou **A × B** par ligne, sous-lignes multiples, total live.
- **Drag & drop** réordonnant sections ET lignes via la poignée (sans casser le scroll).
- **Autocomplétion** désignation depuis la bibliothèque.
- **Auto-enregistrement** Isar avec debounce + indicateur « Enregistrement… / Enregistré ».
- **Total général** + **montant en lettres** auto. Signatures éditables.
🧪 `widget/` : saisie d'une Qté met à jour le P.T ; ajout d'une rubrique formule affiche `a×b=résultat` ; le client vide bloque le partage. `golden/` éditeur rempli vs maquette.

---

## Phase 3 — Aperçu, PDF & partage
🎯 Voir le devis comme le client le recevra, générer le PDF, partager.
📁 `quote_preview_screen.dart`, `features/pdf/quote_pdf.dart`, `widgets/share_sheet.dart`
🔌 Phase 2 · maquettes `Éditeur de devis.html` (onglet Aperçu) + `Gabarit PDF A4.html`
✅ DoD :
- Aperçu fidèle au gabarit (en-tête encadré, tableau, sous-totaux, total général, montant en lettres, signatures).
- `quote_pdf.dart` (package `pdf`) produit un A4 **crédible en noir & blanc** = `Gabarit PDF A4.html`.
- Bottom sheet Partager : **WhatsApp en premier** (vert), Copier le lien, Télécharger PDF, E-mail.
- `printing` permet aperçu/impression ; `share_plus` ouvre WhatsApp.
🧪 `widget/` : le sheet liste WhatsApp en 1er. `golden/` page PDF vs gabarit. Test manuel : ouverture WhatsApp sur device.

---

## Phase 4 — Tableau de bord & Liste des devis
🎯 Relier les devis dans une vraie navigation.
📁 `dashboard_screen.dart`, `quota_card.dart`, `stat_card.dart`, `quote_card.dart`, `quotes_list_screen.dart`, `quotes_list_controller.dart`
🔌 Phases 1–2 · maquette `Application DATO.html`
✅ DoD :
- Dashboard : carte quota (x/3), stats du mois, 3 devis récents, CTA Nouveau devis.
- Liste : recherche (objet/client), filtres par statut (chips), carte par devis, menu d'actions (Voir/Dupliquer/Partager/PDF/Statut/Supprimer).
- FAB central + tap carte → éditeur.
🧪 `widget/` : filtrer « Accepté » réduit la liste ; recherche filtre ; état vide quand 0 résultat.

---

## Phase 5 — Auth téléphone + OTP + Onboarding
🎯 Entrée dans l'app, configuration entreprise.
📁 `features/auth/*`, `features/onboarding/*`, `auth_repository.dart`, `auth_controller.dart`
🔌 Supabase (`supabase_flutter`) · maquette `Auth & Onboarding.html`
✅ DoD :
- Inscription (nom, +237…, mot de passe) → OTP 6 cases + compte à rebours + renvoi.
- Connexion, Mot de passe oublié, Réinitialisation.
- OTP SMS réel via Supabase Auth (phone).
- Onboarding 3 étapes (en-tête entreprise + logo, signatures, fin) → persistées.
- `go_router` redirige selon la session.
🧪 `widget/` : OTP complet active « Vérifier » ; mots de passe différents → erreur. `integration/` : signup → OTP (mock) → onboarding → home.

---

## Phase 6 — Backend Flask, sync & vue publique
🎯 Persistance serveur, partage du devis par lien public.
📁 `data/remote/*`, sync queue dans `quote_repository.dart`, `quote_public_screen.dart`, route `/p/:token`
🔌 Phases 2–5 · backend Flask + Postgres
✅ DoD :
- API Flask : CRUD devis, upload, génération du lien public, endpoint `/devis/:token/public`.
- Sync offline-first : écritures locales mises en file, rejouées au retour réseau (`connectivity_plus`). Bandeau hors-ligne.
- Vue publique accessible **sans auth** via deep link, révocable.
🧪 `unit/` : la file de sync rejoue dans l'ordre après reconnexion (repo mocké). Test manuel : ouvrir le lien public en navigation privée.

---

## Phase 7 — Paiement Mobile Money & abonnement
🎯 Monétisation : paywall → paiement → Pro.
📁 `features/billing/*`, `billing_repository.dart`, `payment_api.dart`
🔌 Campay (via backend Flask + webhook) · maquette `Paiement & Abonnement.html`
✅ DoD :
- Paywall au quota atteint (3/3).
- Choix plan (mensuel/annuel −20%), choix opérateur (MTN/Orange) + numéro.
- Flux Campay : initier → écran **« validez sur votre téléphone »** (polling statut) → Succès / Échec.
- Déblocage Pro après webhook confirmé ; écran Abonnement + historique.
🧪 `widget/` : les 4 états de paiement s'affichent ; succès → quota illimité. `integration/` : paywall → plan → opérateur → succès (API mockée).

---

## Phase 8 — Bibliothèque, Réglages, états & polish
🎯 Finitions et robustesse.
📁 `features/library/*`, `features/settings/*`, états d'erreur, modals restants
🔌 toutes phases · maquette `Modals & États.html`
✅ DoD :
- Bibliothèque d'articles (CRUD, recherche, modal article, état vide).
- Réglages 5 onglets (entreprise, signatures, compte, numérotation avec aperçu, préférences).
- Modals : Nouveau devis, Dupliquer, Changer statut, Logo (recadrage), Suppression, Session expirée.
- États : skeleton, vide, bandeaux d'alerte, 404, hors-réseau, erreur 500, page légale.
- Accessibilité (cibles ≥48px, contraste), perf sur device low-end.
🧪 `integration/` : parcours complet « inscription → premier devis → partage ». Suite golden complète. `flutter analyze` vert.

---

## Ordre conseillé & jalons
1. **MVP démontrable** = Phases 0 → 4 (créer/éditer/aperçu/partager/lister un devis, en local). C'est déjà vendeur.
2. **Comptes & cloud** = Phases 5 → 6.
3. **Monétisation** = Phase 7.
4. **Release** = Phase 8 + build signé Play Store.

> Avance **une phase à la fois**, fais passer la porte de tests, commit, puis enchaîne. Ne démarre pas le paiement (7) avant que l'éditeur (2–3) soit solide.
```
