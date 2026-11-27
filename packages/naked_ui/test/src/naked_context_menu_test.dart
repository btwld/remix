import 'package:flutter/gestures.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';
import 'package:naked_ui/src/utilities/anchored_overlay.dart';

const _targetKey = Key('target');
const _panelKey = Key('panel');
const _targetSize = Size(300, 200);

class _Log {
  final events = <String>[];
}

Widget _host(Widget child) {
  return WidgetsApp(
    color: const Color(0xFF000000),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, _, _) => builder(context),
    ),
    home: ColoredBox(
      color: const Color(0xFFFFFFFF),
      child: Align(alignment: Alignment.topLeft, child: child),
    ),
  );
}

Widget _contextMenu({
  required MenuController controller,
  _Log? log,
  bool enabled = true,
  FocusNode? focusNode,
}) {
  return Padding(
    padding: const EdgeInsets.all(50),
    child: NakedContextMenu<String>(
      controller: controller,
      enabled: enabled,
      focusNode: focusNode,
      onOpen: () => log?.events.add('open'),
      onClose: () => log?.events.add('close'),
      onCanceled: () => log?.events.add('canceled'),
      onSelected: (value) => log?.events.add('selected:$value'),
      overlayBuilder: (context, info) => SizedBox(
        key: _panelKey,
        width: 120,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NakedMenu.Item(value: 'copy', child: const Text('Copy')),
            NakedMenu.Item(value: 'delete', child: const Text('Delete')),
          ],
        ),
      ),
      // The label covers only the corner, so presses land on empty space.
      child: SizedBox.fromSize(
        key: _targetKey,
        size: _targetSize,
        child: const Align(alignment: Alignment.topLeft, child: Text('Target')),
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

void main() {
  group('NakedContextMenu', () {
    testWidgets('a secondary click opens the panel at the pointer', (
      tester,
    ) async {
      final controller = MenuController();
      final log = _Log();
      await tester.pumpWidget(
        _host(_contextMenu(controller: controller, log: log)),
      );

      await _rightClickAt(tester, const Offset(120, 90));

      expect(controller.isOpen, isTrue);
      expect(log.events, ['open']);
      expect(tester.getTopLeft(find.byKey(_panelKey)), const Offset(120, 90));
    });

    testWidgets('a second secondary click moves the open panel', (
      tester,
    ) async {
      final controller = MenuController();
      final log = _Log();
      await tester.pumpWidget(
        _host(_contextMenu(controller: controller, log: log)),
      );

      await _rightClickAt(tester, const Offset(120, 90));
      await _rightClickAt(tester, const Offset(200, 150));

      expect(controller.isOpen, isTrue);
      expect(tester.getTopLeft(find.byKey(_panelKey)), const Offset(200, 150));
      expect(log.events, ['open', 'canceled', 'close', 'open']);
    });

    testWidgets('a touch long press opens at the press; a mouse one does not', (
      tester,
    ) async {
      final controller = MenuController();
      await tester.pumpWidget(_host(_contextMenu(controller: controller)));

      await tester.longPressAt(
        const Offset(100, 100),
        kind: PointerDeviceKind.mouse,
      );
      await tester.pump();
      expect(controller.isOpen, isFalse);

      await tester.longPressAt(const Offset(100, 100));
      await tester.pump();
      expect(controller.isOpen, isTrue);
      expect(tester.getTopLeft(find.byKey(_panelKey)), const Offset(100, 100));
    });

    for (final (name, keys) in [
      ('ContextMenu', [LogicalKeyboardKey.contextMenu]),
      ('Shift+F10', [LogicalKeyboardKey.shift, LogicalKeyboardKey.f10]),
    ]) {
      testWidgets('$name opens at the bottom-left; Escape returns focus', (
        tester,
      ) async {
        final controller = MenuController();
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);
        await tester.pumpWidget(
          _host(_contextMenu(controller: controller, focusNode: focusNode)),
        );
        focusNode.requestFocus();
        await tester.pump();

        for (final key in keys) {
          await tester.sendKeyDownEvent(key);
        }
        for (final key in keys.reversed) {
          await tester.sendKeyUpEvent(key);
        }
        await tester.pump();

        expect(controller.isOpen, isTrue);
        expect(
          tester.getTopLeft(find.byKey(_panelKey)),
          tester.getBottomLeft(find.byKey(_targetKey)),
        );
        expect(focusNode.hasPrimaryFocus, isFalse);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();
        expect(
          Focus.of(tester.element(find.text('Copy'))).hasPrimaryFocus,
          isTrue,
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pump();
        await tester.pump();
        expect(controller.isOpen, isFalse);
        expect(focusNode.hasPrimaryFocus, isTrue);
      });
    }

    testWidgets('Tab reaches the target as one focus stop', (tester) async {
      final controller = MenuController();
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await tester.pumpWidget(
        _host(
          Column(
            children: [
              Focus(
                autofocus: true,
                child: const SizedBox(width: 10, height: 10),
              ),
              _contextMenu(controller: controller, focusNode: focusNode),
            ],
          ),
        ),
      );
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(focusNode.hasPrimaryFocus, isTrue);
    });

    testWidgets('selecting an item closes once, without onCanceled', (
      tester,
    ) async {
      final controller = MenuController();
      final log = _Log();
      await tester.pumpWidget(
        _host(_contextMenu(controller: controller, log: log)),
      );

      await _rightClickAt(tester, const Offset(120, 90));
      await tester.tap(find.text('Delete'));
      await tester.pump();

      expect(controller.isOpen, isFalse);
      expect(log.events, ['open', 'selected:delete', 'close']);
    });

    testWidgets('a primary press on the target or outside closes', (
      tester,
    ) async {
      final controller = MenuController();
      final log = _Log();
      await tester.pumpWidget(
        _host(_contextMenu(controller: controller, log: log)),
      );

      await _rightClickAt(tester, const Offset(120, 90));
      await tester.tapAt(const Offset(300, 220));
      await tester.pump();
      expect(controller.isOpen, isFalse);

      await _rightClickAt(tester, const Offset(120, 90));
      await tester.tapAt(const Offset(700, 500));
      await tester.pump();
      expect(controller.isOpen, isFalse);
      expect(log.events, [
        'open',
        'canceled',
        'close',
        'open',
        'canceled',
        'close',
      ]);
    });

    testWidgets('disabled: nothing opens it and an open menu closes', (
      tester,
    ) async {
      final controller = MenuController();
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await tester.pumpWidget(
        _host(_contextMenu(controller: controller, focusNode: focusNode)),
      );
      await _rightClickAt(tester, const Offset(120, 90));
      expect(controller.isOpen, isTrue);

      await tester.pumpWidget(
        _host(
          _contextMenu(
            controller: controller,
            focusNode: focusNode,
            enabled: false,
          ),
        ),
      );
      await tester.pump();
      expect(controller.isOpen, isFalse);

      await _rightClickAt(tester, const Offset(120, 90));
      await tester.longPressAt(const Offset(120, 90));
      await tester.pump();
      expect(controller.isOpen, isFalse);

      focusNode.requestFocus();
      await tester.pump();
      expect(focusNode.hasFocus, isFalse);
    });

    testWidgets(
      'semantics: the target offers long press, the panel is a menu',
      (tester) async {
        final handle = tester.ensureSemantics();
        final controller = MenuController();
        await tester.pumpWidget(_host(_contextMenu(controller: controller)));

        final target = tester.getSemantics(find.byKey(_targetKey));
        expect(
          target,
          matchesSemantics(
            label: 'Target',
            isFocusable: true,
            hasFocusAction: true,
            hasLongPressAction: true,
          ),
        );

        target.owner!.performAction(target.id, SemanticsAction.longPress);
        await tester.pump();
        expect(controller.isOpen, isTrue);
        expect(
          tester.getTopLeft(find.byKey(_panelKey)),
          tester.getBottomLeft(find.byKey(_targetKey)),
        );

        final item = tester.getSemantics(find.text('Copy'));
        expect(item.role, SemanticsRole.menuItem);
        var menu = item.parent;
        while (menu != null && menu.role != SemanticsRole.menu) {
          menu = menu.parent;
        }
        expect(menu, isNotNull);

        await tester.pumpWidget(
          _host(_contextMenu(controller: controller, enabled: false)),
        );
        await tester.pump();
        expect(
          tester.getSemantics(find.byKey(_targetKey)),
          matchesSemantics(label: 'Target'),
        );
        handle.dispose();
      },
    );
  });

  group('AnchoredOverlay.targetRectOf', () {
    test('uses the anchor rect without a position', () {
      const info = RawMenuOverlayInfo(
        anchorRect: Rect.fromLTWH(10, 20, 100, 40),
        overlaySize: Size(800, 600),
        tapRegionGroupId: Object,
      );
      expect(AnchoredOverlay.targetRectOf(info), info.anchorRect);
    });

    test('is a zero-size rect at the position from the anchor top-left', () {
      const info = RawMenuOverlayInfo(
        anchorRect: Rect.fromLTWH(10, 20, 100, 40),
        overlaySize: Size(800, 600),
        tapRegionGroupId: Object,
        position: Offset(30, 5),
      );
      expect(
        AnchoredOverlay.targetRectOf(info),
        const Rect.fromLTWH(40, 25, 0, 0),
      );
    });
  });
}
