import 'package:flutter_test/flutter_test.dart';
import 'package:dato/core/utils/formatters.dart';

void main() {
  group('formatMoney', () {
    test('formate avec séparateur espace', () {
      expect(formatMoney(1025500), '1 025 500');
    });
    test('formate 0', () {
      expect(formatMoney(0), '0');
    });
    test('formate 50000', () {
      expect(formatMoney(50000), '50 000');
    });
  });

  group('formatFcfa', () {
    test('ajoute le suffixe FCFA', () {
      expect(formatFcfa(50000), '50 000 FCFA');
    });
    test('grand montant', () {
      expect(formatFcfa(1025500), '1 025 500 FCFA');
    });
  });
}
