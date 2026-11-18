import 'package:dashboard/main.dart';
import 'package:dashboard/ui/ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shell switches to the sheet strictly below 720 pixels', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    bool isCompact() => UiSidebarLayoutScope.of(
      tester.element(find.byKey(const ValueKey('dashboard-title'))),
    ).isCompact;

    tester.view.physicalSize = const Size(720, 800);
    await tester.pumpWidget(const DashboardApp());
    expect(isCompact(), isFalse);
    expect(find.byKey(const ValueKey('dashboard-menu')), findsNothing);

    tester.view.physicalSize = const Size(719, 800);
    await tester.pumpWidget(const DashboardApp());
    expect(isCompact(), isTrue);
    expect(find.byKey(const ValueKey('dashboard-menu')), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('installed shell keeps brand and host actions in its headers', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    void expectHeaderContent() {
      expect(find.byKey(const ValueKey('dashboard-brand')), findsOneWidget);
      expect(find.byType(UiDashboardTopBar), findsOneWidget);
      expect(find.byKey(const ValueKey('dashboard-title')), findsOneWidget);
      expect(tester.getCenter(find.byType(UiDashboardTopBar)).dy, lessThan(64));
    }

    tester.view.physicalSize = const Size(1000, 800);
    await tester.pumpWidget(const DashboardApp());
    expectHeaderContent();

    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpWidget(const DashboardApp());
    await tester.tap(find.byKey(const ValueKey('dashboard-menu')).first);
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expectHeaderContent();
  });

  testWidgets('the sidebar pins its brand and account rows around the '
      'scrolling navigation', (tester) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    tester.view.physicalSize = const Size(1000, 800);
    await tester.pumpWidget(const DashboardApp());

    final sidebar = find.byType(UiSidebar<UiDashboardDemoPage>);
    final panel = tester.getRect(sidebar);
    final brand = tester.getRect(find.byKey(const ValueKey('dashboard-brand')));
    final account = tester.getRect(
      find.byKey(const ValueKey('sidebar-account-trigger')),
    );

    expect(brand.top, greaterThanOrEqualTo(panel.top));
    expect(brand.bottom, lessThan(account.top));
    expect(account.bottom, lessThanOrEqualTo(panel.bottom));
    expect(account.top, greaterThan(brand.bottom));

    // The destination region owns the only scroll view in the panel, so the
    // brand and account rows stay fixed.
    final scrollable = find.descendant(
      of: sidebar,
      matching: find.byType(Scrollable),
    );
    expect(scrollable, findsOneWidget);
    expect(
      find.descendant(of: scrollable, matching: find.byType(UiActionMenu)),
      findsNothing,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('overview metrics collapse 4 to 2 to 1 and stretch in-row', (
    tester,
  ) async {
    // The grid is 4 wide from 1000 of content, 2 wide from 520, else 1. The
    // page adds 48 of padding (32 under a 600 wide window).
    final wide = await _pumpOverview(tester, width: 1200);
    expect(wide[1].top, closeTo(wide[0].top, 0.5));
    expect(wide[2].top, closeTo(wide[0].top, 0.5));
    expect(wide[3].top, closeTo(wide[0].top, 0.5));
    expect(wide[0].height, closeTo(wide[3].height, 0.5));
    expect(wide[0].height, closeTo(wide[1].height, 0.5));

    final medium = await _pumpOverview(tester, width: 800);
    expect(medium[1].top, closeTo(medium[0].top, 0.5));
    expect(medium[2].top, greaterThan(medium[0].bottom));
    expect(medium[3].top, closeTo(medium[2].top, 0.5));
    expect(medium[0].height, closeTo(medium[1].height, 0.5));
    expect(medium[2].height, closeTo(medium[3].height, 0.5));

    final compact = await _pumpOverview(tester, width: 500);
    expect(compact[1].top, greaterThan(compact[0].bottom));
    expect(compact[2].top, greaterThan(compact[1].bottom));
    expect(compact[3].top, greaterThan(compact[2].bottom));
    expect(tester.takeException(), isNull);
  });

  testWidgets('recent orders and activity sit side-by-side then stack', (
    tester,
  ) async {
    // Two thirds and one third, in one column under 900 of content.
    await _pumpOverview(tester, width: 948);
    final wideOrders = _cardAround(tester, find.text('Recent orders'));
    final wideActivity = _cardAround(tester, find.text('Activity'));
    expect(wideActivity.top, closeTo(wideOrders.top, 0.5));
    expect(wideActivity.height, closeTo(wideOrders.height, 0.5));
    expect(wideActivity.left, greaterThan(wideOrders.right));
    expect(wideOrders.width, greaterThan(wideActivity.width));

    await _pumpOverview(tester, width: 947);
    final stackedOrders = _cardAround(tester, find.text('Recent orders'));
    final stackedActivity = _cardAround(tester, find.text('Activity'));
    expect(stackedActivity.top, greaterThan(stackedOrders.bottom));
    expect(stackedActivity.left, closeTo(stackedOrders.left, 0.5));
    expect(tester.takeException(), isNull);
  });

  testWidgets('settings profile fields sit side-by-side then stack', (
    tester,
  ) async {
    Rect field(String label) => tester.getRect(
      find
          .ancestor(of: find.text(label), matching: find.byType(UiTextField))
          .first,
    );

    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    // The profile tab is the page's first tab.
    Future<void> pumpSettings() => tester.pumpWidget(
      UiTheme(
        child: WidgetsApp(
          color: const Color(0xFFFFFFFF),
          pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (context, _, _) => builder(context),
          ),
          home: const UiDashboardSettingsPage(),
        ),
      ),
    );
    await pumpSettings();
    final wideName = field('Name');
    final wideEmail = field('Email');
    expect(wideEmail.top, closeTo(wideName.top, 0.5));
    expect(wideEmail.left, greaterThan(wideName.right));

    tester.view.physicalSize = const Size(500, 1600);
    await pumpSettings();
    final stackedName = field('Name');
    final stackedEmail = field('Email');
    expect(stackedEmail.top, greaterThan(stackedName.bottom));
    expect(stackedEmail.left, closeTo(stackedName.left, 0.5));
    expect(tester.takeException(), isNull);
  });

  testWidgets('overview cards stretch in a row and size rows to content', (
    tester,
  ) async {
    // Revenue leads a row beside the featured edition; the channel, top
    // editions and goals cards share the row below the metrics.
    Future<List<Rect>> cards() async => [
      _cardAround(tester, find.text('Revenue')),
      // The keyed widget is the card itself.
      tester.getRect(find.byKey(const ValueKey('overview-featured')).first),
      _cardAround(tester, find.text('Sales by channel')),
      _cardAround(tester, find.text('Top editions')),
      _cardAround(tester, find.text('Studio goals')),
    ];

    await _pumpOverview(tester, width: 1200);
    final wide = await cards();
    expect(wide[1].top, closeTo(wide[0].top, 0.5));
    expect(wide[1].height, closeTo(wide[0].height, 0.5));
    expect(wide[3].top, closeTo(wide[2].top, 0.5));
    expect(wide[4].top, closeTo(wide[2].top, 0.5));
    expect(wide[3].height, closeTo(wide[2].height, 0.5));
    expect(wide[4].height, closeTo(wide[2].height, 0.5));

    await _pumpOverview(tester, width: 700);
    final compact = await cards();
    expect(compact[1].top, greaterThan(compact[0].bottom));
    expect(compact[3].top, greaterThan(compact[2].bottom));
    expect(compact[4].top, greaterThan(compact[3].bottom));
    expect(tester.takeException(), isNull);
  });
}

Future<List<Rect>> _pumpOverview(
  WidgetTester tester, {
  required double width,
}) async {
  tester.view.physicalSize = Size(width, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    UiTheme(
      child: WidgetsApp(
        color: const Color(0xFFFFFFFF),
        pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        ),
        home: const UiDashboardOverview(),
      ),
    ),
  );
  return [
    _cardAround(tester, find.text('Orders')),
    _cardAround(tester, find.text('Active collectors')),
    _cardAround(tester, find.text('Avg. order value')),
    _cardAround(tester, find.text('Shipped on time')),
  ];
}

Rect _cardAround(WidgetTester tester, Finder label) {
  return tester.getRect(
    find.ancestor(of: label, matching: find.byType(UiSurface)).first,
  );
}
