import 'package:flutter/foundation.dart';

int _compareCivil(DateTime a, DateTime b) {
  final year = a.year.compareTo(b.year);
  if (year != 0) return year;
  final month = a.month.compareTo(b.month);
  return month != 0 ? month : a.day.compareTo(b.day);
}

/// An immutable complete inclusive range of civil Gregorian dates.
///
/// Time and UTC flags are ignored. Endpoints are normalized to local midnight;
/// reversed construction throws in release mode as well as debug mode.
@immutable
class NakedDateRange {
  /// Creates an ordered inclusive range. A same-day range is valid.
  NakedDateRange({required DateTime start, required DateTime end})
    : start = DateTime(start.year, start.month, start.day),
      end = DateTime(end.year, end.month, end.day) {
    if (_compareCivil(this.start, this.end) > 0) {
      throw ArgumentError('start must be on or before end.');
    }
  }

  /// First included civil date.
  final DateTime start;

  /// Last included civil date.
  final DateTime end;

  /// Whether [date]'s civil fields fall within the inclusive endpoints.
  bool contains(DateTime date) =>
      _compareCivil(date, start) >= 0 && _compareCivil(date, end) <= 0;

  @override
  bool operator ==(Object other) =>
      other is NakedDateRange &&
      _compareCivil(start, other.start) == 0 &&
      _compareCivil(end, other.end) == 0;

  @override
  int get hashCode => Object.hash(
    start.year,
    start.month,
    start.day,
    end.year,
    end.month,
    end.day,
  );

  @override
  String toString() => 'NakedDateRange(start: $start, end: $end)';
}
