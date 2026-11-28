import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';

import '../helpers/test_helpers.dart';

void main() {
  for (final dark in [false, true]) {
    testWidgets(
      '${dark ? "dark" : "light"}: control track, ink range and shadowed thumb',
      (tester) async {
        for (final states in <Set<WidgetState>>[
          {},
          {WidgetState.hovered},
          {WidgetState.pressed},
          {WidgetState.disabled},
        ]) {
          await resolveInFortalTheme(
            tester,
            (context) {
              final style = fortalSliderStyle().build(context);
              final spec = style.spec;
              final thumb = spec.thumb.spec.decoration as BoxDecoration;
              final reason = '$dark/$states';
              expect(spec.thumbFocusEffects!.outlineOffset, 0);
              expect(
                (spec.track.spec.decoration as BoxDecoration).color,
                FortalTokens.controlTrack.resolve(context),
                reason: reason,
              );
              expect(
                (spec.range.spec.decoration as BoxDecoration).color,
                FortalTokens.accentRange.resolve(context),
                reason: reason,
              );
              expect(thumb.color, FortalTokens.controlThumb.resolve(context));
              expect(
                thumb.boxShadow,
                FortalTokens.shadowThumb.resolve(context),
              );
              expect(
                (thumb.border! as Border).top.color,
                FortalTokens.accentThumbRing.resolve(context),
              );
              expect(
                spec.thumbEffects?.outline.style ?? BorderStyle.none,
                BorderStyle.none,
              );
              expect(spec.trackWidth, 6);
              expect(
                spec.thumb.spec.transform?.getMaxScaleOnAxis() ?? 1,
                states.contains(WidgetState.pressed) ? closeTo(1.16, 1e-9) : 1,
                reason: reason,
              );
              expect(
                style.widgetModifiers?.whereType<OpacityModifier>().map(
                  (m) => m.opacity,
                ),
                states.contains(WidgetState.disabled)
                    ? [0.5]
                    : anyOf(isNull, isEmpty),
                reason: reason,
              );
              return spec;
            },
            mode: dark ? .dark : .light,
            states: states,
          );
        }
      },
    );
  }

  testWidgets('keys and track presses glide the thumb on the snappy spring', (
    tester,
  ) async {
    await resolveInFortalTheme(tester, (context) {
      final motion = fortalSliderStyle().build(context).spec.thumbMotion;
      expect(motion, isA<SpringAnimationConfig>());
      final spring = (motion! as SpringAnimationConfig).spring;
      expect(spring.stiffness, FortalMotion.springSnappy.stiffness);
      expect(spring.damping, FortalMotion.springSnappy.damping);
      return motion;
    });
  });
}
