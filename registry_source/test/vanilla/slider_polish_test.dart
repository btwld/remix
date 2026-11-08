import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';

import 'support.dart';

void main() {
  for (final theme in vanillaThemes) {
    testWidgets('${theme.name}: slider rails are legible pills', (
      tester,
    ) async {
      for (final style in [vanillaSliderStyle(), vanillaRangeSliderStyle()]) {
        final spec = (await resolveVanilla(
          tester,
          style,
          theme: theme.data,
        )).spec;
        expect(
          contrastRatio(spec.trackColor, theme.data.background),
          greaterThanOrEqualTo(3),
        );
        expect(decorationOf(spec.track)?.borderRadius, isFullyRounded);
        expect(decorationOf(spec.range)?.borderRadius, isFullyRounded);
      }
    });
    testWidgets('${theme.name}: slider feedback is opaque and distinct', (
      tester,
    ) async {
      for (final style in [vanillaSliderStyle(), vanillaRangeSliderStyle()]) {
        final hover = (await resolveVanilla(
          tester,
          style,
          theme: theme.data,
          states: {WidgetState.hovered},
        )).spec.thumbEffects!;
        final press = (await resolveVanilla(
          tester,
          style,
          theme: theme.data,
          states: {WidgetState.pressed},
        )).spec.thumbEffects!;
        final focus = (await resolveVanilla(
          tester,
          style,
          theme: theme.data,
          states: {WidgetState.focused},
        )).spec.thumbFocusEffects!;
        expect(hover.outline.width, 2);
        expect(press.outline.width, 6);
        expect(focus.outline.width, 3);
        expect(focus.outlineOffset, 2);
        for (final ring in [hover, press, focus]) {
          expect(ring.outline.color.a, 1);
        }
        expect(press.outline.color, isNot(hover.outline.color));
        expect(
          contrastRatio(focus.outline.color, theme.data.background),
          greaterThanOrEqualTo(3),
        );
      }
    });
  }
}
