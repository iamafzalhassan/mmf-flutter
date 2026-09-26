import 'package:flutter_test/flutter_test.dart';
import 'package:mmf/core/utils/data_sanitizer.dart';

void main() {
  group('DataSanitizer', () {
    test('uppercases text, collapses spaces and tidies punctuation', () {
      expect(DataSanitizer.sanitizeString('  mohamed   rizwan , ok '), 'MOHAMED RIZWAN, OK');
    });

    test('normalises address commas and drops a trailing comma', () {
      expect(DataSanitizer.sanitizeAddress('  no 12 ,, main   street ,colombo , '), 'NO 12, MAIN STREET, COLOMBO');
    });

    test('keeps only digits in phone numbers', () {
      expect(DataSanitizer.sanitizeDigits(' 077-123 4567 '), '0771234567');
    });

    test('keeps only digits, V and X in national ID numbers', () {
      expect(DataSanitizer.sanitizeNic(' 98765432v '), '98765432V');
      expect(DataSanitizer.sanitizeNic('2000-1234 5678'), '200012345678');
    });

    test('drops blank multi-select answers and joins the sanitised rest', () {
      expect(DataSanitizer.sanitizeList(<String>['o/l', '  ', ' a/l ']), 'O/L, A/L');
    });
  });
}
