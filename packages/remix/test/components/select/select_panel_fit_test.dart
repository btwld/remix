import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

const _panelColor = Color(0xFF123456);
const _optionHeight = 40.0;
const _sideOffset = 6.0;
const _triggerKey = Key('trigger');

Finder _selectPanel() => find.byWidgetPredicate(
  (widget) =>
      widget is DecoratedBox &&
      widget.decoration is BoxDecoration &&
      (widget.decoration as BoxDecoration).color == _panelColor,
);

Future<void> _pumpOpenSelect(
  WidgetTester tester, {
  required int optionCount,
  Alignment alignment = Alignment.topCenter,
  ValueChanged<String?>? onChanged,
}) async {
  await tester.pumpWidget(
    MixScope.empty(
      child: MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: alignment,
            child: SizedBox(
              key: _triggerKey,
              child: RemixSelect<String>(
                trigger: const RemixSelectTrigger(placeholder: 'Select'),
                positioning: const OverlayPositionConfig(
                  side: .bottom,
                  alignment: .center,
                  sideOffset: _sideOffset,
                ),
                style: SelectStyler()
                    .content(SelectContentStyler().color(_panelColor))
                    .item(SelectMenuItemStyler().height(_optionHeight)),
                onChanged: onChanged ?? (_) {},
                items: [
                  for (var i = 0; i < optionCount; i++)
                    RemixSelectItem(value: 'item$i', label: 'Item $i'),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.byKey(_triggerKey));
  await tester.pumpAndSettle();
}

double _overlayHeight(WidgetTester tester) =>
    tester.view.physicalSize.height / tester.view.devicePixelRatio;

void main() {
  group('RemixSelect panel beside its trigger', () {
    testWidgets('a long list fits below a trigger near the top', (
      tester,
    ) async {
      String? selected;
      await _pumpOpenSelect(
        tester,
        optionCount: 40,
        onChanged: (value) => selected = value,
      );

      expect(tester.takeException(), isNull);
      final trigger = tester.getRect(find.byKey(_triggerKey));
      final panel = tester.getRect(_selectPanel());
      expect(panel.top, greaterThanOrEqualTo(trigger.bottom + _sideOffset));
      expect(panel.bottom, lessThanOrEqualTo(_overlayHeight(tester)));
      expect(panel.overlaps(trigger), isFalse);

      expect(find.text('Item 39').hitTestable(), findsNothing);
      await tester.drag(_selectPanel(), const Offset(0, -5000));
      await tester.pumpAndSettle();
      expect(find.text('Item 39').hitTestable(), findsOneWidget);
      await tester.tap(find.text('Item 39'));
      await tester.pumpAndSettle();
      expect(selected, 'item39');
    });

    testWidgets('a long list flips above a trigger near the bottom', (
      tester,
    ) async {
      await _pumpOpenSelect(
        tester,
        optionCount: 40,
        alignment: Alignment.bottomCenter,
      );

      expect(tester.takeException(), isNull);
      final trigger = tester.getRect(find.byKey(_triggerKey));
      final panel = tester.getRect(_selectPanel());
      expect(panel.bottom, lessThanOrEqualTo(trigger.top - _sideOffset));
      expect(panel.top, greaterThanOrEqualTo(0));

      await tester.drag(_selectPanel(), const Offset(0, -5000));
      await tester.pumpAndSettle();
      expect(find.text('Item 39').hitTestable(), findsOneWidget);
    });

    testWidgets('a short list keeps the size of its options', (tester) async {
      await _pumpOpenSelect(
        tester,
        optionCount: 3,
        alignment: Alignment.center,
      );

      final trigger = tester.getRect(find.byKey(_triggerKey));
      final panel = tester.getRect(_selectPanel());
      expect(panel.top, trigger.bottom + _sideOffset);
      expect(panel.height, 3 * _optionHeight);
    });
  });
}
