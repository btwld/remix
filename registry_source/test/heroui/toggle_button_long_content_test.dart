import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui_long_content.dart';

void main() {
  setUpAll(loadHeroUiGeist);
  for (final mode in ['light', 'dark']) {
    for (final width in [375.0, 1024.0]) {
      for (final icon in [false, true]) {
        testWidgets('toggle label fits $width $mode icon=$icon', (
          tester,
        ) async {
          final semantics = tester.ensureSemantics();
          var selected = false;
          await pumpHeroUiLongContent(
            tester,
            HeroUiToggleButton(
              label: longHeroUiAction,
              icon: icon ? const IconData(0xe000) : null,
              selected: false,
              onChanged: (value) => selected = value,
            ),
            width: width,
            mode: mode,
          );
          expect(tester.takeException(), isNull);
          final toggle = find.byType(HeroUiToggleButton);
          final label = find.text(longHeroUiAction);
          expectHeroUiTextInside(tester, label, tester.getRect(toggle));
          // The label keeps one line inside the fixed height; the overflow
          // ellipsizes rather than spilling clipped lines below it.
          expectHeroUiGlyphsInside(tester, longHeroUiAction);
          final paragraph = heroUiParagraph(tester, longHeroUiAction);
          expect(paragraph.didExceedMaxLines, width == 375);
          expect(paragraph.size.height, 20);
          expect(tester.getSize(toggle).height, width == 375 ? 40 : 36);
          expect(find.bySemanticsLabel(longHeroUiAction), findsOneWidget);
          semantics.dispose();
          await tester.tap(toggle);
          expect(selected, isTrue);
        });
      }

      testWidgets('toggle label fits beside a short one $width $mode', (
        tester,
      ) async {
        await pumpHeroUiLongContent(
          tester,
          Row(
            children: [
              Expanded(
                child: HeroUiToggleButton(
                  label: longHeroUiLabel,
                  selected: true,
                  onChanged: (_) {},
                ),
              ),
              HeroUiToggleButton(
                label: 'Aus',
                selected: false,
                onChanged: (_) {},
              ),
            ],
          ),
          width: width,
          mode: mode,
        );
        expect(tester.takeException(), isNull);
        expectHeroUiGlyphsInside(tester, longHeroUiLabel);
        expectHeroUiGlyphsInside(tester, 'Aus');
      });
    }

    // A joined group of long labels is wider than a phone, as upstream's
    // `w-fit` group is, so the one-line policy is asserted at desktop width.
    for (final detached in [false, true]) {
      testWidgets('group item labels fit 1024 $mode detached=$detached', (
        tester,
      ) async {
        await pumpHeroUiLongContent(
          tester,
          HeroUiToggleButtonGroup<String>(
            selectedValue: 'long',
            onChanged: (_) {},
            detached: detached,
            items: const [
              RemixToggleGroupItem(value: 'long', label: longHeroUiAction),
              RemixToggleGroupItem(value: 'short', label: 'Aus'),
            ],
          ),
          width: 1024,
          mode: mode,
        );
        expect(tester.takeException(), isNull);
        final group = find.byType(HeroUiToggleButtonGroup<String>);
        expectHeroUiTextInside(
          tester,
          find.text(longHeroUiAction),
          tester.getRect(group),
        );
        expectHeroUiGlyphsInside(tester, longHeroUiAction);
        expect(
          heroUiParagraph(tester, longHeroUiAction).size.height,
          20,
          reason: 'item labels keep one line',
        );
      });
    }
  }
}
