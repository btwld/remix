import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import '../test_helpers.dart';
import 'helpers/builder_state_scope.dart';

extension _NakedMenuTester on WidgetTester {
  Future<void> pressEsc() async {
    await sendKeyEvent(LogicalKeyboardKey.escape);
    await pumpAndSettle();
  }

  Future<void> tapOutsideMenu() async {
    await tapAt(const Offset(10, 10));
    await pump();
  }
}

void main() {
  group('NakedMenu', () {
    group('Basic Functionality', () {
      NakedMenu<String> buildBasicMenu(MenuController controller) {
        return NakedMenu<String>(
          controller: controller,
          builder: (context, state, child) => const Text('child'),
          overlayBuilder: (context, info) => const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NakedMenuItem<String>(value: 'menu', child: Text('Menu Content')),
            ],
          ),
        );
      }

      testWidgets('Renders child widget', (WidgetTester tester) async {
        final controller = MenuController();
        await tester.pumpMaterialWidget(buildBasicMenu(controller));

        expect(find.text('child'), findsOneWidget);
        expect(find.text('Menu Content'), findsNothing);
      });

      testWidgets('Renders menu content when open', (
        WidgetTester tester,
      ) async {
        final controller = MenuController();
        await tester.pumpMaterialWidget(buildBasicMenu(controller));
        controller.open();
        await tester.pump();

        expect(find.text('child'), findsOneWidget);
        expect(find.text('Menu Content'), findsOneWidget);
      });

      testWidgets('Opens when controller.show() is called', (
        WidgetTester tester,
      ) async {
        final controller = MenuController();

        await tester.pumpMaterialWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  NakedButton(
                    onPressed: () => controller.open(),
                    child: const Text('Open Menu'),
                  ),
                  NakedMenu<String>(
                    controller: controller,
                    builder: (context, state, child) => const Text('child'),
                    overlayBuilder: (context, info) => const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        NakedMenuItem<String>(
                          value: 'menu',
                          child: Text('Menu Content'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );

        expect(find.text('Menu Content'), findsNothing);
        await tester.tap(find.text('Open Menu'));
        await tester.pumpAndSettle();
        expect(find.text('Menu Content'), findsOneWidget);
      });

      testWidgets('Places menu according to menuAlignment parameter', (
        WidgetTester tester,
      ) async {
        final controller = MenuController();
        const trigger = Key('trigger');
        const menu = Key('menu');
        await tester.pumpMaterialWidget(
          Center(
            child: NakedMenu<String>(
              controller: controller,
              builder: (context, state, child) => Container(
                key: trigger,
                width: 100,
                height: 40,
                color: Colors.blue,
                child: const Center(child: Text('child')),
              ),
              overlayBuilder: (context, info) => Column(
                key: menu,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  NakedMenuItem<String>(
                    value: 'menu',
                    child: SizedBox(
                      width: 200,
                      height: 100,
                      child: Center(child: Text('Menu Content')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        controller.open();

        await tester.pump();
        expect(find.byKey(menu), findsOneWidget);

        // Get the positions of the trigger and menu
        final triggerBottomLeft = tester.getBottomLeft(find.byKey(trigger));
        final menuTopLeft = tester.getTopLeft(find.byKey(menu));

        // Menu should be positioned below the trigger (or above if near bottom)
        expect(menuTopLeft.dy, triggerBottomLeft.dy);

        // Get the positions of the trigger and menu
        final triggerLeft = tester.getTopLeft(find.byKey(trigger));
        final menuLeft = tester.getTopLeft(find.byKey(menu));

        // Menu should be left-aligned with trigger (current behavior)
        expect(menuLeft.dx, triggerLeft.dx);
      });

      testStateScopeBuilder<NakedMenuState>(
        'builder\'s context contains NakedStateScope',
        (builder) => NakedMenu<String>(
          controller: MenuController(),
          builder: builder,
          overlayBuilder: (BuildContext context, RawMenuOverlayInfo info) =>
              SizedBox(),
        ),
      );
    });

    group('State Management', () {
      testWidgets('calls onMenuClose when Escape key pressed', (
        WidgetTester tester,
      ) async {
        bool onMenuCloseCalled = false;

        final controller = MenuController();
        await tester.pumpMaterialWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return NakedMenu<String>(
                onClose: () => onMenuCloseCalled = true,
                controller: controller,
                builder: (context, state, child) => const Text('child'),
                overlayBuilder: (context, info) => const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NakedMenuItem<String>(
                      value: 'menu',
                      child: Text('Menu Content'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
        controller.open();

        await tester.pumpAndSettle();
        expect(find.text('Menu Content'), findsOneWidget);

        await tester.pressEsc();
        await tester.pumpAndSettle();
        expect(onMenuCloseCalled, true);
      });

      testWidgets(
        'calls onMenuClose when menu item is selected (default behavior)',
        (WidgetTester tester) async {
          bool onMenuCloseCalled = false;
          final controller = MenuController();
          String? selectedValue;

          await tester.pumpMaterialWidget(
            NakedMenu<String>(
              controller: controller,
              onClose: () => onMenuCloseCalled = true,
              onSelected: (value) => selectedValue = value,
              builder: (context, state, child) => const Text('Menu trigger'),
              overlayBuilder: (context, info) => const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NakedMenuItem<String>(value: 'item1', child: Text('Item 1')),
                  NakedMenuItem<String>(value: 'item2', child: Text('Item 2')),
                ],
              ),
            ),
          );

          // Open menu
          controller.open();
          await tester.pumpAndSettle();

          expect(find.text('Item 1'), findsOneWidget);
          expect(onMenuCloseCalled, false);

          // Select an item - should close menu by default
          await tester.tap(find.text('Item 1'));
          await tester.pumpAndSettle();

          expect(onMenuCloseCalled, true);
          expect(selectedValue, 'item1');
          expect(find.text('Item 1'), findsNothing); // Menu should be closed
        },
      );
      testWidgets(
        'keeps menu open when closeOnActivate is false on menu item',
        (WidgetTester tester) async {
          bool onMenuCloseCalled = false;
          const menuKey = Key('menu');
          const item1Key = Key('item1');
          final controller = MenuController();

          await tester.pumpMaterialWidget(
            NakedMenu<String>(
              controller: controller,
              onClose: () => onMenuCloseCalled = true,
              overlayBuilder: (context, info) => Container(
                key: menuKey,
                constraints: const BoxConstraints(
                  maxWidth: 100,
                  maxHeight: 100,
                ),
                child: const NakedMenuItem<String>(
                  key: item1Key,
                  value: 'item1',
                  closeOnActivate: false,
                  child: Text('Item 1'),
                ),
              ),
              builder: (context, state, child) => const Text('child'),
            ),
          );

          controller.open();

          await tester.pump();
          expect(find.byKey(menuKey), findsOneWidget);

          await tester.tap(find.text('Item 1'));
          await tester.pumpAndSettle();

          // Menu should still be open since closeOnActivate is false
          expect(onMenuCloseCalled, false);
          expect(find.byKey(menuKey), findsOneWidget);
        },
      );
    });
    group('Keyboard Interaction', () {
      testWidgets('Traps focus within menu when opens', (
        WidgetTester tester,
      ) async {
        // Remove unused variables
        final controller = MenuController();
        await tester.pumpMaterialWidget(
          Center(
            child: NakedMenu<String>(
              controller: controller,
              overlayBuilder: (context, info) => const Column(
                children: [
                  NakedMenuItem<String>(value: 'item1', child: Text('Item 1')),
                  NakedMenuItem<String>(value: 'item2', child: Text('Item 2')),
                ],
              ),
              builder: (context, state, child) => const Text('child'),
            ),
          ),
        );

        controller.open();

        await tester.pump();
        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();

        // Menu items should still be visible after tab navigation
        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
      });

      testWidgets('Home and End stay within the open menu', (tester) async {
        final controller = MenuController();
        final before = FocusNode(debugLabel: 'before menu');
        final after = FocusNode(debugLabel: 'after menu');
        addTearDown(before.dispose);
        addTearDown(after.dispose);
        var firstFocused = false;
        var lastFocused = false;

        await tester.pumpMaterialWidget(
          Column(
            children: [
              Focus(focusNode: before, child: const SizedBox(height: 20)),
              NakedMenu<String>(
                controller: controller,
                builder: (context, state, child) => const Text('Open'),
                overlayBuilder: (context, info) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NakedMenuItem<String>(
                      value: 'first',
                      builder: (context, state, child) {
                        firstFocused = state.isFocused;
                        return child!;
                      },
                      child: const Text('First'),
                    ),
                    const NakedMenuItem<String>(
                      value: 'middle',
                      child: Text('Middle'),
                    ),
                    NakedMenuItem<String>(
                      value: 'last',
                      builder: (context, state, child) {
                        lastFocused = state.isFocused;
                        return child!;
                      },
                      child: const Text('Last'),
                    ),
                  ],
                ),
              ),
              Focus(focusNode: after, child: const SizedBox(height: 20)),
            ],
          ),
        );

        controller.open();
        await tester.pumpAndSettle();

        await tester.sendKeyEvent(LogicalKeyboardKey.home);
        await tester.pump();
        expect(firstFocused, isTrue);
        expect(before.hasFocus, isFalse);

        await tester.sendKeyEvent(LogicalKeyboardKey.end);
        await tester.pump();
        expect(lastFocused, isTrue);
        expect(after.hasFocus, isFalse);
      });
    });

    group('Structured items and submenus', () {
      testWidgets('checkbox and radio items update controlled values', (
        tester,
      ) async {
        final controller = MenuController();
        bool? checkboxValue;
        String? radioValue;

        await tester.pumpMaterialWidget(
          NakedMenu<String>(
            controller: controller,
            builder: (context, state, child) => const Text('Open'),
            overlayBuilder: (context, info) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                NakedMenuCheckboxItem<String>(
                  value: 'notifications',
                  checked: false,
                  closeOnActivate: false,
                  onChanged: (value) => checkboxValue = value,
                  child: const Text('Notifications'),
                ),
                NakedMenuRadioGroup<String>(
                  value: 'compact',
                  onChanged: (value) => radioValue = value,
                  child: const NakedMenuRadioItem<String>(
                    value: 'comfortable',
                    closeOnActivate: false,
                    child: Text('Comfortable'),
                  ),
                ),
              ],
            ),
          ),
        );
        controller.open();
        await tester.pumpAndSettle();

        await tester.tap(find.text('Notifications'));
        await tester.tap(find.text('Comfortable'));

        expect(checkboxValue, isTrue);
        expect(radioValue, 'comfortable');
        expect(controller.isOpen, isTrue);
      });

      testWidgets('hover opens a submenu only after its delay', (tester) async {
        final controller = MenuController();
        await tester.pumpMaterialWidget(
          NakedMenu<String>(
            controller: controller,
            builder: (context, state, child) => const Text('Open'),
            overlayBuilder: (context, info) => const NakedMenuSubmenu<String>(
              hoverDelay: Duration(milliseconds: 100),
              child: SizedBox(width: 120, height: 40, child: Text('More')),
              overlayBuilder: _submenuContent,
            ),
          ),
        );
        controller.open();
        await tester.pumpAndSettle();

        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: Offset.zero);
        addTearDown(mouse.removePointer);
        await mouse.moveTo(tester.getCenter(find.text('More')));
        await tester.pump(const Duration(milliseconds: 99));
        expect(find.text('Child item'), findsNothing);

        await tester.pump(const Duration(milliseconds: 1));
        await tester.pump();
        expect(find.text('Child item'), findsOneWidget);
      });

      testWidgets('keyboard opens, closes, and restores submenu focus', (
        tester,
      ) async {
        final controller = MenuController();
        final submenuFocus = FocusNode();
        addTearDown(submenuFocus.dispose);

        await tester.pumpMaterialWidget(
          NakedMenu<String>(
            controller: controller,
            builder: (context, state, child) => const Text('Open'),
            overlayBuilder: (context, info) => NakedMenuSubmenu<String>(
              focusNode: submenuFocus,
              child: const SizedBox(
                width: 120,
                height: 40,
                child: Text('More'),
              ),
              overlayBuilder: _submenuContent,
            ),
          ),
        );
        controller.open();
        await tester.pumpAndSettle();
        submenuFocus.requestFocus();
        await tester.pump();

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pumpAndSettle();
        expect(find.text('Child item'), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(find.text('Child item'), findsNothing);
        expect(find.text('More'), findsOneWidget);
        expect(submenuFocus.hasFocus, isTrue);
      });

      testWidgets('submenu direction handoff follows RTL', (tester) async {
        final controller = MenuController();
        final submenuFocus = FocusNode();
        addTearDown(submenuFocus.dispose);

        await tester.pumpMaterialWidget(
          Directionality(
            textDirection: TextDirection.rtl,
            child: NakedMenu<String>(
              controller: controller,
              builder: (context, state, child) => const Text('Open'),
              overlayBuilder: (context, info) => NakedMenuSubmenu<String>(
                focusNode: submenuFocus,
                child: const SizedBox(
                  width: 120,
                  height: 40,
                  child: Text('More'),
                ),
                overlayBuilder: _submenuContent,
              ),
            ),
          ),
        );
        controller.open();
        await tester.pumpAndSettle();
        submenuFocus.requestFocus();
        await tester.pump();

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
        await tester.pumpAndSettle();
        expect(find.text('Child item'), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pumpAndSettle();
        expect(find.text('Child item'), findsNothing);
        expect(submenuFocus.hasFocus, isTrue);
      });

      testWidgets('activating a nested item closes the root menu', (
        tester,
      ) async {
        final controller = MenuController();
        String? selected;
        await tester.pumpMaterialWidget(
          NakedMenu<String>(
            controller: controller,
            onSelected: (value) => selected = value,
            builder: (context, state, child) => const Text('Open'),
            overlayBuilder: (context, info) => const NakedMenuSubmenu<String>(
              child: SizedBox(width: 120, height: 40, child: Text('More')),
              overlayBuilder: _submenuContent,
            ),
          ),
        );
        controller.open();
        await tester.pumpAndSettle();
        await tester.tap(find.text('More'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Child item'));
        await tester.pumpAndSettle();

        expect(selected, 'child');
        expect(controller.isOpen, isFalse);
        expect(find.text('More'), findsNothing);
      });

      testWidgets('submenus can recurse with keyboard handoff', (tester) async {
        final controller = MenuController();
        final outerFocus = FocusNode();
        final innerFocus = FocusNode();
        addTearDown(outerFocus.dispose);
        addTearDown(innerFocus.dispose);

        await tester.pumpMaterialWidget(
          NakedMenu<String>(
            controller: controller,
            builder: (context, state, child) => const Text('Open'),
            overlayBuilder: (context, info) => NakedMenuSubmenu<String>(
              focusNode: outerFocus,
              child: const SizedBox(
                width: 120,
                height: 40,
                child: Text('More'),
              ),
              overlayBuilder: (context, info) => NakedMenuSubmenu<String>(
                focusNode: innerFocus,
                child: const SizedBox(
                  width: 120,
                  height: 40,
                  child: Text('Even more'),
                ),
                overlayBuilder: (context, info) => const NakedMenuItem<String>(
                  value: 'grandchild',
                  child: SizedBox(height: 40, child: Text('Grandchild item')),
                ),
              ),
            ),
          ),
        );
        controller.open();
        await tester.pumpAndSettle();
        outerFocus.requestFocus();
        await tester.pump();

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pumpAndSettle();
        expect(find.text('Even more'), findsOneWidget);
        expect(innerFocus.hasFocus, isTrue);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
        await tester.pumpAndSettle();
        expect(find.text('Grandchild item'), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(find.text('Grandchild item'), findsNothing);
        expect(find.text('Even more'), findsOneWidget);
        expect(innerFocus.hasFocus, isTrue);
      });
    });
  });

  group('NakedMenuContent', () {
    testWidgets('Renders child widget(s)', (WidgetTester tester) async {
      await tester.pumpMaterialWidget(const Text('Menu Content'));

      expect(find.text('Menu Content'), findsOneWidget);
    });

    testWidgets(
      'calls onMenuClose when clicking outside (if consumeOutsideTaps is true)',
      (WidgetTester tester) async {
        bool onMenuCloseCalled = false;

        final controller = MenuController();

        await tester.pumpMaterialWidget(
          StatefulBuilder(
            builder: (context, setState) {
              return Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 10,
                    child: GestureDetector(
                      onTap: () {},
                      child: const SizedBox(
                        width: 50,
                        height: 50,
                        child: ColoredBox(color: Colors.red),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    left: 100,
                    child: NakedMenu(
                      controller: controller,
                      onClose: () => onMenuCloseCalled = true,
                      consumeOutsideTaps: true,
                      overlayBuilder: (context, info) => const SizedBox(
                        width: 100,
                        height: 50,
                        child: Center(child: Text('Menu Content')),
                      ),
                      builder: (context, state, child) => const Text('child'),
                    ),
                  ),
                ],
              );
            },
          ),
        );
        controller.open();

        await tester.pump();
        expect(find.text('Menu Content'), findsOneWidget);

        // Tap outside the menu
        await tester.tapOutsideMenu();
        expect(onMenuCloseCalled, true);
      },
    );

    group('Audit Regression Tests (1.2.0)', () {
      testWidgets(
        'hover-opened submenu: Escape returns focus to submenu trigger',
        (tester) async {
          final controller = MenuController();
          final submenuFocus = FocusNode(debugLabel: 'submenu');
          addTearDown(submenuFocus.dispose);

          await tester.pumpMaterialWidget(
            Align(
              alignment: Alignment.topLeft,
              child: NakedMenu<String>(
                controller: controller,
                builder: (context, state, child) => const Text('Open'),
                overlayBuilder: (context, info) => NakedMenuSubmenu<String>(
                  focusNode: submenuFocus,
                  overlayBuilder: _submenuContent,
                  child: const SizedBox(
                    width: 120,
                    height: 30,
                    child: Text('More'),
                  ),
                ),
              ),
            ),
          );
          controller.open();
          await tester.pumpAndSettle();

          final mouse = await tester.createGesture(
            kind: PointerDeviceKind.mouse,
          );
          await mouse.addPointer(location: const Offset(700, 500));
          addTearDown(mouse.removePointer);
          await mouse.moveTo(tester.getCenter(find.text('More')));
          await tester.pump(const Duration(milliseconds: 150));
          await tester.pumpAndSettle();
          expect(find.text('Child item'), findsOneWidget);
          expect(submenuFocus.hasFocus, isFalse);

          await tester.sendKeyEvent(LogicalKeyboardKey.escape);
          await tester.pumpAndSettle();
          expect(find.text('Child item'), findsNothing);
          expect(submenuFocus.hasFocus, isTrue);
        },
      );

      testWidgets('submenu closing with focus elsewhere does not steal focus', (
        tester,
      ) async {
        final controller = MenuController();
        final submenuFocus = FocusNode(debugLabel: 'submenu');
        final elsewhere = FocusNode(debugLabel: 'elsewhere');
        addTearDown(submenuFocus.dispose);
        addTearDown(elsewhere.dispose);

        await tester.pumpMaterialWidget(
          Align(
            alignment: Alignment.topLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NakedMenu<String>(
                  controller: controller,
                  builder: (context, state, child) => const Text('Open'),
                  overlayBuilder: (context, info) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const NakedMenuItem<String>(
                        value: 'a',
                        child: SizedBox(
                          width: 120,
                          height: 30,
                          child: Text('A'),
                        ),
                      ),
                      NakedMenuSubmenu<String>(
                        focusNode: submenuFocus,
                        overlayBuilder: _submenuContent,
                        child: const SizedBox(
                          width: 120,
                          height: 30,
                          child: Text('More'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 400),
                Focus(focusNode: elsewhere, child: const Text('Elsewhere')),
              ],
            ),
          ),
        );
        controller.open();
        await tester.pumpAndSettle();

        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: const Offset(700, 500));
        addTearDown(mouse.removePointer);
        await mouse.moveTo(tester.getCenter(find.text('More')));
        await tester.pump(const Duration(milliseconds: 150));
        await tester.pumpAndSettle();
        expect(find.text('Child item'), findsOneWidget);

        elsewhere.requestFocus();
        await tester.pump();
        await mouse.moveTo(tester.getCenter(find.text('A')));
        await tester.pump(const Duration(milliseconds: 150));
        await tester.pumpAndSettle();
        expect(find.text('Child item'), findsNothing);
        expect(elsewhere.hasFocus, isTrue);
      });

      testWidgets('Arrow Down and Up move through items and wrap', (
        tester,
      ) async {
        final controller = MenuController();
        final focused = <String>[];
        Widget item(String value) => NakedMenuItem<String>(
          value: value,
          builder: (context, state, child) {
            if (state.isFocused && (focused.isEmpty || focused.last != value)) {
              focused.add(value);
            }
            return child!;
          },
          child: SizedBox(height: 30, width: 100, child: Text(value)),
        );

        await tester.pumpMaterialWidget(
          Align(
            alignment: Alignment.topLeft,
            child: NakedMenu<String>(
              controller: controller,
              builder: (context, state, child) => const Text('Open'),
              overlayBuilder: (context, info) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [item('one'), item('two'), item('three')],
              ),
            ),
          ),
        );
        controller.open();
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pump();
        expect(focused, ['one', 'two']);

        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();
        expect(focused.last, 'three');
      });

      testWidgets(
        'closeOnClickOutside false keeps the menu open on outside tap',
        (tester) async {
          final controller = MenuController();
          await tester.pumpMaterialWidget(
            Align(
              alignment: Alignment.topLeft,
              child: NakedMenu<String>(
                controller: controller,
                closeOnClickOutside: false,
                builder: (context, state, child) => const Text('Open'),
                overlayBuilder: (context, info) => const NakedMenuItem<String>(
                  value: 'x',
                  child: SizedBox(height: 30, width: 100, child: Text('X')),
                ),
              ),
            ),
          );
          controller.open();
          await tester.pumpAndSettle();
          await tester.tapAt(const Offset(700, 500));
          await tester.pumpAndSettle();
          expect(controller.isOpen, isTrue);

          await tester.sendKeyEvent(LogicalKeyboardKey.escape);
          await tester.pumpAndSettle();
          expect(controller.isOpen, isFalse);
        },
      );

      testWidgets('onCloseRequested sees Escape, outside tap, and selection', (
        tester,
      ) async {
        final controller = MenuController();
        var requests = 0;
        await tester.pumpMaterialWidget(
          Align(
            alignment: Alignment.topLeft,
            child: NakedMenu<String>(
              controller: controller,
              onCloseRequested: (hide) {
                requests++;
                hide();
              },
              builder: (context, state, child) => const Text('Open'),
              overlayBuilder: (context, info) => const NakedMenuItem<String>(
                value: 'x',
                child: SizedBox(height: 30, width: 100, child: Text('X')),
              ),
            ),
          ),
        );
        controller.open();
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(requests, 1);

        controller.open();
        await tester.pumpAndSettle();
        await tester.tapAt(const Offset(700, 500));
        await tester.pumpAndSettle();
        expect(requests, 2);

        controller.open();
        await tester.pumpAndSettle();
        await tester.tap(find.text('X'));
        await tester.pumpAndSettle();
        expect(requests, 3);
        expect(controller.isOpen, isFalse);
      });

      testWidgets('submenu opens to the right of its trigger by default', (
        tester,
      ) async {
        final controller = MenuController();
        await tester.pumpMaterialWidget(
          Align(
            alignment: Alignment.topLeft,
            child: NakedMenu<String>(
              controller: controller,
              builder: (context, state, child) => const Text('Open'),
              overlayBuilder: (context, info) => const NakedMenuSubmenu<String>(
                overlayBuilder: _submenuContent,
                child: SizedBox(width: 120, height: 30, child: Text('More')),
              ),
            ),
          ),
        );
        controller.open();
        await tester.pumpAndSettle();
        await tester.tap(find.text('More'));
        await tester.pumpAndSettle();
        final trigger = tester.getRect(find.text('More'));
        final child = tester.getRect(find.text('Child item'));
        expect(child.left, greaterThanOrEqualTo(trigger.right));
      });

      testWidgets('onOpenRequested can defer showing the overlay', (
        tester,
      ) async {
        final controller = MenuController();
        VoidCallback? show;
        await tester.pumpMaterialWidget(
          Align(
            alignment: Alignment.topLeft,
            child: NakedMenu<String>(
              controller: controller,
              onOpenRequested: (position, showOverlay) => show = showOverlay,
              builder: (context, state, child) => const Text('Open'),
              overlayBuilder: (context, info) => const NakedMenuItem<String>(
                value: 'x',
                child: SizedBox(height: 30, width: 100, child: Text('X')),
              ),
            ),
          ),
        );
        controller.open();
        await tester.pumpAndSettle();
        expect(find.text('X'), findsNothing);
        show!();
        await tester.pumpAndSettle();
        expect(find.text('X'), findsOneWidget);
      });

      testWidgets('useRootOverlay mounts the panel in the root overlay', (
        tester,
      ) async {
        final controller = MenuController();
        OverlayState? nearest;
        OverlayState? root;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Overlay(
                initialEntries: [
                  OverlayEntry(
                    builder: (context) => Align(
                      alignment: Alignment.topLeft,
                      child: Builder(
                        builder: (context) {
                          nearest = Overlay.of(context);
                          root = Overlay.of(context, rootOverlay: true);
                          return NakedMenu<String>(
                            controller: controller,
                            useRootOverlay: true,
                            builder: (context, state, child) =>
                                const Text('Open'),
                            overlayBuilder: (context, info) =>
                                const NakedMenuItem<String>(
                                  value: 'x',
                                  child: SizedBox(
                                    height: 30,
                                    width: 100,
                                    child: Text('X'),
                                  ),
                                ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        controller.open();
        await tester.pumpAndSettle();
        expect(nearest, isNot(same(root)));
        final innerTheatre = nearest!.context.findRenderObject();
        RenderObject? parent = tester.renderObject(find.text('X'));
        var inInner = false;
        while (parent != null) {
          if (identical(parent, innerTheatre)) inInner = true;
          parent = parent.parent;
        }
        expect(inInner, isFalse);
      });
    });
  });

  // NakedMenuItem functionality is tested as part of NakedMenu tests above
  // since NakedMenuItem requires the menu scope to function properly.
  // See tests like "calls onMenuClose when menu item is selected" and
  // "keeps menu open when closeOnActivate is false on menu item".
}

Widget _submenuContent(BuildContext context, RawMenuOverlayInfo info) =>
    const SizedBox(
      width: 140,
      child: NakedMenuItem<String>(
        value: 'child',
        child: SizedBox(height: 40, child: Text('Child item')),
      ),
    );
