/// Civil (date-only) helpers matching how Naked calendars read dates.
///
/// Calendar values are year/month/day fields, not instants. They are local
/// midnight dates, except a day the local zone skipped (such as
/// Pacific/Apia's 2011-12-30), which arrives as a UTC date carrying the same
/// fields. Compare and construct them with these helpers. Instant math such as
/// `toLocal()`, `millisecondsSinceEpoch` or `difference(...).inDays`, and `==`
/// against your own `DateTime(year, month, day)`, can disagree for that
/// carrier.
library;

/// Constructs a civil Gregorian date without losing a skipped local day.
///
/// Overflowing fields normalize like `DateTime` (February 30 is March 1 or 2).
/// UTC normalizes them independently of timezone transitions. Prefer the local
/// representation when it retains those fields; otherwise keep the UTC date as
/// a civil-field carrier, not a scheduling instant.
DateTime civilDate(int year, int month, [int day = 1]) {
  final normalized = DateTime.utc(year, month, day);
  final local = DateTime(normalized.year, normalized.month, normalized.day);
  return compareCivilDates(local, normalized) == 0 ? local : normalized;
}

/// Compares civil fields, ignoring time and the representation's UTC flag.
int compareCivilDates(DateTime a, DateTime b) {
  final year = a.year.compareTo(b.year);
  if (year != 0) return year;
  final month = a.month.compareTo(b.month);
  return month != 0 ? month : a.day.compareTo(b.day);
}

/// Whether [a] and [b] name the same civil day; null equals only null.
bool isSameCivilDate(DateTime? a, DateTime? b) =>
    a == null || b == null ? a == b : compareCivilDates(a, b) == 0;
