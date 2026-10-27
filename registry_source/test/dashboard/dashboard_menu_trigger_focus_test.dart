import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_theme.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_widgets.dart';
import 'package:remix/remix.dart';

import '../helpers/pixels.dart';
import '../helpers/test_helpers.dart';

/// Every menu trigger in the dashboard demo is a keyboard focus stop, so each
/// shows a visible `focus-8` ring when it takes focus from the keyboard.
void main() {
  late FocusHighlightStrategy previousStrategy;

  setUp(() {
    previousStrategy = FocusManager.instance.highlightStrategy;
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
  });

  tearDown(() => FocusManager.instance.highlightStrategy = previousStrategy);

  /// Pumps [child] on an opaque page, takes keyboard focus with [focus], and
  /// expects a `focus-8` ring on each edge of [trigger] with nothing 3px in.
  Future<void> expectRingOnFocus(
    WidgetTester tester, {
    required Widget child,
    required Finder trigger,
    required Future<void> Function() focus,
  }) async {
    final boundary = GlobalKey();
    await tester.pumpRemixApp(
      RepaintBoundary(
        key: boundary,
        child: ColoredBox(
          color: const Color(0xFFFFFFFF),
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    );
    final rect = tester.getRect(trigger);
    final idle = await capturePixels(tester, boundary);

    await focus();
    await tester.pumpAndSettle();
    final focused = await capturePixels(tester, boundary);
    final focus8 = MixScope.tokenOf(
      FortalTokens.focus8,
      tester.element(trigger),
    );

    final origin = tester.getTopLeft(find.byKey(boundary));
    Color pixel(Pixels pixels, Offset logical) {
      final device = (logical - origin) * pixelScale.toDouble();
      return pixels.at(device.dx.round(), device.dy.round());
    }

    for (final at in <Offset Function(double inside)>[
      (inside) => Offset(rect.center.dx, rect.top + inside),
      (inside) => Offset(rect.center.dx, rect.bottom - inside),
      (inside) => Offset(rect.left + inside, rect.center.dy),
      (inside) => Offset(rect.right - inside, rect.center.dy),
    ]) {
      expectNearColor(pixel(focused, at(0.5)), focus8);
      expectNearColor(pixel(focused, at(3)), pixel(idle, at(3)));
    }
    expect(tester.getRect(trigger), rect);
  }

  Future<void> tab(WidgetTester tester) =>
      tester.sendKeyEvent(LogicalKeyboardKey.tab);

  testWidgets('the data-table kebab rings on keyboard focus', (tester) async {
    await expectRingOnFocus(
      tester,
      child: FortalActionMenu(
        trigger: fortalDataTableActionsTrigger('Actions for Ada'),
        actions: const [FortalAction(value: 'view', label: 'View profile')],
        onSelected: (_) {},
      ),
      trigger: find.byType(RemixIconButton),
      focus: () => tab(tester),
    );
  });

  testWidgets('the sidebar account row rings on keyboard focus', (
    tester,
  ) async {
    await expectRingOnFocus(
      tester,
      child: const SizedBox(width: 256, child: FortalDashboardSidebarAccount()),
      trigger: find.descendant(
        of: find.byKey(const ValueKey('sidebar-account-trigger')),
        matching: find.byType(RowBox),
      ),
      focus: () => tab(tester),
    );
  });

  testWidgets('the top-bar account avatar rings on keyboard focus', (
    tester,
  ) async {
    final trigger = find.descendant(
      of: find.byKey(const ValueKey('topbar-account-trigger')),
      matching: find.byType(RemixIconButton),
    );
    await expectRingOnFocus(
      tester,
      child: FortalDashboardThemeScope(
        settings: const FortalThemeSettings(),
        onChanged: (_) {},
        child: const FortalDashboardTopBar(),
      ),
      trigger: trigger,
      focus: () async =>
          tester.widget<RemixIconButton>(trigger).focusNode!..requestFocus(),
    );
  });

  testWidgets('the top-bar account avatar is one named, expandable button', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpRemixApp(
      FortalDashboardThemeScope(
        settings: const FortalThemeSettings(),
        onChanged: (_) {},
        child: const FortalDashboardTopBar(),
      ),
    );

    expect(find.semantics.byLabel('Account menu'), findsOne);
    expect(
      tester.getSemantics(find.byType(FortalAvatar)),
      isSemantics(
        label: 'Account menu',
        isButton: true,
        hasTapAction: true,
        hasExpandedState: true,
        isExpanded: false,
      ),
    );
    semantics.dispose();
  });
}
