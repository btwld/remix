import 'package:flutter_test/flutter_test.dart';

import 'support.dart';
import 'vanilla_spec.dart';

/// Holds every Vanilla recipe to `registry_source/specs/vanilla.md`.
///
/// Each target resolves one recipe under each shipped theme and compares one
/// property with its reference value.
void main() {
  test('target names are unique per component', () {
    final names = [
      for (final target in vanillaSpecTargets)
        '${target.component}: ${target.property}',
    ];

    expect(names.toSet(), hasLength(names.length));
  });

  for (final target in vanillaSpecTargets) {
    group('${target.component}: ${target.property}', () {
      for (final theme in vanillaThemes) {
        testWidgets(theme.name, (tester) async {
          expect(
            _unpacked(await target.actual(tester, theme.data)),
            _unpacked(target.expected(theme.data)),
            reason: 'reference: ${target.source}',
          );
        });
      }
    });
  }
}

/// A record's fields as a list, so `expect` compares them deeply and applies
/// any matcher among them; a record compares its fields with `==`, which
/// holds for neither a list of shadows nor a matcher.
Object? _unpacked(Object? value) => switch (value) {
  (final a, final b) => [a, b],
  (final a, final b, final c) => [a, b, c],
  (final a, final b, final c, final d) => [a, b, c, d],
  (final a, final b, final c, final d, final e) => [a, b, c, d, e],
  (final a, final b, final c, final d, final e, final f) => [a, b, c, d, e, f],
  _ => value,
};
