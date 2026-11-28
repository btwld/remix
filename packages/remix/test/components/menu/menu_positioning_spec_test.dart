import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

const _above = OverlayPositionConfig(side: OverlaySide.top, sideOffset: 6);
const _farBelow = OverlayPositionConfig(sideOffset: 20);

Future<void> _open(WidgetTester tester, RemixMenu<String> menu) async {
  await tester.pumpRemixApp(menu);
  await tester.tap(find.text('Options'));
  await tester.pumpAndSettle();
}

RemixMenu<String> _menu({
  OverlayPositionConfig? positioning,
  MenuStyler? style,
  MenuSpec? styleSpec,
}) => RemixMenu<String>(
  trigger: const RemixMenuTrigger(label: 'Options'),
  items: const [RemixMenuItem(value: 'copy', label: 'Copy')],
  positioning: positioning,
  style: style ?? const MenuStyler.create(),
  styleSpec: styleSpec,
);

Rect _trigger(WidgetTester tester) => tester.getRect(find.text('Options'));
Rect _item(WidgetTester tester) => tester.getRect(find.text('Copy'));

void main() {
  testWidgets('without positioning the panel opens right below', (
    tester,
  ) async {
    await _open(tester, _menu());
    expect(_item(tester).top, closeTo(_trigger(tester).bottom, .01));
  });

  testWidgets('the style places the panel', (tester) async {
    await _open(tester, _menu(style: MenuStyler().positioning(_above)));
    expect(_item(tester).bottom, closeTo(_trigger(tester).top - 6, .01));
  });

  testWidgets('a raw styleSpec places the panel', (tester) async {
    await _open(tester, _menu(styleSpec: const MenuSpec(positioning: _above)));
    expect(_item(tester).bottom, closeTo(_trigger(tester).top - 6, .01));
  });

  testWidgets('an explicit positioning wins over the style', (tester) async {
    final menu = _menu(
      positioning: _farBelow,
      style: MenuStyler().positioning(_above),
    );
    expect(menu.positioning, same(_farBelow));
    await _open(tester, menu);
    expect(_item(tester).top, closeTo(_trigger(tester).bottom + 20, .01));
  });

  test('an omitted positioning still reads as the default', () {
    expect(_menu().positioning, const OverlayPositionConfig());
  });
}
