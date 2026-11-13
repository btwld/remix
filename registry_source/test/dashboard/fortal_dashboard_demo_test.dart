import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_artwork.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_collection.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_data.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_records.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_theme.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_themes.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo_widgets.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_overview.dart';
import 'package:remix/remix.dart';

import '../helpers/test_helpers.dart';

/// Hosts the demo the way an application does: a theme scope the demo edits,
/// above a `WidgetsApp` whose builder installs the theme, an overlay and the
/// toast scope.
class _Host extends StatefulWidget {
  const _Host({
    super.key,
    this.settings = const FortalThemeSettings(appearance: .light),
    this.page = .overview,
    this.data,
    this.textDirection = TextDirection.ltr,
    this.disableAnimations = false,
    this.focusRingWidth,
  });

  /// A host token override, placed inside the theme as a host would.
  final double? focusRingWidth;

  final FortalThemeSettings settings;
  final FortalDashboardDemoPage page;
  final FortalDashboardData? data;
  final TextDirection textDirection;
  final bool disableAnimations;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late FortalThemeSettings _settings = widget.settings;

  @override
  Widget build(BuildContext context) => FortalDashboardThemeScope(
    settings: _settings,
    onChanged: (settings) => setState(() => _settings = settings),
    child: WidgetsApp(
      color: const Color(0xFFFFFFFF),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, _, _) => builder(context),
      ),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(disableAnimations: widget.disableAnimations),
        child: Directionality(
          textDirection: widget.textDirection,
          child: FortalTheme(
            accent: _settings.accentColor,
            mode: _settings.appearance,
            panelBackground: _settings.panelBackground,
            radius: _settings.radius,
            scaling: _settings.scaling,
            child: MixScope.inherit(
              spaces: {
                if (widget.focusRingWidth case final width?)
                  FortalTokens.focusRingWidth: width,
              },
              child: Overlay.wrap(
                child: RemixToastScope(
                  style: fortalToastStyle(),
                  child: child!,
                ),
              ),
            ),
          ),
        ),
      ),
      home: FortalDashboardDemo(initialPage: widget.page, data: widget.data),
    ),
  );
}

Future<void> _pumpDemo(
  WidgetTester tester, {
  Size size = const Size(1440, 1000),
  FortalThemeSettings settings = const FortalThemeSettings(appearance: .light),
  FortalDashboardDemoPage page = .overview,
  FortalDashboardData? data,
  TextDirection textDirection = TextDirection.ltr,
  bool disableAnimations = false,
  double? focusRingWidth,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    _Host(
      // A fresh key per pump: a sweep reuses one tester for many hosts.
      key: UniqueKey(),
      settings: settings,
      page: page,
      data: data,
      textDirection: textDirection,
      disableAnimations: disableAnimations,
      focusRingWidth: focusRingWidth,
    ),
  );
  await tester.pump(const Duration(milliseconds: 300));
}

/// Opens [page] from the sidebar and lets its entrance finish.
Future<void> _open(WidgetTester tester, FortalDashboardDemoPage page) async {
  await tester.tap(find.byKey(ValueKey(page)).first);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

Finder _slot(FortalDashboardDemoPage page) =>
    find.byKey(ValueKey('dashboard-page-${page.name}'));

/// [text] inside [page], whether or not other kept pages show it too.
Finder _onPage(FortalDashboardDemoPage page, String text) =>
    find.descendant(of: _slot(page), matching: find.text(text));

Finder _field(String key) => find.descendant(
  of: find.byKey(ValueKey(key)),
  matching: find.byType(EditableText),
);

/// Counts every build of a widget matching [watched] while [action] runs,
/// first builds included.
Future<int> _buildsDuring(
  bool Function(Widget widget) watched,
  Future<void> Function() action,
) async {
  var count = 0;
  final previous = debugOnRebuildDirtyWidget;
  debugOnRebuildDirtyWidget = (element, _) {
    if (watched(element.widget)) count += 1;
  };
  try {
    await action();
  } finally {
    debugOnRebuildDirtyWidget = previous;
  }

  return count;
}

bool _isOverviewContent(Widget widget) =>
    widget is FortalDashboardOverview ||
    widget is FortalRevenueCard ||
    widget is FortalStatCard ||
    widget is FortalChannelsCard ||
    widget is FortalTopEditionsCard ||
    widget is FortalRecentOrdersCard ||
    widget is FortalActivityCard;

void main() {
  group('page stack', () {
    testWidgets('builds a page once and keeps it across navigation', (
      tester,
    ) async {
      await _pumpDemo(tester);
      expect(find.byType(FortalDashboardCustomersPage), findsNothing);

      final builds = await _buildsDuring(_isOverviewContent, () async {
        await _open(tester, .customers);
        await _open(tester, .orders);
        await _open(tester, .overview);
      });

      // Selecting a destination rebuilds the shell around the pages. The
      // overview is the same widget it was, so nothing in it builds again.
      expect(builds, 0);
      expect(find.byType(FortalDashboardCustomersPage), findsOneWidget);
      expect(find.byType(FortalDashboardOrdersPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('keeps a hidden page with its state', (tester) async {
      await _pumpDemo(tester, page: .customers);
      await tester.enterText(_field('customer-search'), 'Ava');
      await tester.pump();
      expect(_onPage(.customers, 'Ava Wilson'), findsOneWidget);
      expect(_onPage(.customers, 'Olivia Martin'), findsNothing);

      await _open(tester, .orders);
      await _open(tester, .customers);

      expect(
        tester.widget<EditableText>(_field('customer-search')).controller.text,
        'Ava',
      );
      expect(_onPage(.customers, 'Ava Wilson'), findsOneWidget);
      expect(_onPage(.customers, 'Olivia Martin'), findsNothing);
    });

    testWidgets('a hidden page takes no pointer, focus or semantics', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await _pumpDemo(tester);
      // The semantics tree itself, not the widgets: a hidden page stays
      // mounted, so only the tree says what is announced.
      final featured = find.semantics.byLabel(RegExp('^Featured edition'));
      expect(featured, findsOne);

      await _open(tester, .customers);

      // Still mounted, behind the page on screen.
      expect(find.byKey(const ValueKey('overview-revenue')), findsOneWidget);
      expect(
        find.byKey(const ValueKey('overview-revenue')).hitTestable(),
        findsNothing,
      );
      expect(featured, findsNothing);

      // Tab through more stops than the visible chrome and page have. Focus
      // must never land inside the hidden overview.
      for (var stop = 0; stop < 60; stop += 1) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        final focused = primaryFocus?.context;
        if (focused == null) continue;
        var inOverview = false;
        focused.visitAncestorElements((ancestor) {
          inOverview =
              ancestor.widget.key == const ValueKey('dashboard-page-overview');

          return !inOverview;
        });
        expect(inOverview, isFalse, reason: 'Tab stop $stop');
      }
      semantics.dispose();
    });

    testWidgets('the entering page fades in', (tester) async {
      await _pumpDemo(tester);
      await tester.tap(
        find.byKey(const ValueKey(FortalDashboardDemoPage.orders)).first,
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));

      double opacityOf(FortalDashboardDemoPage page) => tester
          .widget<FadeTransition>(
            find
                .descendant(
                  of: _slot(page),
                  matching: find.byType(FadeTransition),
                )
                .first,
          )
          .opacity
          .value;

      expect(opacityOf(.orders), inExclusiveRange(0, 1));
      await tester.pump(const Duration(milliseconds: 300));
      expect(opacityOf(.orders), 1);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the entering page appears at once with reduced motion', (
      tester,
    ) async {
      await _pumpDemo(tester, disableAnimations: true);
      await tester.tap(
        find.byKey(const ValueKey(FortalDashboardDemoPage.orders)).first,
      );
      await tester.pump();

      final fade = tester.widget<FadeTransition>(
        find
            .descendant(
              of: _slot(.orders),
              matching: find.byType(FadeTransition),
            )
            .first,
      );
      expect(fade.opacity.value, 1);
    });

    testWidgets('resizing the window lays out only the page on screen', (
      tester,
    ) async {
      await _pumpDemo(tester);
      final wide = tester.getSize(find.byType(FortalDashboardOverview));
      await _open(tester, .customers);

      tester.view.physicalSize = const Size(1100, 1000);
      await tester.pump();

      // The hidden overview keeps the layout it last had on screen; the
      // visible page follows the window.
      expect(tester.getSize(find.byType(FortalDashboardOverview)), wide);
      expect(
        tester.getSize(find.byType(FortalDashboardCustomersPage)).width,
        lessThan(wide.width),
      );

      await _open(tester, .overview);
      expect(
        tester.getSize(find.byType(FortalDashboardOverview)).width,
        lessThan(wide.width),
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('theme changes', () {
    testWidgets('rebuild the page on screen and no hidden one', (tester) async {
      await _pumpDemo(tester);
      await _open(tester, .customers);

      final builds = await _buildsDuring(_isOverviewContent, () async {
        await tester.tap(
          find.byKey(const ValueKey('theme-quick-toggle')).first,
        );
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
      });

      // The customers page turned dark. The overview behind it was told
      // nothing, so nothing in it built.
      expect(builds, 0);
      expect(
        FortalTheme.of(
          tester.element(find.byType(FortalDashboardCustomersPage)),
        ).isDark,
        isTrue,
      );
      expect(
        FortalTheme.of(
          tester.element(find.byType(FortalStatCard).first),
        ).isDark,
        isFalse,
      );
    });

    testWidgets('reach a hidden page in the frame it is shown', (tester) async {
      await _pumpDemo(tester);
      await _open(tester, .customers);
      await tester.tap(find.byKey(const ValueKey('theme-quick-toggle')).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(
        find.byKey(const ValueKey(FortalDashboardDemoPage.overview)).first,
      );
      await tester.pump();

      // One frame after the tap, before the entrance has run, the overview
      // already holds the new appearance: it never paints the old one.
      final card = tester.element(find.byType(FortalStatCard).first);
      expect(FortalTheme.of(card).isDark, isTrue);
      expect(
        MixScope.tokenOf(FortalTokens.gray12, card),
        resolveFortalTokens(
          const FortalThemeConfig(brightness: Brightness.dark),
        ).gray.scale.step(12),
      );
      expect(
        DefaultTextStyle.of(card).style.color,
        MixScope.tokenOf(FortalTokens.gray12, card),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
    });

    testWidgets('keep a host token override inside every page', (tester) async {
      await _pumpDemo(tester, focusRingWidth: 7);

      double ringWidth(Type page) => MixScope.tokenOf(
        FortalTokens.focusRingWidth,
        tester.element(find.byType(page)),
      );
      expect(ringWidth(FortalDashboardOverview), 7);

      await _open(tester, .customers);
      await tester.tap(find.byKey(const ValueKey('theme-quick-toggle')).first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(ringWidth(FortalDashboardCustomersPage), 7);
      await _open(tester, .overview);
      expect(ringWidth(FortalDashboardOverview), 7);
    });

    testWidgets('keep a page with its state', (tester) async {
      await _pumpDemo(tester, page: .customers);
      await tester.enterText(_field('customer-search'), 'Ava');
      await tester.pump();
      await _open(tester, .orders);

      for (final accent in const [
        FortalAccentColor.mar,
        FortalAccentColor.sol,
      ]) {
        final theme = FortalDashboardThemeScope.of(
          tester.element(find.byType(FortalDashboardDemo)),
        );
        theme.onChanged(theme.settings.copyWith(accentColor: accent));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
      }
      await _open(tester, .customers);

      expect(
        tester.widget<EditableText>(_field('customer-search')).controller.text,
        'Ava',
      );
      expect(_onPage(.customers, 'Ava Wilson'), findsOneWidget);
      expect(
        FortalTheme.of(
          tester.element(find.byType(FortalDashboardCustomersPage)),
        ).accent,
        FortalAccentColor.sol,
      );
    });
  });

  group('rebuild scope', () {
    testWidgets('switching the revenue range rebuilds the revenue card only', (
      tester,
    ) async {
      await _pumpDemo(tester);
      expect(find.text(r'$84.4K'), findsWidgets);

      final builds = await _buildsDuring(
        (widget) =>
            widget is FortalStatCard ||
            widget is FortalChannelsCard ||
            widget is FortalTopEditionsCard ||
            widget is FortalRecentOrdersCard ||
            widget is FortalFeaturedEditionCard,
        () async {
          await tester.tap(
            find.descendant(
              of: find.byKey(const ValueKey('overview-range')),
              matching: find.text('30D'),
            ),
          );
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 400));
        },
      );

      expect(builds, 0);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('overview-revenue')),
          matching: find.text(r'$322.4K'),
        ),
        findsOneWidget,
      );
      expect(find.text('vs previous 30 days'), findsOneWidget);
    });

    testWidgets('typing in quick find rebuilds no page', (tester) async {
      await _pumpDemo(tester);

      final builds = await _buildsDuring(_isOverviewContent, () async {
        await tester.enterText(_field('dashboard-search'), 'a');
        await tester.pump();
        await tester.enterText(_field('dashboard-search'), 'av');
        await tester.pump();
      });

      expect(builds, 0);
    });

    testWidgets('each chart and cover paints in its own layer', (tester) async {
      await _pumpDemo(tester);

      // A repaint boundary between the mark and its card: a hover or scroll
      // that repaints the page does not repaint the chart or the cover.
      void expectOwnLayer(Finder mark, String card) {
        final boundary = tester.firstWidget(
          find.ancestor(of: mark, matching: find.byType(RepaintBoundary)),
        );
        expect(
          find.descendant(
            of: find.byKey(ValueKey(card)),
            matching: find.byWidget(boundary),
          ),
          findsOneWidget,
          reason: card,
        );
      }

      expectOwnLayer(find.byType(LineChart), 'overview-revenue');
      expectOwnLayer(find.byType(PieChart), 'overview-channel-chart');
      expectOwnLayer(
        find.descendant(
          of: find.byKey(const ValueKey('overview-featured')),
          matching: find.byType(CustomPaint),
        ),
        'overview-featured',
      );
    });

    testWidgets('a cover repaints only when its inputs change', (tester) async {
      CustomPainter painter() => tester
          .widget<CustomPaint>(
            find.descendant(
              of: find.byType(FortalArtwork),
              matching: find.byType(CustomPaint),
            ),
          )
          .painter!;
      Future<void> pump({int seed = 0, FortalThemeMode mode = .light}) =>
          tester.pumpRemixApp(
            SizedBox(
              width: 200,
              height: 150,
              child: FortalArtwork(motif: .dunes, accent: .duna, seed: seed),
            ),
            mode: mode,
          );

      await pump();
      final first = painter();
      await pump();
      expect(painter().shouldRepaint(first), isFalse);
      await pump(seed: 4);
      expect(painter().shouldRepaint(first), isTrue);
      await pump(mode: .dark);
      expect(painter().shouldRepaint(first), isTrue);
    });
  });

  group('quick find', () {
    testWidgets('jumps to a record and fills its page search', (tester) async {
      await _pumpDemo(tester);
      await tester.enterText(_field('dashboard-search'), 'ava w');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Customer · New York'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.byKey(const ValueKey('data-grid-customers')).hitTestable(),
        findsWidgets,
      );
      expect(
        tester.widget<EditableText>(_field('customer-search')).controller.text,
        'Ava Wilson',
      );
      expect(_onPage(.customers, 'ava@brightpath.com'), findsOneWidget);
      expect(_onPage(.customers, 'olivia@northstar.co'), findsNothing);
      // Ready for the next search, not echoing where the user already is.
      expect(
        tester.widget<EditableText>(_field('dashboard-search')).controller.text,
        isEmpty,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('drops an order filter that would hide the record', (
      tester,
    ) async {
      await _pumpDemo(tester, page: .orders);
      await tester.tap(
        find.descendant(
          of: find.byKey(const ValueKey('order-status')),
          matching: find.text('Refunded'),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(_onPage(.orders, 'ORD-1048'), findsNothing);

      // ORD-1048 is paid, so the refund filter would leave the table empty.
      await tester.enterText(_field('dashboard-search'), 'ord-1048');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.textContaining('Order · '));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        tester.widget<EditableText>(_field('order-search')).controller.text,
        'ORD-1048',
      );
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('data-grid-orders')),
          matching: find.text('ORD-1048'),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('drops a collection filter that would hide the edition', (
      tester,
    ) async {
      await _pumpDemo(tester, page: .collection);
      await tester.tap(
        find.descendant(
          of: find.byKey(const ValueKey('collection-status')),
          matching: find.text('Sold out'),
        ),
      );
      await tester.pump();
      expect(find.byType(FortalEditionCard), findsOneWidget);

      // Duna Branca is live, so the sold-out filter would show no card.
      await tester.enterText(_field('dashboard-search'), 'duna br');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.textContaining('Edition · '));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.descendant(
          of: find.byType(FortalEditionCard),
          matching: find.text('Duna Branca'),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('jumps to a page', (tester) async {
      await _pumpDemo(tester);
      await tester.enterText(_field('dashboard-search'), 'analy');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Page'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.byKey(const ValueKey('analytics-summary')).hitTestable(),
        findsOneWidget,
      );
    });

    testWidgets('gives way on a narrow window', (tester) async {
      await _pumpDemo(tester, size: const Size(900, 900));

      expect(find.byKey(const ValueKey('dashboard-search')), findsNothing);
      expect(find.byKey(const ValueKey('theme-panel-trigger')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('overview', () {
    testWidgets('leads with revenue on the one inverse surface', (
      tester,
    ) async {
      await _pumpDemo(tester);

      final inverse = tester
          .widgetList<FortalSurface>(find.byType(FortalSurface))
          .where((surface) => surface.emphasis == .inverse);
      expect(inverse, hasLength(1));
      expect(inverse.single.key, const ValueKey('overview-revenue'));

      // Inside it the theme is the opposite appearance; outside it is not.
      final inside = tester.element(
        find.byKey(const ValueKey('dashboard-revenue-chart')).first,
      );
      final outside = tester.element(find.byType(FortalStatCard).first);
      expect(FortalTheme.of(inside).isDark, isTrue);
      expect(FortalTheme.of(outside).isDark, isFalse);
    });

    testWidgets('shows caller data and its derived totals', (tester) async {
      final sample = fortalDashboardSampleData;
      final data = FortalDashboardData(
        metrics: const [
          FortalDashboardMetric(
            id: 'visits',
            label: 'Studio visits',
            value: '312',
            delta: '+3.0%',
            trend: [1, 2, 3],
          ),
        ],
        revenue: const {
          FortalDashboardRange.week: [
            FortalDashboardPoint('Mon', 1, 1),
            FortalDashboardPoint('Tue', 2, 1),
          ],
          FortalDashboardRange.month: [FortalDashboardPoint('Jul 1', 4, 5)],
          FortalDashboardRange.quarter: [FortalDashboardPoint('Q3', 9, 9)],
        },
        channels: sample.channels,
        weeks: sample.weeks,
        editions: sample.editions.sublist(1, 3),
        customers: sample.customers,
        orders: sample.orders.sublist(0, 2),
        activities: sample.activities.sublist(0, 1),
        goals: sample.goals,
        team: sample.team,
        events: sample.events,
        today: sample.today,
      );
      await _pumpDemo(tester, data: data);

      expect(find.text('Studio visits'), findsOneWidget);
      expect(find.byType(FortalStatCard), findsOneWidget);
      // 1 + 2 thousand, up from 1 + 1.
      expect(find.text(r'$3.0K'), findsWidgets);
      expect(find.text('+50.0%'), findsOneWidget);
      // The first edition of the caller's list is the featured one.
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('overview-featured')),
          matching: find.text('Mar Aberto'),
        ),
        findsOneWidget,
      );
      expect(find.text('ORD-1047'), findsOneWidget);
      expect(find.text('ORD-1046'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('View all opens the page it names', (tester) async {
      await _pumpDemo(tester);

      final viewOrders = find
          .byKey(const ValueKey('overview-view-orders'))
          .first;
      await tester.ensureVisible(viewOrders);
      await tester.pump();
      await tester.tap(viewOrders);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        find.byKey(const ValueKey('data-grid-orders')).hitTestable(),
        findsWidgets,
      );

      await _open(tester, .overview);
      final featured = find.byKey(const ValueKey('overview-featured'));
      await tester.ensureVisible(featured);
      await tester.pump();
      await tester.tap(featured);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        find.byKey(const ValueKey('collection-spotlight')).hitTestable(),
        findsOneWidget,
      );
    });
  });

  group('collection', () {
    Finder cards() => find.byType(FortalEditionCard);
    Finder inFilter(String label) => find.descendant(
      of: find.byKey(const ValueKey('collection-status')),
      matching: find.text(label),
    );

    testWidgets('filters by status and by search, and recovers from none', (
      tester,
    ) async {
      await _pumpDemo(tester, page: .collection);
      expect(cards(), findsNWidgets(12));

      await tester.tap(inFilter('Sold out'));
      await tester.pump();
      expect(cards(), findsOneWidget);
      expect(
        find.descendant(of: cards(), matching: find.text('Serra Grande')),
        findsOneWidget,
      );

      await tester.tap(inFilter('All'));
      await tester.pump();
      await tester.enterText(_field('collection-search'), 'cobog');
      await tester.pump();
      expect(cards(), findsNWidgets(3));

      await tester.enterText(_field('collection-search'), 'no such print');
      await tester.pump();
      expect(cards(), findsNothing);
      expect(find.text('No editions found'), findsOneWidget);

      await tester.tap(find.text('Clear filters'));
      await tester.pump();
      expect(cards(), findsNWidgets(12));
      expect(tester.takeException(), isNull);
    });

    testWidgets('switches between cover cards and a table', (tester) async {
      await _pumpDemo(tester, page: .collection);
      expect(find.byKey(const ValueKey('collection-grid')), findsOneWidget);

      await tester.tap(
        find.descendant(
          of: find.byKey(const ValueKey('collection-layout')),
          matching: find.text('List'),
        ),
      );
      await tester.pump();

      expect(find.byKey(const ValueKey('collection-grid')), findsNothing);
      expect(find.byKey(const ValueKey('collection-table')), findsWidgets);
      expect(find.byType(FortalEditionThumbnail), findsNWidgets(12));
      expect(tester.takeException(), isNull);
    });

    testWidgets('a cover card is one named button that opens its edition', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await _pumpDemo(tester, page: .collection);
      final card = find.byKey(const ValueKey('edition-mar-aberto'));
      await tester.ensureVisible(card);
      await tester.pump();

      expect(
        tester.getSemantics(
          find.bySemanticsLabel(RegExp('^Mar Aberto by Tomás Braga')),
        ),
        isSemantics(isButton: true, hasTapAction: true),
      );

      await tester.tap(card);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      final dialog = find.byKey(const ValueKey('edition-dialog'));
      expect(dialog, findsWidgets);
      expect(
        find.descendant(
          of: dialog.first,
          matching: find.textContaining('Five layers of green water'),
        ),
        findsOneWidget,
      );

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(dialog, findsNothing);
      expect(tester.takeException(), isNull);
      semantics.dispose();
    });
  });

  group('themes', () {
    FortalAccentColor accentOf(WidgetTester tester) => FortalTheme.of(
      tester.element(find.byKey(const ValueKey('themes-palettes'))),
    ).accent;

    testWidgets('shows every palette and applies the one chosen', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await _pumpDemo(tester, page: .themes);

      expect(
        find.byType(FortalPaletteCard),
        findsNWidgets(FortalAccentColor.values.length),
      );
      expect(fortalPaletteNotes.keys, FortalAccentColor.values);
      expect(accentOf(tester), FortalAccentColor.orla);
      expect(
        find.semantics.byLabel('Orla palette, gray on gray, in use'),
        findsOne,
      );

      await tester.tap(find.byKey(const ValueKey('palette-mar')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(accentOf(tester), FortalAccentColor.mar);
      expect(
        find.semantics.byLabel('Mar palette, teal on sage, in use'),
        findsOne,
      );
      expect(find.semantics.byLabel('Orla palette, gray on gray'), findsOne);
      // The samples on a card are drawn, not operated: of the eight sample
      // switches on the page, only the specimen's is announced.
      expect(find.semantics.byLabel('Sample switch'), findsOne);
      expect(tester.takeException(), isNull);
      semantics.dispose();
    });

    testWidgets('the specimen lists every button and badge variant', (
      tester,
    ) async {
      await _pumpDemo(tester, page: .themes);
      final specimen = find.byKey(const ValueKey('themes-specimen'));

      for (final variant in FortalButtonVariant.values) {
        expect(
          tester
              .widgetList<FortalButton>(
                find.descendant(
                  of: specimen,
                  matching: find.byType(FortalButton),
                ),
              )
              .where((button) => button.variant == variant),
          isNotEmpty,
          reason: variant.name,
        );
      }
      for (final variant in FortalBadgeVariant.values) {
        expect(
          tester
              .widgetList<FortalBadge>(
                find.descendant(
                  of: specimen,
                  matching: find.byType(FortalBadge),
                ),
              )
              .where((badge) => badge.variant == variant),
          isNotEmpty,
          reason: variant.name,
        );
      }
    });

    testWidgets('the overview applies a palette in one tap', (tester) async {
      await _pumpDemo(tester);
      final caju = find.byKey(const ValueKey('overview-palette-caju')).first;
      await tester.ensureVisible(caju);
      await tester.pump();

      await tester.tap(caju);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(
        FortalTheme.of(
          tester.element(find.byKey(const ValueKey('overview-palettes'))),
        ).accent,
        FortalAccentColor.caju,
      );
      // The chosen palette's button fills in; the others stay soft.
      expect(
        tester.widget<FortalButton>(caju).variant,
        FortalButtonVariant.solid,
      );
      expect(
        tester
            .widget<FortalButton>(
              find.byKey(const ValueKey('overview-palette-orla')).first,
            )
            .variant,
        FortalButtonVariant.soft,
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('schedule', () {
    testWidgets('opens on the sample day and follows the calendar', (
      tester,
    ) async {
      await _pumpDemo(tester, page: .schedule);
      final day = find.byKey(const ValueKey('schedule-day'));

      expect(
        find.descendant(of: day, matching: find.text('Sat, Jul 18')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: day, matching: find.text('2 events')),
        findsOneWidget,
      );
      expect(find.text('7 events in range'), findsOneWidget);

      await tester.tap(
        find.descendant(
          of: find.byKey(const ValueKey('schedule-calendar')),
          matching: find.text('21'),
        ),
      );
      await tester.pump();

      expect(
        find.descendant(of: day, matching: find.text('Tue, Jul 21')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: day,
          matching: find.text('Gallery pickup · Serra Grande'),
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('adds an event, and asks for a title first', (tester) async {
      await _pumpDemo(tester, page: .schedule);
      await tester.tap(find.byKey(const ValueKey('schedule-new-event')).first);
      await tester.pumpAndSettle();
      final add = find.byKey(const ValueKey('schedule-dialog-add')).first;

      await tester.tap(add);
      await tester.pump();
      expect(find.text('Give the event a title.'), findsOneWidget);

      await tester.enterText(_field('schedule-dialog-title'), 'Varnish day');
      await tester.pump();
      await tester.tap(add);
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('schedule-dialog')), findsNothing);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('schedule-day')),
          matching: find.text('Varnish day'),
        ),
        findsOneWidget,
      );
      expect(find.text('8 events in range'), findsOneWidget);
      // Let the confirmation toast leave before the test ends.
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('filters', () {
    testWidgets('orders filter by status through named tabs', (tester) async {
      final semantics = tester.ensureSemantics();
      await _pumpDemo(tester, page: .orders);
      final filter = find.byKey(const ValueKey('order-status'));

      expect(find.semantics.byLabel('Filter orders by status'), findsOne);
      expect(_onPage(.orders, 'ORD-1048'), findsOneWidget);

      await tester.tap(
        find.descendant(of: filter, matching: find.text('Refunded')),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(_onPage(.orders, 'ORD-1045'), findsOneWidget);
      expect(_onPage(.orders, 'ORD-1048'), findsNothing);
      // Every row left is a refund.
      final badges = tester.widgetList<FortalStatusBadge>(
        find.descendant(
          of: _slot(.orders),
          matching: find.byType(FortalStatusBadge),
        ),
      );
      expect(badges, hasLength(4));
      expect(badges.map((badge) => badge.label).toSet(), {'Refunded'});
      expect(tester.takeException(), isNull);
      semantics.dispose();
    });

    testWidgets('a filter with no rows offers a way back', (tester) async {
      await _pumpDemo(tester, page: .customers);
      await tester.enterText(_field('customer-search'), 'nobody at all');
      await tester.pump();
      expect(find.text('No customers found'), findsOneWidget);

      await tester.tap(find.text('Clear filters'));
      await tester.pump();

      expect(find.text('No customers found'), findsNothing);
      expect(_onPage(.customers, 'Alexander Scott'), findsOneWidget);
    });
  });

  group('quick find shortcut', () {
    testWidgets('focuses the field from anywhere', (tester) async {
      await _pumpDemo(tester);
      final field = tester.widget<EditableText>(_field('dashboard-search'));
      expect(field.focusNode.hasFocus, isFalse);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.metaLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.metaLeft);
      await tester.pump();

      expect(field.focusNode.hasFocus, isTrue);
    });

    testWidgets('a palette is one of the things it finds', (tester) async {
      await _pumpDemo(tester);
      await tester.enterText(_field('dashboard-search'), 'duna');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Palette · Brown on sand'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(FortalPaletteCard).hitTestable(), findsWidgets);
      expect(
        FortalTheme.of(
          tester.element(find.byKey(const ValueKey('themes-palettes'))),
        ).accent,
        FortalAccentColor.duna,
      );
    });
  });

  group('every page', () {
    for (final page in FortalDashboardDemoPage.values) {
      testWidgets('${page.name} fits from a small phone to a wide display', (
        tester,
      ) async {
        for (final width in const [
          320.0,
          390.0,
          768.0,
          1024.0,
          1440.0,
          1920.0,
        ]) {
          await _pumpDemo(tester, size: Size(width, 900), page: page);
          expect(tester.takeException(), isNull, reason: 'width $width');
        }
      });

      testWidgets('${page.name} fits dark, right to left, enlarged and round', (
        tester,
      ) async {
        for (final width in const [390.0, 1440.0]) {
          await _pumpDemo(
            tester,
            size: Size(width, 900),
            page: page,
            textDirection: TextDirection.rtl,
            settings: const FortalThemeSettings(
              appearance: .dark,
              accentColor: .caju,
              panelBackground: .translucent,
              radius: .full,
              scaling: .percent110,
            ),
          );
          expect(tester.takeException(), isNull, reason: 'width $width');
        }
      });
    }

    testWidgets('survives a data set with nothing in it', (tester) async {
      final empty = FortalDashboardData(
        metrics: const [],
        revenue: const {
          FortalDashboardRange.week: [],
          FortalDashboardRange.month: [],
          FortalDashboardRange.quarter: [],
        },
        channels: const [],
        weeks: const [],
        editions: const [],
        customers: const [],
        orders: const [],
        activities: const [],
        goals: const [],
        team: const [],
        events: const [],
        today: DateTime(2026, 7, 18),
      );
      for (final page in FortalDashboardDemoPage.values) {
        await _pumpDemo(tester, page: page, data: empty);
        expect(tester.takeException(), isNull, reason: page.name);
      }
    });

    testWidgets('renders in every accent and appearance', (tester) async {
      for (final accent in FortalAccentColor.values) {
        for (final appearance in const [
          FortalThemeMode.light,
          FortalThemeMode.dark,
        ]) {
          await _pumpDemo(
            tester,
            settings: FortalThemeSettings(
              appearance: appearance,
              accentColor: accent,
            ),
          );
          expect(
            tester.takeException(),
            isNull,
            reason: '${accent.name} ${appearance.name}',
          );
        }
      }
    });
  });
}
