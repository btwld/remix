import 'package:dashboard/main.dart';
import 'package:dashboard/shell/dashboard_page.dart';
import 'package:dashboard/shell/top_bar.dart';
import 'package:dashboard/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> mount(
    WidgetTester tester, {
    Size size = const Size(1280, 900),
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const DashboardApp());
  }

  Future<void> finishMotion(WidgetTester tester) async {
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Finder sidebar() => find.byType(UiSidebar<DashboardPage>);
  Finder collapse() => find.byKey(const ValueKey('dashboard-collapse')).first;

  bool compactOpen(WidgetTester tester) => UiSidebarLayoutScope.of(
    tester.element(find.byKey(const ValueKey('dashboard-title'))),
  ).isCompactOpen;

  testWidgets('installed shell animates desktop collapse in both directions', (
    tester,
  ) async {
    await mount(tester);
    expect(tester.getSize(sidebar()).width, 256);
    expect(tester.takeException(), isNull, reason: 'initial expanded shell');

    for (final expectedWidth in [72.0, 256.0]) {
      await tester.tap(collapse());
      await tester.pump();
      await finishMotion(tester);
      expect(tester.getSize(sidebar()).width, expectedWidth);
      expect(
        tester.takeException(),
        isNull,
        reason: 'shell after animating to width $expectedWidth',
      );
    }
  });

  testWidgets('host actions, navigation, and collapse remain connected', (
    tester,
  ) async {
    await mount(tester);
    expect(find.byType(TopBar), findsOneWidget);
    expect(find.byKey(const ValueKey('theme-quick-toggle')), findsOneWidget);
    expect(find.byKey(const ValueKey('theme-panel-trigger')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('topbar-account-trigger')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('sidebar-account-trigger')),
      findsOneWidget,
    );

    await tester.tap(collapse());
    await finishMotion(tester);
    expect(find.byKey(const ValueKey('sidebar-account-trigger')), findsNothing);

    await tester.tap(find.byKey(const ValueKey(DashboardPage.customers)).first);
    await tester.pump();
    expect(find.text('Customers'), findsWidgets);
    expect(tester.getSize(sidebar()).width, 72);
    expect(tester.takeException(), isNull);
  });

  testWidgets('compact drawer opens, selects, closes, and restores focus', (
    tester,
  ) async {
    await mount(tester, size: const Size(390, 844));
    final menu = find.byKey(const ValueKey('dashboard-menu')).first;
    expect(menu, findsOneWidget);
    expect(find.byKey(const ValueKey('theme-quick-toggle')), findsOneWidget);
    expect(find.byKey(const ValueKey('theme-panel-trigger')), findsOneWidget);
    expect(tester.takeException(), isNull, reason: 'compact shell');

    await tester.tap(menu);
    await finishMotion(tester);
    expect(compactOpen(tester), isTrue);
    expect(tester.takeException(), isNull, reason: 'open drawer');

    await tester.tap(find.byKey(const ValueKey(DashboardPage.settings)).first);
    await finishMotion(tester);
    expect(compactOpen(tester), isFalse);
    expect(find.text('Settings'), findsWidgets);
    expect(tester.takeException(), isNull, reason: 'select destination');

    await tester.tap(menu);
    await finishMotion(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await finishMotion(tester);
    expect(compactOpen(tester), isFalse);
    expect(FocusManager.instance.primaryFocus, isNotNull);
    expect(tester.takeException(), isNull, reason: 'dismiss drawer');
  });

  testWidgets('short viewport keeps navigation scroll valid after collapse', (
    tester,
  ) async {
    await mount(tester, size: const Size(1100, 500));
    final scroll = find.descendant(
      of: sidebar(),
      matching: find.byType(Scrollable),
    );
    await tester.drag(scroll, const Offset(0, -230));
    await tester.pump(const Duration(milliseconds: 200));
    final position = tester.state<ScrollableState>(scroll).position;
    final before = position.pixels;
    expect(before, greaterThan(0));

    await tester.tap(collapse());
    await finishMotion(tester);
    expect(
      position.pixels,
      closeTo(
        before.clamp(position.minScrollExtent, position.maxScrollExtent),
        .1,
      ),
    );
    expect(tester.takeException(), isNull);
  });
}
