import 'dart:math' as math;

/// The "Did you mean" sentence for [input] among [candidates], or null when
/// none is close.
///
/// Close means an edit distance of at most 2, or a candidate that starts with
/// an input of three or more characters, so `data` finds `data_table`. At most
/// three names, nearest first, ties alphabetical.
String? didYouMean(String input, Iterable<String> candidates) {
  final close =
      [
        for (final candidate in candidates.toSet())
          if (_optimalStringAlignmentDistance(input, candidate)
              case final distance
              when distance <= 2 ||
                  (input.length >= 3 && candidate.startsWith(input)))
            (distance: distance, name: candidate),
      ]..sort((a, b) {
        final byDistance = a.distance.compareTo(b.distance);
        return byDistance != 0 ? byDistance : a.name.compareTo(b.name);
      });
  final names = [for (final match in close.take(3)) match.name];
  return switch (names) {
    [] => null,
    [final only] => 'Did you mean $only?',
    [final first, final second] => 'Did you mean $first or $second?',
    [...final rest, final last] => 'Did you mean ${rest.join(', ')}, or $last?',
  };
}

int _optimalStringAlignmentDistance(String a, String b) {
  final rows = List.generate(
    a.length + 1,
    (i) => List.generate(b.length + 1, (j) => i == 0 ? j : (j == 0 ? i : 0)),
  );
  for (var i = 1; i <= a.length; i++) {
    for (var j = 1; j <= b.length; j++) {
      final cost = a[i - 1] == b[j - 1] ? 0 : 1;
      var best = math.min(
        math.min(rows[i - 1][j] + 1, rows[i][j - 1] + 1),
        rows[i - 1][j - 1] + cost,
      );
      if (i > 1 && j > 1 && a[i - 1] == b[j - 2] && a[i - 2] == b[j - 1]) {
        best = math.min(best, rows[i - 2][j - 2] + 1);
      }
      rows[i][j] = best;
    }
  }
  return rows[a.length][b.length];
}
