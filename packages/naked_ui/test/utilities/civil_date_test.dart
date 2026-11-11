import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

void main() {
  group('civil date helpers', () {
    test('civilDate normalizes overflowing fields like DateTime', () {
      final date = civilDate(2024, 2, 30);
      expect([date.year, date.month, date.day], [2024, 3, 1]);
      final first = civilDate(2024, 13);
      expect([first.year, first.month, first.day], [2025, 1, 1]);
    });

    test('compareCivilDates ignores time and the UTC flag', () {
      expect(
        compareCivilDates(
          DateTime(2024, 2, 20, 23, 59),
          DateTime.utc(2024, 2, 20),
        ),
        0,
      );
      expect(
        compareCivilDates(DateTime(2024, 2, 19), DateTime(2024, 2, 20)),
        -1,
      );
      expect(compareCivilDates(DateTime(2025), DateTime(2024, 12, 31)), 1);
    });

    test('isSameCivilDate compares fields and treats null as only null', () {
      expect(
        isSameCivilDate(DateTime(2024, 2, 20, 8), DateTime.utc(2024, 2, 20)),
        isTrue,
      );
      expect(
        isSameCivilDate(DateTime(2024, 2, 20), DateTime(2024, 2, 21)),
        isFalse,
      );
      expect(isSameCivilDate(null, null), isTrue);
      expect(isSameCivilDate(DateTime(2024), null), isFalse);
    });
  });
}
