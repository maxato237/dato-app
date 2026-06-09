import 'dart:math';

final Random _rand = Random();

/// Identifiant local unique (avant éventuelle synchronisation serveur).
/// Format court, lisible, trié approximativement par date de création.
String newId() {
  final ts = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
  final r = _rand.nextInt(1 << 24).toRadixString(36).padLeft(5, '0');
  return 'id$ts$r';
}
