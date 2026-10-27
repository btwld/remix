import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

const _panelColor = Color(0xFF123456);
const _itemHeight = 40.0;

Finder _boxColored(Color color) => find.byWidgetPredicate(
  (widget) =>
      widget is DecoratedBox &&
      widget.decoration is BoxDecoration &&
      (widget.decoration as BoxDecoration).color == color,
);

/// The painted panels of the open menus, root first.
Finder _menuPanels() => _boxColored(_panelColor);

/// The scroll view of a panel. An open submenu is mounted below its parent
/// panel, so the panel's own scroll view is the first one.
Finder _panelScrollable({int panel = 0}) => find
    .descendant(of: _menuPanels().at(panel), matching: find.byType(Scrollable))
    .first;

ScrollPosition _scrollPosition(WidgetTester tester, {int panel = 0}) =>
    tester.state<ScrollableState>(_panelScrollable(panel: panel)).position;

Rect _itemRect(WidgetTester tester, int index) =>
    tester.getRect(find.byType(NakedMenuItem<String>).at(index));

bool _isInView(WidgetTester tester, int index) {
  final viewport = tester.getRect(_panelScrollable());
  final item = _itemRect(tester, index);
  return item.top >= viewport.top - 0.01 &&
      item.bottom <= viewport.bottom + 0.01;
}

/// The value of the ordinary item that holds primary focus.
String? _focusedItemValue() => FocusManager.instance.primaryFocus?.context
    ?.findAncestorWidgetOfExactType<NakedMenuItem<String>>()
    ?.value;

List<RemixMenuItemData<String>> _items(int count, {String name = 'Item'}) => [
  for (var i = 0; i < count; i++)
    RemixMenuItem<String>(value: '$name$i', label: '$name $i'),
];

MenuStyler _menuStyle({
  double? maxHeight,
  double padding = 0,
  RemixBoxEffectsMix? effects,
}) {
  var overlay = FlexBoxStyler().color(_panelColor).padding(.all(padding));
  if (maxHeight != null) overlay = overlay.maxHeight(maxHeight);
  var style = MenuStyler()
      .overlay(overlay)
      .item(MenuItemStyler().height(_itemHeight));
  if (effects != null) style = style.containerEffects(effects);
  return style;
}

Widget _centered(Widget menu) => Scaffold(body: Center(child: menu));

/// Opens a [RemixMenu] whose items are all [_itemHeight] tall and whose panel
/// is painted in [_panelColor], inside the page that [host] builds around it.
Future<void> _pumpOpenMenu(
  WidgetTester tester, {
  List<RemixMenuItemData<String>>? items,
  MenuStyler? style,
  ValueChanged<String>? onSelected,
  Widget Function(Widget menu) host = _centered,
}) async {
  await tester.pumpWidget(
    MixScope.empty(
      child: MaterialApp(
        home: host(
          RemixMenu<String>(
            trigger: const RemixMenuTrigger(label: 'Options'),
            style: style ?? _menuStyle(),
            onSelected: onSelected ?? (_) {},
            items: items ?? _items(30),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.byType(RemixMenu<String>));
  await tester.pumpAndSettle();
}

Future<void> _pressKey(
  WidgetTester tester,
  LogicalKeyboardKey key, {
  int times = 1,
}) async {
  for (var i = 0; i < times; i++) {
    await tester.sendKeyEvent(key);
    await tester.pumpAndSettle();
  }
}

void _setViewSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  group('RemixMenu long menus', () {
    testWidgets('a short menu keeps the size of its items', (tester) async {
      await _pumpOpenMenu(
        tester,
        items: _items(3),
        style: _menuStyle(padding: 8),
      );

      expect(tester.takeException(), isNull);
      final panel = tester.getSize(_menuPanels());
      expect(panel.height, 3 * _itemHeight + 2 * 8);
      expect(panel.width, _itemRect(tester, 0).width + 2 * 8);
    });

    testWidgets('scrolls instead of overflowing past the overlay', (
      tester,
    ) async {
      _setViewSize(tester, const Size(800, 300));
      String? selected;
      await _pumpOpenMenu(tester, onSelected: (value) => selected = value);

      expect(tester.takeException(), isNull);
      expect(tester.getSize(_menuPanels()).height, lessThanOrEqualTo(300));
      expect(_scrollPosition(tester).maxScrollExtent, greaterThan(0));
      expect(find.text('Item 29').hitTestable(), findsNothing);

      await tester.drag(_menuPanels(), const Offset(0, -2000));
      await tester.pumpAndSettle();
      expect(find.text('Item 29').hitTestable(), findsOneWidget);

      await tester.tap(find.text('Item 29'));
      await tester.pumpAndSettle();
      expect(selected, 'Item29');
    });

    testWidgets('scrolls inside an overlay maxHeight', (tester) async {
      await _pumpOpenMenu(
        tester,
        items: _items(20),
        style: _menuStyle(maxHeight: 200, padding: 10),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getSize(_menuPanels()).height, 200);
      expect(_scrollPosition(tester).maxScrollExtent, greaterThan(0));
      expect(find.text('Item 19').hitTestable(), findsNothing);

      await tester.drag(_menuPanels(), const Offset(0, -2000));
      await tester.pumpAndSettle();
      expect(find.text('Item 19').hitTestable(), findsOneWidget);
      expect(find.text('Item 0').hitTestable(), findsNothing);
    });

    testWidgets('keeps its width when the items scroll', (tester) async {
      await _pumpOpenMenu(
        tester,
        items: _items(20),
        style: _menuStyle(maxHeight: 200),
      );

      final item = _itemRect(tester, 0);
      final panel = tester.getRect(_menuPanels());
      expect(panel.width, item.width);
      expect(panel.width, lessThan(400));
    });

    testWidgets('padding and decoration stay put while scrolling', (
      tester,
    ) async {
      await _pumpOpenMenu(
        tester,
        items: _items(20),
        style: _menuStyle(maxHeight: 200, padding: 10),
      );

      final panel = tester.getRect(_menuPanels());
      final viewport = tester.getRect(_panelScrollable());
      expect(viewport, panel.deflate(10));

      await tester.drag(_menuPanels(), const Offset(0, -150));
      await tester.pumpAndSettle();

      expect(_scrollPosition(tester).pixels, greaterThan(0));
      expect(tester.getRect(_menuPanels()), panel);
      expect(tester.getRect(_panelScrollable()), viewport);
    });

    testWidgets('container effects frame the scroll view too', (tester) async {
      await _pumpOpenMenu(
        tester,
        items: _items(20),
        style: _menuStyle(
          maxHeight: 200,
          padding: 10,
          effects: RemixBoxEffectsMix(backdropBlur: 4),
        ),
      );

      expect(tester.takeException(), isNull);
      final panel = tester.getRect(_menuPanels());
      final viewport = tester.getRect(_panelScrollable());
      expect(panel.height, 200);
      expect(viewport, panel.deflate(10));

      await tester.drag(_menuPanels(), const Offset(0, -2000));
      await tester.pumpAndSettle();

      expect(find.text('Item 19').hitTestable(), findsOneWidget);
      expect(tester.getRect(_menuPanels()), panel);
      expect(tester.getRect(_panelScrollable()), viewport);
    });

    testWidgets('arrow keys scroll the focused item into view', (tester) async {
      await _pumpOpenMenu(
        tester,
        items: _items(20),
        style: _menuStyle(maxHeight: 200),
      );
      expect(_isInView(tester, 7), isFalse);

      await _pressKey(tester, LogicalKeyboardKey.arrowDown, times: 8);

      expect(_focusedItemValue(), 'Item7');
      expect(_isInView(tester, 7), isTrue);
      expect(_scrollPosition(tester).pixels, greaterThan(0));
    });

    testWidgets('the last item is reachable and selectable by keyboard', (
      tester,
    ) async {
      String? selected;
      await _pumpOpenMenu(
        tester,
        items: _items(20),
        style: _menuStyle(maxHeight: 200),
        onSelected: (value) => selected = value,
      );

      await _pressKey(tester, LogicalKeyboardKey.arrowDown, times: 20);
      expect(_focusedItemValue(), 'Item19');
      expect(_isInView(tester, 19), isTrue);

      await _pressKey(tester, LogicalKeyboardKey.enter);
      expect(selected, 'Item19');
    });

    testWidgets('arrow up scrolls back to the first item', (tester) async {
      await _pumpOpenMenu(
        tester,
        items: _items(20),
        style: _menuStyle(maxHeight: 200),
      );

      await _pressKey(tester, LogicalKeyboardKey.arrowDown, times: 12);
      expect(_scrollPosition(tester).pixels, greaterThan(0));
      await _pressKey(tester, LogicalKeyboardKey.arrowUp, times: 11);

      expect(_focusedItemValue(), 'Item0');
      expect(_isInView(tester, 0), isTrue);
      expect(_scrollPosition(tester).pixels, 0);
    });

    testWidgets('exposes scrolling to assistive technology', (tester) async {
      final semantics = tester.ensureSemantics();
      await _pumpOpenMenu(
        tester,
        items: _items(20),
        style: _menuStyle(maxHeight: 200),
      );

      final scroll = tester.getSemantics(_panelScrollable()).getSemanticsData();
      expect(scroll.hasAction(SemanticsAction.scrollUp), isTrue);
      expect(scroll.hasAction(SemanticsAction.scrollDown), isFalse);

      _scrollPosition(tester).jumpTo(_scrollPosition(tester).maxScrollExtent);
      await tester.pump();

      final atEnd = tester.getSemantics(_panelScrollable()).getSemanticsData();
      expect(atEnd.hasAction(SemanticsAction.scrollDown), isTrue);
      expect(atEnd.hasAction(SemanticsAction.scrollUp), isFalse);
      semantics.dispose();
    });

    testWidgets('leaves the host primary scroll controller alone', (
      tester,
    ) async {
      final hostController = ScrollController();
      addTearDown(hostController.dispose);
      await tester.pumpRemixApp(
        PrimaryScrollController(
          controller: hostController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RemixMenu<String>(
                trigger: const RemixMenuTrigger(label: 'Options'),
                items: _items(30),
              ),
              SizedBox(
                height: 200,
                child: ListView(
                  primary: true,
                  children: const [SizedBox(height: 1000)],
                ),
              ),
            ],
          ),
        ),
      );
      expect(hostController.positions, hasLength(1));

      await tester.tap(find.byType(RemixMenu<String>));
      await tester.pumpAndSettle();

      expect(find.text('Item 0'), findsOneWidget);
      expect(hostController.positions, hasLength(1));
    });

    testWidgets('scrolling does not notify the host page', (tester) async {
      final received = <Notification>[];
      await _pumpOpenMenu(
        tester,
        items: _items(20),
        style: _menuStyle(maxHeight: 200),
        host: (menu) => Scaffold(
          body: NotificationListener<Notification>(
            onNotification: (notification) {
              if (notification is ViewportNotificationMixin) {
                received.add(notification);
              }
              return false;
            },
            child: Center(child: menu),
          ),
        ),
      );

      await tester.drag(_menuPanels(), const Offset(0, -150));
      await tester.pumpAndSettle();

      expect(_scrollPosition(tester).pixels, greaterThan(0));
      expect(received, isEmpty);
    });

    testWidgets('scrolling does not scroll the app bar under', (tester) async {
      double appBarElevation() => tester
          .widget<Material>(
            find
                .descendant(
                  of: find.byType(AppBar),
                  matching: find.byType(Material),
                )
                .first,
          )
          .elevation;

      await _pumpOpenMenu(
        tester,
        items: _items(20),
        style: _menuStyle(maxHeight: 200),
        host: (menu) => Scaffold(
          appBar: AppBar(title: const Text('Page')),
          body: Center(child: menu),
        ),
      );
      final restingElevation = appBarElevation();

      await tester.drag(_menuPanels(), const Offset(0, -150));
      await tester.pumpAndSettle();
      expect(_scrollPosition(tester).pixels, greaterThan(0));
      expect(appBarElevation(), restingElevation);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(appBarElevation(), restingElevation);
    });

    testWidgets('does not stretch or glow past the ends', (tester) async {
      await _pumpOpenMenu(
        tester,
        items: _items(20),
        style: _menuStyle(maxHeight: 200),
      );

      expect(
        find.descendant(
          of: _menuPanels(),
          matching: find.byWidgetPredicate(
            (widget) =>
                widget is StretchingOverscrollIndicator ||
                widget is GlowingOverscrollIndicator,
          ),
        ),
        findsNothing,
      );
    });

    testWidgets(
      'stops at the ends instead of bouncing',
      (tester) async {
        await _pumpOpenMenu(
          tester,
          items: _items(20),
          style: _menuStyle(maxHeight: 200),
        );
        final position = _scrollPosition(tester);

        final gesture = await tester.startGesture(
          tester.getCenter(_menuPanels()),
        );
        await gesture.moveBy(const Offset(0, 100));
        await tester.pump();
        expect(position.pixels, position.minScrollExtent);

        await gesture.moveBy(const Offset(0, -3000));
        await tester.pump();
        expect(position.pixels, position.maxScrollExtent);

        await gesture.up();
        await tester.pumpAndSettle();
        expect(position.pixels, position.maxScrollExtent);
      },
      variant: TargetPlatformVariant.only(TargetPlatform.iOS),
    );

    testWidgets('keeps a scrollbar on desktop', (tester) async {
      await _pumpOpenMenu(
        tester,
        items: _items(20),
        style: _menuStyle(maxHeight: 200),
      );

      expect(
        find.descendant(of: _menuPanels(), matching: find.byType(Scrollbar)),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    }, variant: TargetPlatformVariant.desktop());

    group('compound items', () {
      List<RemixMenuItemData<String>> compoundItems({
        ValueChanged<bool?>? onBoldChanged,
        ValueChanged<String>? onAlignChanged,
      }) => [
        ..._items(12),
        const RemixMenuDivider(),
        RemixMenuCheckboxItem<String>(
          value: 'bold',
          label: 'Bold',
          checked: false,
          onChanged: onBoldChanged ?? (_) {},
        ),
        RemixMenuRadioGroup<String>(
          value: 'left',
          onChanged: onAlignChanged ?? (_) {},
          items: const [
            RemixMenuRadioItem(value: 'left', label: 'Left'),
            RemixMenuRadioItem(value: 'right', label: 'Right'),
          ],
        ),
        const RemixMenuDivider(),
        ..._items(12, name: 'Tail'),
      ];

      testWidgets('a checkbox item deep in the list can be toggled', (
        tester,
      ) async {
        final changes = <bool?>[];
        await _pumpOpenMenu(
          tester,
          items: compoundItems(onBoldChanged: changes.add),
          style: _menuStyle(maxHeight: 200),
        );
        expect(find.text('Bold').hitTestable(), findsNothing);

        await tester.ensureVisible(find.text('Bold'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Bold'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(changes, [true]);
      });

      testWidgets('a radio item deep in the list can be chosen', (
        tester,
      ) async {
        final changes = <String>[];
        await _pumpOpenMenu(
          tester,
          items: compoundItems(onAlignChanged: changes.add),
          style: _menuStyle(maxHeight: 200),
        );
        expect(find.text('Right').hitTestable(), findsNothing);

        await tester.ensureVisible(find.text('Right'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Right'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(changes, ['right']);
      });

      testWidgets('dividers scroll with the items they separate', (
        tester,
      ) async {
        await _pumpOpenMenu(
          tester,
          items: compoundItems(),
          style: _menuStyle(maxHeight: 200),
        );
        final divider = find.byType(RemixDivider).first;
        final restingTop = tester.getTopLeft(divider).dy;
        expect(restingTop, _itemRect(tester, 11).bottom);

        await tester.drag(_menuPanels(), const Offset(0, -150));
        await tester.pumpAndSettle();

        expect(_scrollPosition(tester).pixels, greaterThan(0));
        expect(
          tester.getTopLeft(divider).dy,
          restingTop - _scrollPosition(tester).pixels,
        );
      });
    });

    group('submenus', () {
      List<RemixMenuItemData<String>> itemsWithSubmenuAt(
        int index, {
        int submenuItems = 3,
      }) => [
        ..._items(index),
        RemixMenuSubmenu<String>(
          label: 'More',
          items: [
            for (var i = 0; i < submenuItems; i++)
              RemixMenuItem<String>(value: 'sub$i', label: 'Sub $i'),
          ],
        ),
        ..._items(12, name: 'Tail'),
      ];

      Rect submenuTriggerRect(WidgetTester tester) => tester.getRect(
        find.ancestor(
          of: find.text('More'),
          matching: find.byType(NakedMenuSubmenu<String>),
        ),
      );

      testWidgets(
        'a submenu opens beside an item scrolled partly out of view',
        (tester) async {
          _setViewSize(tester, const Size(800, 700));
          await _pumpOpenMenu(
            tester,
            items: itemsWithSubmenuAt(12),
            style: _menuStyle(maxHeight: 200),
          );
          final viewport = tester.getRect(_panelScrollable());
          final submenuContentTop = 12 * _itemHeight;

          _scrollPosition(tester).jumpTo(submenuContentTop - 180);
          await tester.pump();
          final trigger = submenuTriggerRect(tester);
          expect(trigger.top, viewport.bottom - 20);

          await tester.tapAt(Offset(trigger.center.dx, trigger.top + 8));
          await tester.pumpAndSettle();

          expect(tester.takeException(), isNull);
          expect(find.text('Sub 0'), findsOneWidget);
          final submenuPanel = tester.getRect(_menuPanels().last);
          expect(submenuPanel.top, trigger.top);
          expect(submenuPanel.left, trigger.right + 4);
        },
      );

      testWidgets('an open submenu follows its item while the panel scrolls', (
        tester,
      ) async {
        _setViewSize(tester, const Size(800, 700));
        await _pumpOpenMenu(
          tester,
          items: itemsWithSubmenuAt(3),
          style: _menuStyle(maxHeight: 200),
        );
        await tester.tap(find.text('More'));
        await tester.pumpAndSettle();
        final before = submenuTriggerRect(tester);
        expect(tester.getRect(_menuPanels().last).top, before.top);

        _scrollPosition(tester).jumpTo(60);
        await tester.pump();
        await tester.pump();

        final after = submenuTriggerRect(tester);
        expect(after.top, before.top - 60);
        expect(tester.getRect(_menuPanels().last).top, after.top);
      });

      testWidgets('a long submenu scrolls instead of overflowing', (
        tester,
      ) async {
        _setViewSize(tester, const Size(800, 300));
        String? selected;
        await _pumpOpenMenu(
          tester,
          items: [
            RemixMenuSubmenu<String>(
              label: 'More',
              items: [
                for (var i = 0; i < 30; i++)
                  RemixMenuItem<String>(value: 'sub$i', label: 'Sub $i'),
              ],
            ),
          ],
          onSelected: (value) => selected = value,
        );

        await tester.tap(find.text('More'));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text('Sub 0'), findsOneWidget);
        expect(
          tester.getSize(_menuPanels().last).height,
          lessThanOrEqualTo(300),
        );
        expect(
          _scrollPosition(tester, panel: 1).maxScrollExtent,
          greaterThan(0),
        );

        await tester.ensureVisible(find.text('Sub 29'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Sub 29'));
        await tester.pumpAndSettle();
        expect(selected, 'sub29');
      });
    });
  });
}
