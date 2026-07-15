import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('RemixToggleGroupStyler', () {
    test('constructors retain container and item styles', () {
      final container = FlexBoxStyler();
      final item = RemixToggleGroupItemStyler();
      final style = RemixToggleGroupStyler(container: container, item: item);

      expect(style.$container, Prop.maybeMix(container));
      expect(style.$item, Prop.maybeMix(item));
    });

    styleMethodTest(
      'sets the group background color',
      initial: RemixToggleGroupStyler(),
      modify: (style) => style.backgroundColor(Colors.blue),
      expect: (style) {
        expect(style, RemixToggleGroupStyler.color(Colors.blue));
      },
    );

    styleMethodTest(
      'sets the default item style',
      initial: RemixToggleGroupStyler(),
      modify: (style) => style.item(RemixToggleGroupItemStyler()),
      expect: (style) {
        expect(style.$item, Prop.maybeMix(RemixToggleGroupItemStyler()));
      },
    );

    test('generic call creates a typed group', () {
      final widget = RemixToggleGroupStyler().call<String>(
        items: const [RemixToggleGroupItem(value: 'list', label: 'List')],
        selectedValue: 'list',
        onChanged: (_) {},
      );

      expect(widget, isA<RemixToggleGroup<String>>());
    });

    testWidgets('Fortal recipe resolves in a Fortal scope', (tester) async {
      await tester.pumpWidget(
        FortalScope(
          child: MaterialApp(
            home: FortalToggleGroup<String>(
              items: const [
                RemixToggleGroupItem(value: 'list', label: 'List'),
                RemixToggleGroupItem(value: 'grid', label: 'Grid'),
              ],
              selectedValue: 'list',
              onChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixToggleGroup<String>), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('RemixToggleGroupItemStyler', () {
    styleMethodTest(
      'sets foreground color on label and icon',
      initial: RemixToggleGroupItemStyler(),
      modify: (style) => style.foregroundColor(Colors.red),
      expect: (style) {
        expect(style.$label, isNotNull);
        expect(style.$icon, isNotNull);
      },
    );

    styleMethodTest(
      'adds a selected-state variant',
      initial: RemixToggleGroupItemStyler(),
      modify: (style) => style.onSelected(
        RemixToggleGroupItemStyler().backgroundColor(Colors.purple),
      ),
      expect: (style) {
        expect(style.$variants, hasLength(1));
      },
    );

    styleMethodTest(
      'sets icon and label spacing',
      initial: RemixToggleGroupItemStyler(),
      modify: (style) => style.spacing(8),
      expect: (style) {
        expect(style, RemixToggleGroupItemStyler.spacing(8));
      },
    );
  });
}
