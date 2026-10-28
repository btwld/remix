import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/disclosure.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

Widget _disclosure({
  bool enabled = true,
  bool defaultExpanded = false,
  DisclosureStyler style = const DisclosureStyler.create(),
}) => HeroUiDisclosure(
  style: style,
  enabled: enabled,
  defaultExpanded: defaultExpanded,
  trigger: const Text('Toggle'),
  content: const Text('Body'),
);

DisclosureSpec _spec(WidgetTester tester) =>
    tester.resolvedSpecOf<DisclosureSpec>(find.text('Toggle'));

void main() {
  for (final mode in ['light', 'dark']) {
    testWidgets('the body is inset by p-2 in $mode', (tester) async {
      await tester.pumpHeroUi(_disclosure(defaultExpanded: true), mode: mode);
      await tester.pumpAndSettle();
      final body = heroUiCase('disclosure-open-body', mode: mode);
      final padding = EdgeInsets.fromLTRB(
        body.px('paddingLeft'),
        body.px('paddingTop'),
        body.px('paddingRight'),
        body.px('paddingBottom'),
      );
      expect(_spec(tester).content.spec.padding, padding);

      // One 24px line inside the body's 8px inset makes the 40px panel.
      final inset = find
          .ancestor(of: find.text('Body'), matching: find.byType(Padding))
          .first;
      expect(tester.getSize(find.text('Body')).height, 24);
      expect(
        tester.getSize(inset),
        tester.getSize(find.text('Body')) +
            Offset(padding.horizontal, padding.vertical),
      );
      expect(tester.getSize(inset).height, body.size.height);
    });

    testWidgets('keyboard focus draws the measured ring around the trigger '
        'without moving it in $mode', (tester) async {
      await tester.pumpHeroUi(_disclosure(), mode: mode);
      await tester.pumpAndSettle();
      final before = tester.getRect(find.text('Toggle'));
      expect(_spec(tester).triggerEffects?.isEmpty ?? true, isTrue);
      expect(_spec(tester).trigger.spec.decoration, isNull);

      await tester.focusWithTab();
      expectFocusRing(
        _spec(tester).triggerEffects,
        heroUiCase('disclosure-closed-focus-trigger', mode: mode, state: true),
      );
      expect(_spec(tester).trigger.spec.decoration, isNull);
      expect(tester.getRect(find.text('Toggle')), before);
    });

    testWidgets('disabled dims the trigger and ignores taps in $mode', (
      tester,
    ) async {
      await tester.pumpHeroUi(_disclosure(enabled: false), mode: mode);
      await tester.pumpAndSettle();
      expect(
        tester.opacityAbove(find.text('Toggle')),
        double.parse(
          heroUiCase(
            'disclosure-disabled-trigger',
            mode: mode,
          ).styles['opacity']!,
        ),
      );

      await tester.tap(find.text('Toggle'));
      await tester.pumpAndSettle();
      expect(find.text('Body'), findsNothing);
    });
  }

  testWidgets('the panel animates over 200ms with ease-out-quad', (
    tester,
  ) async {
    await tester.pumpHeroUi(_disclosure());
    final style = tester
        .widget<RemixDisclosure>(find.byType(RemixDisclosure))
        .animationStyle;
    expect(style.duration, const Duration(milliseconds: 200));
    expect(style.reverseDuration, const Duration(milliseconds: 200));
    // --ease-out-quad.
    expect(style.curve, const Cubic(.25, .46, .45, .94));
  });

  testWidgets('tapping the trigger opens and closes the panel', (tester) async {
    await tester.pumpHeroUi(_disclosure());
    expect(find.text('Body'), findsNothing);

    await tester.tap(find.text('Toggle'));
    await tester.pumpAndSettle();
    expect(find.text('Body'), findsOneWidget);

    await tester.tap(find.text('Toggle'));
    await tester.pumpAndSettle();
    expect(find.text('Body'), findsNothing);
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    await tester.pumpHeroUi(
      _disclosure(
        defaultExpanded: true,
        style: DisclosureStyler().content(BoxStyler().padding(.all(20))),
      ),
    );
    await tester.pumpAndSettle();
    expect(_spec(tester).content.spec.padding, const EdgeInsets.all(20));
  });
}
