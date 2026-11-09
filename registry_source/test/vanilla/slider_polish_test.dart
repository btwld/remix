import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';

import 'support.dart';

void main() {
  test('identical slider recipe arguments preserve style equality', () {
    for (final surface in <Color?>[null, const Color(0xFFE1E7F6)]) {
      expect(
        vanillaSliderStyle(surfaceColor: surface),
        vanillaSliderStyle(surfaceColor: surface),
      );
      expect(
        vanillaRangeSliderStyle(surfaceColor: surface),
        vanillaRangeSliderStyle(surfaceColor: surface),
      );
    }
  });
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
        expect(
          contrastRatio(spec.trackColor, spec.rangeColor),
          greaterThanOrEqualTo(3),
        );
        if (theme.data.brightness == Brightness.dark) {
          final border = decorationOf(spec.thumb)!.border! as Border;
          expect(
            contrastRatio(border.top.color, const Color(0xFFFFFFFF)),
            greaterThanOrEqualTo(7),
          );
        }
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
        expect(focus.outlineOffset, 0);
        expect(focus.outline.color, isNot(theme.data.mutedForeground));
        expect(
          contrastRatio(hover.outline.color, theme.data.background),
          greaterThanOrEqualTo(1.5),
        );
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
