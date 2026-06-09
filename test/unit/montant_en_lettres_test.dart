import 'package:flutter_test/flutter_test.dart';
import 'package:dato/core/utils/montant_en_lettres.dart';

void main() {
  group('montantEnLettres', () {
    final cas = <int, String>{
      0: 'Zéro francs CFA',
      1: 'Un francs CFA',
      71: 'Soixante-et-onze francs CFA',
      80: 'Quatre-vingts francs CFA',
      81: 'Quatre-vingt-un francs CFA',
      100: 'Cent francs CFA',
      200: 'Deux cents francs CFA',
      1000: 'Mille francs CFA',
      1025500: 'Un million vingt-cinq mille cinq cents francs CFA',
      18630000: 'Dix-huit millions six cent trente mille francs CFA',
      1000000000: 'Un milliard francs CFA',
    };
    cas.forEach((n, attendu) {
      test('$n → $attendu', () => expect(montantEnLettres(n), attendu));
    });
  });
}
