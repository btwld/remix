import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';

import '../../helpers/contrast.dart';
import '../../helpers/test_helpers.dart';

void main() {
  for (final accent in FortalAccentColor.values) {
    for (final dark in [false, true]) {
      testWidgets(
        '${accent.name}/${dark ? 'dark' : 'light'} select trigger content contrast',
        (tester) async {
          for (final variant in FortalSelectVariant.values) {
            for (final (:themeHc, :familyHc) in [
              (themeHc: false, familyHc: false),
              (themeHc: true, familyHc: false),
              (themeHc: false, familyHc: true),
            ]) {
              for (final states in [
                <WidgetState>{},
                {WidgetState.hovered},
                {WidgetState.selected},
              ]) {
                late SelectTriggerSpec trigger;
                late FortalThemeColors colors;
                await tester.pumpRemixApp(
                  WidgetStateStyleOverride(
                    states: states,
                    child: Builder(
                      builder: (context) {
                        colors = resolveFortalTokens(FortalTheme.of(context));
                        trigger = fortalSelectStyle(
                          variant: variant,
                          highContrast: familyHc,
                        ).build(context).spec.trigger.spec;
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  accent: accent,
                  mode: dark ? .dark : .light,
                  highContrast: themeHc,
                );
                final reason =
                    '$accent/$dark/$variant/theme=$themeHc/family=$familyHc/'
                    '$states';
                final placeholder = trigger.placeholder.spec.style!.color!;
                final chevron = trigger.indicator.spec.color!;
                if (!themeHc && !familyHc) {
                  // The default look keeps gray 10.
                  expect(
                    placeholder,
                    colors.gray.scale.step(10),
                    reason: reason,
                  );
                  expect(chevron, colors.gray.scale.step(10), reason: reason);
                  continue;
                }
                expect(placeholder, colors.gray.scale.step(11), reason: reason);
                expect(chevron, colors.gray.scale.step(11), reason: reason);
                final fill =
                    (trigger.container.spec.box?.spec.decoration
                            as BoxDecoration?)
                        ?.color ??
                    const Color(0x00000000);
                for (final panel in [
                  colors.colorBackground,
                  colors.colorPanelSolid,
                ]) {
                  expect(
                    compositedContrast(
                      foreground: placeholder,
                      fill: fill,
                      panel: panel,
                    ),
                    greaterThanOrEqualTo(4.5),
                    reason: '$reason placeholder',
                  );
                  expect(
                    compositedContrast(
                      foreground: chevron,
                      fill: fill,
                      panel: panel,
                    ),
                    greaterThanOrEqualTo(3),
                    reason: '$reason chevron',
                  );
                }
              }
            }
          }
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
