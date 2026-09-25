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
