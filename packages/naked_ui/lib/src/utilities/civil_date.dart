/// Constructs a civil Gregorian date without losing a skipped local day.
///
/// UTC normalizes overflowing fields independently of timezone transitions.
/// Prefer the local representation when it retains those fields; otherwise
/// keep the UTC date as a civil-field carrier, not a scheduling instant.
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
