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
import '../../components/icon_button.dart';
import '../../components/menu.dart';
import '../../components/popover.dart';
import '../../components/toast.dart';
import '../activity_recipe.dart';
import '../answer_recipe.dart';
import '../composer_recipe.dart';
import '../execution_recipe.dart';
import '../message_recipe.dart';
import '../permission_recipe.dart';
import '../plan_recipe.dart';
import '../transcript_recipe.dart';
import '../../theme/tokens.dart';
import '../../theme/theme_data.dart';
import '../../theme/theme_scope.dart';
import 'dashboard_demo_galleries.dart';
import 'dashboard_demo_records.dart';
import 'dashboard_demo_settings.dart';
import 'dashboard_overview.dart';
import 'dashboard_shell.dart';

/// Full default-preset dashboard demo.
///
/// This is the open-code equivalent of the repository's Fortal showcase: it
/// includes the same Workspace, Data, Manage, and Components destinations,
/// while demonstrating the smaller default preset vocabulary honestly.
class VanillaDashboardDemo extends StatefulWidget {
  const VanillaDashboardDemo({
    super.key,
    this.brand = const _VanillaBrand(),
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
  State<VanillaDashboardDemo> createState() => _VanillaDashboardDemoState();
}

class _VanillaDashboardDemoState extends State<VanillaDashboardDemo> {
  /// The appearance the toggle chose, or null to follow the scope this demo
  /// is placed in.
  bool? _dark;
  Brightness? _ambientBrightness;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ambient = VanillaTheme.maybeOf(context)?.brightness;
    if (_ambientBrightness != null && ambient != _ambientBrightness) {
      _dark = null;
    }
    _ambientBrightness = ambient;
  }

  bool get _isDark =>
      _dark ?? (VanillaTheme.maybeOf(context)?.brightness == Brightness.dark);

  @override
  Widget build(BuildContext context) {
    const kit = _VanillaDashboardDemoKit();
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
          }) => VanillaDashboardShell<RegistryDashboardDemoPage>(
            sections: sections,
            selectedValue: selectedValue,
            onSelected: onSelected,
            body: body,
            title: title,
            headerTitle: widget.builtInChrome
                ? _VanillaBreadcrumb(page: selectedValue)
                : null,
            brand: widget.brand,
            account:
                widget.account ??
                (widget.builtInChrome ? const _VanillaAccount() : null),
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
        .overview => VanillaDashboardOverview(
          data: widget.data,
          onViewOrders: () => onSelected(RegistryDashboardDemoPage.orders),
        ),
        .chat => RegistryDashboardChatPage(
          styles: _vanillaAgentStyles(),
          stepDelay: widget.chatStepDelay,
        ),
        .customers => DefaultDashboardCustomersPage(globalQuery: query),
        .orders => DefaultDashboardOrdersPage(globalQuery: query),
        .settings => DefaultDashboardSettingsPage(
          darkMode: _dark,
          onDarkModeChanged: (value) => setState(() => _dark = value),
        ),
        .actions => const DefaultGalleryActionsPage(),
        .forms => const DefaultGalleryFormsPage(),
        .dataDisplay => const DefaultGalleryDisplayPage(),
        .overlays => const DefaultGalleryOverlaysPage(),
        .navigation => const DefaultGalleryNavigationPage(),
        .typography => const DefaultGalleryTypographyPage(),
        _ => RegistryDashboardDemoContent(
          page: page,
          kit: kit,
          data: widget.data,
        ),
      },
    );
    if (!widget.builtInChrome) return demo;
    return VanillaTheme(
      mode: _isDark ? VanillaThemeMode.dark : VanillaThemeMode.light,
      child: Builder(
        builder: (context) => ColoredBox(
          color: VanillaTokens.background.resolve(context),
          child: RemixToastScope(style: vanillaToastStyle(), child: demo),
        ),
      ),
    );
  }

  List<Widget> _chromeActions() => [
    VanillaIconButton.ghost(
      key: const ValueKey('dashboard-appearance-toggle'),
      icon: _isDark ? RemixIcons.sun : RemixIcons.moon,
      semanticLabel: _isDark ? 'Use light appearance' : 'Use dark appearance',
      onPressed: () => setState(() => _dark = !_isDark),
    ),
    VanillaPopover(
      semanticLabel: 'Notifications',
      popoverChild: SizedBox(
        width: 280,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StyledText(
                'Notifications',
                style: _textStyle(weight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              StyledText(
                'Order ORD-1047 requires review.',
                style: _textStyle(size: 13),
              ),
              const SizedBox(height: 6),
              StyledText(
                'Three customer invitations are pending.',
                style: _textStyle(size: 13, muted: true),
              ),
            ],
          ),
        ),
      ),
      child: const VanillaIconButton.ghost(
        icon: RemixIcons.bell,
        semanticLabel: 'Open notifications',
      ),
    ),
    VanillaPopover(
      semanticLabel: 'Theme settings',
      popoverChild: SizedBox(
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StyledText(
                'Theme settings',
                style: _textStyle(size: 16, weight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _settingLine('Appearance', _isDark ? 'Dark' : 'Light'),
              _settingLine('Accent color', 'Neutral'),
              _settingLine('Radius', 'Medium'),
              _settingLine('Density', 'Comfortable'),
            ],
          ),
        ),
      ),
      child: const VanillaIconButton.ghost(
        icon: RemixIcons.gear,
        semanticLabel: 'Open theme settings',
      ),
    ),
  ];

  Widget _settingLine(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Expanded(child: StyledText(label, style: _textStyle())),
        StyledText(value, style: _textStyle(muted: true)),
      ],
    ),
  );
}

class _VanillaBrand extends StatelessWidget {
  const _VanillaBrand();

  @override
  Widget build(BuildContext context) => StyledText(
    'Northstar',
    style: _textStyle(
      weight: FontWeight.w600,
    ).maxLines(1).softWrap(false).overflow(.ellipsis),
  );
}

class _VanillaBreadcrumb extends StatelessWidget {
  const _VanillaBreadcrumb({required this.page});
  final RegistryDashboardDemoPage page;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Flexible(
        child: StyledText(
          page.section.label,
          style: _textStyle(
            muted: true,
          ).maxLines(1).softWrap(false).overflow(.ellipsis),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: StyledText('/', style: _textStyle(muted: true)),
      ),
      Flexible(
        child: StyledText(
          page.label,
          style: _textStyle(
            size: 16,
            weight: FontWeight.w600,
          ).maxLines(1).softWrap(false).overflow(.ellipsis),
        ),
      ),
    ],
  );
}

class _VanillaAccount extends StatelessWidget {
  const _VanillaAccount();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      StyledText('Northstar workspace', style: _textStyle(muted: true)),
      const SizedBox(height: 8),
      VanillaMenu<String>(
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

final class _VanillaDashboardDemoKit implements RegistryDashboardDemoKit {
  const _VanillaDashboardDemoKit();

  @override
  Widget pageHeader(String title, String description) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      StyledText(title, style: _textStyle(size: 28, weight: FontWeight.w700)),
      const SizedBox(height: 6),
      StyledText(description, style: _textStyle(muted: true)),
    ],
  );

  @override
  Widget charts(RegistryDashboardSampleData data) =>
      _VanillaDashboardCharts(data: data);
}

class _VanillaDashboardCharts extends StatelessWidget {
  const _VanillaDashboardCharts({required this.data});

  final RegistryDashboardSampleData data;

  @override
  Widget build(BuildContext context) => RegistryDashboardCharts(
    cardBuilder: _chartCard,
    sectionBuilder: (title, description, cards) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StyledText(title, style: _textStyle(size: 17, weight: FontWeight.w600)),
        const SizedBox(height: 4),
        StyledText(description, style: _textStyle(size: 13, muted: true)),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth < 760
                ? constraints.maxWidth
                : (constraints.maxWidth - 16) / 2;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                for (final card in cards) SizedBox(width: width, child: card),
              ],
            );
          },
        ),
      ],
    ),
    chartBuilder: (context, chart, selected, onSelected) => switch (chart) {
      .revenueMomentum => VanillaLineChart(
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
      .linePatterns => VanillaLineChart(
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
      .stepGaps => VanillaLineChart(
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
      .viewportLabels => VanillaLineChart(
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
      .groupedBars => VanillaBarChart(
        semanticsLabel: 'Monthly actual and planned revenue',
        groups: registryDashboardGroupedBars(),
        yAxis: registryDashboardNumericAxis(max: 60),
        style: registryDashboardBarStyle(),
      ),
      .stackedBars => VanillaBarChart(
        semanticsLabel: 'Monthly product and services revenue',
        groups: registryDashboardStackedBars(),
        yAxis: registryDashboardNumericAxis(max: 60),
        style: registryDashboardBarStyle(),
      ),
      .floatingBars => VanillaBarChart(
        semanticsLabel: 'Monthly floating inventory changes',
        groups: registryDashboardFloatingBars(),
        yAxis: registryDashboardNumericAxis(max: 40),
        style: registryDashboardBarStyle(),
      ),
      .trackedBars => VanillaBarChart(
        semanticsLabel: 'Monthly revenue against full-scale tracks',
        groups: registryDashboardTrackedBars(),
        yAxis: registryDashboardNumericAxis(max: 70),
        style: registryDashboardBarStyle(),
      ),
      .trafficPie => VanillaPieChart(
        style: _pieRing(),
        semanticsLabel: 'Traffic share by device',
        slices: registryDashboardChannelSlices(),
        valueFormatter: (value) => '${value.toInt()}%',
      ),
      .interactivePie => VanillaPieChart(
        centerRadius: 40,
        style: _pieRing(40),
        semanticsLabel: 'Product mix',
        slices: registryDashboardProductSlices(),
        selectedSliceIds: {?selected},
        onSliceTap: (hit) => onSelected(hit.sliceId),
        valueFormatter: (value) => '${value.toInt()}%',
      ),
      .badgePie => VanillaPieChart(
        centerRadius: 34,
        style: _pieRing(34),
        semanticsLabel: 'Device traffic with badge markers',
        slices: registryDashboardChannelSlices(badges: true),
      ),
      .emptyPie => Stack(
        alignment: Alignment.center,
        children: [
          VanillaPieChart(
            centerRadius: 52,
            style: _pieRing(52),
            semanticsLabel: 'No channel data',
            slices: registryDashboardEmptySlices(),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StyledIcon(
                icon: RemixIcons.box,
                style: IconStyler()
                    .size(20)
                    .color(VanillaTokens.mutedForeground()),
              ),
              const SizedBox(height: 6),
              StyledText(
                'No data yet',
                style: _textStyle(size: 12, muted: true),
              ),
            ],
          ),
        ],
      ),
    },
  );
}

/// How far every pie on the charts page reaches: 80% of the way to the edge of
/// its 240px box, where Recharts puts a pie by default.
///
/// mix_chart draws each slice 80px wide whatever the box, so a donut left at
/// that default spills out of the box by the width of its hole.
const _pieRadius = 96.0;

/// A pie ring that ends at [_pieRadius] around a hole of [centerRadius].
PieChartStyler _pieRing([double centerRadius = 0]) =>
    PieChartStyler().slice(PieSliceStyler().radius(_pieRadius - centerRadius));

Widget _chartCard(String title, String description, Widget chart) =>
    VanillaCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StyledText(
            title,
            style: _textStyle(size: 16, weight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          StyledText(description, style: _textStyle(size: 13, muted: true)),
          const SizedBox(height: 12),
          SizedBox(height: 240, child: chart),
        ],
      ),
    );

TextStyler _textStyle({
  double size = 14,
  FontWeight weight = FontWeight.w400,
  bool muted = false,
}) => TextStyler()
    .fontSize(size)
    .fontWeight(weight)
    .color(
      muted ? VanillaTokens.mutedForeground() : VanillaTokens.foreground(),
    );

RegistryDashboardAgentStyles _vanillaAgentStyles() {
  final message = vanillaAgentMessageRecipe();
  final answer = vanillaAgentAnswerRecipe();
  final transcript = vanillaAgentTranscriptRecipe();
  final plan = vanillaAgentPlanRecipe();
  final activity = vanillaAgentActivityRecipe();
  final permission = vanillaAgentPermissionRecipe();
  final execution = vanillaAgentExecutionRecipe();
  final composer = vanillaAgentComposerRecipe();
  return RegistryDashboardAgentStyles(
    buttonBuilder: (label, onPressed, tone) => switch (tone) {
      .primary => VanillaButton(label: label, onPressed: onPressed),
      .soft => VanillaButton.secondary(label: label, onPressed: onPressed),
      .outline => VanillaButton.outline(label: label, onPressed: onPressed),
    },
    heading: _textStyle(size: 26, weight: FontWeight.w700),
    body: _textStyle(size: 13, muted: true),
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
