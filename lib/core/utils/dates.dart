const List<String> _frMonths = [
  'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
  'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
];

/// '2026-05-12' -> '12 mai 2026'. Renvoie l'entrée telle quelle si invalide.
String frenchLongDate(String iso) {
  final d = DateTime.tryParse(iso);
  if (d == null) return iso;
  return '${d.day} ${_frMonths[d.month - 1]} ${d.year}';
}

const List<String> _frMonthsShort = [
  'janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin',
  'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.',
];

/// '2026-05-12' -> '12 mai 2026' (mois abrégé). Pour les cartes de devis.
String frenchShortDate(String iso) {
  final d = DateTime.tryParse(iso);
  if (d == null) return iso;
  return '${d.day} ${_frMonthsShort[d.month - 1]} ${d.year}';
}
