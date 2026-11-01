import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

const _panelColor = Color(0xFF123456);
const _itemHeight = 40.0;
const _sideOffset = 6.0;
const _triggerKey = Key('trigger');

Finder _menuPanel() => find
    .byWidgetPredicate(
      (widget) =>
          widget is DecoratedBox &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).color == _panelColor,
    )
    .first;

Future<void> _pumpOpenMenu(
  WidgetTester tester, {
  required int itemCount,
  Alignment alignment = Alignment.topCenter,
  ValueChanged<String>? onSelected,
}) async {
  await tester.pumpWidget(
    MixScope.empty(
      child: MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: alignment,
            child: SizedBox(
              key: _triggerKey,
              child: RemixMenu<String>(
                trigger: const RemixMenuTrigger(label: 'Options'),
                positioning: const OverlayPositionConfig(
                  sideOffset: _sideOffset,
                ),
                style: MenuStyler()
                    .overlay(FlexBoxStyler().color(_panelColor))
                    .item(MenuItemStyler().height(_itemHeight)),
                onSelected: onSelected ?? (_) {},
                items: [
                  for (var i = 0; i < itemCount; i++)
                    RemixMenuItem<String>(value: 'item$i', label: 'Item $i'),
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
  group('RemixMenu panel beside its trigger', () {
    testWidgets('a long menu fits below a trigger near the top', (
      tester,
    ) async {
      String? selected;
      await _pumpOpenMenu(
        tester,
        itemCount: 40,
        onSelected: (value) => selected = value,
      );

      expect(tester.takeException(), isNull);
      final trigger = tester.getRect(find.byKey(_triggerKey));
      final panel = tester.getRect(_menuPanel());
      expect(panel.top, greaterThanOrEqualTo(trigger.bottom + _sideOffset));
      expect(panel.bottom, lessThanOrEqualTo(_overlayHeight(tester)));
      expect(panel.overlaps(trigger), isFalse);

      expect(find.text('Item 39').hitTestable(), findsNothing);
      await tester.drag(_menuPanel(), const Offset(0, -5000));
      await tester.pumpAndSettle();
      expect(find.text('Item 39').hitTestable(), findsOneWidget);
      await tester.tap(find.text('Item 39'));
      await tester.pumpAndSettle();
      expect(selected, 'item39');
    });

    testWidgets('a long menu flips above a trigger near the bottom', (
      tester,
    ) async {
      await _pumpOpenMenu(
        tester,
        itemCount: 40,
        alignment: Alignment.bottomCenter,
      );

      expect(tester.takeException(), isNull);
      final trigger = tester.getRect(find.byKey(_triggerKey));
      final panel = tester.getRect(_menuPanel());
      expect(panel.bottom, lessThanOrEqualTo(trigger.top - _sideOffset));
      expect(panel.top, greaterThanOrEqualTo(0));

      await tester.drag(_menuPanel(), const Offset(0, -5000));
      await tester.pumpAndSettle();
      expect(find.text('Item 39').hitTestable(), findsOneWidget);
    });

    testWidgets('a short menu keeps the size of its items', (tester) async {
      await _pumpOpenMenu(tester, itemCount: 3, alignment: Alignment.center);

      final trigger = tester.getRect(find.byKey(_triggerKey));
      final panel = tester.getRect(_menuPanel());
      expect(panel.top, trigger.bottom + _sideOffset);
      expect(panel.height, 3 * _itemHeight);
    });
  });
}
