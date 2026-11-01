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
  bool fullHeight = false,
  double outerPadding = 0,
  double panelPadding = 0,
  EdgeInsets collisionPadding = EdgeInsets.zero,
  ValueChanged<String>? onSelected,
}) async {
  await tester.pumpWidget(
    MixScope.empty(
      child: MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(outerPadding),
            child: Align(
              alignment: alignment,
              child: SizedBox(
                key: _triggerKey,
                height: fullHeight ? double.infinity : null,
                child: RemixMenu<String>(
                  trigger: const RemixMenuTrigger(label: 'Options'),
                  positioning: OverlayPositionConfig(
                    sideOffset: _sideOffset,
                    collisionPadding: collisionPadding,
                  ),
                  style: MenuStyler()
                      .overlay(
                        FlexBoxStyler()
                            .color(_panelColor)
                            .padding(.all(panelPadding)),
                      )
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
    ),
  );
  await tester.tap(find.byKey(_triggerKey));
  await tester.pumpAndSettle();
}

double _overlayHeight(WidgetTester tester) =>
    tester.view.physicalSize.height / tester.view.devicePixelRatio;

void main() {
  group('RemixMenu panel beside its trigger', () {
    testWidgets('a nearly full-height padded trigger keeps options usable', (
      tester,
    ) async {
      String? selected;
      await _pumpOpenMenu(
        tester,
        itemCount: 3,
        fullHeight: true,
        outerPadding: 16,
        panelPadding: 8,
        onSelected: (value) => selected = value,
      );
      expect(tester.takeException(), isNull);
      final trigger = tester.getRect(find.byKey(_triggerKey));
      expect(trigger.top, 16);
      expect(trigger.bottom, _overlayHeight(tester) - 16);
      expect(find.text('Item 2').hitTestable(), findsOneWidget);
      await tester.tap(find.text('Item 2'));
      await tester.pumpAndSettle();
      expect(selected, 'item2');
    });

    testWidgets('fallback respects collision padding and can select last row', (
      tester,
    ) async {
      String? selected;
      await _pumpOpenMenu(
        tester,
        itemCount: 40,
        fullHeight: true,
        collisionPadding: const EdgeInsets.all(32),
        panelPadding: 8,
        onSelected: (value) => selected = value,
      );
      expect(tester.takeException(), isNull);
      final panel = tester.getRect(_menuPanel());
      expect(panel.top, greaterThanOrEqualTo(32));
      expect(panel.bottom, lessThanOrEqualTo(_overlayHeight(tester) - 32));
      await tester.drag(_menuPanel(), const Offset(0, -5000));
      await tester.pumpAndSettle();
      expect(find.text('Item 39').hitTestable(), findsOneWidget);
      await tester.tap(find.text('Item 39'));
      await tester.pumpAndSettle();
      expect(selected, 'item39');
    });

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
    testWidgets('a full-height menu trigger keeps the panel usable', (
      tester,
    ) async {
      String? selected;
      await _pumpOpenMenu(
        tester,
        itemCount: 3,
        fullHeight: true,
        onSelected: (value) => selected = value,
      );
      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byKey(_triggerKey)).height,
        _overlayHeight(tester),
      );
      final panel = tester.getRect(_menuPanel());
      expect(panel.height, 3 * _itemHeight);
      expect(panel.top, greaterThanOrEqualTo(0));
      expect(panel.bottom, lessThanOrEqualTo(_overlayHeight(tester)));
      expect(find.text('Item 2').hitTestable(), findsOneWidget);
      await tester.tap(find.text('Item 2'));
      await tester.pumpAndSettle();
      expect(selected, 'item2');
    });
  });
}
