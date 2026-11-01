import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';
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
    // `w-fit` group is, so the group scrolls its row inside the width it is
    // given rather than overflowing it.
    for (final width in [375.0, 1024.0]) {
      for (final detached in [false, true]) {
        testWidgets('group item labels fit $width $mode detached=$detached', (
          tester,
        ) async {
          String? selected = 'long';
          await pumpHeroUiLongContent(
            tester,
            StatefulBuilder(
              builder: (context, setState) => HeroUiToggleButtonGroup<String>(
                selectedValue: selected,
                onChanged: (value) => setState(() => selected = value),
                detached: detached,
                items: const [
                  RemixToggleGroupItem(value: 'long', label: longHeroUiAction),
                  RemixToggleGroupItem(value: 'short', label: 'Aus'),
                ],
              ),
            ),
            width: width,
            mode: mode,
          );
          expect(tester.takeException(), isNull);
          final group = find.byType(HeroUiToggleButtonGroup<String>);
          final viewport = tester.getRect(group);
          expect(viewport.left, greaterThanOrEqualTo(24));
          expect(viewport.right, lessThanOrEqualTo(width - 24));
          expectHeroUiGlyphsInside(tester, longHeroUiAction);
          expect(
            heroUiParagraph(tester, longHeroUiAction).size.height,
            20,
            reason: 'item labels keep one line',
          );
          // Only a group wider than its viewport scrolls; one that fits keeps
          // the size it had without the scroll.
          final position = tester
              .state<ScrollableState>(
                find.descendant(of: group, matching: find.byType(Scrollable)),
              )
              .position;
          expect(position.maxScrollExtent, width == 375 ? greaterThan(0) : 0);
          // Keyboard focus reveals the item it reaches and activates it
          // there: Tab enters at the first item, an arrow moves on.
          await tester.focusWithTab();
          await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
          await tester.pumpAndSettle();
          expectHeroUiTextInside(tester, find.text('Aus'), viewport);
          await tester.sendKeyEvent(LogicalKeyboardKey.space);
          await tester.pumpAndSettle();
          expect(selected, 'short');
          await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
          await tester.pumpAndSettle();
          expect(position.pixels, 0, reason: 'the long item scrolls back');
          await tester.sendKeyEvent(LogicalKeyboardKey.space);
          await tester.pumpAndSettle();
          expect(selected, 'long');
          // A drag reaches the item at the end, where a tap selects it.
          await tester.drag(group, const Offset(-1000, 0));
          await tester.pumpAndSettle();
          expectHeroUiTextInside(tester, find.text('Aus'), viewport);
          await tester.tap(find.text('Aus'));
          await tester.pumpAndSettle();
          expect(selected, 'short');
          expect(tester.takeException(), isNull);
        });
      }
    }
  }
}
