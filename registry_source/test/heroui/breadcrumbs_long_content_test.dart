import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';

import '../helpers/heroui_long_content.dart';

const _labels = [
  'Organization settings',
  'Notification preferences',
  'Email delivery and account updates',
];

void main() {
  setUpAll(loadHeroUiGeist);
  for (final mode in ['light', 'dark']) {
    for (final width in [375.0, 1024.0]) {
      for (final direction in TextDirection.values) {
        for (final oversized in [false, true]) {
          testWidgets('breadcrumbs fit $width $mode $direction '
              'oversized=$oversized', (tester) async {
            final current = oversized ? longHeroUiLabel : _labels.last;
            var navigated = false;
            await pumpHeroUiLongContent(
              tester,
              Directionality(
                textDirection: direction,
                child: HeroUiBreadcrumbs(
                  items: [
                    HeroUiBreadcrumb(
                      _labels[0],
                      onPressed: () => navigated = true,
                    ),
                    HeroUiBreadcrumb(_labels[1], onPressed: () {}),
                    HeroUiBreadcrumb(current),
                  ],
                ),
              ),
              width: width,
              mode: mode,
            );
            expect(tester.takeException(), isNull);
            final trail = tester.getRect(find.byType(HeroUiBreadcrumbs));
            expect(trail.left, greaterThanOrEqualTo(24));
            expect(trail.right, lessThanOrEqualTo(width - 24));
            for (final label in [_labels[0], _labels[1], current]) {
              expectHeroUiTextInside(tester, find.text(label), trail);
              expect(heroUiParagraph(tester, label).didExceedMaxLines, isFalse);
            }
            if (width == 375) {
              expect(
                tester.getRect(find.text(current)).top,
                greaterThan(tester.getRect(find.text(_labels.first)).top),
              );
            } else {
              expect(
                tester.getRect(find.text(current)).top,
                tester.getRect(find.text(_labels.first)).top,
              );
            }
            await tester.tap(find.text(_labels.first));
            expect(navigated, isTrue);
          });
        }
      }
    }
  }
}
