import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_fonts/remix_ui_fonts.dart';

import '../helpers/heroui.dart';

const _longLabel =
    'Email me important product updates and account notifications';
const _description = 'Product news and account activity.';

void main() {
  setUpAll(() async {
    final loader = FontLoader(RemixFonts.geist);
    for (final weight in ['Regular', 'Medium']) {
      loader.addFont(
        rootBundle.load(
          'packages/remix_ui_fonts/lib/fonts/geist/Geist-$weight.ttf',
        ),
      );
    }
    await loader.load();
  });

  for (final radio in [true, false]) {
    for (final mode in ['light', 'dark']) {
      for (final orientation in Axis.values) {
        for (final width in [375.0, 1024.0]) {
          testWidgets(
            '${radio ? 'radio' : 'switch'} labels fit at ${width.round()}px '
            'in $mode with ${orientation.name} orientation',
            (tester) async {
              const groupKey = ValueKey('group');
              await tester.pumpHeroUi(
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: radio
                      ? HeroUiRadioGroup<String>(
                          key: groupKey,
                          orientation: orientation,
                          groupValue: 'updates',
                          onChanged: (_) {},
                          options: const [
                            HeroUiRadioOption(
                              value: 'updates',
                              label: _longLabel,
                              description: _description,
                            ),
                            HeroUiRadioOption(
                              value: 'summary',
                              label: 'Account summary',
                            ),
                          ],
                        )
                      : HeroUiSwitchGroup(
                          key: groupKey,
                          orientation: orientation,
                          items: [
                            HeroUiSwitchOption(
                              selected: false,
                              label: _longLabel,
                              description: _description,
                              onChanged: (_) {},
                            ),
                            HeroUiSwitchOption(
                              selected: true,
                              label: 'Account summary',
                              onChanged: (_) {},
                            ),
                          ],
                        ),
                ),
                width: width,
                mode: mode,
                theme: mode == 'light'
                    ? const HeroUiThemeData.light(fontFamily: RemixFonts.geist)
                    : const HeroUiThemeData.dark(fontFamily: RemixFonts.geist),
              );
              await tester.pumpAndSettle();

              expect(tester.takeException(), isNull);
              final group = tester.getRect(find.byKey(groupKey));
              final label = tester.getRect(find.text(_longLabel));
              final description = tester.getRect(find.text(_description));
              final nextLabel = tester.getRect(find.text('Account summary'));
              expect(label.left, greaterThanOrEqualTo(group.left));
              expect(label.right, lessThanOrEqualTo(group.right));
              expect(label.height, width == 375 ? greaterThan(20) : 20);
              expect(description.top, greaterThanOrEqualTo(label.bottom + 4));
              if (width == 375 || orientation == Axis.vertical) {
                expect(nextLabel.top, greaterThan(description.bottom));
              }

              // Wrapping text must not shrink the bare control.
              final labeledControl = radio
                  ? find.byType(HeroUiRadio<String>).first
                  : find.byType(HeroUiSwitch).first;
              final control = tester.getSize(
                find
                    .descendant(
                      of: labeledControl,
                      matching: find.byType(StyleSpecBuilder<BoxSpec>),
                    )
                    .first,
              );
              expect(control, radio ? const Size(16, 16) : const Size(40, 20));
            },
          );
        }
      }
    }
  }
}
