import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../lib/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('RemixMenuTrigger', () {
    test('creates trigger with label', () {
      const trigger = RemixMenuTrigger(label: 'Options');

      expect(trigger.label, equals('Options'));
      expect(trigger.icon, isNull);
    });

    test('creates trigger with label and icon', () {
      const trigger = RemixMenuTrigger(label: 'Options', icon: Icons.more_vert);

      expect(trigger.label, equals('Options'));
      expect(trigger.icon, equals(Icons.more_vert));
    });
  });

  group('RemixMenuItem', () {
    test('creates menu item with value and label', () {
      const item = RemixMenuItem<String>(value: 'copy', label: 'Copy');

      expect(item.value, equals('copy'));
      expect(item.label, equals('Copy'));
      expect(item.leadingIcon, isNull);
      expect(item.trailingIcon, isNull);
      expect(item.enabled, isTrue);
      expect(item.closeOnActivate, isTrue);
    });

    test('creates menu item with all parameters', () {
      const item = RemixMenuItem<String>(
        value: 'delete',
        label: 'Delete',
        leadingIcon: Icons.delete,
        trailingIcon: Icons.chevron_right,
        enabled: false,
        closeOnActivate: false,
        semanticLabel: 'Delete item',
      );

      expect(item.value, equals('delete'));
      expect(item.label, equals('Delete'));
      expect(item.leadingIcon, equals(Icons.delete));
      expect(item.trailingIcon, equals(Icons.chevron_right));
      expect(item.enabled, isFalse);
      expect(item.closeOnActivate, isFalse);
      expect(item.semanticLabel, equals('Delete item'));
    });

    test('menu item extends RemixMenuItemData', () {
      const item = RemixMenuItem<String>(value: 'test', label: 'Test');

      expect(item, isA<RemixMenuItemData<String>>());
    });
  });

  group('RemixMenuDivider', () {
    test('creates divider', () {
      const divider = RemixMenuDivider<String>();

      expect(divider, isNotNull);
      expect(divider, isA<RemixMenuItemData<String>>());
    });
  });

  group('RemixMenu Basic Rendering', () {
    testWidgets('renders menu with minimal props', (tester) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [RemixMenuItem<String>(value: 'copy', label: 'Copy')],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixMenu<String>), findsOneWidget);
      expect(find.text('Options'), findsOneWidget);
    });

    testWidgets('renders menu with icon in trigger', (tester) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(
            label: 'Options',
            icon: Icons.more_vert,
          ),
          items: const [RemixMenuItem<String>(value: 'copy', label: 'Copy')],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Options'), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('renders menu with multiple items', (tester) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [
            RemixMenuItem<String>(value: 'copy', label: 'Copy'),
            RemixMenuItem<String>(value: 'paste', label: 'Paste'),
            RemixMenuItem<String>(value: 'delete', label: 'Delete'),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixMenu<String>), findsOneWidget);
    });

    testWidgets('renders menu with dividers', (tester) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [
            RemixMenuItem<String>(value: 'copy', label: 'Copy'),
            RemixMenuDivider<String>(),
            RemixMenuItem<String>(value: 'delete', label: 'Delete'),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixMenu<String>), findsOneWidget);
    });

    testWidgets('renders menu items with icons', (tester) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [
            RemixMenuItem<String>(
              value: 'copy',
              label: 'Copy',
              leadingIcon: Icons.copy,
            ),
            RemixMenuItem<String>(
              value: 'paste',
              label: 'Paste',
              leadingIcon: Icons.paste,
              trailingIcon: Icons.chevron_right,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixMenu<String>), findsOneWidget);
    });
  });

  group('RemixMenu Interaction Tests', () {
    testWidgets('menu opens when trigger is tapped', (tester) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [
            RemixMenuItem<String>(value: 'copy', label: 'Copy'),
            RemixMenuItem<String>(value: 'paste', label: 'Paste'),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Tap the trigger
      await tester.tap(find.text('Options'));
      await tester.pumpAndSettle();

      // Menu items should now be visible
      expect(find.text('Copy'), findsOneWidget);
      expect(find.text('Paste'), findsOneWidget);
    });

    testWidgets('onSelected callback fires when item is selected', (
      tester,
    ) async {
      String? selectedValue;

      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [
            RemixMenuItem<String>(value: 'copy', label: 'Copy'),
            RemixMenuItem<String>(value: 'paste', label: 'Paste'),
          ],
          onSelected: (value) => selectedValue = value,
        ),
      );
      await tester.pumpAndSettle();

      // Open the menu
      await tester.tap(find.text('Options'));
      await tester.pumpAndSettle();

      // Tap an item
      await tester.tap(find.text('Copy'));
      await tester.pumpAndSettle();

      expect(selectedValue, equals('copy'));
    });

    testWidgets('onOpen callback fires when menu opens', (tester) async {
      int openCount = 0;

      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [RemixMenuItem<String>(value: 'copy', label: 'Copy')],
          onOpen: () => openCount++,
        ),
      );
      await tester.pumpAndSettle();

      // Open the menu
      await tester.tap(find.text('Options'));
      await tester.pumpAndSettle();

      expect(openCount, equals(1));
    });

    testWidgets('onClose callback fires when menu closes', (tester) async {
      int closeCount = 0;

      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [RemixMenuItem<String>(value: 'copy', label: 'Copy')],
          onClose: () => closeCount++,
        ),
      );
      await tester.pumpAndSettle();

      // Open the menu
      await tester.tap(find.text('Options'));
      await tester.pumpAndSettle();

      // Close by selecting an item
      await tester.tap(find.text('Copy'));
      await tester.pumpAndSettle();

      expect(closeCount, equals(1));
    });

    testWidgets('menu closes when item with closeOnActivate is selected', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [
            RemixMenuItem<String>(
              value: 'copy',
              label: 'Copy',
              closeOnActivate: true,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      // Open the menu
      await tester.tap(find.text('Options'));
      await tester.pumpAndSettle();

      expect(find.text('Copy'), findsOneWidget);

      // Select the item
      await tester.tap(find.text('Copy'));
      await tester.pumpAndSettle();

      // Trigger remains visible after selection
      expect(find.text('Options'), findsOneWidget);
    });

    testWidgets('disabled menu item does not trigger onSelected', (
      tester,
    ) async {
      String? selectedValue;

      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [
            RemixMenuItem<String>(value: 'copy', label: 'Copy', enabled: false),
          ],
          onSelected: (value) => selectedValue = value,
        ),
      );
      await tester.pumpAndSettle();

      // Open the menu
      await tester.tap(find.text('Options'));
      await tester.pumpAndSettle();

      // Try to tap the disabled item
      await tester.tap(find.text('Copy'));
      await tester.pumpAndSettle();

      // onSelected should not have been called
      expect(selectedValue, isNull);
    });
  });

  group('RemixMenu Controller Tests', () {
    testWidgets('uses provided controller', (tester) async {
      final controller = MenuController();

      await tester.pumpRemixApp(
        RemixMenu<String>(
          controller: controller,
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [RemixMenuItem<String>(value: 'copy', label: 'Copy')],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixMenu<String>), findsOneWidget);
    });

    testWidgets('creates default controller when not provided', (tester) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [RemixMenuItem<String>(value: 'copy', label: 'Copy')],
        ),
      );
      await tester.pumpAndSettle();

      // Menu should work without explicit controller
      expect(find.byType(RemixMenu<String>), findsOneWidget);
    });
  });

  group('RemixMenu Focus Tests', () {
    testWidgets('uses provided focus node for trigger', (tester) async {
      final focusNode = FocusNode();
      addTearDown(() => focusNode.dispose());

      await tester.pumpRemixApp(
        RemixMenu<String>(
          triggerFocusNode: focusNode,
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [RemixMenuItem<String>(value: 'copy', label: 'Copy')],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixMenu<String>), findsOneWidget);
    });
  });

  group('RemixMenu Styling Tests', () {
    testWidgets('applies custom style to menu', (tester) async {
      final style = RemixMenuStyle().trigger(
        RemixMenuTriggerStyle().padding(EdgeInsetsGeometryMix.all(20.0)),
      );

      await tester.pumpRemixApp(
        RemixMenu<String>(
          style: style,
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [RemixMenuItem<String>(value: 'copy', label: 'Copy')],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixMenu<String>), findsOneWidget);
    });

    testWidgets('applies custom style to menu items', (tester) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: [
            RemixMenuItem<String>(
              value: 'copy',
              label: 'Copy',
              style: RemixMenuItemStyle().padding(
                EdgeInsetsGeometryMix.all(12.0),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixMenu<String>), findsOneWidget);
    });
  });

  group('RemixMenu Semantics and Accessibility', () {
    testWidgets('menu item has semantic label', (tester) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [
            RemixMenuItem<String>(
              value: 'copy',
              label: 'Copy',
              semanticLabel: 'Copy item',
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixMenu<String>), findsOneWidget);
    });

    testWidgets('menu item uses label as default semantic label', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [RemixMenuItem<String>(value: 'copy', label: 'Copy')],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixMenu<String>), findsOneWidget);
    });
  });

  group('RemixMenu Edge Cases', () {
    testWidgets('renders menu with empty items list', (tester) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixMenu<String>), findsOneWidget);
      expect(find.text('Options'), findsOneWidget);
    });

    testWidgets('renders menu with only dividers', (tester) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [RemixMenuDivider<String>(), RemixMenuDivider<String>()],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixMenu<String>), findsOneWidget);
    });

    testWidgets('handles multiple sequential dividers', (tester) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [
            RemixMenuItem<String>(value: 'copy', label: 'Copy'),
            RemixMenuDivider<String>(),
            RemixMenuDivider<String>(),
            RemixMenuItem<String>(value: 'paste', label: 'Paste'),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixMenu<String>), findsOneWidget);
    });
  });

  group('RemixMenu Positioning Tests', () {
    testWidgets('applies custom positioning config', (tester) async {
      const positioning = OverlayPositionConfig(
        targetAnchor: Alignment.bottomLeft,
        followerAnchor: Alignment.topLeft,
      );

      await tester.pumpRemixApp(
        RemixMenu<String>(
          positioning: positioning,
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [RemixMenuItem<String>(value: 'copy', label: 'Copy')],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixMenu<String>), findsOneWidget);
    });
  });

  group('RemixMenu Configuration Tests', () {
    testWidgets('respects closeOnClickOutside flag', (tester) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          closeOnClickOutside: true,
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [RemixMenuItem<String>(value: 'copy', label: 'Copy')],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixMenu<String>), findsOneWidget);
    });

    testWidgets('respects consumeOutsideTaps flag', (tester) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          consumeOutsideTaps: false,
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [RemixMenuItem<String>(value: 'copy', label: 'Copy')],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixMenu<String>), findsOneWidget);
    });

    testWidgets('respects useRootOverlay flag', (tester) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          useRootOverlay: true,
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [RemixMenuItem<String>(value: 'copy', label: 'Copy')],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixMenu<String>), findsOneWidget);
    });
  });

  group('RemixMenu Type Safety', () {
    testWidgets('menu works with int type', (tester) async {
      int? selectedValue;

      await tester.pumpRemixApp(
        RemixMenu<int>(
          trigger: const RemixMenuTrigger(label: 'Numbers'),
          items: const [
            RemixMenuItem<int>(value: 1, label: 'One'),
            RemixMenuItem<int>(value: 2, label: 'Two'),
          ],
          onSelected: (value) => selectedValue = value,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Numbers'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('One'));
      await tester.pumpAndSettle();

      expect(selectedValue, equals(1));
    });

    testWidgets('menu works with custom enum type', (tester) async {
      MenuAction? selectedValue;

      await tester.pumpRemixApp(
        RemixMenu<MenuAction>(
          trigger: const RemixMenuTrigger(label: 'Actions'),
          items: const [
            RemixMenuItem<MenuAction>(value: MenuAction.copy, label: 'Copy'),
            RemixMenuItem<MenuAction>(value: MenuAction.paste, label: 'Paste'),
          ],
          onSelected: (value) => selectedValue = value,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Actions'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Copy'));
      await tester.pumpAndSettle();

      expect(selectedValue, equals(MenuAction.copy));
    });
  });
}

// Test enum for type safety testing
enum MenuAction { copy, paste, delete }
