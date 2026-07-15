import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('RemixPopoverStyler', () {
    test('constructors retain container and universal style properties', () {
      final animation = AnimationConfig.linear(
        const Duration(milliseconds: 150),
      );
      final modifier = WidgetModifierConfig();
      final style = RemixPopoverStyler(
        container: BoxStyler(padding: EdgeInsetsGeometryMix.all(12)),
        animation: animation,
        variants: const [],
        modifier: modifier,
      );

      expect(style.$container, isNotNull);
      expect(style.$animation, animation);
      expect(style.$variants, isEmpty);
      expect(style.$modifier, modifier);
    });

    test('factory constructors create focused styles', () {
      expect(RemixPopoverStyler.color(Colors.purple).$container, isNotNull);
      expect(
        RemixPopoverStyler.padding(EdgeInsetsGeometryMix.all(12)).$container,
        isNotNull,
      );
      expect(
        RemixPopoverStyler.constraints(
          BoxConstraintsMix(maxWidth: 320),
        ).$container,
        isNotNull,
      );
    });

    styleMethodTest(
      'container methods compose without mutating the original style',
      initial: const RemixPopoverStyler.create(),
      modify: (style) => style
          .padding(EdgeInsetsGeometryMix.all(12))
          .margin(EdgeInsetsGeometryMix.all(8))
          .backgroundColor(Colors.purple)
          .alignment(Alignment.center),
      expect: (style) => expect(style.$container, isNotNull),
    );

    testWidgets('resolves to a RemixPopoverSpec', (tester) async {
      const style = RemixPopoverStyler.create();

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(style.resolve(context).spec, isA<RemixPopoverSpec>());
              return const SizedBox();
            },
          ),
        ),
      );
    });

    test('call creates a RemixPopover with this style', () {
      final style = RemixPopoverStyler().backgroundColor(Colors.purple);

      final widget = style(
        popoverChild: const Text('Content'),
        child: const Text('Trigger'),
      );

      expect(widget.style, same(style));
      expect(widget.popoverChild, isA<Text>());
      expect(widget.child, isA<Text>());
    });
  });
}
