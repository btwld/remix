import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui_long_content.dart';

void main() {
  setUpAll(loadHeroUiGeist);
  for (final mode in ['light', 'dark']) {
    for (final width in [375.0, 1024.0]) {
      for (final fullWidth in [false, true]) {
        for (final icons in [false, true]) {
          testWidgets('button label fits $width $mode '
              'fullWidth=$fullWidth icons=$icons', (tester) async {
            final semantics = tester.ensureSemantics();
            var pressed = false;
            await pumpHeroUiLongContent(
              tester,
              HeroUiButton(
                label: longHeroUiAction,
                fullWidth: fullWidth,
                leadingIcon: icons ? const IconData(0xe000) : null,
                trailingIcon: icons ? const IconData(0xe001) : null,
                onPressed: () => pressed = true,
              ),
              width: width,
              mode: mode,
            );
            expect(tester.takeException(), isNull);
            final button = find.byType(HeroUiButton);
            expectHeroUiTextInside(
              tester,
              find.text(longHeroUiAction),
              tester.getRect(button),
            );
            expect(
              heroUiParagraph(tester, longHeroUiAction).didExceedMaxLines,
              width == 375,
            );
            expect(tester.getSize(button).height, width == 375 ? 40 : 36);
            expect(find.bySemanticsLabel(longHeroUiAction), findsOneWidget);
            semantics.dispose();
            await tester.tap(button);
            expect(pressed, isTrue);
          });
        }

        testWidgets('joined button labels fit $width $mode '
            'fullWidth=$fullWidth', (tester) async {
          await pumpHeroUiLongContent(
            tester,
            HeroUiButtonGroup(
              fullWidth: fullWidth,
              buttons: [
                for (final label in [longHeroUiAction, longHeroUiLabel])
                  (context, style) =>
                      RemixButton(label: label, style: style, onPressed: () {}),
              ],
            ),
            width: width,
            mode: mode,
          );
          expect(tester.takeException(), isNull);
          final group = tester.getRect(find.byType(HeroUiButtonGroup));
          for (final label in [longHeroUiAction, longHeroUiLabel]) {
            expectHeroUiTextInside(tester, find.text(label), group);
          }
        });
      }
    }
  }
}
