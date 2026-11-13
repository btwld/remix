import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:registry_source/src/dashboard/dashboard_demo_base.dart';
import 'package:registry_source/src/dashboard/dashboard_demo_records.dart';
import 'package:registry_source/src/dashboard/dashboard_sample_data.dart';
import 'package:registry_source/src/default/components/icon_button.dart';
import 'package:registry_source/src/default/components/menu.dart';
import 'package:registry_source/src/default/components/popover.dart';
import 'package:registry_source/src/default/recipes/dashboard/dashboard_demo.dart';
import 'package:registry_source/src/default/recipes/dashboard/dashboard_demo_settings.dart';
import 'package:registry_source/src/default/recipes/dashboard/dashboard_overview.dart';
import 'package:registry_source/src/default/theme/theme_data.dart';
import 'package:registry_source/src/default/theme/theme_scope.dart';
import 'package:registry_source/src/default/theme/tokens.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_settings.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_theme.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_overview.dart';
import 'package:registry_source/src/fortal/theme/theme.dart';
import 'package:registry_source/src/heroui/components/button.dart';
import 'package:registry_source/src/heroui/components/dropdown.dart';
import 'package:registry_source/src/heroui/components/popover.dart';
import 'package:registry_source/src/heroui/recipes/dashboard/dashboard_demo.dart';
import 'package:registry_source/src/heroui/recipes/dashboard/dashboard_demo_settings.dart';
import 'package:registry_source/src/heroui/recipes/dashboard/dashboard_overview.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';
import 'package:remix/src/utilities/remix_path_icon.dart';

enum _Preset { defaultPreset, fortal, heroui }

void main() {
  test('currency uses one format with thousands separators', () {
    expect(registryDashboardCurrency(1249), r'$1,249.00');
    expect(registryDashboardCurrency(64), r'$64.00');
    expect(registryDashboardCurrency(3200.5), r'$3,200.50');
    expect(registryDashboardCurrency(1234567), r'$1,234,567.00');
  });

  test('overview records match the Orders page records', () {
    for (final record in registryDashboardSampleData.records) {
      final order = registryDashboardOrders.firstWhere(
        (order) => order.id == record.id,
      );
      expect(record.customer, order.customer);
      expect(record.amount, registryDashboardCurrency(order.amount));
    }
  });

  test('shared dashboard contract matches the Fortal sample inventory', () {
    expect(RegistryDashboardDemoPage.values.map((page) => page.name), [
      'overview',
      'chat',
      'customers',
      'orders',
      'settings',
    ]);
    expect(
      registryDashboardDemoSectionIds.keys,
      RegistryDashboardDemoPage.values,
    );
    expect(registryDashboardDemoSectionIds.values, everyElement(isNotEmpty));
    expect(registryDashboardCustomers, hasLength(24));
    expect(registryDashboardOrders, hasLength(30));
  });

  testWidgets('alert notification uses the sample event title', (tester) async {
    await _pumpDashboard(tester, preset: .fortal);
    await tester.tap(find.bySemanticsLabel('Notifications').first);
    await tester.pump();

    expect(
      find.descendant(
        of: find.byKey(const ValueKey('topbar-notifications-content')),
        matching: find.text('Inventory alert'),
      ),
      findsOneWidget,
    );
    expect(find.text('Order ORD-1047 requires review.'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('an order row opens its actions from a real icon button', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _pumpDashboard(
      tester,
      preset: .defaultPreset,
      initialPage: RegistryDashboardDemoPage.orders,
    );
    const label = 'Actions for ORD-1048';
    final button = find.byWidgetPredicate(
      (widget) => widget is VanillaIconButton && widget.semanticLabel == label,
    );
    expect(button, findsOneWidget);
    final menu = find.ancestor(
      of: button,
      matching: find.byType(VanillaMenu<String>),
    );

    Color? fill() => _fillOf(_specOf(tester, button));

    final muted = VanillaTheme.of(tester.element(button)).muted;

    expect(find.semantics.byLabel(label), findsOne);
    expect(_focusStops(tester, menu), 1);
    expect(fill(), isNot(muted));
    expect(
      tester.getSemantics(button),
      isSemantics(
        label: label,
        isButton: true,
        isFocusable: true,
        hasEnabledState: true,
        isEnabled: true,
        hasExpandedState: true,
        isExpanded: false,
      ),
    );

    await tester.tap(button);
    await tester.pumpAndSettle();

    expect(find.text('Archive'), findsOneWidget);
    expect(
      fill(),
      muted,
      reason: 'the button is filled while its menu is open',
    );
    expect(
      tester.getSemantics(button),
      isSemantics(label: label, hasExpandedState: true, isExpanded: true),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.text('Archive'), findsNothing);
    expect(fill(), isNot(muted), reason: 'the fill goes with the menu');
    expect(
      tester.getSemantics(button),
      isSemantics(label: label, isFocused: true),
    );
    semantics.dispose();
  });

  for (final dark in const [false, true]) {
    testWidgets('the open kebab keeps its look under the pointer in '
        '${dark ? 'dark' : 'light'}', (tester) async {
      await _pumpDashboard(
        tester,
        preset: .defaultPreset,
        initialPage: RegistryDashboardDemoPage.orders,
      );
      if (dark) {
        await tester.tap(
          find.byKey(const ValueKey('dashboard-appearance-toggle')).first,
        );
        await tester.pumpAndSettle();
      }
      final button = find.byWidgetPredicate(
        (widget) =>
            widget is VanillaIconButton &&
            widget.semanticLabel == 'Actions for ORD-1048',
      );
      final theme = VanillaTheme.of(tester.element(button));
      expect(theme.brightness, dark ? Brightness.dark : Brightness.light);

      final pointer = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(pointer.removePointer);
      await pointer.addPointer(location: Offset.zero);
      await pointer.moveTo(tester.getCenter(button));
      await tester.pumpAndSettle();
      final hovered = _specOf(tester, button);
      expect(
        hovered.icon.spec.color,
        theme.accentForeground,
        reason: 'the pointer is on the closed button',
      );

      await pointer.down(tester.getCenter(button));
      await pointer.up();
      await tester.pumpAndSettle();

      expect(find.text('Archive'), findsOneWidget);
      final open = _specOf(tester, button);
      expect(_fillOf(open), theme.muted);
      expect(open.icon.spec.color, theme.mutedForeground);

      await pointer.down(tester.getCenter(button));
      await tester.pump();
      final pressed = _specOf(tester, button);
      expect(_fillOf(pressed), theme.muted, reason: 'pressed while open');
      expect(pressed.icon.spec.color, theme.mutedForeground);
      await pointer.up();
      await tester.pumpAndSettle();
    });
  }

  for (final preset in const [_Preset.defaultPreset, _Preset.heroui])
    for (final (label, panelText) in const [
      ('Open notifications', 'Order ORD-1047 requires review.'),
      ('Open theme settings', 'Theme settings'),
    ]) {
      testWidgets('${preset == .heroui ? 'HeroUI: ' : ''}the $label button '
          'is its popover\'s one focus stop and toggles it', (tester) async {
        final semantics = tester.ensureSemantics();
        await _pumpDashboard(tester, preset: preset);
        final button = find.byWidgetPredicate(
          (widget) => switch (preset) {
            .heroui =>
              widget is HeroUiIconButton && widget.semanticLabel == label,
            _ => widget is VanillaIconButton && widget.semanticLabel == label,
          },
        );
        final popover = find.ancestor(
          of: button,
          matching: find.byType(switch (preset) {
            .heroui => HeroUiPopover,
            _ => VanillaPopover,
          }),
        );

        expect(_focusStops(tester, popover), 1);
        expect(
          tester.getSemantics(button),
          isSemantics(
            label: label,
            isButton: true,
            isFocusable: true,
            hasEnabledState: true,
            isEnabled: true,
            hasTapAction: true,
            hasExpandedState: true,
            isExpanded: false,
          ),
        );

        await tester.tap(button);
        await tester.pumpAndSettle();
        expect(find.text(panelText), findsOneWidget);
        expect(
          tester.getSemantics(button),
          isSemantics(label: label, hasExpandedState: true, isExpanded: true),
        );

        await tester.tap(button);
        await tester.pumpAndSettle();
        expect(find.text(panelText), findsNothing, reason: 'it closes again');
        expect(
          tester.getSemantics(button),
          isSemantics(label: label, hasExpandedState: true, isExpanded: false),
        );

        await tester.tap(button);
        await tester.pumpAndSettle();
        expect(find.text(panelText), findsOneWidget);
        expect(_hasFocusWithin(tester, button), isFalse);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(find.text(panelText), findsNothing);
        expect(_hasFocusWithin(tester, button), isTrue);
        semantics.dispose();
      });
    }

  group('HeroUI row actions', () {
    Finder kebab(String label) => find.byWidgetPredicate(
      (widget) => widget is HeroUiIconButton && widget.semanticLabel == label,
    );

    testWidgets('an order row opens its actions from a real icon button', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await _pumpDashboard(
        tester,
        preset: .heroui,
        initialPage: RegistryDashboardDemoPage.orders,
      );
      const label = 'Actions for ORD-1048';
      final button = kebab(label);
      expect(button, findsOneWidget);
      final menu = find.ancestor(
        of: button,
        matching: find.byType(HeroUiDropdown<String>),
      );

      Color? fill() => _fillOf(_specOf(tester, button));
      final open = MixScope.tokenOf(
        HeroUiTokens.defaultColor,
        tester.element(button),
      );

      expect(find.semantics.byLabel(label), findsOne);
      expect(_focusStops(tester, menu), 1);
      expect(fill(), isNot(open));
      expect(
        tester.getSemantics(button),
        isSemantics(
          label: label,
          isButton: true,
          isFocusable: true,
          hasEnabledState: true,
          isEnabled: true,
          hasExpandedState: true,
          isExpanded: false,
        ),
      );

      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('Archive'), findsOneWidget);
      expect(
        fill(),
        open,
        reason: 'the button is filled while its menu is open',
      );
      expect(find.semantics.byLabel(label), findsOne);
      expect(
        tester.getSemantics(button),
        isSemantics(label: label, hasExpandedState: true, isExpanded: true),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text('Archive'), findsNothing);
      expect(fill(), isNot(open), reason: 'the fill goes with the menu');
      expect(
        tester.getSemantics(button),
        isSemantics(label: label, isFocused: true),
      );
      semantics.dispose();
    });

    for (final dark in const [false, true]) {
      testWidgets('the open kebab keeps its look under the pointer in '
          '${dark ? 'dark' : 'light'}', (tester) async {
        await _pumpDashboard(
          tester,
          preset: .heroui,
          initialPage: RegistryDashboardDemoPage.orders,
        );
        if (dark) {
          await tester.tap(
            find.byKey(const ValueKey('dashboard-appearance-toggle')).first,
          );
          await tester.pumpAndSettle();
        }
        final button = kebab('Actions for ORD-1048');
        final context = tester.element(button);
        expect(
          HeroUiTheme.of(context).brightness,
          dark ? Brightness.dark : Brightness.light,
        );
        Color token(ColorToken token) => MixScope.tokenOf(token, context);

        final pointer = await tester.createGesture(
          kind: PointerDeviceKind.mouse,
        );
        addTearDown(pointer.removePointer);
        await pointer.addPointer(location: Offset.zero);
        await pointer.moveTo(tester.getCenter(button));
        await tester.pumpAndSettle();
        final hovered = _specOf(tester, button);
        expect(_fillOf(hovered), token(HeroUiTokens.defaultColor));
        expect(
          hovered.icon.spec.color,
          token(HeroUiTokens.muted),
          reason: 'the pointer is on the closed button',
        );

        await pointer.down(tester.getCenter(button));
        await pointer.up();
        await tester.pumpAndSettle();

        expect(find.text('Archive'), findsOneWidget);
        final open = _specOf(tester, button);
        expect(_fillOf(open), token(HeroUiTokens.defaultColor));
        expect(open.icon.spec.color, token(HeroUiTokens.defaultForeground));

        await pointer.down(tester.getCenter(button));
        await tester.pump();
        final pressed = _specOf(tester, button);
        expect(
          _fillOf(pressed),
          token(HeroUiTokens.defaultColor),
          reason: 'pressed while open',
        );
        expect(pressed.icon.spec.color, token(HeroUiTokens.defaultForeground));
        await pointer.up();
        await tester.pumpAndSettle();
      });
    }

    Future<({Finder button, String name})> pumpCustomerKebab(
      WidgetTester tester,
    ) async {
      await _pumpDashboard(
        tester,
        preset: .heroui,
        initialPage: RegistryDashboardDemoPage.customers,
      );
      final customer = tester
          .widget<RemixDataTable<RegistryDashboardCustomer>>(
            find.byType(RemixDataTable<RegistryDashboardCustomer>),
          )
          .rows
          .first;
      final name = 'Actions for ${customer.name}';
      return (button: kebab(name), name: name);
    }

    testWidgets('a customer kebab is announced once, with the expanded state', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      final (:button, :name) = await pumpCustomerKebab(tester);

      expect(button, findsOneWidget);
      expect(find.semantics.byLabel(name), findsOne);
      expect(
        tester.getSemantics(button),
        isSemantics(
          label: name,
          isButton: true,
          hasTapAction: true,
          hasExpandedState: true,
          isExpanded: false,
        ),
      );

      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(find.text('View'), findsOneWidget);
      expect(find.semantics.byLabel(name), findsOne);
      expect(
        tester.getSemantics(button),
        isSemantics(label: name, hasExpandedState: true, isExpanded: true),
      );
      expect(tester.takeException(), isNull);
      semantics.dispose();
    });

    testWidgets('a customer kebab is one tab stop that Enter opens and '
        'Escape returns to', (tester) async {
      final (:button, name: _) = await pumpCustomerKebab(tester);
      final menu = find.ancestor(
        of: button,
        matching: find.byType(HeroUiDropdown<String>),
      );
      expect(_focusStops(tester, menu), 1);
      bool inKebab() => _hasFocusWithin(tester, button);
      final control =
          tester
                .widget<RemixIconButton>(
                  find.descendant(
                    of: button,
                    matching: find.byType(RemixIconButton),
                  ),
                )
                .focusNode!
            ..requestFocus();
      await tester.pump();
      expect(inKebab(), isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(inKebab(), isFalse);

      control.requestFocus();
      await tester.pump();
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pump();
      expect(inKebab(), isFalse);

      control.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('View'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('View'), findsNothing);
      expect(control.hasPrimaryFocus, isTrue);
    });
  });

  group('Fortal data-table kebab', () {
    Future<({Finder kebab, Finder button, String name})> pumpKebab(
      WidgetTester tester,
    ) async {
      await _pumpDashboard(
        tester,
        preset: .fortal,
        initialPage: RegistryDashboardDemoPage.customers,
      );
      final customer = tester
          .widget<RemixDataTable<RegistryDashboardCustomer>>(
            find.byType(RemixDataTable<RegistryDashboardCustomer>),
          )
          .rows
          .first;
      final kebab = find.byKey(ValueKey('customer-actions-${customer.id}'));
      return (
        kebab: kebab,
        button: find.descendant(
          of: kebab,
          matching: find.byType(RemixIconButton),
        ),
        name: 'Actions for ${customer.name}',
      );
    }

    testWidgets('is a real button announced once, with the expanded state', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      final (:kebab, :button, :name) = await pumpKebab(tester);

      expect(button, findsOneWidget);
      expect(find.semantics.byLabel(name), findsOne);
      expect(
        tester.getSemantics(button),
        isSemantics(
          label: name,
          isButton: true,
          hasTapAction: true,
          hasExpandedState: true,
          isExpanded: false,
        ),
      );

      await tester.tap(kebab);
      await tester.pumpAndSettle();

      expect(find.text('View profile'), findsOneWidget);
      expect(find.semantics.byLabel(name), findsOne);
      expect(
        tester.getSemantics(button),
        isSemantics(label: name, hasExpandedState: true, isExpanded: true),
      );
      expect(tester.takeException(), isNull);
      semantics.dispose();
    });

    testWidgets('is one tab stop that Enter opens and Escape returns to', (
      tester,
    ) async {
      final (:kebab, :button, name: _) = await pumpKebab(tester);
      bool inKebab() => find
          .descendant(
            of: kebab,
            matching: find.byElementPredicate(
              (element) =>
                  element == FocusManager.instance.primaryFocus?.context,
            ),
          )
          .evaluate()
          .isNotEmpty;
      final control = tester.widget<RemixIconButton>(button).focusNode!
        ..requestFocus();
      await tester.pump();
      expect(inKebab(), isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(inKebab(), isFalse);

      control.requestFocus();
      await tester.pump();
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.pump();
      expect(inKebab(), isFalse);

      control.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('View profile'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('View profile'), findsNothing);
      expect(control.hasPrimaryFocus, isTrue);
    });
  });

  for (final preset in _Preset.values) {
    group(preset.name, () {
      for (final change in [
        'header appearance',
        'Settings appearance',
        'radius',
      ]) {
        testWidgets('hosted demo retains pages and edits after $change', (
          tester,
        ) async {
          await _pumpDashboard(
            tester,
            preset: preset,
            chatStepDelay: const Duration(milliseconds: 10),
          );
          final base = tester.state(find.byType(RegistryDashboardDemoBase));
          List<Type> ancestors() {
            final types = <Type>[];
            tester
                .element(find.byType(RegistryDashboardDemoBase))
                .visitAncestorElements((element) {
                  types.add(element.widget.runtimeType);
                  return true;
                });
            return types;
          }

          final parents = ancestors();
          await tester.tap(find.text('Chat').first);
          await tester.pumpAndSettle();
          await _ask(tester, 'Review checkout');
          for (var frame = 0; frame < 12; frame++) {
            await tester.pump(const Duration(milliseconds: 11));
          }
          expect(find.textContaining('The cart flow is ready'), findsWidgets);
          await tester.tap(find.text('Settings').first);
          await tester.pumpAndSettle();
          final profile = find
              .descendant(
                of: find.byKey(const ValueKey('dashboard-page-settings')),
                matching: find.byType(EditableText),
              )
              .first;
          await tester.enterText(profile, 'Retained profile');
          await tester.pumpAndSettle();
          await tester.tap(find.text('Customers').first);
          await tester.pumpAndSettle();
          final search = find.descendant(
            of: find.byKey(const ValueKey('customer-search')),
            matching: find.byType(EditableText),
          );
          await tester.enterText(search, 'olivia');
          await tester.pumpAndSettle();
          await tester.tap(find.text('Orders').first);
          await tester.pumpAndSettle();
          await tester.tap(find.text('Pending').first);
          await tester.pumpAndSettle();

          if (change == 'header appearance') {
            await tester.tap(
              find.byKey(const ValueKey('dashboard-appearance-toggle')).first,
            );
          } else {
            await tester.tap(find.text('Settings').first);
            await tester.pumpAndSettle();
            if (change == 'radius') {
              await _changeRadius(tester, preset);
            } else {
              await tester.ensureVisible(find.text('Dark').last);
              await tester.tap(find.text('Dark').last);
            }
          }
          await tester.pumpAndSettle();
          final pages = tester.widget<IndexedStack>(
            find.byKey(const ValueKey('dashboard-demo-pages')),
          );
          expect(
            pages.index,
            change == 'header appearance'
                ? RegistryDashboardDemoPage.orders.index
                : RegistryDashboardDemoPage.settings.index,
          );
          expect(
            tester.state(find.byType(RegistryDashboardDemoBase)),
            same(base),
          );
          expect(
            ancestors(),
            parents,
            reason: 'theme changes keep the ancestor structure stable',
          );
          await tester.tap(find.text('Customers').first);
          await tester.pumpAndSettle();
          expect(tester.widget<EditableText>(search).controller.text, 'olivia');
          await tester.tap(find.text('Orders').first);
          await tester.pumpAndSettle();
          final orders = tester.widget<RemixDataTable<RegistryDashboardOrder>>(
            find.byType(RemixDataTable<RegistryDashboardOrder>),
          );
          expect(orders.rows, isNotEmpty);
          expect(
            orders.rows.map((order) => order.status),
            everyElement(RegistryDashboardOrderStatus.pending),
          );
          await tester.tap(find.text('Settings').first);
          await tester.pumpAndSettle();
          expect(
            tester.widget<EditableText>(profile).controller.text,
            'Retained profile',
          );
          await tester.tap(find.text('Chat').first);
          await tester.pumpAndSettle();
          expect(find.textContaining('The cart flow is ready'), findsWidgets);
          expect(tester.takeException(), isNull);
        });
      }

      for (final control in ['appearance', 'radius']) {
        testWidgets('Settings $control applies without built-in chrome', (
          tester,
        ) async {
          await _pumpDashboard(
            tester,
            preset: preset,
            builtInChrome: false,
            initialPage: RegistryDashboardDemoPage.settings,
          );
          BuildContext pageContext() => tester.element(
            find.byKey(const ValueKey('dashboard-demo-pages')),
          );
          expect(_brightness(preset, pageContext()), Brightness.light);
          final before = _radius(preset, pageContext());
          if (control == 'appearance') {
            await tester.ensureVisible(find.text('Dark').last);
            await tester.tap(find.text('Dark').last);
            await tester.pumpAndSettle();
            expect(_brightness(preset, pageContext()), Brightness.dark);
            await tester.tap(find.text('System').last);
            await tester.pumpAndSettle();
            expect(_brightness(preset, pageContext()), Brightness.light);
          } else {
            await _changeRadius(tester, preset);
            expect(_radius(preset, pageContext()), isNot(before));
          }
          expect(
            find.byKey(const ValueKey('dashboard-appearance-toggle')),
            findsNothing,
          );
          expect(tester.takeException(), isNull);
        });
      }

      testWidgets('theme popover closes on appearance changes', (tester) async {
        await _pumpDashboard(tester, preset: preset);
        final trigger = preset == .fortal
            ? find.byKey(const ValueKey('theme-panel-trigger'))
            : find.bySemanticsLabel('Open theme settings');
        final panel = preset == .fortal
            ? find.byKey(const ValueKey('theme-panel'))
            : find.text('Theme settings');
        for (final label in ['Dark', 'Light']) {
          await tester.tap(trigger);
          await tester.pumpAndSettle();
          expect(panel, findsOneWidget);
          await tester.tap(find.text(label).last);
          await tester.pumpAndSettle();
          expect(panel, findsNothing);
        }
        expect(tester.takeException(), isNull);
      });

      for (final direction in TextDirection.values) {
        testWidgets('header breadcrumb follows ${direction.name} direction', (
          tester,
        ) async {
          await _pumpDashboard(
            tester,
            preset: preset,
            textDirection: direction,
          );
          final separator = find.byKey(
            const ValueKey('dashboard-breadcrumb-separator'),
          );
          expect(separator, findsOneWidget);
          expect(
            tester.widget<Transform>(separator).transform.entry(0, 0),
            direction == TextDirection.rtl ? -1 : 1,
          );
          expect(
            tester
                .widget<StyledIcon>(
                  find.descendant(
                    of: separator,
                    matching: find.byType(StyledIcon),
                  ),
                )
                .icon,
            RemixIcons.chevronRight,
          );
          expect(tester.takeException(), isNull);
        });
      }

      testWidgets('regression: Settings accepts a large host radius', (
        tester,
      ) async {
        final semantics = tester.ensureSemantics();
        try {
          await _pump(
            tester,
            preset: preset,
            width: 1200,
            height: 1600,
            hostRadius: 24,
            child: switch (preset) {
              .defaultPreset => const VanillaDashboardSettingsPage(),
              .heroui => const HeroUiDashboardSettingsPage(),
              // Fortal exposes named radii instead of a numeric slider.
              .fortal => FortalDashboardThemeScope(
                settings: const FortalThemeSettings(radius: .full),
                onChanged: (_) {},
                child: const FortalDashboardSettingsPage(),
              ),
            },
          );
          expect(tester.takeException(), isNull);
          if (preset == .fortal) {
            expect(find.text('Full'), findsOneWidget);
            expect(find.byType(RemixSlider), findsNothing);
          } else {
            expect(find.text('Control radius · 24px'), findsOneWidget);
            final slider = tester.widget<RemixSlider>(find.byType(RemixSlider));
            expect(slider.value, 24);
            expect(slider.max, greaterThanOrEqualTo(24));
            expect(slider.snapDivisions, slider.max.toInt());
            await tester.ensureVisible(find.byType(RemixSlider));
            tester.semantics.performAction(
              find.semantics.byLabel('Control radius'),
              SemanticsAction.decrease,
            );
            await tester.pump();
            expect(find.text('Control radius · 23px'), findsOneWidget);
          }
        } finally {
          semantics.dispose();
        }
      });

      if (preset != .fortal) {
        testWidgets(
          'regression: full demo preserves the host radius slider maximum',
          (tester) async {
            final semantics = tester.ensureSemantics();
            try {
              await _pumpDashboard(
                tester,
                preset: preset,
                initialPage: .settings,
                hostRadius: 24,
              );
              final slider = find.byType(RemixSlider);
              await tester.ensureVisible(slider);

              void expectRadius(double value) {
                final control = tester.widget<RemixSlider>(slider);
                expect(control.value, value);
                expect(control.max, 24);
                expect(control.snapDivisions, 24);
                expect(
                  find.text('Control radius · ${value.round()}px'),
                  findsOneWidget,
                );
                expect(
                  _radius(preset, tester.element(slider)),
                  preset == .defaultPreset ? Radius.circular(value) : value,
                );
              }

              expectRadius(24);
              tester.semantics.performAction(
                find.semantics.byLabel('Control radius'),
                SemanticsAction.decrease,
              );
              await tester.pumpAndSettle();
              expectRadius(23);

              tester.semantics.performAction(
                find.semantics.byLabel('Control radius'),
                SemanticsAction.increase,
              );
              await tester.pumpAndSettle();
              expectRadius(24);
              expect(tester.takeException(), isNull);
            } finally {
              semantics.dispose();
            }
          },
        );
      }

      testWidgets('regression: revenue accepts duplicate display labels', (
        tester,
      ) async {
        await _pumpOverview(
          tester,
          preset: preset,
          width: 1280,
          data: const RegistryDashboardSampleData(
            metrics: [],
            records: [],
            revenue: [
              RegistryDashboardPoint(label: 'Same day', value: 12),
              RegistryDashboardPoint(label: 'Same day', value: 34),
            ],
          ),
        );
        expect(tester.takeException(), isNull);
        final chart = tester.widget<LineChart>(find.byType(LineChart));
        expect(
          chart.series.single.points.map((p) => p.id).toSet(),
          hasLength(2),
        );
        expect(chart.series.single.points.map((p) => p.y), [12, 34]);
        expect(chart.xAxis!.labelFormatter!(0), 'Same day');
        expect(chart.xAxis!.labelFormatter!(1), 'Same day');
      });

      for (final values in <List<double>>[
        [],
        [300, 650],
        [-125, 325],
        [0],
        [0.12, 0.24],
      ]) {
        testWidgets('regression: revenue axis contains caller values $values', (
          tester,
        ) async {
          await _pumpOverview(
            tester,
            preset: preset,
            width: 1280,
            data: RegistryDashboardSampleData(
              metrics: const [],
              records: const [],
              revenue: [
                for (final (i, value) in values.indexed)
                  RegistryDashboardPoint(label: 'Day $i', value: value),
              ],
            ),
          );
          expect(tester.takeException(), isNull);
          final axis = tester.widget<LineChart>(find.byType(LineChart)).yAxis!;
          expect(axis.interval, greaterThan(0));
          if (values.isNotEmpty &&
              values.every((value) => value > 0 && value < 1)) {
            expect(axis.interval, lessThan(1));
          }
          expect(axis.max! - axis.min!, lessThanOrEqualTo(10 * axis.interval!));
          for (final value in values) {
            expect(axis.min! + axis.interval! / 2, lessThanOrEqualTo(value));
            expect(axis.max! - axis.interval! / 2, greaterThanOrEqualTo(value));
          }
          if (values.isEmpty) {
            expect((axis.min, axis.max, axis.interval), (-10, 110, 20));
          }
        });
      }

      testWidgets('regression: stock chart bounds and ticks stay unchanged', (
        tester,
      ) async {
        await _pumpOverview(tester, preset: preset, width: 1280);
        final revenue = tester.widget<LineChart>(find.byType(LineChart)).yAxis!;
        expect((revenue.min, revenue.max, revenue.interval), (-10, 110, 20));
        expect(revenue.minIncluded, isFalse);
        expect(revenue.maxIncluded, isFalse);
        final bars = tester.widget<BarChart>(find.byType(BarChart)).yAxis!;
        expect((
          bars.min,
          bars.max,
          bars.interval,
        ), preset == .fortal ? (-12.5, 112.5, 25) : (-5, 55, 10));
        expect(bars.minIncluded, isFalse);
        expect(bars.maxIncluded, isFalse);
        for (final tick in const ['0', '20', '40', '60', '80', '100']) {
          expect(
            find.descendant(
              of: find.byType(LineChart),
              matching: find.text(tick),
            ),
            findsOneWidget,
          );
        }
        final barTicks = preset == .fortal
            ? ['0', '25', '50', '75', '100']
            : ['0', '10', '20', '30', '40', '50'];
        for (final tick in barTicks) {
          expect(
            find.descendant(
              of: find.byType(BarChart),
              matching: find.text(tick),
            ),
            findsOneWidget,
          );
        }
      });

      testWidgets('regression: View all follows RTL direction', (tester) async {
        await _pumpOverview(
          tester,
          preset: preset,
          width: 1280,
          textDirection: .rtl,
        );
        final action = find.byKey(const ValueKey('overview-view-orders'));
        expect(
          find.descendant(
            of: action,
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is StyledIcon &&
                  widget.icon == RemixIcons.chevronsLeft,
            ),
          ),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets(
        'regression: metric progress has its metric accessible name',
        (tester) async {
          final semantics = tester.ensureSemantics();
          try {
            await _pumpOverview(tester, preset: preset, width: 1280);
            final progress = find.byType(RemixProgress);
            expect(progress, findsOneWidget);
            expect(tester.getSemantics(progress).label, 'Fulfillment');
            expect(tester.getSemantics(progress).value, '94');
          } finally {
            semantics.dispose();
          }
        },
      );

      testWidgets('regression: customer search has an accessible name', (
        tester,
      ) async {
        final semantics = tester.ensureSemantics();
        try {
          await _pumpDashboard(tester, preset: preset, initialPage: .customers);
          final search = find.semantics.byLabel('Search customers');
          expect(search, findsOne);
          expect(
            search
                .evaluate()
                .single
                .getSemanticsData()
                .flagsCollection
                .isTextField,
            isTrue,
          );
          await tester.enterText(
            find.byKey(const ValueKey('customer-search')),
            'Olivia',
          );
          await tester.pump();
          expect(search.evaluate().single.getSemanticsData().value, 'Olivia');
        } finally {
          semantics.dispose();
        }
      });

      testWidgets('regression: Orders status filter has an accessible name', (
        tester,
      ) async {
        final semantics = tester.ensureSemantics();
        try {
          await _pumpDashboard(tester, preset: preset, initialPage: .orders);
          expect(find.semantics.byLabel('Filter orders by status'), findsOne);
        } finally {
          semantics.dispose();
        }
      });

      testWidgets('overview renders coherent sample data', (tester) async {
        await _pumpOverview(tester, preset: preset, width: 1280);

        expect(find.text(r'$84,420'), findsOneWidget);
        expect(find.text('Mon'), findsWidgets);
        expect(find.text('ORD-1048'), findsOneWidget);
        expect(find.text('Olivia Martin'), findsOneWidget);
        expect(find.byType(LineChart), findsOneWidget);
        expect(
          find.byType(RemixDataTable<RegistryDashboardRecord>),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets('overview uses caller-owned data', (tester) async {
        const data = RegistryDashboardSampleData(
          metrics: [
            RegistryDashboardMetric(
              label: 'Retained metric',
              value: '17',
              change: 'Edited locally',
            ),
          ],
          revenue: [RegistryDashboardPoint(label: 'Now', value: 17)],
          records: [
            RegistryDashboardRecord(
              id: 'LOCAL-1',
              customer: 'Local customer',
              status: 'Ready',
              amount: r'$17',
            ),
          ],
        );
        await _pumpOverview(tester, preset: preset, width: 760, data: data);

        expect(find.text('Retained metric'), findsOneWidget);
        expect(find.text('LOCAL-1'), findsOneWidget);
        expect(find.text('ORD-1048'), findsNothing);
        expect(tester.takeException(), isNull);
      });

      testWidgets('narrow enlarged layout scrolls without overflow', (
        tester,
      ) async {
        await _pumpOverview(
          tester,
          preset: preset,
          width: 390,
          height: 520,
          textScaler: const TextScaler.linear(1.8),
        );

        expect(
          find.byKey(const ValueKey('dashboard-overview-scroll')),
          findsOneWidget,
        );
        expect(find.text('Revenue trend'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('compact demo chrome fits a 375 pixel viewport', (
        tester,
      ) async {
        await _pumpDashboard(tester, preset: preset, width: 375, height: 812);

        expect(find.byKey(const ValueKey('dashboard-menu')), findsWidgets);
        expect(tester.takeException(), isNull);
      });

      testWidgets('full demo exposes and navigates all real destinations', (
        tester,
      ) async {
        await _pumpDashboard(tester, preset: preset);

        for (final label in [
          'Overview',
          'Chat',
          'Customers',
          'Orders',
          'Settings',
        ]) {
          expect(find.text(label), findsWidgets, reason: label);
        }

        await tester.tap(find.text('Chat').first);
        await tester.pump();

        expect(find.text('What should we work on?'), findsOneWidget);
        expect(find.text('Ask the agent…'), findsOneWidget);
        expect(find.text('Acme starter'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('built-in chrome is functional and independently optional', (
        tester,
      ) async {
        await _pumpDashboard(tester, preset: preset);
        expect(find.byKey(const ValueKey('dashboard-search')), findsWidgets);
        expect(
          find.byKey(const ValueKey('dashboard-appearance-toggle')),
          findsWidgets,
        );
        expect(find.text('Northstar workspace'), findsOneWidget);

        await tester.tap(
          find.byKey(const ValueKey('dashboard-appearance-toggle')).first,
        );
        await tester.pump();
        expect(find.bySemanticsLabel('Use light appearance'), findsOneWidget);

        final notifications = switch (preset) {
          .defaultPreset || .heroui => 'Open notifications',
          .fortal => 'Notifications',
        };
        await tester.tap(find.bySemanticsLabel(notifications).first);
        await tester.pump();
        expect(
          find.text(switch (preset) {
            .defaultPreset || .heroui => 'Order ORD-1047 requires review.',
            .fortal => 'Inventory alert',
          }),
          findsWidgets,
        );
        if (preset == .fortal) {
          expect(
            find.descendant(
              of: find.byKey(const ValueKey('topbar-notifications-content')),
              matching: find.text('Inventory alert'),
            ),
            findsOneWidget,
          );
          expect(find.text('Order ORD-1047 requires review.'), findsNothing);
        }
        await tester.tap(find.bySemanticsLabel(notifications).first);
        await tester.pump();

        await _pumpDashboard(
          tester,
          preset: preset,
          builtInChrome: false,
          account: const Text('Caller account'),
        );
        expect(find.byKey(const ValueKey('dashboard-search')), findsNothing);
        expect(
          find.byKey(const ValueKey('dashboard-appearance-toggle')),
          findsNothing,
        );
        expect(find.text('Caller account'), findsOneWidget);
        expect(find.text('Northstar workspace'), findsNothing);
        expect(tester.takeException(), isNull);
      });

      testWidgets('all five screens expose the shared section inventory', (
        tester,
      ) async {
        const expected = <RegistryDashboardDemoPage, List<String>>{
          RegistryDashboardDemoPage.overview: [
            'Revenue trend',
            'Recent activity',
            'Recent orders',
          ],
          RegistryDashboardDemoPage.chat: [
            'What should we work on?',
            'Review checkout',
          ],
          RegistryDashboardDemoPage.customers: [
            'Customers',
            'Search customers…',
            'Email',
          ],
          RegistryDashboardDemoPage.orders: ['Orders', 'Paid', 'ORD-1048'],
          RegistryDashboardDemoPage.settings: [
            'Profile',
            'Preferences',
            'Appearance',
            'Danger zone',
          ],
        };

        final mixWarnings = <String>[];
        final originalDebugPrint = debugPrint;
        debugPrint = (String? message, {int? wrapWidth}) {
          if (message != null && message.contains('Mix: could not convert')) {
            mixWarnings.add(message);
          }
        };
        try {
          for (final entry in expected.entries) {
            await _pumpDashboard(
              tester,
              preset: preset,
              initialPage: entry.key,
            );
            for (final label in entry.value) {
              expect(
                find.text(label),
                findsWidgets,
                reason: '${entry.key.name}: $label',
              );
            }
            expect(tester.takeException(), isNull, reason: entry.key.name);
            expect(mixWarnings, isEmpty, reason: entry.key.name);
          }
        } finally {
          debugPrint = originalDebugPrint;
        }
      });

      testWidgets(
        'sidebar collapse and expand animate across frames without overflow, jumps, or Mix warnings',
        (tester) async {
          final mixWarnings = <String>[];
          final originalDebugPrint = debugPrint;
          debugPrint = (String? message, {int? wrapWidth}) {
            if (message != null && message.contains('Mix: could not convert')) {
              mixWarnings.add(message);
            }
          };
          try {
            await _pumpDashboard(tester, preset: preset);
            expect(mixWarnings, isEmpty);

            final collapseButton = find
                .byKey(const ValueKey('dashboard-collapse'))
                .first;

            await tester.tap(collapseButton);
            await tester.pump();
            double previousButtonDx = tester.getCenter(collapseButton).dx;
            for (var frame = 0; frame < 24; frame++) {
              await tester.pump(const Duration(milliseconds: 10));
              expect(
                tester.takeException(),
                isNull,
                reason: 'collapse frame $frame',
              );
              expect(mixWarnings, isEmpty, reason: 'collapse frame $frame');
              final currentButtonDx = tester.getCenter(collapseButton).dx;
              final step = previousButtonDx - currentButtonDx;
              expect(
                currentButtonDx,
                lessThanOrEqualTo(previousButtonDx + 0.5),
                reason: 'collapse button should move monotonically left',
              );
              expect(
                step,
                lessThanOrEqualTo(frame >= 19 ? 4.0 : 20.0),
                reason: 'collapse frame $frame should not jump',
              );
              previousButtonDx = currentButtonDx;
            }

            await tester.tap(collapseButton);
            await tester.pump();
            previousButtonDx = tester.getCenter(collapseButton).dx;
            for (var frame = 0; frame < 24; frame++) {
              await tester.pump(const Duration(milliseconds: 10));
              expect(
                tester.takeException(),
                isNull,
                reason: 'expand frame $frame',
              );
              expect(mixWarnings, isEmpty, reason: 'expand frame $frame');
              final currentButtonDx = tester.getCenter(collapseButton).dx;
              final step = currentButtonDx - previousButtonDx;
              expect(
                currentButtonDx,
                greaterThanOrEqualTo(previousButtonDx - 0.5),
                reason: 'collapse button should move monotonically right',
              );
              expect(
                step,
                lessThanOrEqualTo(frame >= 19 ? 4.0 : 20.0),
                reason: 'expand frame $frame should not jump',
              );
              previousButtonDx = currentButtonDx;
            }
          } finally {
            debugPrint = originalDebugPrint;
          }
        },
      );

      testWidgets('value axis end labels sit on their gridlines', (
        tester,
      ) async {
        await _pumpOverview(tester, preset: preset, width: 1280);

        // The revenue axis labels 0 to 100 in steps of 20. On their
        // gridlines they are evenly spaced; an end label pulled in off its
        // value shortens the gap beside it.
        final centers = [
          for (final label in const ['100', '80', '60', '40', '20', '0'])
            tester.getCenter(find.text(label).first).dy,
        ];
        final gaps = [
          for (var i = 1; i < centers.length; i++) centers[i] - centers[i - 1],
        ];
        for (final gap in gaps) {
          expect(gap, closeTo(gaps[2], 1), reason: 'gaps: $gaps');
        }
      });

      // mix_chart draws each slice 80px wide whatever box it is given, so a
      // donut whose hole plus ring outgrows half its box is clipped.
      testWidgets('every pie fits inside its chart box', (tester) async {
        await _pumpOverview(tester, preset: preset, width: 1280);
        final overviewPies = _expectPiesFit(tester);

        expect(overviewPies, greaterThan(0));
      });

      testWidgets('customer state survives navigation', (tester) async {
        await _pumpDashboard(
          tester,
          preset: preset,
          initialPage: RegistryDashboardDemoPage.customers,
        );
        await tester.enterText(
          find.byKey(const ValueKey('customer-search')),
          'Olivia',
        );
        await tester.pump();
        expect(find.text('Olivia Martin'), findsOneWidget);
        expect(find.text('Jackson Lee'), findsNothing);

        await tester.tap(find.text('Orders').first);
        await tester.pump();
        await tester.tap(find.text('Customers').first);
        await tester.pump();

        expect(find.text('Olivia Martin'), findsOneWidget);
        expect(find.text('Jackson Lee'), findsNothing);
        expect(tester.takeException(), isNull);
      });

      testWidgets('global search finds real screens by section id', (
        tester,
      ) async {
        await _pumpDashboard(tester, preset: preset);

        await tester.enterText(
          find.descendant(
            of: find.byKey(const ValueKey('dashboard-search')),
            matching: find.byType(EditableText),
          ),
          'profile',
        );
        await tester.pump();

        expect(find.text('Settings'), findsWidgets);
        expect(find.text('Profile'), findsWidgets);
        expect(tester.takeException(), isNull);
      });

      testWidgets('tables expose full controlled interaction contracts', (
        tester,
      ) async {
        await _pumpDashboard(
          tester,
          preset: preset,
          initialPage: RegistryDashboardDemoPage.customers,
        );
        var customers = tester
            .widget<RemixDataTable<RegistryDashboardCustomer>>(
              find.byType(RemixDataTable<RegistryDashboardCustomer>),
            );
        expect(customers.columns.map((column) => column.id), [
          'name',
          'email',
          'plan',
          'status',
          'joined',
          'actions',
        ]);
        expect(customers.totalRows, 24);
        expect(customers.rows, hasLength(10));
        expect(customers.onSortChanged, isNotNull);
        expect(customers.onSelectionChanged, isNotNull);
        expect(customers.onPageChanged, isNotNull);
        expect(customers.onPageSizeChanged, isNotNull);

        customers.onSelectionChanged!({customers.rows.first.id});
        await tester.pump();
        expect(find.text('1 selected'), findsOneWidget);

        customers = tester.widget(
          find.byType(RemixDataTable<RegistryDashboardCustomer>),
        );
        customers.onPageChanged!(1);
        await tester.pump();
        customers = tester.widget(
          find.byType(RemixDataTable<RegistryDashboardCustomer>),
        );
        expect(customers.pageIndex, 1);
        expect(customers.rows, hasLength(10));

        await tester.tap(find.text('Orders').first);
        await tester.pump();
        var orders = tester.widget<RemixDataTable<RegistryDashboardOrder>>(
          find.byType(RemixDataTable<RegistryDashboardOrder>),
        );
        expect(orders.columns.map((column) => column.id), [
          'id',
          'customer',
          'date',
          'amount',
          'status',
          'actions',
        ]);
        expect(orders.totalRows, 30);
        orders.onSortChanged!(
          const RemixDataTableSort(
            columnId: 'amount',
            direction: RemixDataTableSortDirection.ascending,
          ),
        );
        await tester.pump();
        orders = tester.widget(
          find.byType(RemixDataTable<RegistryDashboardOrder>),
        );
        expect(orders.sort?.columnId, 'amount');
        expect(
          orders.rows.first.amount,
          lessThanOrEqualTo(orders.rows.last.amount),
        );

        await tester.tap(find.text('Pending').first);
        await tester.pump();
        orders = tester.widget(
          find.byType(RemixDataTable<RegistryDashboardOrder>),
        );
        expect(
          orders.rows,
          everyElement(
            isA<RegistryDashboardOrder>().having(
              (order) => order.status,
              'status',
              RegistryDashboardOrderStatus.pending,
            ),
          ),
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets(
        'Agent leading action adds checkout context without sending',
        (tester) async {
          await _pumpDashboard(
            tester,
            preset: preset,
            initialPage: RegistryDashboardDemoPage.chat,
          );
          if (preset == _Preset.fortal) {
            expect(tester.getSize(find.byType(AgentComposer)).height, 94);
          }
          await tester.tap(find.bySemanticsLabel('Add checkout context'));
          await tester.pump();
          final composer = tester.widget<AgentComposer>(
            find.byType(AgentComposer),
          );
          expect(
            composer.controller!.text,
            'Review packages/checkout and its cart tests.',
          );
          expect(composer.focusNode!.hasFocus, isTrue);
          expect(find.byType(AgentMessage), findsNothing);
        },
      );

      testWidgets('Agent suggestions fill the composer and do not send', (
        tester,
      ) async {
        await _pumpDashboard(
          tester,
          preset: preset,
          initialPage: RegistryDashboardDemoPage.chat,
          chatStepDelay: const Duration(milliseconds: 10),
        );

        await tester.tap(find.text('Run terminal checks'));
        await tester.pump();

        final composer = tester.widget<AgentComposer>(
          find.byType(AgentComposer),
        );
        expect(composer.controller!.text, startsWith('Run the checkout tests'));
        expect(find.byType(AgentTurn), findsNothing);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Agent success, approval, stop, and retry are local', (
        tester,
      ) async {
        await _pumpDashboard(
          tester,
          preset: preset,
          initialPage: RegistryDashboardDemoPage.chat,
          chatStepDelay: const Duration(milliseconds: 10),
        );

        await _ask(tester, 'Review checkout');
        for (var frame = 0; frame < 12; frame++) {
          await tester.pump(const Duration(milliseconds: 11));
        }
        expect(find.textContaining('The cart flow is ready'), findsWidgets);
        expect(
          tester.widget<AgentAnswer>(find.byType(AgentAnswer)).onCopy,
          isNotNull,
        );

        await tester.tap(find.text('New chat'));
        await tester.pump();
        await _ask(tester, 'Run terminal checks');
        await tester.pump(const Duration(milliseconds: 12));
        final call = tester.widget<AgentToolCall>(find.byType(AgentToolCall));
        expect(call.call.status, AgentToolCallStatus.awaitingApproval);
        expect(call.onDecision, isNotNull);
        call.onDecision!(AgentApprovalDecision.allowOnce);
        await tester.pump(const Duration(milliseconds: 12));
        final composer = tester.widget<AgentComposer>(
          find.byType(AgentComposer),
        );
        expect(composer.controller!.running, isTrue);
        expect(composer.onStop, isNotNull);
        composer.onStop!();
        await tester.pump();
        expect(
          tester
              .widget<AgentComposer>(find.byType(AgentComposer))
              .controller!
              .running,
          isFalse,
        );
        expect(
          tester.widget<AgentAnswer>(find.byType(AgentAnswer)).onRetry,
          isNotNull,
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets('Agent denial, failure and retry script the mock states', (
        tester,
      ) async {
        await _pumpDashboard(
          tester,
          preset: preset,
          initialPage: RegistryDashboardDemoPage.chat,
          chatStepDelay: const Duration(milliseconds: 10),
        );

        await _ask(tester, 'Run terminal checks');
        await tester.pump(const Duration(milliseconds: 12));
        expect(find.text('Waiting for approval · 2 steps'), findsOneWidget);
        tester.widget<AgentToolCall>(find.byType(AgentToolCall)).onDecision!(
          AgentApprovalDecision.deny,
        );
        await tester.pump();
        expect(
          tester.widget<AgentToolCall>(find.byType(AgentToolCall)).call.status,
          AgentToolCallStatus.denied,
        );
        expect(find.textContaining("won't run anything"), findsOneWidget);

        await tester.tap(find.text('New chat'));
        await tester.pump();
        await _ask(tester, 'Recover a failed command');
        await tester.pump(const Duration(milliseconds: 12));
        tester.widget<AgentToolCall>(find.byType(AgentToolCall)).onDecision!(
          AgentApprovalDecision.allowOnce,
        );
        for (var frame = 0; frame < 6; frame++) {
          await tester.pump(const Duration(milliseconds: 11));
        }
        final failed = tester.widget<AgentToolCall>(find.byType(AgentToolCall));
        expect(failed.call.status, AgentToolCallStatus.failed);
        expect(failed.call.error, contains('Expected: OrderStatus.placed'));

        tester.widget<AgentAnswer>(find.byType(AgentAnswer)).onRetry!();
        for (var frame = 0; frame < 14; frame++) {
          await tester.pump(const Duration(milliseconds: 11));
        }
        expect(find.textContaining('The cart flow is ready'), findsWidgets);
        expect(tester.takeException(), isNull);
      });

      testWidgets('Agent turns are spaced apart more than their blocks', (
        tester,
      ) async {
        await _pumpDashboard(
          tester,
          preset: preset,
          initialPage: RegistryDashboardDemoPage.chat,
          chatStepDelay: const Duration(milliseconds: 10),
          height: 1400,
        );
        for (var run = 0; run < 2; run++) {
          await _ask(tester, 'Review checkout');
          for (var frame = 0; frame < 14; frame++) {
            await tester.pump(const Duration(milliseconds: 11));
          }
        }
        await tester.pumpAndSettle();

        final firstAnswer = tester.getRect(find.byType(AgentAnswer).first);
        final secondPrompt = tester.getRect(find.byType(AgentMessage).last);
        final secondSteps = tester.getRect(find.byType(AgentSteps).last);
        final betweenTurns = secondPrompt.top - firstAnswer.bottom;
        final withinTurn = secondSteps.top - secondPrompt.bottom;
        expect(withinTurn, greaterThan(0));
        expect(
          betweenTurns,
          greaterThan(withinTurn),
          reason: 'A prompt groups with its reply, not the turn above.',
        );
        expect(tester.takeException(), isNull);
      });

      testWidgets('Agent copy confirms the copied answer only, briefly', (
        tester,
      ) async {
        final copied = <Object?>[];
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          (call) async {
            if (call.method == 'Clipboard.setData') copied.add(call.arguments);
            return null;
          },
        );
        addTearDown(
          () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            SystemChannels.platform,
            null,
          ),
        );
        await _pumpDashboard(
          tester,
          preset: preset,
          initialPage: RegistryDashboardDemoPage.chat,
          chatStepDelay: const Duration(milliseconds: 10),
          height: 1400,
        );
        // Two turns whose answers have the same text.
        for (var run = 0; run < 2; run++) {
          await _ask(tester, 'Review checkout');
          for (var frame = 0; frame < 14; frame++) {
            await tester.pump(const Duration(milliseconds: 11));
          }
        }
        await tester.pumpAndSettle();
        final answers = find.byType(AgentAnswer);
        expect(answers, findsNWidgets(2));

        await tester.tap(
          find.descendant(
            of: answers.first,
            matching: find.byKey(const ValueKey('agent-answer-copy')),
          ),
        );
        await tester.pump();
        await tester.pump();
        expect(copied, hasLength(1));
        expect(
          find.descendant(of: answers.first, matching: find.text('Copied')),
          findsOneWidget,
        );
        expect(
          find.descendant(of: answers.last, matching: find.text('Copied')),
          findsNothing,
        );

        await tester.pump(const Duration(seconds: 2));
        expect(find.text('Copied'), findsNothing);
        expect(tester.takeException(), isNull);
      });

      testWidgets(
        'DataTable sort carets, tri-state selection checkboxes, and pager buttons work',
        (tester) async {
          await _pumpDashboard(
            tester,
            preset: preset,
            initialPage: RegistryDashboardDemoPage.customers,
            height: 1200,
          );

          final table = find.byType(RemixDataTable<RegistryDashboardCustomer>);
          expect(_glyphIn(table, RemixPathGlyph.caretDown), findsOneWidget);
          expect(_glyphIn(table, RemixPathGlyph.caretSort), findsOneWidget);

          await tester.tap(
            find.descendant(of: table, matching: find.text('Customer')),
          );
          await tester.pumpAndSettle();
          expect(_glyphIn(table, RemixPathGlyph.caretUp), findsOneWidget);
          expect(_glyphIn(table, RemixPathGlyph.caretSort), findsOneWidget);

          await tester.tap(
            find.descendant(of: table, matching: find.text('Customer')),
          );
          await tester.pumpAndSettle();
          expect(_glyphIn(table, RemixPathGlyph.caretDown), findsOneWidget);
          expect(_glyphIn(table, RemixPathGlyph.caretSort), findsOneWidget);

          final checkboxes = find.descendant(
            of: table,
            matching: find.byType(RemixCheckbox),
          );
          final headerCheckbox = checkboxes.first;
          final firstRowCheckbox = checkboxes.at(1);

          await tester.tap(firstRowCheckbox);
          await tester.pumpAndSettle();
          expect(find.text('1 selected'), findsOneWidget);
          expect(
            _glyphIn(headerCheckbox, RemixPathGlyph.thickDividerHorizontal),
            findsOneWidget,
          );

          await tester.tap(headerCheckbox);
          await tester.pumpAndSettle();
          expect(find.text('10 selected'), findsOneWidget);
          expect(
            _glyphIn(headerCheckbox, RemixPathGlyph.thickCheck),
            findsOneWidget,
          );

          expect(find.text('1–10 of 24'), findsOneWidget);
          await tester.tap(
            find.descendant(
              of: table,
              matching: _pathGlyph(RemixPathGlyph.chevronRight),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.text('11–20 of 24'), findsOneWidget);

          await tester.tap(
            find.descendant(
              of: table,
              matching: _pathGlyph(RemixPathGlyph.chevronLeft),
            ),
          );
          await tester.pumpAndSettle();
          expect(find.text('1–10 of 24'), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'Settings Select, Checkbox, and Danger zone Disclosure work',
        (tester) async {
          final semantics = tester.ensureSemantics();
          await _pumpDashboard(
            tester,
            preset: preset,
            initialPage: RegistryDashboardDemoPage.settings,
          );

          final language = find.semantics.byLabel('Language');
          expect(language, findsOne);
          expect(
            language.evaluate().single.getSemanticsData().value,
            preset == .fortal ? 'English (US)' : 'English',
          );

          final select = find.byType(RemixSelect<String>);
          expect(_glyphIn(select, RemixPathGlyph.chevronDown), findsOneWidget);
          expect(_transformAngleIn(tester, select), closeTo(0, 0.01));

          tester.semantics.tap(language);
          await tester.pumpAndSettle();
          expect(_transformAngleIn(tester, select), closeTo(math.pi, 0.01));
          expect(_pathGlyph(RemixPathGlyph.thickCheck), findsOneWidget);

          await tester.tap(find.text('Spanish').last);
          await tester.pumpAndSettle();
          expect(
            find.descendant(of: select, matching: find.text('Spanish')),
            findsOneWidget,
          );
          expect(_transformAngleIn(tester, select), closeTo(0, 0.01));
          expect(
            language.evaluate().single.getSemanticsData().value,
            'Spanish',
          );

          final checkbox = find.byType(RemixCheckbox);
          expect(_glyphIn(checkbox, RemixPathGlyph.thickCheck), findsNothing);
          await tester.ensureVisible(checkbox);
          await tester.tap(checkbox);
          await tester.pumpAndSettle();
          expect(_glyphIn(checkbox, RemixPathGlyph.thickCheck), findsOneWidget);

          final dangerZone = find
              .byKey(const ValueKey('settings-danger-zone'))
              .first;
          expect(find.text('Delete workspace'), findsNothing);
          expect(_transformAngleIn(tester, dangerZone), closeTo(0, 0.01));

          await tester.ensureVisible(dangerZone);
          await tester.tap(find.text('Danger zone'));
          await tester.pumpAndSettle();
          expect(find.text('Delete workspace'), findsOneWidget);
          expect(_transformAngleIn(tester, dangerZone), closeTo(math.pi, 0.01));
          expect(tester.takeException(), isNull);

          semantics.dispose();
        },
      );
    });
  }

  testWidgets('settings radius keeps a host\'s custom dark theme', (
    tester,
  ) async {
    const customBackground = Color(0xFF123456);
    await _pumpDashboard(
      tester,
      preset: .defaultPreset,
      initialPage: RegistryDashboardDemoPage.settings,
      darkTheme: const VanillaThemeData.dark().copyWith(
        background: customBackground,
      ),
    );

    final slider = find.byType(RemixSlider);
    await tester.ensureVisible(slider);
    await tester.drag(slider, const Offset(160, 0));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const ValueKey('dashboard-appearance-toggle')).first,
    );
    await tester.pumpAndSettle();

    expect(
      MixScope.tokenOf(
        VanillaTokens.background,
        tester.element(find.textContaining('Control radius')),
      ),
      customBackground,
    );
  });

  testWidgets('settings radius slider changes the resolved radius', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _pumpDashboard(
      tester,
      preset: .defaultPreset,
      initialPage: RegistryDashboardDemoPage.settings,
    );

    Radius radiusOf(RadiusToken token) => MixScope.tokenOf(
      token,
      tester.element(find.textContaining('Control radius')),
    );

    final radius = find.semantics.byLabel('Control radius');
    expect(radius, findsOne);
    expect(
      radius.evaluate().single.getSemanticsData().hasAction(
        SemanticsAction.increase,
      ),
      isTrue,
    );

    final before = radiusOf(VanillaTokens.radiusLg);
    expect(before, const Radius.circular(10));
    expect(find.text('Control radius · 10px'), findsOneWidget);

    final slider = find.byType(RemixSlider);
    await tester.ensureVisible(slider);
    await tester.drag(slider, const Offset(160, 0));
    await tester.pumpAndSettle();

    final after = radiusOf(VanillaTokens.radiusLg);
    expect(after.x, greaterThan(before.x));
    expect(radiusOf(VanillaTokens.radiusMd).x, closeTo(after.x - 2, 0.001));
    expect(find.text('Control radius · 10px'), findsNothing);

    await tester.tap(
      find.byKey(const ValueKey('dashboard-appearance-toggle')).first,
    );
    await tester.pumpAndSettle();
    expect(
      MixScope.tokenOf(
        VanillaTokens.background,
        tester.element(find.textContaining('Control radius')),
      ),
      const Color(0xFF0A0A0A),
    );
    expect(radiusOf(VanillaTokens.radiusLg), after);

    await tester.tap(find.bySemanticsLabel('Open theme settings'));
    await tester.pumpAndSettle();
    expect(find.text('Theme settings'), findsOneWidget);
    expect(find.text('Accent color'), findsNothing);
    expect(find.text('Density'), findsNothing);
    expect(find.text('Comfortable'), findsNothing);
    expect(find.text('Neutral'), findsNothing);
    expect(find.text('Light'), findsWidgets);
    expect(find.text('Dark'), findsWidgets);
    expect(tester.takeException(), isNull);

    semantics.dispose();
  });

  test('dashboard_demo starter sources remain independent of Material', () {
    final lib = Directory('lib').existsSync() ? 'lib' : 'registry_source/lib';
    final paths = Directory('$lib/src')
        .listSync(recursive: true)
        .whereType<File>()
        .where(
          (file) =>
              file.path.endsWith('.dart') &&
              (file.path.contains('dashboard_demo') ||
                  file.path.contains('dashboard_overview')),
        )
        .map((file) => file.path)
        .toList();
    expect(paths, isNotEmpty);
    for (final path in paths) {
      expect(
        File(path).readAsStringSync(),
        isNot(contains('package:flutter/material.dart')),
        reason: path,
      );
    }
  });
}

/// Checks that the outermost edge of every pie on screen, with a selected
/// slice pulled out, stays inside the box the pie is laid out in, and returns
/// how many pies it checked.
int _expectPiesFit(WidgetTester tester) {
  // The adapter is private to mix_chart; it is where the resolved spec lands.
  final adapters = find.byWidgetPredicate(
    (widget) => widget.runtimeType.toString() == 'FlPieChartAdapter',
  );

  for (final element in adapters.evaluate()) {
    final spec = (element.widget as dynamic).spec as PieChartSpec;
    final outer =
        (spec.centerRadius ?? 0) +
        (spec.slice?.spec.radius ?? 80) +
        (spec.selectedSliceRadiusOffset ?? 8);
    final box = (element.renderObject! as RenderBox).size;

    expect(
      outer,
      lessThanOrEqualTo(box.shortestSide / 2),
      reason: 'a pie reaching $outer px in a $box box',
    );
  }

  return adapters.evaluate().length;
}

Future<void> _pumpOverview(
  WidgetTester tester, {
  required _Preset preset,
  required double width,
  double height = 800,
  TextScaler textScaler = TextScaler.noScaling,
  RegistryDashboardSampleData data = registryDashboardSampleData,
  TextDirection textDirection = TextDirection.ltr,
}) async {
  final overview = switch (preset) {
    .defaultPreset => VanillaDashboardOverview(data: data),
    .fortal => FortalDashboardOverview(data: data),
    .heroui => HeroUiDashboardOverview(data: data),
  };
  await _pump(
    tester,
    preset: preset,
    width: width,
    height: height,
    textScaler: textScaler,
    textDirection: textDirection,
    child: overview,
  );
}

Future<void> _pumpDashboard(
  WidgetTester tester, {
  required _Preset preset,
  RegistryDashboardDemoPage initialPage = RegistryDashboardDemoPage.overview,
  Duration chatStepDelay = const Duration(milliseconds: 320),
  bool builtInChrome = true,
  Widget? account,
  double width = 1200,
  double height = 800,
  VanillaThemeData? darkTheme,
  double? hostRadius,
  TextDirection textDirection = TextDirection.ltr,
}) => _pump(
  tester,
  preset: preset,
  width: width,
  height: height,
  darkTheme: darkTheme,
  hostRadius: hostRadius,
  textDirection: textDirection,
  child: switch (preset) {
    .defaultPreset => VanillaDashboardDemo(
      key: ValueKey(initialPage),
      brand: const Text('Acme starter'),
      initialPage: initialPage,
      chatStepDelay: chatStepDelay,
      builtInChrome: builtInChrome,
      account: account,
    ),
    .fortal => FortalDashboardDemo(
      key: ValueKey(initialPage),
      brand: const Text('Acme starter'),
      initialPage: initialPage,
      chatStepDelay: chatStepDelay,
      builtInChrome: builtInChrome,
      account: account,
    ),
    .heroui => HeroUiDashboardDemo(
      key: ValueKey(initialPage),
      brand: const Text('Acme starter'),
      initialPage: initialPage,
      chatStepDelay: chatStepDelay,
      builtInChrome: builtInChrome,
      account: account,
    ),
  },
);

Future<void> _pump(
  WidgetTester tester, {
  required _Preset preset,
  required double width,
  required double height,
  required Widget child,
  TextScaler textScaler = TextScaler.noScaling,
  VanillaThemeData? darkTheme,

  double? hostRadius,
  TextDirection textDirection = TextDirection.ltr,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, height);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final app = WidgetsApp(
    color: const Color(0xFFFFFFFF),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    ),
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: textScaler),
      child: Directionality(textDirection: textDirection, child: child!),
    ),
    home: SizedBox(width: width, height: height, child: child),
  );

  await tester.pumpWidget(switch (preset) {
    .defaultPreset => VanillaTheme(
      mode: VanillaThemeMode.light,
      darkTheme: darkTheme,
      theme: hostRadius == null
          ? null
          : const VanillaThemeData.light().copyWith(
              radius: Radius.circular(hostRadius),
            ),
      child: app,
    ),
    .fortal => FortalTheme(
      theme: hostRadius == null
          ? null
          : const FortalThemeData.light(radius: .full),
      child: app,
    ),
    .heroui => HeroUiTheme(
      mode: HeroUiThemeMode.light,
      theme: hostRadius == null
          ? null
          : HeroUiThemeData.light(radius: hostRadius),
      child: app,
    ),
  });
  await tester.pump();
}

Finder _pathGlyph(RemixPathGlyph glyph) => find.byWidgetPredicate(
  (widget) => widget is RemixPathIcon && widget.glyph == glyph,
);

Finder _glyphIn(Finder ancestor, RemixPathGlyph glyph) =>
    find.descendant(of: ancestor, matching: _pathGlyph(glyph));

double _transformAngleIn(WidgetTester tester, Finder ancestor) {
  final transform = tester.widget<Transform>(
    find.descendant(of: ancestor, matching: find.byType(Transform)).first,
  );
  return math
      .atan2(transform.transform.entry(1, 0), transform.transform.entry(0, 0))
      .abs();
}

/// The spec the icon button under [button] resolved.
IconButtonSpec _specOf(WidgetTester tester, Finder button) => tester
    .widget<StyleSpecProvider<IconButtonSpec>>(
      find
          .descendant(
            of: button,
            matching: find.byType(StyleSpecProvider<IconButtonSpec>),
          )
          .first,
    )
    .spec
    .spec;

Color? _fillOf(IconButtonSpec spec) =>
    (spec.container.spec.decoration as BoxDecoration?)?.color;

/// How many focus stops sit inside [root].
int _focusStops(WidgetTester tester, Finder root) {
  final rootElement = tester.element(root);

  return FocusManager.instance.rootScope.traversalDescendants
      .where((node) => _isInside(node.context, rootElement))
      .length;
}

/// Whether the primary focus sits inside [root].
bool _hasFocusWithin(WidgetTester tester, Finder root) => _isInside(
  FocusManager.instance.primaryFocus?.context,
  tester.element(root),
);

bool _isInside(BuildContext? context, Element root) {
  if (context == null) return false;
  var inside = identical(context, root);
  context.visitAncestorElements((ancestor) {
    inside = identical(ancestor, root);
    return !inside;
  });

  return inside;
}

Brightness _brightness(_Preset preset, BuildContext context) =>
    switch (preset) {
      .defaultPreset => VanillaTheme.of(context).brightness,
      .fortal => FortalTheme.of(context).brightness,
      .heroui => HeroUiTheme.of(context).brightness,
    };

Object _radius(_Preset preset, BuildContext context) => switch (preset) {
  .defaultPreset => VanillaTheme.of(context).radius,
  .fortal => FortalTheme.of(context).radius,
  .heroui => HeroUiTheme.of(context).radius,
};

Future<void> _changeRadius(WidgetTester tester, _Preset preset) async {
  if (preset == .fortal) {
    await tester.ensureVisible(find.text('Full').last);
    await tester.tap(find.text('Full').last);
  } else {
    final slider = find.byType(RemixSlider);
    await tester.ensureVisible(slider);
    await tester.drag(slider, const Offset(160, 0));
  }
  await tester.pumpAndSettle();
}

/// Asks the demo agent as a reader does: a suggestion fills the composer in
/// the empty conversation, and Send submits what the composer holds.
Future<void> _ask(WidgetTester tester, String suggestion) async {
  final starter = find.text(suggestion);
  if (starter.evaluate().isNotEmpty) {
    await tester.tap(starter.first);
  } else {
    // Later turns are typed; the prompt is what the suggestion would fill.
    await tester.enterText(
      find.byType(EditableText).last,
      _suggestionPrompts[suggestion]!,
    );
  }
  await tester.pump();
  await tester.tap(find.byKey(const ValueKey('agent-composer-send')));
  await tester.pump();
}

/// What each of the demo's suggestions fills into the composer.
const _suggestionPrompts = {
  'Review checkout':
      'Review the checkout flow and tell me if the cart is ready.',
  'Run terminal checks':
      'Run the checkout tests and tell me if the cart flow is ready.',
  'Recover a failed command':
      'Run the checkout tests again and recover if one fails.',
};
