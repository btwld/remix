import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';

import '../helpers/heroui.dart';

void main() {
  for (final mode in ['light', 'dark']) {
    testWidgets(
      'a callback-disabled radio group dims its composed text in $mode',
      (tester) async {
        HeroUiRadioGroup<String> group({bool interactive = false}) =>
            HeroUiRadioGroup<String>(
              groupValue: 'a',
              label: 'Radio group',
              options: const [
                HeroUiRadioOption(
                  value: 'a',
                  label: 'Alpha',
                  description: 'Details',
                ),
              ],
              onChanged: interactive ? (_) {} : null,
            );

        await tester.pumpHeroUi(group(), mode: mode);
        expect(tester.opacityAbove(find.text('Radio group')), .5);
        expect(tester.opacityAbove(find.text('Details')), .25);

        await tester.pumpHeroUi(group(interactive: true), mode: mode);
        expect(tester.opacityAbove(find.text('Radio group')), 1);
        expect(tester.opacityAbove(find.text('Details')), 1);
      },
    );

    testWidgets('a callback-disabled checkbox group dims its label in $mode', (
      tester,
    ) async {
      HeroUiCheckboxGroup<String> group({bool interactive = false}) =>
          HeroUiCheckboxGroup<String>(
            values: const {},
            label: 'Checkbox group',
            options: const [HeroUiCheckboxOption(value: 'a', label: 'Alpha')],
            onChanged: interactive ? (_) {} : null,
          );

      await tester.pumpHeroUi(group(), mode: mode);
      expect(tester.opacityAbove(find.text('Checkbox group')), .5);

      await tester.pumpHeroUi(group(interactive: true), mode: mode);
      expect(tester.opacityAbove(find.text('Checkbox group')), 1);
    });

    testWidgets('a callback-disabled switch dims its description in $mode', (
      tester,
    ) async {
      HeroUiSwitchGroup group({bool interactive = false}) => HeroUiSwitchGroup(
        items: [
          HeroUiSwitchOption(
            selected: false,
            label: 'Switch',
            description: 'Details',
            onChanged: interactive ? (_) {} : null,
          ),
        ],
      );

      await tester.pumpHeroUi(group(), mode: mode);
      expect(tester.opacityAbove(find.text('Details')), .25);

      await tester.pumpHeroUi(group(interactive: true), mode: mode);
      expect(tester.opacityAbove(find.text('Details')), 1);
    });
  }
}
