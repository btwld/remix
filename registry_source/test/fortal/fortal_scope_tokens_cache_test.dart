import 'package:flutter/widgets.dart' show Color;
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/src/fortal/theme/theme_data.dart'
    show buildFortalScopeTokens;

void main() {
  test('equal themes share one token map', () {
    final first = buildFortalScopeTokens(const FortalThemeData.light());
    final again = buildFortalScopeTokens(
      const FortalThemeData.light().copyWith(),
    );

    // Not only equal: the same instance, so a nested scope that rebuilds
    // neither resolves its roles again nor makes Mix compare 250 entries.
    expect(identical(first, again), isTrue);
  });

  test('a different theme gets its own map', () {
    final light = buildFortalScopeTokens(const FortalThemeData.light());
    final dark = buildFortalScopeTokens(const FortalThemeData.dark());
    final mar = buildFortalScopeTokens(
      const FortalThemeData.light(accent: .mar),
    );
    final large = buildFortalScopeTokens(
      const FortalThemeData.light(radius: .large),
    );

    expect(identical(light, dark), isFalse);
    expect(light[FortalTokens.gray12], isNot(dark[FortalTokens.gray12]));
    expect(light[FortalTokens.accent9], isNot(mar[FortalTokens.accent9]));
    expect(light[FortalTokens.radius4], isNot(large[FortalTokens.radius4]));
  });

  test('the shared map cannot be modified', () {
    final tokens = buildFortalScopeTokens(const FortalThemeData.light());

    expect(
      () => tokens[FortalTokens.gray12] = const Color(0xFF000000),
      throwsUnsupportedError,
    );
  });

  test('stays correct past the number of themes it keeps', () {
    final expected = buildFortalScopeTokens(
      const FortalThemeData.dark(accent: .caju),
    )[FortalTokens.accent9];

    // More distinct themes than the cache holds: every accent, appearance,
    // radius and scaling.
    for (final accent in FortalAccentColor.values) {
      for (final radius in FortalRadius.values) {
        for (final scaling in FortalScaling.values) {
          for (final theme in [
            FortalThemeData.light(
              accent: accent,
              radius: radius,
              scaling: scaling,
            ),
            FortalThemeData.dark(
              accent: accent,
              radius: radius,
              scaling: scaling,
            ),
          ]) {
            expect(
              buildFortalScopeTokens(theme)[FortalTokens.accent9],
              isNotNull,
            );
          }
        }
      }
    }

    expect(
      buildFortalScopeTokens(
        const FortalThemeData.dark(accent: .caju),
      )[FortalTokens.accent9],
      expected,
    );
  });
}
