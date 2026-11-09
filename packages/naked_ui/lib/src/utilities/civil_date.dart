/// Civil (date-only) helpers matching how Naked calendars read dates.
///
/// Calendar values are year/month/day fields, not instants. They are local
/// dates, normally at 00:00 (where daylight saving skips midnight, at the first
/// time that day has), except a day the local zone skipped entirely (such as
/// Pacific/Apia's 2011-12-30), which arrives as a UTC date carrying the same
/// fields. Compare and construct them with these helpers. Instant math such as
/// `toLocal()`, `millisecondsSinceEpoch` or `difference(...).inDays`, and `==`
/// against your own `DateTime(year, month, day)`, can disagree for that
/// carrier.
library;

/// Constructs a civil Gregorian date without losing a skipped local day.
///
/// Prefer this to hand-building `DateTime.utc(year, month, day)`. It returns
/// the local `DateTime(year, month, day)` whenever the local zone keeps those
/// fields, so the result is `==` to the dates the calendar returns, and falls
/// back to a UTC date only for a day the zone skipped.
///
/// Overflowing fields normalize like `DateTime` (February 30 is March 1 or 2).
/// UTC normalizes them independently of timezone transitions. The UTC fallback
/// is a civil-field carrier, not a scheduling instant.
DateTime civilDate(int year, int month, [int day = 1]) {
  final normalized = DateTime.utc(year, month, day);
  final local = DateTime(normalized.year, normalized.month, normalized.day);
  return compareCivilDates(local, normalized) == 0 ? local : normalized;
}

/// Compares civil fields, ignoring time and the representation's UTC flag.
///
/// The fields are read as stored, with no timezone conversion, so the flag
/// never changes which day a value names. The fields themselves depend on how
/// the value was made: `DateTime.now().toUtc()` supplies UTC fields, which can
/// be the day before or after the local date.
int compareCivilDates(DateTime a, DateTime b) {
  final year = a.year.compareTo(b.year);
  if (year != 0) return year;
  final month = a.month.compareTo(b.month);
  return month != 0 ? month : a.day.compareTo(b.day);
}

/// Whether [a] and [b] name the same civil day; null equals only null.
bool isSameCivilDate(DateTime? a, DateTime? b) =>
    a == null || b == null ? a == b : compareCivilDates(a, b) == 0;
