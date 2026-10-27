import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import '../test_helpers.dart';

void main() {
  Widget bar({
    required MenuController file,
    required MenuController edit,
    MenuController? group,
    bool openOnHover = true,
    VoidCallback? onOpen,
    VoidCallback? onClose,
    TextDirection direction = TextDirection.ltr,
    FocusNode? fileNode,
    FocusNode? editNode,
  }) {
    return Directionality(
      textDirection: direction,
      child: NakedMenubar(
        controller: group,
        openOnHover: openOnHover,
        onOpen: onOpen,
        onClose: onClose,
        child: Row(
          children: [
            _menu(
              label: 'File',
              item: 'New',
              controller: file,
              triggerFocusNode: fileNode,
            ),
            _menu(
              label: 'Edit',
              item: 'Copy',
              controller: edit,
              triggerFocusNode: editNode,
            ),
          ],
        ),
      ),
    );
  }

  testWidgets('opening one menu closes the other', (tester) async {
    final file = MenuController();
    final edit = MenuController();
    await tester.pumpMaterialWidget(bar(file: file, edit: edit));

    await tester.tap(find.text('File'));
    await tester.pumpAndSettle();
    expect(find.text('New'), findsOneWidget);
    expect(file.isOpen, isTrue);

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(edit.isOpen, isTrue);
    expect(file.isOpen, isFalse);
    expect(find.text('New'), findsNothing);
    expect(find.text('Copy'), findsOneWidget);
  });

  testWidgets('outside tap and group controller close every menu', (
    tester,
  ) async {
    final file = MenuController();
    final edit = MenuController();
    final group = MenuController();
    await tester.pumpMaterialWidget(bar(file: file, edit: edit, group: group));

    await tester.tap(find.text('File'));
    await tester.pumpAndSettle();
    expect(group.isOpen, isTrue);

    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(group.isOpen, isFalse);
    expect(find.text('New'), findsNothing);

    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    group.close();
    await tester.pumpAndSettle();
    expect(edit.isOpen, isFalse);
  });

  testWidgets('hover switches menus only while one is open', (tester) async {
    final file = MenuController();
    final edit = MenuController();
    await tester.pumpMaterialWidget(bar(file: file, edit: edit));

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    addTearDown(gesture.removePointer);
    await gesture.moveTo(tester.getCenter(find.text('Edit')));
    await tester.pump();
    expect(edit.isOpen, isFalse);

    await tester.tap(find.text('File'));
    await tester.pumpAndSettle();
    await gesture.moveTo(const Offset(0, 0));
    await tester.pump();
    await gesture.moveTo(tester.getCenter(find.text('Edit')));
    await tester.pumpAndSettle();
    expect(edit.isOpen, isTrue);
    expect(file.isOpen, isFalse);
  });

  testWidgets('openOnHover false does not switch menus', (tester) async {
    final file = MenuController();
    final edit = MenuController();
    await tester.pumpMaterialWidget(
      bar(file: file, edit: edit, openOnHover: false),
    );

    await tester.tap(find.text('File'));
    await tester.pumpAndSettle();
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    addTearDown(gesture.removePointer);
    await gesture.moveTo(tester.getCenter(find.text('Edit')));
    await tester.pumpAndSettle();
    expect(file.isOpen, isTrue);
    expect(edit.isOpen, isFalse);
  });

  testWidgets('arrow keys move across the bar and open the focused menu', (
    tester,
  ) async {
    final file = MenuController();
    final edit = MenuController();
    var opens = 0;
    var closes = 0;
    await tester.pumpMaterialWidget(
      bar(
        file: file,
        edit: edit,
        onOpen: () => opens++,
        onClose: () => closes++,
      ),
    );

    await tester.tap(find.text('File'));
    await tester.pumpAndSettle();
    expect(opens, 1);
    expect(closes, 0);

    // Switching menus keeps the bar open: no extra transition.
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(edit.isOpen, isTrue);
    expect(file.isOpen, isFalse);
    expect(opens, 1);
    expect(closes, 0);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(edit.isOpen, isFalse);
    expect(closes, 1);

    // Closed bar: Left/Right only move focus.
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pumpAndSettle();
    expect(file.isOpen, isFalse);
    expect(edit.isOpen, isFalse);

    // Down opens the focused (File) menu.
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(file.isOpen, isTrue);
    expect(edit.isOpen, isFalse);
    expect(opens, 2);
  });

  testWidgets('arrow keys traverse from inside an open panel', (tester) async {
    final file = MenuController();
    final edit = MenuController();
    await tester.pumpMaterialWidget(bar(file: file, edit: edit));

    await tester.tap(find.text('File'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(
      FocusManager.instance.primaryFocus?.debugLabel,
      'NakedButton (internal)',
      reason: 'focus is on the New item inside the File panel',
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(edit.isOpen, isTrue);
    expect(file.isOpen, isFalse);
  });

  group('explicit trigger focus nodes', () {
    late FocusNode fileNode;
    late FocusNode editNode;

    setUp(() {
      fileNode = FocusNode(debugLabel: 'file');
      editNode = FocusNode(debugLabel: 'edit');
    });

    tearDown(() {
      fileNode.dispose();
      editNode.dispose();
    });

    testWidgets('escape and outside tap close the bar', (tester) async {
      final file = MenuController();
      final edit = MenuController();
      await tester.pumpMaterialWidget(
        bar(file: file, edit: edit, fileNode: fileNode, editNode: editNode),
      );

      await tester.tap(find.text('File'));
      await tester.pumpAndSettle();
      expect(file.isOpen, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(file.isOpen, isFalse);
      expect(edit.isOpen, isFalse);
      expect(fileNode.hasFocus, isTrue);

      await tester.tap(find.text('File'));
      await tester.pumpAndSettle();
      expect(file.isOpen, isTrue);

      await tester.tapAt(const Offset(5, 300));
      await tester.pumpAndSettle();
      expect(file.isOpen, isFalse);
      expect(edit.isOpen, isFalse);
    });

    testWidgets('arrow keys and hover switch menus', (tester) async {
      final file = MenuController();
      final edit = MenuController();
      await tester.pumpMaterialWidget(
        bar(file: file, edit: edit, fileNode: fileNode, editNode: editNode),
      );

      await tester.tap(find.text('File'));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pumpAndSettle();
      expect(edit.isOpen, isTrue);
      expect(file.isOpen, isFalse);

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer();
      addTearDown(gesture.removePointer);
      await gesture.moveTo(tester.getCenter(find.text('File')));
      await tester.pumpAndSettle();
      expect(file.isOpen, isTrue);
      expect(edit.isOpen, isFalse);
    });

    testWidgets('swapping a trigger focus node keeps traversal working', (
      tester,
    ) async {
      final file = MenuController();
      final edit = MenuController();
      await tester.pumpMaterialWidget(bar(file: file, edit: edit));
      await tester.pumpMaterialWidget(
        bar(file: file, edit: edit, fileNode: fileNode),
      );

      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(edit.isOpen, isFalse);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
      await tester.pumpAndSettle();
      expect(fileNode.hasFocus, isTrue);
    });
  });

  testWidgets('rtl flips horizontal traversal', (tester) async {
    final file = MenuController();
    final edit = MenuController();
    await tester.pumpMaterialWidget(
      bar(file: file, edit: edit, direction: TextDirection.rtl),
    );

    await tester.tap(find.text('File'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pumpAndSettle();
    expect(edit.isOpen, isTrue);
    expect(file.isOpen, isFalse);
  });

  testWidgets('Home and End move across bar triggers', (tester) async {
    final a = MenuController();
    final b = MenuController();
    final c = MenuController();
    final nodeA = FocusNode(debugLabel: 'a');
    final nodeC = FocusNode(debugLabel: 'c');
    addTearDown(nodeA.dispose);
    addTearDown(nodeC.dispose);

    await tester.pumpMaterialWidget(
      NakedMenubar(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _menu(
              label: 'A',
              item: 'A-item',
              controller: a,
              triggerFocusNode: nodeA,
            ),
            _menu(label: 'B', item: 'B-item', controller: b),
            _menu(
              label: 'C',
              item: 'C-item',
              controller: c,
              triggerFocusNode: nodeC,
            ),
          ],
        ),
      ),
    );
    nodeA.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.end);
    await tester.pump();
    expect(nodeC.hasFocus, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.home);
    await tester.pump();
    expect(nodeA.hasFocus, isTrue);
  });

  group('in a horizontally scrolling bar', () {
    const menuCount = 20;
    const triggerWidth = 100.0;
    const viewportKey = Key('bar viewport');
    late ScrollController scrollController;
    late List<MenuController> controllers;
    late List<FocusNode> triggerNodes;

    setUp(() {
      scrollController = ScrollController();
      controllers = List.generate(menuCount, (_) => MenuController());
      triggerNodes = List.generate(
        menuCount,
        (index) => FocusNode(debugLabel: 'trigger $index'),
      );
    });

    tearDown(() {
      scrollController.dispose();
      for (final node in triggerNodes) {
        node.dispose();
      }
    });

    Future<void> pumpScrollingBar(WidgetTester tester) async {
      await tester.pumpMaterialWidget(
        Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            key: viewportKey,
            width: 3 * triggerWidth,
            height: 48,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              child: NakedMenubar(
                child: Row(
                  children: [
                    for (var index = 0; index < menuCount; index++)
                      NakedMenu<String>(
                        controller: controllers[index],
                        triggerFocusNode: triggerNodes[index],
                        builder: (context, state, child) => SizedBox(
                          key: Key('trigger$index'),
                          width: triggerWidth,
                          height: 48,
                          child: Center(child: Text('Menu $index')),
                        ),
                        overlayBuilder: (context, info) =>
                            NakedMenu.Item<String>(
                              value: 'item$index',
                              child: Text('Item $index'),
                            ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    bool isInViewport(WidgetTester tester, int index) {
      final viewport = tester.getRect(find.byKey(viewportKey));
      final trigger = tester.getRect(find.byKey(Key('trigger$index')));
      return trigger.left >= viewport.left && trigger.right <= viewport.right;
    }

    testWidgets('End focuses the last trigger and scrolls it into view', (
      tester,
    ) async {
      await pumpScrollingBar(tester);
      triggerNodes.first.requestFocus();
      await tester.pump();
      expect(isInViewport(tester, menuCount - 1), isFalse);

      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pumpAndSettle();

      expect(triggerNodes.last.hasPrimaryFocus, isTrue);
      expect(isInViewport(tester, menuCount - 1), isTrue);
    });

    testWidgets('Home focuses the first trigger and scrolls it into view', (
      tester,
    ) async {
      await pumpScrollingBar(tester);
      triggerNodes.last.requestFocus();
      await tester.pump();
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
      await tester.pumpAndSettle();
      expect(isInViewport(tester, 0), isFalse);

      await tester.sendKeyEvent(LogicalKeyboardKey.home);
      await tester.pumpAndSettle();

      expect(triggerNodes.first.hasPrimaryFocus, isTrue);
      expect(isInViewport(tester, 0), isTrue);
    });

    testWidgets(
      'arrow keys from an open menu scroll the next trigger into view',
      (tester) async {
        await pumpScrollingBar(tester);
        await tester.tap(find.byKey(const Key('trigger2')));
        await tester.pumpAndSettle();
        expect(controllers[2].isOpen, isTrue);
        expect(isInViewport(tester, 3), isFalse);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pumpAndSettle();

        expect(isInViewport(tester, 3), isTrue);
        expect(controllers[3].isOpen, isTrue);
        expect(find.text('Item 3'), findsOneWidget);
        final trigger = tester.getRect(find.byKey(const Key('trigger3')));
        final item = tester.getRect(find.text('Item 3'));
        expect(item.left, inInclusiveRange(trigger.left, trigger.right));
        expect(item.top, greaterThanOrEqualTo(trigger.bottom));
        expect(controllers[2].isOpen, isFalse);
      },
    );

    testWidgets('End keeps a scrolled page where it is', (tester) async {
      final pageController = ScrollController();
      addTearDown(pageController.dispose);

      await tester.pumpMaterialWidget(
        SingleChildScrollView(
          controller: pageController,
          child: Column(
            children: [
              const SizedBox(height: 1000),
              NakedMenubar(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var index = 0; index < 3; index++)
                      NakedMenu<String>(
                        controller: controllers[index],
                        triggerFocusNode: triggerNodes[index],
                        builder: (context, state, child) => SizedBox(
                          key: Key('trigger$index'),
                          width: triggerWidth,
                          height: 48,
                          child: Center(child: Text('Menu $index')),
                        ),
                        overlayBuilder: (context, info) =>
                            NakedMenu.Item<String>(
                              value: 'item$index',
                              child: Text('Item $index'),
                            ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 1000),
            ],
          ),
        ),
      );
      pageController.jumpTo(800);
      await tester.pump();
      triggerNodes.first.requestFocus();
      await tester.pump();
      final before = tester.getTopLeft(find.byKey(const Key('trigger2')));

      await tester.sendKeyEvent(LogicalKeyboardKey.end);
      await tester.pumpAndSettle();

      expect(triggerNodes[2].hasPrimaryFocus, isTrue);
      expect(tester.getTopLeft(find.byKey(const Key('trigger2'))), before);
    });
  });

  testWidgets(
    'closed bar menus do not receive onCloseRequested when a sibling opens',
    (tester) async {
      final file = MenuController();
      final edit = MenuController();
      final calls = <String>[];
      Widget menuWithClose(String label, MenuController controller) =>
          NakedMenu<String>(
            controller: controller,
            onCloseRequested: (hide) {
              calls.add('$label(open=${controller.isOpen})');
              hide();
            },
            builder: (context, state, child) =>
                Padding(padding: const EdgeInsets.all(8), child: Text(label)),
            overlayBuilder: (context, info) => NakedMenu.Item<String>(
              value: label,
              child: Text('$label-item'),
            ),
          );

      await tester.pumpMaterialWidget(
        NakedMenubar(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              menuWithClose('File', file),
              menuWithClose('Edit', edit),
            ],
          ),
        ),
      );
      await tester.tap(find.text('File'));
      await tester.pumpAndSettle();
      expect(calls.where((c) => c.endsWith('(open=false)')), isEmpty);

      file.close();
      edit.close();
      await tester.pumpAndSettle();
      expect(calls.where((c) => c.endsWith('(open=false)')), isEmpty);
    },
  );

  testWidgets(
    'animated onCloseRequested in a bar does not close a newly opened menu or steal focus when switching siblings',
    (tester) async {
      final file = MenuController();
      final edit = MenuController();
      final fileNode = FocusNode(debugLabel: 'file');
      final editNode = FocusNode(debugLabel: 'edit');
      addTearDown(fileNode.dispose);
      addTearDown(editNode.dispose);

      Widget animatedMenu(
        String label,
        MenuController controller,
        FocusNode triggerFocusNode,
      ) => NakedMenu<String>(
        controller: controller,
        triggerFocusNode: triggerFocusNode,
        onCloseRequested: (hide) =>
            Future<void>.delayed(const Duration(milliseconds: 50), hide),
        builder: (context, state, child) =>
            Padding(padding: const EdgeInsets.all(8), child: Text(label)),
        overlayBuilder: (context, info) =>
            NakedMenu.Item<String>(value: label, child: Text('$label-item')),
      );

      await tester.pumpMaterialWidget(
        NakedMenubar(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              animatedMenu('File', file, fileNode),
              animatedMenu('Edit', edit, editNode),
            ],
          ),
        ),
      );

      await tester.tap(find.text('File'));
      await tester.pumpAndSettle();
      expect(file.isOpen, isTrue);
      expect(find.text('File-item'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(edit.isOpen, isTrue);
      expect(file.isOpen, isFalse);
      expect(fileNode.hasFocus, isFalse);

      // Closing the last open menu in the bar still restores focus to its trigger.
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(edit.isOpen, isFalse);
      expect(editNode.hasFocus, isTrue);
    },
  );
}

Widget _menu({
  required String label,
  required String item,
  required MenuController controller,
  FocusNode? triggerFocusNode,
}) {
  return NakedMenu<String>(
    controller: controller,
    triggerFocusNode: triggerFocusNode,
    builder: (context, state, child) =>
        Padding(padding: const EdgeInsets.all(8), child: Text(label)),
    overlayBuilder: (context, info) =>
        NakedMenu.Item<String>(value: item, child: Text(item)),
  );
}
