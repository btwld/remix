import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';

import '../helpers/heroui_long_content.dart';

/// One line of a field's text: `text-base` below 640px, `text-sm` above.
double _lineHeight(double width) => width < 640 ? 24 : 20;

void main() {
  setUpAll(loadHeroUiGeist);
  for (final mode in ['light', 'dark']) {
    for (final width in [375.0, 1024.0]) {
      final line = _lineHeight(width);

      testWidgets('the text field placeholder keeps one line $width $mode', (
        tester,
      ) async {
        await pumpHeroUiLongContent(
          tester,
          HeroUiTextField(
            label: longHeroUiAction,
            hintText: longHeroUiHint,
            helperText: longHeroUiLabel,
          ),
          width: width,
          mode: mode,
        );
        expect(tester.takeException(), isNull);
        final field = find.byType(HeroUiTextField);
        // The placeholder ellipsizes on its single line instead of laying out
        // lines the one-line input then clips.
        expectHeroUiGlyphsInside(tester, longHeroUiHint);
        final hint = heroUiParagraph(tester, longHeroUiHint);
        expect(hint.size.height, line);
        expect(hint.didExceedMaxLines, width == 375);
        expectHeroUiTextInside(
          tester,
          find.text(longHeroUiHint),
          tester.getRect(field),
        );
        // The label and the description own their lines and wrap.
        expectHeroUiGlyphsInside(tester, longHeroUiAction);
        expectHeroUiGlyphsInside(tester, longHeroUiLabel);
        for (final text in [longHeroUiAction, longHeroUiLabel]) {
          expectHeroUiTextInside(
            tester,
            find.text(text),
            tester.getRect(field),
          );
        }
        // Typing dismisses the placeholder without resizing the field.
        final height = tester.getSize(field).height;
        await tester.enterText(find.byType(EditableText), longHeroUiAction);
        await tester.pumpAndSettle();
        expect(tester.getSize(field).height, height);
        expect(tester.takeException(), isNull);
      });

      testWidgets('the input group placeholder keeps one line $width $mode', (
        tester,
      ) async {
        await pumpHeroUiLongContent(
          tester,
          HeroUiInputGroup(
            hintText: longHeroUiHint,
            leading: const Text('https://'),
            trailing: const Text('.de'),
          ),
          width: width,
          mode: mode,
        );
        expect(tester.takeException(), isNull);
        expectHeroUiGlyphsInside(tester, longHeroUiHint);
        final hint = heroUiParagraph(tester, longHeroUiHint);
        expect(hint.size.height, line);
        expect(hint.didExceedMaxLines, width == 375);
        final group = find.byType(HeroUiInputGroup);
        expectHeroUiTextInside(
          tester,
          find.text(longHeroUiHint),
          tester.getRect(group),
        );
        // The prefix and suffix keep their place beside the ellipsis.
        for (final accessory in ['https://', '.de']) {
          expectHeroUiTextInside(
            tester,
            find.text(accessory),
            tester.getRect(group),
          );
        }
      });

      testWidgets('the text area placeholder ellipsizes at two lines '
          '$width $mode', (tester) async {
        await pumpHeroUiLongContent(
          tester,
          // Upstream renders the text area 320px wide, which is also narrow
          // enough for the placeholder to pass two lines at both widths.
          SizedBox(
            width: 320,
            child: HeroUiTextArea(
              label: longHeroUiAction,
              hintText: longHeroUiHint,
            ),
          ),
          width: width,
          mode: mode,
        );
        expect(tester.takeException(), isNull);
        // The text area shows several lines, so its placeholder wraps; it
        // stops at the lines the editor shows rather than painting past them.
        expectHeroUiGlyphsInside(tester, longHeroUiHint);
        final hint = heroUiParagraph(tester, longHeroUiHint);
        expect(hint.size.height, 2 * line);
        expect(hint.didExceedMaxLines, isTrue);
        final area = find.byType(HeroUiTextArea);
        expectHeroUiTextInside(
          tester,
          find.text(longHeroUiHint),
          tester.getRect(area),
        );
        expectHeroUiGlyphsInside(tester, longHeroUiAction);
      });

      // The placeholder follows the editor's own line settings: it may fill
      // the lines the empty editor shows, and no more.
      for (final minLines in [null, 1, 2, 4]) {
        testWidgets('the text area placeholder keeps to its '
            '${minLines ?? 1} line(s) minLines=$minLines $width $mode', (
          tester,
        ) async {
          await pumpHeroUiLongContent(
            tester,
            // Upstream renders the text area 320px wide; the German
            // placeholder passes four lines there at both widths, while the
            // English one fits in two.
            SizedBox(
              width: 320,
              child: Column(
                children: [
                  HeroUiTextArea(
                    minLines: minLines,
                    hintText: longHeroUiParagraphHint,
                  ),
                  HeroUiTextArea(minLines: minLines, hintText: longHeroUiLabel),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: HeroUiTextArea(
                      minLines: minLines,
                      hintText: longHeroUiArabicHint,
                    ),
                  ),
                ],
              ),
            ),
            width: width,
            mode: mode,
          );
          expect(tester.takeException(), isNull);
          final budget = minLines ?? 1;
          final areas = find.byType(HeroUiTextArea);
          expect(areas, findsNWidgets(3));
          for (final (index, hintText) in [
            longHeroUiParagraphHint,
            longHeroUiLabel,
            longHeroUiArabicHint,
          ].indexed) {
            final reason = 'minLines=$minLines "$hintText"';
            // Nothing is laid out past the lines the editor shows, so the
            // ellipsis lands on the last visible line.
            expectHeroUiGlyphsInside(tester, hintText);
            expectHeroUiTextInside(
              tester,
              find.text(hintText),
              tester.getRect(areas.at(index)),
            );
            final wanted = heroUiWantedLines(tester, hintText);
            final shown = wanted < budget ? wanted : budget;
            final hint = heroUiParagraph(tester, hintText);
            expect(hint.size.height, shown * line, reason: reason);
            // A placeholder that fits in the editor keeps every line.
            expect(hint.didExceedMaxLines, wanted > budget, reason: reason);
          }
        });
      }
    }
  }
}
