// ============================================================
// DATO — Montant en lettres (français)
// Porté fidèlement depuis util.js (maquettes). Gère jusqu'aux milliards,
// les accords « quatre-vingts », « cent(s) », « mille ».
//
// Dossier conseillé : lib/core/utils/montant_en_lettres.dart
// Couvert par des tests unitaires (voir TESTING.md).
// ============================================================

const List<String> _units = [
  'zéro', 'un', 'deux', 'trois', 'quatre', 'cinq', 'six', 'sept', 'huit', 'neuf',
  'dix', 'onze', 'douze', 'treize', 'quatorze', 'quinze', 'seize',
  'dix-sept', 'dix-huit', 'dix-neuf',
];

const List<String> _tens = [
  '', '', 'vingt', 'trente', 'quarante', 'cinquante',
  'soixante', 'soixante', 'quatre-vingt', 'quatre-vingt',
];

String _below100(int n, {bool noPlural = false}) {
  if (n < 20) return _units[n];
  final t = n ~/ 10;
  final u = n % 10;
  if (t == 7) {
    if (u == 0) return 'soixante-dix';
    if (u == 1) return 'soixante-et-onze';
    return 'soixante-${_units[10 + u]}';
  }
  if (t == 9) return 'quatre-vingt-${_units[10 + u]}';
  if (t == 8) {
    if (u == 0) return noPlural ? 'quatre-vingt' : 'quatre-vingts';
    return 'quatre-vingt-${_units[u]}';
  }
  if (u == 0) return _tens[t];
  if (u == 1) return '${_tens[t]}-et-un';
  return '${_tens[t]}-${_units[u]}';
}

String _below1000(int n, {bool noPlural = false}) {
  final c = n ~/ 100;
  final r = n % 100;
  var s = '';
  if (c > 0) {
    s = c == 1 ? 'cent' : '${_units[c]} cent';
    if (r == 0 && c > 1 && !noPlural) s += 's';
  }
  if (r > 0) s += (s.isNotEmpty ? ' ' : '') + _below100(r, noPlural: noPlural);
  return s;
}

String _toWords(int value) {
  if (value == 0) return 'zéro';
  var n = value;
  final parts = <String>[];
  final md = n ~/ 1000000000;
  n %= 1000000000;
  final mi = n ~/ 1000000;
  n %= 1000000;
  final ml = n ~/ 1000;
  n %= 1000;
  final re = n;

  if (md > 0) parts.add('${_below1000(md)} ${md > 1 ? 'milliards' : 'milliard'}');
  if (mi > 0) parts.add('${_below1000(mi)} ${mi > 1 ? 'millions' : 'million'}');
  if (ml > 0) parts.add(ml == 1 ? 'mille' : '${_below1000(ml, noPlural: true)} mille');
  if (re > 0) parts.add(_below1000(re));

  return parts.join(' ');
}

/// Convertit un montant en toutes lettres, suffixé « francs CFA ».
/// Ex. montantEnLettres(1025500) => "Un million vingt-cinq mille cinq cents francs CFA".
String montantEnLettres(num montant) {
  final n = montant.round();
  final w = _toWords(n);
  final cap = w.isEmpty ? w : w[0].toUpperCase() + w.substring(1);
  return '$cap francs CFA';
}
