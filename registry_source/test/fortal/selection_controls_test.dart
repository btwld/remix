import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';

import '../helpers/contrast.dart';
import '../helpers/test_helpers.dart';

Widget _checkbox({bool highContrast = false, bool autofocus = false}) =>
    FortalCheckbox(
      selected: false,
      onChanged: (_) {},
      highContrast: highContrast,
      autofocus: autofocus,
      label: 'Email',
    );

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

Widget _switch({bool highContrast = false, bool autofocus = false}) =>
    FortalSwitch(
      selected: false,
      onChanged: (_) {},
      highContrast: highContrast,
      autofocus: autofocus,
      label: 'Email',
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

  group('focus ring', () {
    late FocusHighlightStrategy previous;
    setUp(() {
      previous = FocusManager.instance.highlightStrategy;
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
    });
    tearDown(() => FocusManager.instance.highlightStrategy = previous);

    for (final (name, build, root) in <(String, _Build, Finder)>[
      ('checkbox', _checkbox, find.byType(FortalCheckbox)),
      ('radio', _radio, find.byType(FortalRadio<String>)),
      ('switch', _switch, find.byType(FortalSwitch)),
    ]) {
      for (final dark in [false, true]) {
        testWidgets('$name ${dark ? 'dark' : 'light'} draws the focus ring '
            'only while keyboard focused', (tester) async {
          PaintPattern ring(Color color) => paints
            ..something(
              (method, args) =>
                  method == #drawDRRect &&
                  (args[2] as Paint).color.toARGB32() == color.toARGB32(),
            );

          await tester.pumpRemixApp(build(), mode: dark ? .dark : .light);
          await tester.pumpAndSettle();
          final focus = fortalFocusOutline()
              .resolve(tester.element(root))
              .outline
              .color;
          expect(tester.renderObject(root), isNot(ring(focus)));

          await tester.pumpWidget(const SizedBox());
          await tester.pumpRemixApp(
            build(autofocus: true),
            mode: dark ? .dark : .light,
          );
          await tester.pumpAndSettle();
          expect(tester.renderObject(root), ring(focus));
        });
      }
    }
  });
}
