import 'package:flutter/foundation.dart';

import 'utilities/civil_date.dart';

/// An immutable complete inclusive range of civil Gregorian dates.
///
/// Time and UTC flags are ignored. Endpoints use local civil dates where
/// representable, with a UTC date-only fallback for skipped local days. These
/// fields are not scheduling instants; do not convert their timezones.
/// Reversed construction throws in release mode as well as debug mode.
@immutable
class NakedDateRange {
  /// Creates an ordered inclusive range. A same-day range is valid.
  NakedDateRange({required DateTime start, required DateTime end})
    : start = civilDate(start.year, start.month, start.day),
      end = civilDate(end.year, end.month, end.day) {
    if (compareCivilDates(this.start, this.end) > 0) {
      throw ArgumentError(
        'start (${_civil(this.start)}) must be on or before '
        'end (${_civil(this.end)}).',
      );
    }
  }

  /// First included civil date.
  final DateTime start;

  /// Last included civil date.
  final DateTime end;

  /// Whether [date]'s civil fields fall within the inclusive endpoints.
  bool contains(DateTime date) =>
      compareCivilDates(date, start) >= 0 && compareCivilDates(date, end) <= 0;

  @override
  bool operator ==(Object other) =>
      other is NakedDateRange &&
      compareCivilDates(start, other.start) == 0 &&
      compareCivilDates(end, other.end) == 0;

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
  String toString() =>
      'NakedDateRange(start: ${_civil(start)}, end: ${_civil(end)})';
}

// ISO-style year-month-day, without the time or zone a DateTime would print.
String _civil(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';
