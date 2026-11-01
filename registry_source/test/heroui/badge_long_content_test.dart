import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui_long_content.dart';

void main() {
  setUpAll(loadHeroUiGeist);
  for (final mode in ['light', 'dark']) {
    for (final width in [375.0, 1024.0]) {
      for (final anchorWidth in [64.0, double.infinity]) {
        testWidgets('long badge $mode $width anchor $anchorWidth', (
          tester,
        ) async {
          for (final size in HeroUiBadgeSize.values) {
            for (final placement in HeroUiBadgePlacement.values) {
              const anchorKey = Key('anchor');
              await pumpHeroUiLongContent(
                tester,
                HeroUiBadge(
                  label: longHeroUiLabel,
                  size: size,
                  placement: placement,
                  child: SizedBox(
                    key: anchorKey,
                    width: anchorWidth,
                    height: 64,
                  ),
                ),
                width: width,
                mode: mode,
              );
              expect(tester.takeException(), isNull);
              final badge = tester.getRect(find.byType(RemixBadge));
              final anchor = tester.getRect(find.byKey(anchorKey));
              expect(badge.left, greaterThanOrEqualTo(anchor.left));
              expect(badge.right, lessThanOrEqualTo(anchor.right));
              expect(badge.height, switch (size) {
                HeroUiBadgeSize.sm => 16,
                HeroUiBadgeSize.md => 28,
                HeroUiBadgeSize.lg => 32,
              });
              expectHeroUiTextInside(tester, find.text(longHeroUiLabel), badge);
              final paragraph = heroUiParagraph(tester, longHeroUiLabel);
              expect(paragraph.maxLines, 1);
              if (anchorWidth == 64 || width == 1024) {
                expect(paragraph.didExceedMaxLines, anchorWidth == 64);
              }
              final semantics = tester.ensureSemantics();
              expect(find.bySemanticsLabel(longHeroUiLabel), findsOneWidget);
              semantics.dispose();
            }
          }
        });
      }
    }
  }
}
