import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/app_bar.dart';
import 'package:registry_source/src/heroui/recipes/dashboard/dashboard_shell.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _overviewIcon = IconData(0xe000, fontFamily: 'Ahem');
const _reportsIcon = IconData(0xe001, fontFamily: 'Ahem');

const _sections = <RemixSidebarSection<String>>[
  RemixSidebarSection(
    label: 'Workspace',
    destinations: [
      RemixSidebarDestination(
        value: 'overview',
        label: 'Overview',
        icon: _overviewIcon,
      ),
      RemixSidebarDestination(
        value: 'reports',
        label: 'Reports',
        icon: _reportsIcon,
      ),
    ],
  ),
];

Future<void> _pump(
  WidgetTester tester, {
  required Size size,
  String mode = 'light',
  bool? collapsed,
  ValueChanged<bool>? onCollapsedChanged,
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    WidgetsApp(
      color: const Color(0xFFFFFFFF),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, _, _) => builder(context),
      ),
      builder: (context, navigator) => HeroUiTheme(
        mode: HeroUiThemeMode.values.byName(mode),
        child: navigator!,
      ),
      home: HeroUiDashboardShell<String>(
        sections: _sections,
        selectedValue: 'overview',
        onSelected: (_) {},
        body: const Text('Overview body'),
        title: 'Overview',
        brand: const Text('Acme brand'),
        account: const Text('Workspace account'),
        onSearchChanged: (_) {},
        collapsed: collapsed,
        onCollapsedChanged: onCollapsedChanged,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final mode in ['light', 'dark']) {
    testWidgets('desktop: the brand row lines up with the app bar in $mode', (
      tester,
    ) async {
      await _pump(tester, size: const Size(1440, 900), mode: mode);
      expect(tester.takeException(), isNull);

      final appBar = tester.getRect(find.byType(HeroUiAppBar));
      expect(appBar.top, 0);
      expect(appBar.height, heroUiAppBarToolbarHeight);
      // Both rows share the toolbar's center line above the 1px separator.
      expect(
        tester.getCenter(find.text('Acme brand')).dy,
        (heroUiAppBarToolbarHeight - 1) / 2,
      );
      expect(
        tester
            .getCenter(find.byKey(const ValueKey('dashboard-collapse')).first)
            .dy,
        (heroUiAppBarToolbarHeight - 1) / 2,
      );
      expect(
        tester
            .getSize(find.byKey(const ValueKey('dashboard-sidebar')).first)
            .width,
        256,
      );
      expect(find.byKey(const ValueKey('dashboard-search')), findsWidgets);
      expect(find.byKey(const ValueKey('dashboard-menu')), findsNothing);

      final brandRow = tester
          .widgetList<Container>(
            find.ancestor(
              of: find.text('Acme brand'),
              matching: find.byType(Container),
            ),
          )
          .map((container) => container.decoration)
          .whereType<BoxDecoration>()
          .firstWhere((decoration) => decoration.border != null);
      expect(brandRow.color, heroUiToken(HeroUiTokens.background, mode));
      expect(
        (brandRow.border! as Border).bottom,
        BorderSide(color: heroUiToken(HeroUiTokens.separator, mode)),
      );
    });

    testWidgets('compact: a menu button opens the sheet in $mode', (
      tester,
    ) async {
      await _pump(tester, size: const Size(390, 844), mode: mode);
      expect(tester.takeException(), isNull);
      expect(find.byKey(const ValueKey('dashboard-sidebar')), findsNothing);
      expect(find.byKey(const ValueKey('dashboard-search')), findsNothing);
      expect(tester.getSize(find.byType(HeroUiAppBar)).height, 64);

      await tester.tap(find.byKey(const ValueKey('dashboard-menu')).first);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('dashboard-sidebar')), findsWidgets);
      expect(find.text('Acme brand'), findsOneWidget);
      expect(find.byKey(const ValueKey('dashboard-collapse')), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('a collapsed rail centres each destination icon', (tester) async {
    await _pump(tester, size: const Size(1440, 900), collapsed: true);
    final rail = tester.getRect(
      find.byKey(const ValueKey('dashboard-sidebar')).first,
    );
    expect(rail.width, 72);
    // The 1px end separator is part of the panel; centre on the rest.
    for (final icon in [_overviewIcon, _reportsIcon]) {
      expect(
        tester.getCenter(find.byIcon(icon)).dx,
        moreOrLessEquals((rail.width - 1) / 2, epsilon: 0.5),
      );
    }
    expect(find.text('Workspace account'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keyboard focus on the collapse button does not move it', (
    tester,
  ) async {
    final previous = FocusManager.instance.highlightStrategy;
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
    addTearDown(() => FocusManager.instance.highlightStrategy = previous);

    await _pump(tester, size: const Size(1440, 900));
    final collapse = find.byKey(const ValueKey('dashboard-collapse')).first;
    final idle = tester.getRect(collapse);
    final overview = find.descendant(
      of: find.byKey(const ValueKey('dashboard-sidebar')).first,
      matching: find.bySemanticsLabel('Overview'),
    );
    final destination = tester.getRect(overview);

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    final focused = FocusManager.instance.primaryFocus!.context!;
    expect(
      find.ancestor(
        of: find.byElementPredicate((e) => e == focused),
        matching: collapse,
      ),
      findsOneWidget,
    );
    expect(tester.getRect(collapse), idle);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(
      tester
          .resolvedSpecOf<ToggleSpec>(find.byIcon(_overviewIcon))
          .containerEffects
          ?.outline
          .width,
      HeroUiTokens.focusWidth,
    );
    expect(tester.getRect(overview), destination);
    expect(tester.takeException(), isNull);
  });
}
