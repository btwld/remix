import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';

import '../helpers/contrast.dart';
import '../helpers/test_helpers.dart';

Widget _checkboxItem({bool highContrast = false, bool autofocus = false}) =>
    RemixCheckboxGroup<String>(
      values: const {},
      onChanged: (_) {},
      child: FortalCheckboxGroupItem<String>(
        value: 'a',
        highContrast: highContrast,
        autofocus: autofocus,
        label: 'Email',
        description: 'Details',
      ),
    );

Widget _radio({bool highContrast = false, bool autofocus = false}) =>
    RemixRadioGroup<String>(
      groupValue: 'a',
      onChanged: (_) {},
      child: FortalRadio<String>(
        value: 'b',
        highContrast: highContrast,
        autofocus: autofocus,
        label: 'Email',
        description: 'Details',
      ),
    );

typedef _Build = Widget Function({bool highContrast, bool autofocus});

void main() {
  group('descriptions', () {
    for (final (name, build) in <(String, _Build)>[
      ('checkbox', _checkboxItem),
      ('radio', _radio),
    ]) {
      for (final dark in [false, true]) {
        testWidgets(
          '$name ${dark ? 'dark' : 'light'} description keeps gray 10 and '
          'reads at 4.5:1 under high contrast',
          (tester) async {
            for (final accent in FortalAccentColor.values) {
              for (final (:themeHc, :familyHc) in [
                (themeHc: false, familyHc: false),
                (themeHc: true, familyHc: false),
                (themeHc: false, familyHc: true),
              ]) {
                await tester.pumpRemixApp(
                  build(highContrast: familyHc),
                  accent: accent,
                  mode: dark ? .dark : .light,
                  highContrast: themeHc,
                );
                await tester.pumpAndSettle();
                final colors = resolveFortalTokens(
                  FortalTheme.of(tester.element(find.text('Details'))),
                );
                final color = tester
                    .renderObject<RenderParagraph>(find.text('Details'))
                    .text
                    .style!
                    .color!;
                final reason = '$accent theme=$themeHc family=$familyHc';
                if (!themeHc && !familyHc) {
                  expect(color, colors.gray.scale.step(10), reason: reason);
                  continue;
                }
                for (final page in [
                  colors.colorBackground,
                  colors.colorPanelSolid,
                ]) {
                  expect(
                    contrastRatio(color, page),
                    greaterThanOrEqualTo(4.5),
                    reason: reason,
                  );
                }
              }
            }
          },
        );
      }
    }
  });
}
