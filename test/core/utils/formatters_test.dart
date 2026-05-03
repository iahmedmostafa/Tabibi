import 'package:flutter_test/flutter_test.dart';
import 'package:tabibi/core/utils/formatters.dart/formatters.dart';

void main() {
  group('Formatter', () {
    test('keeps time-only schedule values unchanged in 12-hour format', () {
      expect(Formatter.formatTo12Hour('12:25:00'), '12:25 PM');
      expect(Formatter.formatTo12Hour('00:25:00'), '12:25 AM');
    });

    test('does not shift ISO slot times into the local timezone', () {
      expect(Formatter.formatIsoTo12Hour('2026-05-03T00:25:00Z'), '12:25 AM');
      expect(
        Formatter.formatIsoTo12Hour('2026-05-03T12:25:00Z'),
        '12:25 PM',
      );
    });
  });
}
