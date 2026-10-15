import 'package:flutter/widgets.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/button.dart';
import '../../components/card.dart';
import '../../components/chart.dart';
import '../../components/icon_button.dart';
import '../../components/menu.dart';
import '../../components/popover.dart';
import '../../components/toast.dart';
import '../../theme/theme_data.dart';
import '../../theme/theme_scope.dart';
import '../../theme/tokens.dart';
import '../activity_recipe.dart';
import '../answer_recipe.dart';
import '../composer_recipe.dart';
import '../execution_recipe.dart';
import '../message_recipe.dart';
import '../permission_recipe.dart';
import '../plan_recipe.dart';
import '../transcript_recipe.dart';
import 'dashboard_demo_base.dart';
import 'dashboard_demo_charts.dart';
import 'dashboard_demo_chat.dart';
import 'dashboard_demo_content.dart';
import 'dashboard_demo_galleries.dart';
import 'dashboard_demo_records_page.dart';
import 'dashboard_demo_settings.dart';
import 'dashboard_overview.dart';
import 'dashboard_sample_data.dart';
import 'dashboard_shell.dart';

/// Full default-preset dashboard demo.
///
/// This is the open-code equivalent of the repository's Fortal showcase: it
/// includes the same Workspace, Data, Manage, and Components destinations,
/// while demonstrating the smaller default preset vocabulary honestly.
class PlaygroundDashboardDemo extends StatefulWidget {
  const PlaygroundDashboardDemo({
    super.key,
    this.brand = const _PlaygroundBrand(),
    this.account,
    this.headerActions = const [],
    this.onSearchChanged,
    this.data = playgroundDashboardSampleData,
    this.initialPage = PlaygroundDashboardDemoPage.overview,
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
  final PlaygroundDashboardSampleData data;
  final PlaygroundDashboardDemoPage initialPage;
  final bool? collapsed;
  final bool initiallyCollapsed;
  final ValueChanged<bool>? onCollapsedChanged;
  final bool builtInChrome;
  final Duration chatStepDelay;

  @override
  State<PlaygroundDashboardDemo> createState() =>
      _PlaygroundDashboardDemoState();
}

class _PlaygroundDashboardDemoState extends State<PlaygroundDashboardDemo> {
  /// The appearance the toggle chose, or null to follow the scope this demo
  /// is placed in.
  bool? _dark;
  Brightness? _ambientBrightness;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ambient = PlaygroundTheme.maybeOf(context)?.brightness;
    if (_ambientBrightness != null && ambient != _ambientBrightness) {
      _dark = null;
    }
    _ambientBrightness = ambient;
  }

  bool get _isDark =>
      _dark ??
      (PlaygroundTheme.maybeOf(context)?.brightness == Brightness.dark);

  @override
  Widget build(BuildContext context) {
    const kit = _PlaygroundDashboardDemoKit();
    final demo = PlaygroundDashboardDemoBase(
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
          }) => PlaygroundDashboardShell<PlaygroundDashboardDemoPage>(
            sections: sections,
            selectedValue: selectedValue,
            onSelected: onSelected,
            body: body,
            title: title,
            headerTitle: widget.builtInChrome
                ? _PlaygroundBreadcrumb(page: selectedValue)
                : null,
            brand: widget.brand,
            account:
                widget.account ??
                (widget.builtInChrome ? const _PlaygroundAccount() : null),
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
        .overview => PlaygroundDashboardOverview(
          data: widget.data,
          onViewOrders: () => onSelected(PlaygroundDashboardDemoPage.orders),
        ),
        .chat => PlaygroundDashboardChatPage(
          styles: _playgroundAgentStyles(),
          stepDelay: widget.chatStepDelay,
        ),
        .customers => PlaygroundDashboardCustomersPage(globalQuery: query),
        .orders => PlaygroundDashboardOrdersPage(globalQuery: query),
        .settings => PlaygroundDashboardSettingsPage(
          darkMode: _dark,
          onDarkModeChanged: (value) => setState(() => _dark = value),
        ),
        .actions => const PlaygroundGalleryActionsPage(),
        .forms => const PlaygroundGalleryFormsPage(),
        .dataDisplay => const PlaygroundGalleryDisplayPage(),
        .overlays => const PlaygroundGalleryOverlaysPage(),
        .navigation => const PlaygroundGalleryNavigationPage(),
        .typography => const PlaygroundGalleryTypographyPage(),
        _ => PlaygroundDashboardDemoContent(
          page: page,
          kit: kit,
          data: widget.data,
        ),
      },
    );
    if (!widget.builtInChrome) return demo;
    return PlaygroundTheme(
      mode: _isDark ? PlaygroundThemeMode.dark : PlaygroundThemeMode.light,
      child: Box(
        style: BoxStyler().color(PlaygroundTokens.background()),
        child: RemixToastScope(style: playgroundToastStyle(), child: demo),
      ),
    );
  }

  List<Widget> _chromeActions() => [
    PlaygroundIconButton.ghost(
      key: const ValueKey('dashboard-appearance-toggle'),
      icon: _isDark ? RemixIcons.sun : RemixIcons.moon,
      semanticLabel: _isDark ? 'Use light appearance' : 'Use dark appearance',
      onPressed: () => setState(() => _dark = !_isDark),
    ),
    PlaygroundPopover(
      semanticLabel: 'Notifications',
      popoverChild: Box(
        style: BoxStyler()
            .width(PlaygroundTokens.popoverWidth)
            .padding(.all(PlaygroundTokens.s4)),
        child: ColumnBox(
          style: FlexBoxStyler()
              .mainAxisSize(.min)
              .crossAxisAlignment(.start)
              .spacing(PlaygroundTokens.s1_5),
          children: [
            StyledText(
              'Notifications',
              style: _textStyle(weight: FontWeight.w600),
            ),
            StyledText(
              'Order ORD-1047 requires review.',
              style: _textStyle(token: PlaygroundTokens.textXs),
            ),
            StyledText(
              'Three customer invitations are pending.',
              style: _textStyle(token: PlaygroundTokens.textXs, muted: true),
            ),
          ],
        ),
      ),
      child: const PlaygroundIconButton.ghost(
        icon: RemixIcons.bell,
        semanticLabel: 'Open notifications',
      ),
    ),
    PlaygroundPopover(
      semanticLabel: 'Theme settings',
      popoverChild: Box(
        style: BoxStyler()
            .width(PlaygroundTokens.popoverWidth)
            .padding(.all(PlaygroundTokens.s4)),
        child: ColumnBox(
          style: FlexBoxStyler()
              .mainAxisSize(.min)
              .crossAxisAlignment(.stretch)
              .spacing(PlaygroundTokens.s3),
          children: [
            StyledText(
              'Theme settings',
              style: _textStyle(
                token: PlaygroundTokens.textBase,
                weight: FontWeight.w600,
              ),
            ),
            ColumnBox(
              style: FlexBoxStyler()
                  .crossAxisAlignment(.stretch)
                  .spacing(PlaygroundTokens.s2),
              children: [
                _settingLine('Appearance', _isDark ? 'Dark' : 'Light'),
                _settingLine('Accent color', 'Neutral'),
                _settingLine('Radius', 'Medium'),
                _settingLine('Density', 'Comfortable'),
              ],
            ),
          ],
        ),
      ),
      child: const PlaygroundIconButton.ghost(
        icon: RemixIcons.gear,
        semanticLabel: 'Open theme settings',
      ),
    ),
  ];

  Widget _settingLine(String label, String value) => RowBox(
    style: FlexBoxStyler().crossAxisAlignment(.center),
    children: [
      Expanded(child: StyledText(label, style: _textStyle())),
      StyledText(value, style: _textStyle(muted: true)),
    ],
  );
}

class _PlaygroundBrand extends StatelessWidget {
  const _PlaygroundBrand();

  @override
  Widget build(BuildContext context) => StyledText(
    'Northstar',
    style: _textStyle(
      weight: FontWeight.w600,
    ).maxLines(1).softWrap(false).overflow(.ellipsis),
  );
}

class _PlaygroundBreadcrumb extends StatelessWidget {
  const _PlaygroundBreadcrumb({required this.page});
  final PlaygroundDashboardDemoPage page;

  @override
  Widget build(BuildContext context) => RowBox(
    style: FlexBoxStyler()
        .crossAxisAlignment(.center)
        .spacing(PlaygroundTokens.s2),
    children: [
      Flexible(
        child: StyledText(
          page.section.label,
          style: _textStyle(
            muted: true,
          ).maxLines(1).softWrap(false).overflow(.ellipsis),
        ),
      ),
      StyledText('/', style: _textStyle(muted: true)),
      Flexible(
        child: StyledText(
          page.label,
          style: _textStyle(
            token: PlaygroundTokens.textBase,
            weight: FontWeight.w600,
          ).maxLines(1).softWrap(false).overflow(.ellipsis),
        ),
      ),
    ],
  );
}

class _PlaygroundAccount extends StatelessWidget {
  const _PlaygroundAccount();

  @override
  Widget build(BuildContext context) => ColumnBox(
    style: FlexBoxStyler()
        .crossAxisAlignment(.stretch)
        .spacing(PlaygroundTokens.s2),
    children: [
      StyledText('Northstar workspace', style: _textStyle(muted: true)),
      PlaygroundMenu<String>(
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

final class _PlaygroundDashboardDemoKit implements PlaygroundDashboardDemoKit {
  const _PlaygroundDashboardDemoKit();

  @override
  Widget pageHeader(String title, String description) => ColumnBox(
    style: FlexBoxStyler()
        .crossAxisAlignment(.start)
        .spacing(PlaygroundTokens.s1_5),
    children: [
      StyledText(
        title,
        style: _textStyle(
          token: PlaygroundTokens.text3xl,
          weight: FontWeight.w700,
        ),
      ),
      StyledText(description, style: _textStyle(muted: true)),
    ],
  );

  @override
  Widget charts(PlaygroundDashboardSampleData data) =>
      _PlaygroundDashboardCharts(data: data);
}

class _PlaygroundDashboardCharts extends StatelessWidget {
  const _PlaygroundDashboardCharts({required this.data});

  final PlaygroundDashboardSampleData data;

  @override
  Widget build(BuildContext context) => PlaygroundDashboardCharts(
    cardBuilder: _chartCard,
    sectionBuilder: (title, description, cards) => ColumnBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(.stretch)
          .spacing(PlaygroundTokens.s3),
      children: [
        ColumnBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.start)
              .spacing(PlaygroundTokens.s1),
          children: [
            StyledText(
              title,
              style: _textStyle(
                token: PlaygroundTokens.textLg,
                weight: FontWeight.w600,
              ),
            ),
            StyledText(description, style: _textStyle(muted: true)),
          ],
        ),
        GridBox(
          style: GridBoxStyler.equalColumns(2)
              .gap(PlaygroundTokens.s4)
              .onConstraints(
                const .maxWidth(759),
                .equalColumns(1).gap(PlaygroundTokens.s4),
              ),
          children: cards,
        ),
      ],
    ),
    chartBuilder: (context, chart, selected, onSelected) => switch (chart) {
      .revenueMomentum => PlaygroundLineChart(
        showMarkers: true,
        semanticsLabel: 'Weekly revenue momentum',
        series: [
          LineSeries(
            id: 'revenue',
            label: 'Revenue',
            points: playgroundDashboardRevenuePoints(data),
          ),
        ],
        xAxis: playgroundDashboardWeekdayAxis(),
        yAxis: playgroundDashboardNumericAxis(max: 100, interval: 20),
        style: playgroundDashboardLineStyle(),
      ),
      .linePatterns => PlaygroundLineChart(
        showMarkers: true,
        semanticsLabel: 'Weekly actual and planned revenue',
        series: [
          LineSeries(
            id: 'actual',
            label: 'Actual',
            points: playgroundDashboardPoints('actual', const [
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
            points: playgroundDashboardPoints('plan', const [
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
        xAxis: playgroundDashboardWeekdayAxis(),
        yAxis: playgroundDashboardNumericAxis(max: 50),
        style: playgroundDashboardLineStyle(),
      ),
      .stepGaps => PlaygroundLineChart(
        showMarkers: true,
        semanticsLabel: 'Inventory levels with missing observations',
        series: [
          LineSeries(
            id: 'inventory',
            label: 'Inventory',
            points: playgroundDashboardPoints('inventory', const [
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
        xAxis: playgroundDashboardWeekdayAxis(),
        yAxis: playgroundDashboardNumericAxis(max: 40),
        style: playgroundDashboardLineStyle(),
      ),
      .viewportLabels => PlaygroundLineChart(
        showMarkers: true,
        semanticsLabel: 'Revenue chart with scalable horizontal viewport',
        viewport: ChartViewport(axis: .horizontal, maxScale: 3),
        series: [
          LineSeries(
            id: 'viewport',
            label: 'Revenue',
            points: playgroundDashboardPoints('viewport', const [
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
        xAxis: playgroundDashboardWeekdayAxis(),
        yAxis: playgroundDashboardNumericAxis(max: 50),
        style: playgroundDashboardLineStyle(),
      ),
      .groupedBars => PlaygroundBarChart(
        semanticsLabel: 'Monthly actual and planned revenue',
        groups: playgroundDashboardGroupedBars(),
        yAxis: playgroundDashboardNumericAxis(max: 60),
        style: playgroundDashboardBarStyle(),
      ),
      .stackedBars => PlaygroundBarChart(
        semanticsLabel: 'Monthly product and services revenue',
        groups: playgroundDashboardStackedBars(),
        yAxis: playgroundDashboardNumericAxis(max: 60),
        style: playgroundDashboardBarStyle(),
      ),
      .floatingBars => PlaygroundBarChart(
        semanticsLabel: 'Monthly floating inventory changes',
        groups: playgroundDashboardFloatingBars(),
        yAxis: playgroundDashboardNumericAxis(max: 40),
        style: playgroundDashboardBarStyle(),
      ),
      .trackedBars => PlaygroundBarChart(
        semanticsLabel: 'Monthly revenue against full-scale tracks',
        groups: playgroundDashboardTrackedBars(),
        yAxis: playgroundDashboardNumericAxis(max: 70),
        style: playgroundDashboardBarStyle(),
      ),
      .trafficPie => PlaygroundPieChart(
        style: _pieRing(),
        semanticsLabel: 'Traffic share by device',
        slices: playgroundDashboardChannelSlices(),
        valueFormatter: (value) => '${value.toInt()}%',
      ),
      .interactivePie => PlaygroundPieChart(
        centerRadius: 40,
        style: _pieRing(40),
        semanticsLabel: 'Product mix',
        slices: playgroundDashboardProductSlices(),
        selectedSliceIds: {?selected},
        onSliceTap: (hit) => onSelected(hit.sliceId),
        valueFormatter: (value) => '${value.toInt()}%',
      ),
      .badgePie => PlaygroundPieChart(
        centerRadius: 34,
        style: _pieRing(34),
        semanticsLabel: 'Device traffic with badge markers',
        slices: playgroundDashboardChannelSlices(badges: true),
      ),
      .emptyPie => StackBox(
        style: StackBoxStyler().alignment(.center),
        children: [
          PlaygroundPieChart(
            centerRadius: 52,
            style: _pieRing(52),
            semanticsLabel: 'No channel data',
            slices: playgroundDashboardEmptySlices(),
          ),
          ColumnBox(
            style: FlexBoxStyler()
                .mainAxisSize(.min)
                .crossAxisAlignment(.center)
                .spacing(PlaygroundTokens.s1_5),
            children: [
              StyledIcon(
                icon: RemixIcons.box,
                style: IconStyler()
                    .size(PlaygroundTokens.s5)
                    .color(PlaygroundTokens.mutedForeground()),
              ),
              StyledText(
                'No data yet',
                style: _textStyle(token: PlaygroundTokens.textXs, muted: true),
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
    PlaygroundCard(
      child: ColumnBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.stretch)
            .spacing(PlaygroundTokens.s3),
        children: [
          ColumnBox(
            style: FlexBoxStyler()
                .crossAxisAlignment(.start)
                .spacing(PlaygroundTokens.s1),
            children: [
              StyledText(
                title,
                style: _textStyle(
                  token: PlaygroundTokens.textBase,
                  weight: FontWeight.w600,
                ),
              ),
              StyledText(description, style: _textStyle(muted: true)),
            ],
          ),
          Box(style: BoxStyler().height(240), child: chart),
        ],
      ),
    );

TextStyler _textStyle({
  TextStyleToken token = PlaygroundTokens.textSm,
  FontWeight weight = FontWeight.w400,
  bool muted = false,
}) => TextStyler()
    .style(token.mix())
    .fontWeight(weight)
    .color(
      muted
          ? PlaygroundTokens.mutedForeground()
          : PlaygroundTokens.foreground(),
    );

PlaygroundDashboardAgentStyles _playgroundAgentStyles() {
  final message = playgroundAgentMessageRecipe();
  final answer = playgroundAgentAnswerRecipe();
  final transcript = playgroundAgentTranscriptRecipe();
  final plan = playgroundAgentPlanRecipe();
  final activity = playgroundAgentActivityRecipe();
  final permission = playgroundAgentPermissionRecipe();
  final execution = playgroundAgentExecutionRecipe();
  final composer = playgroundAgentComposerRecipe();
  return PlaygroundDashboardAgentStyles(
    buttonBuilder: (label, onPressed, tone) => switch (tone) {
      .primary => PlaygroundButton(label: label, onPressed: onPressed),
      .soft => PlaygroundButton.secondary(label: label, onPressed: onPressed),
      .outline => PlaygroundButton.outline(label: label, onPressed: onPressed),
    },
    heading: _textStyle(
      token: PlaygroundTokens.text2xl,
      weight: FontWeight.w700,
    ),
    body: _textStyle(muted: true),
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
