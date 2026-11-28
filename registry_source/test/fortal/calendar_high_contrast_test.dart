import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';

import '../helpers/contrast.dart';
import '../helpers/test_helpers.dart';

Color _textColor(WidgetTester tester, String text) => tester
    .renderObject<RenderParagraph>(find.text(text).first)
    .text
    .style!
    .color!;

void main() {
  for (final dark in [false, true]) {
    testWidgets('${dark ? 'dark' : 'light'} calendar weekdays and selected '
        'disc keep the default look and lift under high contrast', (
      tester,
    ) async {
      for (final accent in FortalAccentColor.values) {
        for (final highContrast in [false, true]) {
          await tester.pumpRemixApp(
            FortalCalendar(
              value: DateTime(2026, 11, 12),
              firstDate: DateTime(2026),
              lastDate: DateTime(2027),
              onChanged: (_) {},
            ),
            accent: accent,
            mode: dark ? .dark : .light,
            highContrast: highContrast,
          );
          await tester.pumpAndSettle();
          final colors = resolveFortalTokens(
            FortalTheme.of(tester.element(find.byType(FortalCalendar))),
          );
          final weekday = _textColor(tester, 'Mo');
          final disc =
              (tester
                          .widget<DecoratedBox>(
                            find.descendant(
                              of: find.byType(AnimatedPositioned),
                              matching: find.byType(DecoratedBox),
                            ),
                          )
                          .decoration
                      as ShapeDecoration)
                  .color!;
          final numeral = _textColor(tester, '12');
          final reason = '$accent highContrast=$highContrast';

          if (!highContrast) {
            expect(weekday, colors.gray.scale.step(10), reason: reason);
            expect(disc, colors.accent.scale.step(9), reason: reason);
            continue;
          }
          for (final page in [colors.colorBackground, colors.colorPanelSolid]) {
            expect(
              contrastRatio(weekday, page),
              greaterThanOrEqualTo(4.5),
              reason: '$reason weekday',
            );
            expect(
              contrastRatio(disc, page),
              greaterThanOrEqualTo(3),
              reason: '$reason disc',
            );
          }
          expect(
            contrastRatio(numeral, disc),
            greaterThanOrEqualTo(4.5),
            reason: '$reason numeral',
          );
        }
      }
    });
  }
}
