import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';

import '../helpers/test_helpers.dart';

void main() {
  for (final dark in [false, true]) {
    testWidgets(
      '${dark ? "dark" : "light"}: shared slider promotes polished states',
      (tester) async {
        for (final states in <Set<WidgetState>>[
          {},
          {WidgetState.hovered},
          {WidgetState.pressed},
          {WidgetState.disabled, WidgetState.hovered, WidgetState.pressed},
        ]) {
          await resolveInFortalTheme(
            tester,
            (context) {
              final spec = fortalSliderStyle().build(context).spec;
              final thumb = spec.thumb.spec.decoration as BoxDecoration;
              expect(spec.thumbFocusEffects!.outlineOffset, 0);
              if (states.contains(WidgetState.disabled)) {
                expect(
                  thumb.color,
                  (dark ? FortalTokens.gray9 : FortalTokens.gray4).resolve(
                    context,
                  ),
                );
                expect(
                  (spec.track.spec.decoration as BoxDecoration).color,
                  FortalTokens.gray5.resolve(context),
                );
                expect(
                  (spec.range.spec.decoration as BoxDecoration).color,
                  FortalTokens.gray8.resolve(context),
                );
                expect(spec.blendMode, BlendMode.srcOver);
                expect(spec.thumbEffects?.outline.style, BorderStyle.none);
              } else if (states.contains(WidgetState.pressed)) {
                expect(
                  spec.thumbEffects!.outline.color,
                  FortalTokens.accentA6.resolve(context),
                );
                expect(
                  spec.thumbEffects!.outline.width,
                  FortalTokens.space1.resolve(context),
                );
              } else if (states.contains(WidgetState.hovered)) {
                expect(
                  spec.thumbEffects!.outline.color,
                  FortalTokens.accentA7.resolve(context),
                );
                expect(spec.thumbEffects!.outline.width, 2);
              }
              return spec;
            },
            mode: dark ? .dark : .light,
            states: states,
          );
        }
      },
    );
  }
}
