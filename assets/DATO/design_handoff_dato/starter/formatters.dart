// ============================================================
// DATO — Formatage des montants
// Dossier conseillé : lib/core/utils/formatters.dart
// Dépendance : intl  (déjà fournie par flutter_localizations)
// ============================================================

import 'package:intl/intl.dart';

// Groupe les milliers. On force l'espace simple (et non l'espace insécable
// que `fr_FR` insère) pour rester fidèle aux maquettes : "1 025 500".
final NumberFormat _milliers = NumberFormat('#,##0', 'fr_FR');

/// 1025500 -> "1 025 500"
String formatMoney(num n) {
  return _milliers
      .format(n.round())
      .replaceAll('\u202f', ' ') // espace fine insécable
      .replaceAll('\u00a0', ' '); // espace insécable
}

/// 1025500 -> "1 025 500 FCFA"
String formatFcfa(num n) => '${formatMoney(n)} FCFA';

// NB côté UI : pour aligner les chiffres dans les colonnes (P.U, P.T, totaux),
// appliquer sur les Text de montants :
//   style: TextStyle(fontFeatures: [FontFeature.tabularFigures()])
