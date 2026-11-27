import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

const _targetKey = Key('target');

Future<void> _pump(
  WidgetTester tester, {
  FortalThemeMode mode = FortalThemeMode.light,
  Alignment alignment = Alignment.center,
}) async {
  tester.view.physicalSize = const Size(800, 600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    WidgetsApp(
      color: const Color(0xFF000000),
      builder: (context, _) => FortalTheme(
        mode: mode,
        child: Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) => Align(
                alignment: alignment,
                child: FortalContextMenu<String>(
                  items: [
                    const RemixMenuItem(
                      value: 'copy',
                      label: 'Copy',
                      leadingIcon: RemixIcons.copy,
                    ),
                    RemixMenuItem(
                      value: 'delete',
                      label: 'Delete',
                      leadingIcon: RemixIcons.trash,
                      style: fortalContextMenuItemStyle(destructive: true),
                    ),
                  ],
                  child: const SizedBox(
                    key: _targetKey,
                    width: 300,
                    height: 200,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _rightClickAt(WidgetTester tester, Offset position) async {
  final gesture = await tester.startGesture(
    position,
    kind: PointerDeviceKind.mouse,
    buttons: kSecondaryButton,
  );
  await gesture.up();
  await tester.pump();
}

Finder get _panel =>
    find.ancestor(of: find.text('Copy'), matching: find.byType(Container)).last;

Finder _row(String label) =>
    find.ancestor(of: find.text(label), matching: find.byType(Container)).first;

BoxDecoration _decoration(WidgetTester tester, Finder finder) =>
    tester.widget<Container>(finder).decoration! as BoxDecoration;

Color _labelColor(WidgetTester tester, String label) => tester
    .widget<RichText>(
      find.descendant(of: find.text(label), matching: find.byType(RichText)),
    )
    .text
    .style!
    .color!;

double _opacityAbove(WidgetTester tester, Finder finder) => tester
    .widgetList<Opacity>(
      find.ancestor(of: finder, matching: find.byType(Opacity)),
    )
    .fold(1.0, (value, widget) => value * widget.opacity);

void main() {
  for (final (mode, panel, border, text, icon, highlight, danger, dangerFill)
      in const [
        (
          FortalThemeMode.light,
          Color(0xffffffff),
          Color(0xffe9e9e9),
          Color(0xff0b0b0b),
          Color(0xff585858),
          Color(0xfff8f8f8),
          Color(0xffbb2c54),
          Color(0xfffceff0),
        ),
        (
          FortalThemeMode.dark,
          Color(0xff1f1f1f),
          Color(0xff2b2b2b),
          Color(0xfff2f2f2),
          Color(0xffb4b4b4),
          Color(0xff242424),
          Color(0xfff0738f),
          Color(0xff282022),
        ),
      ]) {
    testWidgets('default panel and rows in ${mode.name}', (tester) async {
      await _pump(tester, mode: mode);
      final point =
          tester.getTopLeft(find.byKey(_targetKey)) + const Offset(40, 30);
      final mouse = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
        buttons: kSecondaryButton,
      );
      addTearDown(mouse.removePointer);
      await mouse.addPointer(location: point);
      await mouse.down(point);
      await mouse.up();
      await tester.pumpAndSettle();

      final panelRect = tester.getRect(_panel);
      expect(panelRect.topLeft, point);
      expect(panelRect.width, 208);
      final box = _decoration(tester, _panel);
      expect(box.color, panel);
      expect(box.borderRadius, BorderRadius.circular(20));
      expect(box.boxShadow, hasLength(mode == FortalThemeMode.light ? 2 : 1));
      final edge =
          tester.widget<Container>(_panel).foregroundDecoration!
              as BoxDecoration;
      expect(edge.border, Border.all(color: border));
      expect(tester.widget<Container>(_panel).padding, const EdgeInsets.all(6));

      final row = tester.getRect(_row('Copy'));
      expect(row.height, 34);
      expect(row.left, panelRect.left + 6);
      expect(row.top, panelRect.top + 6);
      expect(tester.getTopLeft(find.text('Copy')).dx, panelRect.left + 42);
      expect(
        _decoration(tester, _row('Copy')).borderRadius,
        BorderRadius.circular(14),
      );
      final label = tester
          .widget<RichText>(
            find.descendant(
              of: find.text('Copy'),
              matching: find.byType(RichText),
            ),
          )
          .text
          .style!;
      expect(label.fontSize, 13);
      expect(label.letterSpacing, closeTo(-.13, .001));
      expect(label.height, 1.4);
      expect(label.color, text);
      expect(_labelColor(tester, 'Delete'), danger);
      final copyIcon = tester.widget<Icon>(find.byIcon(RemixIcons.copy));
      expect(copyIcon.size, 15);
      expect(copyIcon.color, icon);

      await mouse.moveTo(tester.getCenter(find.text('Copy')));
      await tester.pumpAndSettle();
      expect(_decoration(tester, _row('Copy')).color, highlight);

      await mouse.moveTo(tester.getCenter(find.text('Delete')));
      await tester.pumpAndSettle();
      expect(_decoration(tester, _row('Delete')).color, dangerFill);
      expect(_decoration(tester, _row('Copy')).color, const Color(0x00000000));
    });
  }

  testWidgets('the panel grows from the pointer and fades in', (tester) async {
    await _pump(tester, alignment: Alignment.bottomRight);
    final point =
        tester.getBottomRight(find.byKey(_targetKey)) - const Offset(20, 20);
    await _rightClickAt(tester, point);
    await tester.pumpAndSettle();
    final settled = tester.getRect(_panel);
    // Shifted 8px inside the right edge and flipped above the pointer, so the
    // pointer sits on the panel's bottom edge, inside its width.
    expect(settled.right, 792);
    expect(settled.bottom, point.dy);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    await _rightClickAt(tester, point);
    await tester.pump(const Duration(milliseconds: 1));

    final growing = tester.getRect(_panel);
    expect(growing.width / settled.width, closeTo(.96, .005));
    final fixed = (point - settled.topLeft);
    expect(
      growing.topLeft,
      offsetMoreOrLessEquals(point - fixed * .96, epsilon: .5),
    );
    expect(_opacityAbove(tester, find.text('Copy')), lessThan(.05));

    await tester.pump(const Duration(milliseconds: 149));
    expect(_opacityAbove(tester, _panel), closeTo(1, .001));
    await tester.pumpAndSettle();
    expect(tester.getRect(_panel), settled);
  });

  testWidgets('rows rise in one after another', (tester) async {
    await _pump(tester);
    await _rightClickAt(tester, tester.getCenter(find.byKey(_targetKey)));
    await tester.pump(const Duration(milliseconds: 30));

    final panelOpacity = _opacityAbove(tester, _panel);
    final first = _opacityAbove(tester, find.text('Copy')) / panelOpacity;
    final second = _opacityAbove(tester, find.text('Delete')) / panelOpacity;
    expect(first, greaterThan(0));
    expect(second, 0);

    await tester.pump(const Duration(milliseconds: 310));
    expect(_opacityAbove(tester, find.text('Delete')), 1);
  });

  testWidgets('the panel fades out in 100ms', (tester) async {
    await _pump(tester);
    await _rightClickAt(tester, tester.getCenter(find.byKey(_targetKey)));
    await tester.pumpAndSettle();
    final settled = tester.getRect(_panel);

    await tester.tapAt(const Offset(10, 10));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    final opacity = _opacityAbove(tester, _panel);
    expect(opacity, inExclusiveRange(0, 1));
    expect(tester.getRect(_panel).width, lessThan(settled.width));
    expect(tester.getRect(_panel).width, greaterThan(settled.width * .98));
    expect(_opacityAbove(tester, find.text('Delete')), opacity);

    await tester.pump(const Duration(milliseconds: 60));
    expect(find.text('Copy'), findsNothing);
  });
}
