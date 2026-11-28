import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';

import '../helpers/contrast.dart';
import '../helpers/test_helpers.dart';

Color _textColor(WidgetTester tester, String text) => tester
    .renderObject<RenderParagraph>(find.text(text).first)
    .text
    .style!
    .color!;

BoxDecoration _trigger(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(
      find.descendant(
        of: find.byType(RemixButton),
        matching: find.byType(DecoratedBox),
      ),
    )
    .map((box) => box.decoration)
    .whereType<BoxDecoration>()
    .firstWhere((decoration) => decoration.border != null);

void main() {
  final pickers = <(String, Widget, String?)>[
    (
      'date picker',
      FortalDatePicker(
        value: null,
        firstDate: DateTime(2026),
        lastDate: DateTime(2027),
        onChanged: (_) {},
      ),
      'Select date',
    ),
    (
      'date range picker',
      FortalDateRangePicker(
        value: null,
        firstDate: DateTime(2026),
        lastDate: DateTime(2027),
        onChanged: (_) {},
      ),
      null,
    ),
  ];

  for (final (name, picker, placeholder) in pickers) {
    for (final dark in [false, true]) {
      testWidgets('$name ${dark ? 'dark' : 'light'} keeps its muted look and '
          'lifts text and frame under high contrast', (tester) async {
        for (final accent in FortalAccentColor.values) {
          for (final highContrast in [false, true]) {
            await tester.pumpWidget(const SizedBox());
            await tester.pumpRemixApp(
              picker,
              accent: accent,
              mode: dark ? .dark : .light,
              highContrast: highContrast,
            );
            await tester.pumpAndSettle();
            final colors = resolveFortalTokens(
              FortalTheme.of(tester.element(find.byType(RemixButton))),
            );
            final reason = '$accent highContrast=$highContrast';
            final rest = _trigger(tester);

            final mouse = await tester.createGesture(
              kind: PointerDeviceKind.mouse,
            );
            await mouse.addPointer(location: Offset.zero);
            await mouse.moveTo(tester.getCenter(find.byType(RemixButton)));
            await tester.pumpAndSettle();
            final hover = _trigger(tester);
            await mouse.removePointer();

            await tester.tap(find.byType(RemixButton));
            await tester.pumpAndSettle();
            final footer = _textColor(tester, 'No date selected');
            final placeholderColor = placeholder == null
                ? null
                : _textColor(tester, placeholder);

            if (!highContrast) {
              expect(footer, colors.gray.scale.step(10), reason: reason);
              expect(
                (rest.border! as Border).top.color,
                colors.gray.scale.step(7),
                reason: reason,
              );
              if (placeholderColor != null) {
                expect(
                  placeholderColor,
                  colors.gray.scale.step(10),
                  reason: reason,
                );
              }
              continue;
            }
            expect(
              contrastRatio(footer, colors.colorPanelSolid),
              greaterThanOrEqualTo(4.5),
              reason: '$reason footer',
            );
            for (final (state, decoration) in [
              ('rest', rest),
              ('hover', hover),
            ]) {
              final fill = Color.alphaBlend(
                decoration.color!,
                colors.colorBackground,
              );
              final frame = (decoration.border! as Border).top.color;
              for (final against in [fill, colors.colorBackground]) {
                expect(
                  contrastRatio(frame, against),
                  greaterThanOrEqualTo(3),
                  reason: '$reason $state frame',
                );
              }
              if (placeholderColor != null && state == 'rest') {
                expect(
                  contrastRatio(placeholderColor, fill),
                  greaterThanOrEqualTo(4.5),
                  reason: '$reason placeholder',
                );
              }
            }
          }
        }
      });
    }
  }
}
