# Handoff développeur — DATO (application **Flutter** de devis pour artisans)

> **À donner à Claude Code / l'assistant Android Studio.** Ce paquet contient tout pour transformer les maquettes en une vraie application **mobile native Android (Flutter)**.

---

## 📦 Contenu du paquet

| Fichier | Rôle |
|---|---|
| **README.md** *(ce fichier)* | Contexte produit, modèle de données, intégrations |
| **ARCHITECTURE.md** | Arborescence Flutter complète, couches, Riverpod, go_router, offline-first |
| **ROADMAP.md** | Phases d'implémentation **écran par écran**, avec Definition of Done + tests |
| **TESTING.md** | Stratégie de tests (unit / widget / golden / intégration) + exemples |
| **PROMPT_ANDROID_STUDIO.md** | **Prompts prêts à coller** (maître + un par phase) |
| **starter/** | Code Dart de démarrage déjà porté (thème, modèles, montant en lettres, formatters, pubspec) |
| **maquettes/** | Les écrans `.html` — référence visuelle pixel-près |

👉 **Commence par `PROMPT_ANDROID_STUDIO.md`** : il te dit comment créer le projet, copier le starter, et lancer l'IA phase par phase.

---

## 1. Vue d'ensemble

**DATO** permet à des **artisans/techniciens** (menuisiers, décorateurs, électriciens, BTP…) de **créer, mettre en forme, partager et télécharger des devis professionnels** depuis leur téléphone.

- **Marché :** Afrique francophone (Cameroun en premier). Interface **100 % en français**.
- **Utilisateur :** artisan 25–55 ans, peu à l'aise avec l'informatique, sur **Android d'entrée/milieu de gamme**, connexion parfois instable.
- **Modèle économique :** freemium (3 devis/mois gratuits) + abonnement **Pro** payé en **Mobile Money** (MTN MoMo / Orange Money).
- **Partage des devis :** prioritairement via **WhatsApp** (lien public + PDF).
- **Distribution :** **Play Store natif**, Android prioritaire.

## 2. ⚠️ À propos des fichiers de design

Les `.html` du dossier `maquettes/` sont des **références de design** — ils montrent l'apparence et le comportement voulus. **Ce n'est PAS du code à copier.** La tâche est de **recréer ces écrans en Flutter**, avec une vraie base de données et de vraies intégrations.

## 3. Fidélité : **HAUTE (hi-fi)**

Les maquettes sont **pixel-près** : couleurs, typographie, espacements et interactions sont définitifs. Les **design tokens** (section 8 + `starter/app_theme.dart`) sont la source de vérité.

## 4. Stack (imposée)

| Couche | Choix | Justification |
|---|---|---|
| **Mobile** | **Flutter (Dart)** | Rendu 60fps constant sur Android low-end, drag & drop sans conflit scroll, UI pixel-près garantie |
| **État** | **Riverpod** | Controllers testables, recalculs réactifs |
| **Navigation** | **go_router** | Routes déclaratives + deep link (lien public) |
| **BDD locale** | **Isar** | Offline-first, rapide, embarqué |
| **Backend** | **Flask + PostgreSQL** (Railway / Render) | API REST, génération PDF server-side, lien public |
| **Auth** | **Supabase** (`supabase_flutter`) | Auth téléphone + OTP SMS, SDK Flutter officiel |
| **PDF** | **`pdf` + `printing`** | Génération + impression in-app ; Puppeteer backend pour le lien |
| **Paiement** | **Campay** (Cameroun-first) | MTN MoMo + Orange Money, webhook de confirmation |
| **Drag & drop** | **`ReorderableListView`** (handle dédié) | Tactile, pas de conflit scroll |
| **Partage** | **`share_plus`** + `url_launcher` | WhatsApp + autres canaux |

> Le backend Flask expose `/devis/:token/public` (HTML rendu) pour la **vue publique** partagée via WhatsApp — accessible sans auth.

## 5. Modèle de données (LE point critique)

Le cœur de l'app est l'éditeur. **Les rubriques sont entièrement libres et ajoutables, chacune avec sa propre logique de calcul.** Le modèle Dart complet (entités + getters de calcul) est **déjà fourni** dans **`starter/quote.dart`**. Résumé :

```
Quote
 ├─ number, date, object, client (OBLIGATOIRE = "DOIT"), status, note
 ├─ sections[]      Section{ title, lines[] { designation, qty, pu → pt=qty×pu } }
 │                  → sous-total = Σ pt
 ├─ rubriques[]     Rubrique{ label, lines[] }
 │                  RubriqueLine : mode 'forfait' (amount) | mode 'formula' (a×b)
 │                  → total = Σ lignes
 └─ grandTotal = Σ sous-totaux sections + Σ totaux rubriques
```

Règles métier :
- Une rubrique peut avoir **plusieurs sous-lignes** (ex. « Usinage : Planches 1000×1360 + Madriers 500×760 »).
- Un devis peut cumuler **plusieurs sections** matériel (« Devis 1 + Devis 2 »).
- **Montant en lettres** : généré automatiquement, jamais saisi → **déjà porté en Dart** dans `starter/montant_en_lettres.dart` (gère milliards, « quatre-vingts », « cent(s) », « mille »).
- **Montants** : entiers FCFA, séparateur par **espace** (`1 025 500 FCFA`) → `starter/formatters.dart` ; affichage en **chiffres tabulaires** (`FontFeature.tabularFigures()`).
- Numérotation paramétrable : `DV-{année}-{séquence}`.

## 6. Inventaire des écrans (par maquette)

| Fichier `maquettes/` | Écrans |
|---|---|
| `Design System.html` | Tokens, boutons, champs, badges, cartes, onglets, toasts, modal, bottom sheet, tab bar, états vides, skeletons |
| `Auth & Onboarding.html` | Inscription · Connexion · OTP (6 chiffres + compte à rebours) · Mot de passe oublié · Réinitialisation · Onboarding 3 étapes |
| `Application DATO.html` | Dashboard (quota, stats, récents) · Liste (recherche, filtres, menu) · Tab bar |
| `Éditeur de devis.html` | **Éditeur** (drag & drop, rubriques forfait/formule, autosave, hors-ligne) · Aperçu · Vue publique |
| `Paiement & Abonnement.html` | Paywall · Plan · Opérateur · En attente · Succès · Échec · Abonnement |
| `Modals & États.html` | Bibliothèque · Réglages (5 onglets) · 8 modals · états (chargement/vide/alerte/404/réseau/500/légal) |
| `Landing & Tarifs.html` | Landing marketing — **web séparé** (hors app native) |
| `Gabarit PDF A4.html` | Gabarit imprimable A4 — à reproduire via package `pdf` |

## 7. Interactions à respecter

- **Drag & drop** : `ReorderableListView` (sections ET lignes), `buildDefaultDragHandles: false`, `ReorderableDragStartListener` sur la **poignée ⠿** uniquement → pas de conflit scroll ; `proxyDecorator` pour l'élévation pendant le déplacement. Réf. : `maquettes/devis/Sortable.jsx`.
- **Saisie rapide** : clavier numérique (`TextInputType.number`) pour Qté/P.U, P.T live.
- **Auto-enregistrement** : « Enregistrement… » → « Enregistré » (debounce ~800 ms), Isar + file de sync.
- **Hors-ligne** : bandeau persistant ; détection `connectivity_plus`.
- **WhatsApp = partage primaire** : bouton vert en premier dans le bottom sheet.
- **Mobile Money** : expliquer l'étape « validez sur votre téléphone » (PIN USSD) ; 4 états (saisie / attente+polling / succès / échec).
- **Auto-complétion** désignation depuis la bibliothèque (`Autocomplete<Article>`).
- **Statuts** : Brouillon (gris) → Envoyé (bleu) → Accepté (vert) / Refusé (rouge).
- **Cibles tactiles ≥ 48 px**, contraste AA.

## 8. Design tokens (source de vérité)

Tous portés dans **`starter/app_theme.dart`** (`AppColors`, `AppSpacing`, `AppRadii`, `AppTheme.light()`). Extrait :

```
Marque      ink #1B4965 · green #2BA84A · amber #F4A300 · whatsapp #25D366
Neutres     bg #F7F8FA · surface #FFF · border #E3E8EE · text #101828/#475467/#98A2B3
Statuts     draft #5b6573/#eef0f3 · sent #1B4965/#e7eef3 · accepted #218a3c/#e4f5e9 · refused #c0383c/#fde8e8
Type        Titres Sora (700/800) · Corps Inter (400–700) · montants tabulaires
Espace      échelle 4px (4 8 12 16 20 24 32 40 48) · Rayons 8/10/12/16/pill · Tap min 48px
```

## 9. Intégrations à implémenter

1. **Auth téléphone + OTP SMS** : Supabase Auth. Format `+237…`.
2. **Mobile Money** : Campay. Flux : initier → validation PIN USSD côté client → polling/webhook → débloquer Pro côté Flask → sync app.
3. **PDF** : in-app (`pdf`/`printing`) pour aperçu/téléchargement ; backend Flask `/devis/:id/pdf` (Puppeteer) pour le lien partagé.
4. **Lien public** : route Flask `/devis/:token/public` (sans auth), révocable.
5. **Logo** : Supabase Storage, `image_picker` + `image_cropper`.

## 10. Fichiers `starter/` (déjà prêts à copier)

| Fichier | Destination conseillée |
|---|---|
| `app_theme.dart` | `lib/core/theme/app_theme.dart` (scinder ensuite) |
| `montant_en_lettres.dart` | `lib/core/utils/montant_en_lettres.dart` |
| `formatters.dart` | `lib/core/utils/formatters.dart` |
| `quote.dart` | `lib/features/quotes/domain/quote.dart` |
| `pubspec.yaml` | racine du projet |

## 11. Parcours clés à câbler

1. Inscription → OTP → onboarding → premier devis → partage WhatsApp.
2. Nouveau devis → éditeur (drag & drop) → aperçu PDF → partage.
3. Quota atteint → paywall → plan → paiement Mobile Money → Pro débloqué.
4. Dupliquer un ancien devis → modifier → renvoyer.

---

## Démarrage rapide

1. Lis **PROMPT_ANDROID_STUDIO.md** (mise en place + prompts).
2. `flutter create --org com.dato --project-name dato dato`, copie le `starter/`.
3. Place cette doc + `maquettes/` à la racine, lance l'IA avec le **prompt maître**, puis avance **phase par phase** (ROADMAP.md), en passant la **porte de tests** (TESTING.md) à chaque fois.

> Ordre conseillé : **MVP local** (Phases 0→4) → **comptes & cloud** (5→6) → **paiement** (7) → **polish & release** (8).
