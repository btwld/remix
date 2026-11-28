import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/rendering/remix_box_effects.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('RadioSpec.keepIndicatorMounted', () {
    Future<void> pump(
      WidgetTester tester,
      String? groupValue,
      RadioStyler style,
    ) => tester.pumpRemixApp(
      RemixRadioGroup<String>(
        groupValue: groupValue,
        onChanged: (_) {},
        child: RemixRadio<String>(
          semanticLabel: 'Option',
          value: 'a',
          style: style,
        ),
      ),
    );

    final container = find
        .descendant(
          of: find.byType(RemixBoxAdapter),
          matching: find.byType(Box),
        )
        .first;
    final indicator = find.descendant(
      of: container,
      matching: find.byType(Box),
    );

    testWidgets('keeps one indicator element across selection changes', (
      tester,
    ) async {
      final style = RadioStyler()
          .keepIndicatorMounted(true)
          .indicator(BoxStyler().size(4, 4))
          .onSelected(RadioStyler().indicator(BoxStyler().size(8, 8)));

      await pump(tester, null, style);
      final unselected = tester.element(indicator);
      expect(tester.getSize(indicator), const Size(4, 4));

      await pump(tester, 'a', style);
      expect(tester.element(indicator), same(unselected));
      expect(tester.getSize(indicator), const Size(8, 8));

      await pump(tester, null, style);
      expect(tester.element(indicator), same(unselected));
      expect(tester.getSize(indicator), const Size(4, 4));
    });

    testWidgets('by default an unselected radio has no indicator', (
      tester,
    ) async {
      final style = RadioStyler().indicator(BoxStyler().size(4, 4));

      await pump(tester, null, style);
      expect(indicator, findsNothing);

      await pump(tester, 'a', style);
      expect(indicator, findsOneWidget);
    });
  });
}
