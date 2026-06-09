import 'package:intl/intl.dart';

final NumberFormat _milliers = NumberFormat('#,##0', 'fr_FR');

/// 1025500 -> "1 025 500"
String formatMoney(num n) {
  return _milliers
      .format(n.round())
      .replaceAll(' ', ' ') // espace fine insécable
      .replaceAll(' ', ' '); // espace insécable
}

/// 1025500 -> "1 025 500 FCFA"
String formatFcfa(num n) => '${formatMoney(n)} FCFA';