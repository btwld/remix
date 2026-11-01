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
      for (final variant in HeroUiTabsVariant.values) {
        for (final direction in TextDirection.values) {
          testWidgets('long tabs $variant $direction $mode $width', (
            tester,
          ) async {
            String? selected;
            final changes = <String>[];
            await pumpHeroUiLongContent(
              tester,
              Directionality(
                textDirection: direction,
                child: RemixTabs(
                  selectedTabId: 'one',
                  onChanged: (value) {
                    selected = value;
                    changes.add(value);
                  },
                  child: HeroUiTabBar(
                    variant: variant,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HeroUiTab(
                          variant: variant,
                          tabId: 'one',
                          label: longHeroUiLabel,
                        ),
                        HeroUiTab(
                          variant: variant,
                          tabId: 'two',
                          label: 'Security and account management',
                        ),
                        HeroUiTab(
                          variant: variant,
                          tabId: 'three',
                          label: 'Billing and payment history',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              width: width,
              mode: mode,
            );
            expect(tester.takeException(), isNull);
            final scroll = find.descendant(
              of: find.byType(HeroUiTabBar),
              matching: find.byType(Scrollable),
            );
            expect(scroll, findsOneWidget);
            final position = tester.state<ScrollableState>(scroll).position;
            expect(position.maxScrollExtent, width == 375 ? greaterThan(0) : 0);
            final viewport = tester.getRect(find.byType(HeroUiTabBar));
            expect(viewport.left, greaterThanOrEqualTo(24));
            expect(viewport.right, lessThanOrEqualTo(width - 24));
            for (final tab in find.byType(HeroUiTab).evaluate()) {
              expect(tester.getSize(find.byWidget(tab.widget)).height, 32);
            }
            await tester.drag(
              find.byType(HeroUiTabBar),
              Offset(direction == TextDirection.ltr ? -1000 : 1000, 0),
            );
            await tester.pumpAndSettle();
            final last = find.text('Billing and payment history');
            expectHeroUiTextInside(tester, last, viewport);
            await tester.tap(last);
            await tester.pumpAndSettle();
            expect(selected, 'three');
            position.jumpTo(0);
            await tester.pumpAndSettle();
            await tester.focusWithTab();
            await tester.sendKeyEvent(LogicalKeyboardKey.end);
            await tester.pumpAndSettle();
            expectHeroUiTextInside(tester, last, viewport);
            // Arrows follow the reading direction, so the key pointing at the
            // neighbouring tab reaches it in both directions.
            await tester.sendKeyEvent(LogicalKeyboardKey.home);
            await tester.pumpAndSettle();
            changes.clear();
            final [
              towardsNext,
              towardsPrevious,
            ] = direction == TextDirection.ltr
                ? [LogicalKeyboardKey.arrowRight, LogicalKeyboardKey.arrowLeft]
                : [LogicalKeyboardKey.arrowLeft, LogicalKeyboardKey.arrowRight];
            await tester.sendKeyEvent(towardsNext);
            await tester.pumpAndSettle();
            expect(changes, ['two']);
            await tester.sendKeyEvent(towardsNext);
            await tester.pumpAndSettle();
            expect(changes, ['two', 'three']);
            await tester.sendKeyEvent(towardsPrevious);
            await tester.pumpAndSettle();
            expect(changes, ['two', 'three', 'two']);
            expect(tester.takeException(), isNull);
          });
        }
      }
    }
  }
}
