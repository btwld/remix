import 'package:flutter/widgets.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../../dashboard/dashboard_demo_base.dart';
import '../../../dashboard/dashboard_demo_chat.dart';
import '../../../dashboard/dashboard_demo_charts.dart';
import '../../../dashboard/dashboard_demo_content.dart';
import '../../../dashboard/dashboard_sample_data.dart';
import '../../components/button.dart';
import '../../components/card.dart';
import '../../components/chart.dart';
import '../../components/heading.dart';
import '../../components/icon_button.dart';
import '../../components/menu.dart';
import '../../components/popover.dart';
import '../../components/text.dart';
import '../../components/toast.dart';
import '../../theme/theme.dart';
import '../activity_recipe.dart';
import '../answer_recipe.dart';
import '../composer_recipe.dart';
import '../execution_recipe.dart';
import '../message_recipe.dart';
import '../permission_recipe.dart';
import '../plan_recipe.dart';
import '../transcript_recipe.dart';
import 'dashboard_demo_gallery_actions.dart';
import 'dashboard_demo_gallery_display.dart';
import 'dashboard_demo_gallery_forms.dart';
import 'dashboard_demo_gallery_navigation.dart';
import 'dashboard_demo_gallery_overlays.dart';
import 'dashboard_demo_gallery_typography.dart';
import 'dashboard_demo_records.dart';
import 'dashboard_demo_settings.dart';
import 'dashboard_overview.dart';
import 'dashboard_shell.dart';

/// Full Fortal dashboard demo.
///
/// This is the open-code equivalent of the repository's Fortal showcase: it
/// includes the same Workspace, Data, Manage, and Components destinations,
/// while demonstrating the Radix-aligned Fortal vocabulary honestly.
class FortalDashboardDemo extends StatefulWidget {
  const FortalDashboardDemo({
    super.key,
    this.brand = const FortalText(
      'Northstar',
      size: .size3,
      weight: .bold,
      softWrap: false,
      truncate: true,
    ),
    this.account,
    this.headerActions = const [],
    this.onSearchChanged,
    this.data = registryDashboardSampleData,
    this.initialPage = RegistryDashboardDemoPage.overview,
    this.collapsed,
    this.initiallyCollapsed = false,
    this.onCollapsedChanged,
    this.builtInChrome = true,
    this.chatStepDelay = const Duration(milliseconds: 320),
  });

  final Widget brand;
  final Widget? account;
  final List<Widget> headerActions;
  final ValueChanged<String>? onSearchChanged;
  final RegistryDashboardSampleData data;
  final RegistryDashboardDemoPage initialPage;
  final bool? collapsed;
  final bool initiallyCollapsed;
  final ValueChanged<bool>? onCollapsedChanged;
  final bool builtInChrome;
  final Duration chatStepDelay;

  @override
  State<FortalDashboardDemo> createState() => _FortalDashboardDemoState();
}

class _FortalDashboardDemoState extends State<FortalDashboardDemo> {
  /// The appearance the toggle chose, or null to follow the scope this demo
  /// is placed in.
  bool? _dark;
  bool? _ambientIsDark;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ambient = FortalTheme.maybeOf(context)?.isDark;
    if (_ambientIsDark != null && ambient != _ambientIsDark) {
      _dark = null;
    }
    _ambientIsDark = ambient;
  }

  bool get _isDark => _dark ?? (FortalTheme.maybeOf(context)?.isDark ?? false);

  @override
  Widget build(BuildContext context) {
    const kit = _FortalDashboardDemoKit();
    final demo = RegistryDashboardDemoBase(
      initialPage: widget.initialPage,
      shellBuilder:
          (
            context, {
            required sections,
            required selectedValue,
            required onSelected,
            required body,
            required title,
            required onSearchChanged,
          }) => FortalDashboardShell<RegistryDashboardDemoPage>(
            sections: sections,
            selectedValue: selectedValue,
            onSelected: onSelected,
            body: body,
            title: title,
            headerTitle: widget.builtInChrome
                ? _FortalBreadcrumb(page: selectedValue)
                : null,
            brand: widget.brand,
            account:
                widget.account ??
                (widget.builtInChrome ? const _FortalAccount() : null),
            headerActions: [
              if (widget.builtInChrome) ..._chromeActions(),
              ...widget.headerActions,
            ],
            onSearchChanged:
                widget.builtInChrome || widget.onSearchChanged != null
                ? (value) {
                    onSearchChanged(value);
                    widget.onSearchChanged?.call(value);
                  }
                : null,
            collapsed: widget.collapsed,
            initiallyCollapsed: widget.initiallyCollapsed,
            onCollapsedChanged: widget.onCollapsedChanged,
          ),
      pageBuilder: (context, page, query, onSelected) => switch (page) {
        .overview => FortalDashboardOverview(
          data: widget.data,
          onViewOrders: () => onSelected(RegistryDashboardDemoPage.orders),
        ),
        .chat => RegistryDashboardChatPage(
          styles: _fortalAgentStyles(),
          stepDelay: widget.chatStepDelay,
        ),
        .customers => FortalDashboardCustomersPage(globalQuery: query),
        .orders => FortalDashboardOrdersPage(globalQuery: query),
        .settings => FortalDashboardSettingsPage(
          darkMode: _dark,
          onDarkModeChanged: (value) => setState(() => _dark = value),
        ),
        .actions => const GalleryActionsPage(),
        .forms => const GalleryFormsPage(),
        .dataDisplay => const GalleryDisplayPage(),
        .overlays => const GalleryOverlaysPage(),
        .navigation => const GalleryNavigationPage(),
        .typography => const GalleryTypographyPage(),
        _ => RegistryDashboardDemoContent(
          page: page,
          kit: kit,
          data: widget.data,
        ),
      },
    );
    if (!widget.builtInChrome) return demo;
    return FortalTheme(
      mode: _isDark ? FortalThemeMode.dark : FortalThemeMode.light,
      child: RemixToastScope(style: fortalToastStyle(), child: demo),
    );
  }

  List<Widget> _chromeActions() => [
    FortalIconButton.ghost(
      key: const ValueKey('dashboard-appearance-toggle'),
      icon: _isDark ? RemixIcons.sun : RemixIcons.moon,
      semanticLabel: _isDark ? 'Use light appearance' : 'Use dark appearance',
      onPressed: () => setState(() => _dark = !_isDark),
    ),
    FortalPopover(
      semanticLabel: 'Notifications',
      popoverChild: Box(
        style: BoxStyler().width(280).padding(.all(16)),
        child: ColumnBox(
          style: FlexBoxStyler()
              .mainAxisSize(.min)
              .crossAxisAlignment(.start)
              .spacing(6),
          children: const [
            FortalText('Notifications', weight: .bold),
            FortalText('Order ORD-1047 requires review.', size: .size2),
            FortalText('Three customer invitations are pending.', size: .size2),
          ],
        ),
      ),
      child: const FortalIconButton.ghost(
        icon: RemixIcons.bell,
        semanticLabel: 'Open notifications',
      ),
    ),
    FortalPopover(
      semanticLabel: 'Theme settings',
      popoverChild: Box(
        style: BoxStyler().width(300).padding(.all(16)),
        child: ColumnBox(
          style: FlexBoxStyler()
              .mainAxisSize(.min)
              .crossAxisAlignment(.stretch)
              .spacing(12),
          children: [
            const FortalText('Theme settings', size: .size4, weight: .bold),
            ColumnBox(
              style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(8),
              children: [
                _settingLine('Appearance', _isDark ? 'Dark' : 'Light'),
                _settingLine('Accent color', 'Indigo'),
                _settingLine('Gray color', 'Slate'),
                _settingLine('Radius', 'Medium'),
                _settingLine('Scaling', '100%'),
              ],
            ),
          ],
        ),
      ),
      child: const FortalIconButton.ghost(
        icon: RemixIcons.gear,
        semanticLabel: 'Open theme settings',
      ),
    ),
  ];

  Widget _settingLine(String label, String value) => RowBox(
    style: FlexBoxStyler().crossAxisAlignment(.center),
    children: [
      Expanded(child: FortalText(label, size: .size2)),
      FortalText(value, size: .size1, highContrast: false),
    ],
  );
}

class _FortalBreadcrumb extends StatelessWidget {
  const _FortalBreadcrumb({required this.page});
  final RegistryDashboardDemoPage page;

  @override
  Widget build(BuildContext context) => RowBox(
    style: FlexBoxStyler().crossAxisAlignment(.center).spacing(8),
    children: [
      Flexible(
        child: FortalText(
          page.section.label,
          size: .size2,
          highContrast: false,
          softWrap: false,
          truncate: true,
        ),
      ),
      const FortalText('/', size: .size2, highContrast: false),
      Flexible(
        child: FortalText(
          page.label,
          size: .size3,
          weight: .bold,
          softWrap: false,
          truncate: true,
        ),
      ),
    ],
  );
}

class _FortalAccount extends StatelessWidget {
  const _FortalAccount();

  @override
  Widget build(BuildContext context) => ColumnBox(
    style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(8),
    children: [
      const FortalText(
        'Northstar workspace',
        size: .size1,
        highContrast: false,
      ),
      FortalMenu<String>(
        trigger: const RemixMenuTrigger(
          label: 'Ada Chen',
          icon: RemixIcons.person,
        ),
        items: const [
          RemixMenuItem(value: 'account', label: 'Account settings'),
          RemixMenuItem(value: 'workspace', label: 'Switch workspace'),
          RemixMenuDivider(),
          RemixMenuItem(value: 'sign-out', label: 'Sign out'),
        ],
        onSelected: (value) =>
            showRemixToast(context, RemixToastData(title: '$value selected')),
      ),
    ],
  );
}

final class _FortalDashboardDemoKit implements RegistryDashboardDemoKit {
  const _FortalDashboardDemoKit();

  @override
  Widget pageHeader(String title, String description) => ColumnBox(
    style: FlexBoxStyler().crossAxisAlignment(.start).spacing(6),
    children: [
      FortalHeading(title, size: .size7),
      FortalText(description, size: .size2, highContrast: false),
    ],
  );

  @override
  Widget charts(RegistryDashboardSampleData data) =>
      _FortalDashboardCharts(data: data);
}

class _FortalDashboardCharts extends StatelessWidget {
  const _FortalDashboardCharts({required this.data});

  final RegistryDashboardSampleData data;

  @override
  Widget build(BuildContext context) => RegistryDashboardCharts(
    cardBuilder: _chartCard,
    sectionBuilder: (title, description, cards) => ColumnBox(
      style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(12),
      children: [
        ColumnBox(
          style: FlexBoxStyler().crossAxisAlignment(.start).spacing(4),
          children: [
            FortalHeading(title, headingLevel: 2, size: .size4),
            FortalText(description, size: .size2, highContrast: false),
          ],
        ),
        GridBox(
          style: GridBoxStyler.equalColumns(2)
              .gap(16)
              .onConstraints(const .maxWidth(759), .equalColumns(1).gap(16)),
          children: cards,
        ),
      ],
    ),
    chartBuilder: (context, chart, selected, onSelected) => switch (chart) {
      .revenueMomentum => FortalLineChart(
        showMarkers: true,
        semanticsLabel: 'Weekly revenue momentum',
        series: [
          LineSeries(
            id: 'revenue',
            label: 'Revenue',
            points: registryDashboardRevenuePoints(data),
          ),
        ],
        xAxis: registryDashboardWeekdayAxis(),
        yAxis: registryDashboardNumericAxis(max: 100, interval: 20),
        style: registryDashboardLineStyle(),
      ),
      .linePatterns => FortalLineChart(
        showMarkers: true,
        semanticsLabel: 'Weekly actual and planned revenue',
        series: [
          LineSeries(
            id: 'actual',
            label: 'Actual',
            points: registryDashboardPoints('actual', const [
              18,
              24,
              22,
              34,
              31,
              42,
              48,
            ]),
          ),
          LineSeries(
            id: 'plan',
            label: 'Plan',
            points: registryDashboardPoints('plan', const [
              16,
              20,
              25,
              28,
              34,
              37,
              41,
            ]),
            style: LineSeriesStyler()
                .stroke(ChartStrokeStyler().dashArray([6, 4]))
                .marker(ChartMarkerStyler().show(true).shape(.square)),
          ),
        ],
        xAxis: registryDashboardWeekdayAxis(),
        yAxis: registryDashboardNumericAxis(max: 50),
        style: registryDashboardLineStyle(),
      ),
      .stepGaps => FortalLineChart(
        showMarkers: true,
        semanticsLabel: 'Inventory levels with missing observations',
        series: [
          LineSeries(
            id: 'inventory',
            label: 'Inventory',
            points: registryDashboardPoints('inventory', const [
              32,
              27,
              null,
              null,
              19,
              25,
              22,
            ]),
            style: LineSeriesStyler().curve(.stepAfter),
          ),
        ],
        xAxis: registryDashboardWeekdayAxis(),
        yAxis: registryDashboardNumericAxis(max: 40),
        style: registryDashboardLineStyle(),
      ),
      .viewportLabels => FortalLineChart(
        showMarkers: true,
        semanticsLabel: 'Revenue chart with scalable horizontal viewport',
        viewport: ChartViewport(axis: .horizontal, maxScale: 3),
        series: [
          LineSeries(
            id: 'viewport',
            label: 'Revenue',
            points: registryDashboardPoints('viewport', const [
              18,
              24,
              22,
              34,
              31,
              42,
              48,
            ]),
          ),
        ],
        xAxis: registryDashboardWeekdayAxis(),
        yAxis: registryDashboardNumericAxis(max: 50),
        style: registryDashboardLineStyle(),
      ),
      .groupedBars => FortalBarChart(
        semanticsLabel: 'Monthly actual and planned revenue',
        groups: registryDashboardGroupedBars(),
        yAxis: registryDashboardNumericAxis(max: 60),
        style: registryDashboardBarStyle(),
      ),
      .stackedBars => FortalBarChart(
        semanticsLabel: 'Monthly product and services revenue',
        groups: registryDashboardStackedBars(),
        yAxis: registryDashboardNumericAxis(max: 60),
        style: registryDashboardBarStyle(),
      ),
      .floatingBars => FortalBarChart(
        semanticsLabel: 'Monthly floating inventory changes',
        groups: registryDashboardFloatingBars(),
        yAxis: registryDashboardNumericAxis(max: 40),
        style: registryDashboardBarStyle(),
      ),
      .trackedBars => FortalBarChart(
        semanticsLabel: 'Monthly revenue against full-scale tracks',
        groups: registryDashboardTrackedBars(),
        yAxis: registryDashboardNumericAxis(max: 70),
        style: registryDashboardBarStyle(),
      ),
      .trafficPie => FortalPieChart(
        style: _pieRing(),
        semanticsLabel: 'Traffic share by device',
        slices: registryDashboardChannelSlices(),
        valueFormatter: (value) => '${value.toInt()}%',
      ),
      .interactivePie => FortalPieChart(
        centerRadius: 40,
        style: _pieRing(40),
        semanticsLabel: 'Product mix',
        slices: registryDashboardProductSlices(),
        selectedSliceIds: {?selected},
        onSliceTap: (hit) => onSelected(hit.sliceId),
        valueFormatter: (value) => '${value.toInt()}%',
      ),
      .badgePie => FortalPieChart(
        centerRadius: 34,
        style: _pieRing(34),
        semanticsLabel: 'Device traffic with badge markers',
        slices: registryDashboardChannelSlices(badges: true),
      ),
      .emptyPie => StackBox(
        style: StackBoxStyler().alignment(.center),
        children: [
          FortalPieChart(
            centerRadius: 52,
            style: _pieRing(52),
            semanticsLabel: 'No channel data',
            slices: registryDashboardEmptySlices(),
          ),
          ColumnBox(
            style: FlexBoxStyler()
                .mainAxisSize(.min)
                .crossAxisAlignment(.center)
                .spacing(6),
            children: const [
              Icon(RemixIcons.box, size: 20),
              FortalText('No data yet', size: .size1),
            ],
          ),
        ],
      ),
    },
  );
}

/// How far every pie on the charts page reaches: 80% of the way to the edge
/// of its 240px box.
///
/// mix_chart draws each slice 80px wide whatever the box, so a donut left at
/// that default spills out of the box by the width of its hole.
const _pieRadius = 96.0;

/// A pie ring that ends at [_pieRadius] around a hole of [centerRadius].
PieChartStyler _pieRing([double centerRadius = 0]) =>
    PieChartStyler().slice(PieSliceStyler().radius(_pieRadius - centerRadius));

Widget _chartCard(String title, String description, Widget chart) =>
    FortalCard.surface(
      size: .size2,
      child: ColumnBox(
        style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(12),
        children: [
          ColumnBox(
            style: FlexBoxStyler().crossAxisAlignment(.start).spacing(4),
            children: [
              FortalHeading(title, headingLevel: 3, size: .size3),
              FortalText(description, size: .size1, highContrast: false),
            ],
          ),
          Box(style: BoxStyler().height(240), child: chart),
        ],
      ),
    );

RegistryDashboardAgentStyles _fortalAgentStyles() {
  final message = fortalAgentMessageRecipe();
  final answer = fortalAgentAnswerRecipe();
  final transcript = fortalAgentTranscriptRecipe();
  final plan = fortalAgentPlanRecipe();
  final activity = fortalAgentActivityRecipe();
  final permission = fortalAgentPermissionRecipe();
  final execution = fortalAgentExecutionRecipe();
  final composer = fortalAgentComposerRecipe();
  return RegistryDashboardAgentStyles(
    buttonBuilder: (label, onPressed, tone) => switch (tone) {
      .primary => FortalButton(label: label, onPressed: onPressed),
      .soft => FortalButton.soft(label: label, onPressed: onPressed),
      .outline => FortalButton.outline(label: label, onPressed: onPressed),
    },
    heading: fortalTextStyle(size: .size6, weight: .bold),
    body: fortalTextStyle(size: .size2, highContrast: false),
    messageStyle: message.style,
    messageSurfaceStyle: message.surfaceStyle,
    answerStyle: answer.style,
    answerSurfaceStyle: answer.surfaceStyle,
    answerSourcesStyle: answer.sourcesStyle,
    answerCopyStyle: answer.copyStyle,
    answerRetryStyle: answer.retryStyle,
    transcriptStyle: transcript.style,
    planStyle: plan.style,
    planDisclosureStyle: plan.disclosureStyle,
    activityStyle: activity.style,
    activityDisclosureStyle: activity.disclosureStyle,
    permissionStyle: permission.style,
    permissionSurfaceStyle: permission.surfaceStyle,
    permissionDetailsStyle: permission.detailsStyle,
    permissionParametersStyle: permission.parametersStyle,
    permissionAllowOnceStyle: permission.allowOnceStyle,
    permissionAlwaysAllowStyle: permission.alwaysAllowStyle,
    permissionDenyStyle: permission.denyStyle,
    executionStyle: execution.style,
    executionSurfaceStyle: execution.surfaceStyle,
    executionDisclosureStyle: execution.disclosureStyle,
    executionCopyStyle: execution.copyStyle,
    executionRetryStyle: execution.retryStyle,
    composerStyle: composer.style,
    composerSurfaceStyle: composer.surfaceStyle,
    composerFieldStyle: composer.fieldStyle,
    composerSubmitStyle: composer.submitStyle,
    composerStopStyle: composer.stopStyle,
  );
}
