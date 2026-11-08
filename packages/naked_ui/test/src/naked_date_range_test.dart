import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

void main() {
  test('skipped local endpoints retain civil fields, equality and order', () {
    final start = DateTime.utc(2011, 12, 30, 18);
    final range = NakedDateRange(start: start, end: DateTime.utc(2011, 12, 31));
    expect(range.start.day, 30);
    expect(range.end.day, 31);
    expect(range.contains(DateTime.utc(2011, 12, 30)), isTrue);
    final equal = NakedDateRange(
      start: DateTime.utc(2011, 12, 30),
      end: DateTime(2011, 12, 31),
    );
    expect(range, equal);
    expect(range.hashCode, equal.hashCode);
    expect(
      () => NakedDateRange(start: DateTime.utc(2011, 12, 31), end: start),
      throwsArgumentError,
    );
  });

  test(
    'normalizes civil fields, ignores time/UTC and includes both endpoints',
    () {
      final range = NakedDateRange(
        start: DateTime.utc(2024, 2, 28, 23),
        end: DateTime(2024, 3, 1, 17),
      );
      expect(range.start, DateTime(2024, 2, 28));
      expect(range.end, DateTime(2024, 3));
      expect(range.start.isUtc, isFalse);
      expect(range.contains(DateTime.utc(2024, 2, 28)), isTrue);
      expect(range.contains(DateTime(2024, 2, 29, 22)), isTrue);
      expect(range.contains(DateTime.utc(2024, 3, 1, 23)), isTrue);
      expect(range.contains(DateTime(2024, 2, 27)), isFalse);
      expect(range.contains(DateTime(2024, 3, 2)), isFalse);
      final equal = NakedDateRange(
        start: DateTime(2024, 2, 28),
        end: DateTime.utc(2024, 3),
      );
      expect(range, equal);
      expect(range.hashCode, equal.hashCode);
      expect({range, equal}, hasLength(1));
    },
  );

  test(
    'same-day ranges are valid and reversed ordinary construction throws',
    () {
      final date = DateTime(2024, 2, 29);
      expect(NakedDateRange(start: date, end: date).contains(date), isTrue);
      expect(
        () => NakedDateRange(start: DateTime(2024, 3), end: date),
        throwsArgumentError,
      );
    },
  );

  test(
    'civil order crosses year, leap-century and daylight-saving boundaries',
    () {
      for (final dates in [
        (DateTime(1999, 12, 31), DateTime(2000, 3, 1), DateTime(2000, 2, 29)),
        (DateTime(2024, 3, 9), DateTime(2024, 3, 11), DateTime(2024, 3, 10)),
        (DateTime(2024, 11, 2), DateTime(2024, 11, 4), DateTime(2024, 11, 3)),
      ]) {
        expect(
          NakedDateRange(start: dates.$1, end: dates.$2).contains(dates.$3),
          isTrue,
        );
      }
    },
  );

  test('toString prints civil dates without time or zone', () {
    final range = NakedDateRange(
      start: DateTime(2024, 2, 5, 13),
      end: DateTime.utc(2024, 12, 31, 23),
    );
    expect(
      range.toString(),
      'NakedDateRange(start: 2024-02-05, end: 2024-12-31)',
    );
  });

  test('a reversed range names both civil dates', () {
    expect(
      () => NakedDateRange(start: DateTime(2024, 3), end: DateTime(2024, 2)),
      throwsA(
        isA<ArgumentError>().having(
          (e) => e.message,
          'message',
          allOf(contains('2024-03-01'), contains('2024-02-01')),
        ),
      ),
    );
  });
}
