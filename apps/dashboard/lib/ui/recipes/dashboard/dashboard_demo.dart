import 'package:flutter/widgets.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

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
import 'dashboard_demo_gallery_actions.dart';
import 'dashboard_demo_gallery_display.dart';
import 'dashboard_demo_gallery_forms.dart';
import 'dashboard_demo_gallery_navigation.dart';
import 'dashboard_demo_gallery_overlays.dart';
import 'dashboard_demo_gallery_typography.dart';
import 'dashboard_demo_page_header.dart';
import 'dashboard_demo_records_page.dart';
import 'dashboard_demo_settings.dart';
import 'dashboard_demo_text.dart';
import 'dashboard_demo_theme.dart';
import 'dashboard_demo_theme_panel.dart';
import 'dashboard_demo_typography.dart';
import 'dashboard_demo_ui.dart';
import 'dashboard_demo_widgets.dart';
import 'dashboard_overview.dart';
import 'dashboard_sample_data.dart';
import 'dashboard_shell.dart';

/// Product brand supplied through the installed shell's brand slot.
class UiDashboardBrand extends StatelessWidget {
  const UiDashboardBrand({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    key: const ValueKey('dashboard-brand'),
    label: 'Dashboard',
    excludeSemantics: true,
    child: const UiText(
      'Dashboard',
      size: .size5,
      weight: .bold,
      softWrap: false,
      truncate: true,
    ),
  );
}

/// Product account menu supplied through the installed shell's footer slot.
class UiDashboardSidebarAccount extends StatelessWidget {
  const UiDashboardSidebarAccount({super.key});

  @override
  Widget build(BuildContext context) => Box(
    style: BoxStyler().padding(
      .symmetric(horizontal: UiTokens.space2(), vertical: UiTokens.space3()),
    ),
    child: UiActionMenu(
      key: const ValueKey('sidebar-account-trigger'),
      semanticLabel: 'Workspace account menu',
      trigger: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: RowBox(
          style: FlexBoxStyler().crossAxisAlignment(.center).spacing(10),
          children: [
            const UiAvatar(label: 'LF', size: .size2),
            Expanded(
              child: ColumnBox(
                style: FlexBoxStyler()
                    .mainAxisSize(.min)
                    .crossAxisAlignment(.start),
                children: [
                  const UiText(
                    'Leo Farias',
                    size: .size2,
                    weight: .medium,
                    softWrap: false,
                    truncate: true,
                  ),
                  StyledText(
                    'Northstar workspace',
                    style: dashboardText(
                      .size1,
                      tone: .muted,
                    ).maxLines(1).softWrap(false).overflow(.ellipsis),
                  ),
                ],
              ),
            ),
            Icon(
              RemixIcons.dotsHorizontal,
              size: 18,
              color: MixScope.tokenOf(UiTokens.gray11, context),
            ),
          ],
        ),
      ),
      actions: const [
        UiAction(value: 'profile', label: 'View profile'),
        UiAction(value: 'preferences', label: 'Preferences'),
        UiAction(value: 'signout', label: 'Sign out', dividerBefore: true),
      ],
      onSelected: (value) => showRemixToast(
        context,
        RemixToastData(
          title: value == 'signout'
              ? 'Signed out of demo'
              : '${capitalize(value)} opened',
          icon: RemixIcons.checkCircled,
        ),
      ),
    ),
  );
}

/// Application-owned toolbar actions supplied to the Ui dashboard shell.
class UiDashboardTopBar extends StatefulWidget {
  const UiDashboardTopBar({super.key, this.activities = const []});

  final List<UiDashboardActivity> activities;

  @override
  State<UiDashboardTopBar> createState() => _UiDashboardTopBarState();
}

class _UiDashboardTopBarState extends State<UiDashboardTopBar> {
  final _notificationsController = MenuController();
  final _themeController = MenuController();
  bool _notificationsRead = false;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;
    final isDark = UiTheme.of(context).isDark;

    return RowBox(
      style: FlexBoxStyler().spacing(UiTokens.space2()),
      children: [
        KeyedSubtree(
          key: const ValueKey('dashboard-appearance-toggle'),
          child: RemixIconButton(
            key: const ValueKey('theme-quick-toggle'),
            semanticLabel: isDark
                ? 'Use light appearance'
                : 'Use dark appearance',
            style: _toolbarButtonStyle,
            onPressed: () {
              final theme = UiDashboardThemeScope.of(context);
              theme.onChanged(
                theme.settings.copyWith(appearance: isDark ? .light : .dark),
              );
            },
            icon: isDark ? RemixIcons.sun : RemixIcons.moon,
          ),
        ),
        if (!compact)
          UiPopover(
            controller: _notificationsController,
            openOnTap: false,
            semanticLabel: 'Notifications',
            positioning: const OverlayPositionConfig(
              side: .bottom,
              alignment: .end,
              sideOffset: 8,
            ),
            popoverChild: Box(
              key: const ValueKey('topbar-notifications-content'),
              style: BoxStyler().width(330),
              child: ColumnBox(
                style: FlexBoxStyler()
                    .mainAxisSize(.min)
                    .crossAxisAlignment(.stretch)
                    .spacing(10),
                children: [
                  RowBox(
                    style: FlexBoxStyler().crossAxisAlignment(.center),
                    children: [
                      const Expanded(
                        child: UiHeading(
                          'Notifications',
                          headingLevel: 2,
                          size: .size3,
                          weight: .medium,
                        ),
                      ),
                      if (!_notificationsRead)
                        UiButton.ghost(
                          size: .size1,
                          onPressed: () {
                            setState(() => _notificationsRead = true);
                            _notificationsController.close();
                            showRemixToast(
                              context,
                              const RemixToastData(
                                title: 'All notifications marked read',
                                icon: RemixIcons.checkCircled,
                              ),
                            );
                          },
                          label: 'Mark all read',
                        ),
                    ],
                  ),
                  for (final event in widget.activities.take(4))
                    RowBox(
                      style: FlexBoxStyler()
                          .crossAxisAlignment(.start)
                          .spacing(9),
                      children: [
                        Box(
                          style: BoxStyler()
                              .width(7)
                              .height(7)
                              .margin(.top(6))
                              .color(
                                _notificationsRead
                                    ? UiTokens.gray6()
                                    : UiTokens.accent9(),
                              )
                              .borderRadius(.circular(4)),
                        ),
                        Expanded(
                          child: ColumnBox(
                            style: FlexBoxStyler()
                                .crossAxisAlignment(.start)
                                .spacing(2),
                            children: [
                              UiText(
                                event.kind == .alert
                                    ? 'Order ORD-1047 requires review.'
                                    : event.title,
                                size: .size2,
                                weight: _notificationsRead ? .regular : .medium,
                              ),
                              StyledText(
                                event.relativeTime,
                                style: dashboardText(.size1, tone: .muted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            child: RemixIconButton(
              semanticLabel: 'Notifications',
              style: _toolbarButtonStyle,
              onPressed: _toggleNotifications,
              icon: RemixIcons.bell,
              iconBuilder: (context, spec, icon) => Stack(
                clipBehavior: Clip.none,
                children: [
                  StyledIcon(
                    icon: icon,
                    styleSpec: StyleSpec(spec: spec),
                  ),
                  if (!_notificationsRead)
                    Positioned(
                      right: -1,
                      top: -1,
                      child: Box(
                        style: BoxStyler()
                            .width(7)
                            .height(7)
                            .color(UiTokens.accent9())
                            .borderRadius(.circular(4)),
                      ),
                    ),
                ],
              ),
            ),
          ),
        UiPopover(
          controller: _themeController,
          openOnTap: false,
          semanticLabel: 'Theme settings',
          positioning: const OverlayPositionConfig(
            side: .bottom,
            alignment: .end,
            sideOffset: 8,
          ),
          popoverChild: Box(
            style: BoxStyler().width(400).maxHeight(650),
            child: const SingleChildScrollView(child: UiThemePanel()),
          ),
          child: RemixIconButton(
            key: const ValueKey('theme-panel-trigger'),
            semanticLabel: 'Theme settings',
            style: _toolbarButtonStyle,
            onPressed: _toggleTheme,
            icon: RemixIcons.mixerHorizontal,
          ),
        ),
        if (!compact)
          UiActionMenu(
            key: const ValueKey('topbar-account-trigger'),
            semanticLabel: 'Account menu',
            positioning: const OverlayPositionConfig(
              side: .bottom,
              alignment: .end,
              sideOffset: 8,
            ),
            trigger: const UiAvatar(label: 'LF', size: .size2),
            actions: const [
              UiAction(value: 'profile', label: 'Profile'),
              UiAction(value: 'preferences', label: 'Preferences'),
              UiAction(
                value: 'signout',
                label: 'Sign out',
                dividerBefore: true,
              ),
            ],
            onSelected: (value) => showRemixToast(
              context,
              RemixToastData(
                title: value == 'signout'
                    ? 'Signed out of demo'
                    : 'Opened $value',
                icon: RemixIcons.checkCircled,
              ),
            ),
          ),
      ],
    );
  }

  void _toggleNotifications() {
    _notificationsController.isOpen
        ? _notificationsController.close()
        : _notificationsController.open();
  }

  void _toggleTheme() {
    _themeController.isOpen
        ? _themeController.close()
        : _themeController.open();
  }
}

final _toolbarButtonStyle = uiIconButtonStyle(variant: .ghost)
    .width(40)
    .height(40)
    .padding(.all(0))
    .margin(.all(0))
    .container(.alignment(.center));

/// Full Ui dashboard demo.
///
/// This is the open-code Ui showcase: it includes the Workspace, Data,
/// Manage, and Components destinations, live Radix theme customization,
/// interactive Agent chat, and 12 chart patterns.
class UiDashboardDemo extends StatefulWidget {
  const UiDashboardDemo({
    super.key,
    this.brand = const UiDashboardBrand(),
    this.account,
    this.headerActions = const [],
    this.onSearchChanged,
    this.data = uiDashboardSampleData,
    this.initialPage = UiDashboardDemoPage.overview,
    this.initialSettings = const UiThemeSettings(),
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
  final UiDashboardSampleData data;
  final UiDashboardDemoPage initialPage;
  final UiThemeSettings initialSettings;
  final bool? collapsed;
  final bool initiallyCollapsed;
  final ValueChanged<bool>? onCollapsedChanged;
  final bool builtInChrome;
  final Duration chatStepDelay;

  @override
  State<UiDashboardDemo> createState() => _UiDashboardDemoState();
}

class _UiDashboardDemoState extends State<UiDashboardDemo> {
  late UiThemeSettings _settings = widget.initialSettings;
  bool? _ambientIsDark;

  @override
  void didUpdateWidget(covariant UiDashboardDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSettings != oldWidget.initialSettings) {
      _settings = widget.initialSettings;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ambient = UiTheme.maybeOf(context)?.isDark;
    if (_ambientIsDark != null && ambient != _ambientIsDark) {
      _settings = _settings.copyWith(appearance: .system);
    }
    _ambientIsDark = ambient;
  }

  bool _resolveIsDark(BuildContext context, UiThemeSettings settings) {
    final platformDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final ambientDark = UiTheme.maybeOf(context)?.isDark ?? false;
    return switch (settings.appearance) {
      .light => false,
      .dark => true,
      .system => platformDark || ambientDark,
    };
  }

  @override
  Widget build(BuildContext context) {
    final ambientScope = UiDashboardThemeScope.maybeOf(context);
    final activeSettings = ambientScope?.settings ?? _settings;
    final onSettingsChanged =
        ambientScope?.onChanged ??
        (UiThemeSettings next) => setState(() => _settings = next);
    final isDark = _resolveIsDark(context, activeSettings);
    final demo = UiDashboardDemoBase(
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
          }) => UiDashboardShell<UiDashboardDemoPage>(
            sections: sections,
            selectedValue: selectedValue,
            onSelected: onSelected,
            body: body,
            title: title,
            brand: widget.brand,
            account:
                widget.account ??
                (widget.builtInChrome
                    ? const UiDashboardSidebarAccount()
                    : null),
            headerActions: [
              if (widget.builtInChrome)
                UiDashboardTopBar(activities: widget.data.activities),
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
        .overview => UiDashboardOverview(
          data: widget.data,
          onViewOrders: () => onSelected(UiDashboardDemoPage.orders),
        ),
        .chat => UiDashboardChatPage(
          styles: _uiAgentStyles(),
          stepDelay: widget.chatStepDelay,
        ),
        .customers => UiDashboardCustomersPage(globalQuery: query),
        .orders => UiDashboardOrdersPage(globalQuery: query),
        .settings => UiDashboardSettingsPage(
          darkMode: switch (activeSettings.appearance) {
            .light => false,
            .dark => true,
            .system => null,
          },
          onDarkModeChanged: (value) => onSettingsChanged(
            activeSettings.copyWith(
              appearance: switch (value) {
                false => .light,
                true => .dark,
                null => .system,
              },
            ),
          ),
        ),
        .charts => UiChartsPage(data: widget.data),
        .actions => const UiGalleryActionsPage(),
        .forms => const UiGalleryFormsPage(),
        .dataDisplay => const UiGalleryDisplayPage(),
        .overlays => const UiGalleryOverlaysPage(),
        .navigation => const UiGalleryNavigationPage(),
        .typography => const UiGalleryTypographyPage(),
      },
    );
    if (!widget.builtInChrome || ambientScope != null) return demo;
    return UiDashboardThemeScope(
      settings: _settings,
      onChanged: onSettingsChanged,
      child: UiTheme(
        key: const ValueKey('dashboard-theme-scope'),
        mode: isDark ? UiThemeMode.dark : UiThemeMode.light,
        accent: _settings.accentColor,
        gray: _settings.grayColor,
        panelBackground: _settings.panelBackground,
        radius: _settings.radius,
        scaling: _settings.scaling,
        child: RemixToastScope(style: uiToastStyle(), child: demo),
      ),
    );
  }
}

/// Charts gallery page for the Ui dashboard.
class UiChartsPage extends StatelessWidget {
  const UiChartsPage({super.key, this.data = uiDashboardSampleData});

  final UiDashboardSampleData data;

  @override
  Widget build(BuildContext context) => UiDashboardDemoContent(
    page: UiDashboardDemoPage.charts,
    kit: const _UiDashboardDemoKit(),
    data: data,
  );
}

final class _UiDashboardDemoKit implements UiDashboardDemoKit {
  const _UiDashboardDemoKit();

  @override
  Widget pageHeader(String title, String description) => UiPageHeader(
    title: title,
    description:
        'Native chart patterns for comparison, composition, interaction, and empty states.',
  );

  @override
  Widget charts(UiDashboardSampleData data) => _UiDashboardCharts(data: data);
}

class _UiDashboardCharts extends StatelessWidget {
  const _UiDashboardCharts({required this.data});

  final UiDashboardSampleData data;

  @override
  Widget build(BuildContext context) {
    final palette = resolveUiChartPalette(context);

    return KeyedSubtree(
      key: const ValueKey('charts-page'),
      child: UiDashboardCharts(
        cardBuilder: (title, description, chart, {legend}) => UiChartCard(
          title: title,
          description: description,
          legend: legend,
          chartPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          chart: chart,
        ),
        legendBuilder: (_, chart) => _chartLegend(chart, palette),
        sectionBuilder: (title, description, cards) => ColumnBox(
          style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(12),
          children: [
            ColumnBox(
              style: FlexBoxStyler().crossAxisAlignment(.start).spacing(4),
              children: [
                UiSectionLabel(title),
                StyledText(
                  description,
                  style: dashboardText(.size2, tone: .muted),
                ),
              ],
            ),
            GridBox(
              style: GridBoxStyler.equalColumns(2)
                  .gap(16)
                  .onConstraints(
                    const .maxWidth(860),
                    .equalColumns(1).gap(16),
                  ),
              children: cards,
            ),
          ],
        ),
        chartBuilder: (context, chart, selected, onSelected) => switch (chart) {
          .revenueMomentum => UiLineChart(
            palette: palette,
            showMarkers: true,
            semanticsLabel: 'Weekly revenue momentum',
            series: [
              LineSeries(
                id: 'revenue',
                label: 'Revenue',
                points: uiDashboardRevenuePoints(data),
              ),
            ],
            xAxis: uiDashboardWeekdayAxis(),
            yAxis: uiDashboardNumericAxis(max: 100, interval: 20),
            style: uiDashboardLineStyle(),
          ),
          .linePatterns => UiLineChart(
            key: const ValueKey('charts-line-patterns'),
            palette: palette,
            showMarkers: true,
            semanticsLabel: 'Weekly actual and planned revenue',
            series: [
              LineSeries(
                id: 'actual',
                label: 'Actual',
                points: uiDashboardPoints('actual', const [
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
                points: uiDashboardPoints('plan', const [
                  16,
                  20,
                  25,
                  28,
                  34,
                  37,
                  41,
                ]),
                style: LineSeriesStyler()
                    .stroke(ChartStrokeStyler().dashArray([6, 4]).width(2.5))
                    .marker(
                      ChartMarkerStyler().show(true).shape(.square).radius(3.5),
                    ),
              ),
            ],
            xAxis: uiDashboardWeekdayAxis(),
            yAxis: uiDashboardNumericAxis(max: 60),
            style: uiDashboardLineStyle(),
          ),
          .stepGaps => UiLineChart(
            palette: palette,
            showMarkers: true,
            semanticsLabel: 'Inventory levels with missing observations',
            series: [
              LineSeries(
                id: 'inventory',
                label: 'Inventory',
                points: uiDashboardPoints('inventory', const [
                  32,
                  27,
                  null,
                  null,
                  19,
                  25,
                  22,
                ]),
                style: LineSeriesStyler()
                    .curve(.stepAfter)
                    .marker(ChartMarkerStyler().show(true).shape(.square)),
              ),
            ],
            xAxis: uiDashboardWeekdayAxis(),
            yAxis: uiDashboardNumericAxis(max: 40),
            style: uiDashboardLineStyle(),
          ),
          .viewportLabels => LayoutBuilder(
            builder: (context, constraints) => UiLineChart(
              palette: palette,
              showMarkers: true,
              semanticsLabel: 'Revenue chart with scalable horizontal viewport',
              viewport: ChartViewport(axis: .horizontal, maxScale: 3),
              series: [
                LineSeries(
                  id: 'viewport',
                  label: 'Revenue',
                  points: uiDashboardPoints('viewport', const [
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
              xAxis: ChartAxis.numeric(
                min: 0,
                max: 6,
                interval: constraints.maxWidth < 360 ? 3 : 1,
                labelFormatter: uiDashboardWeekdayLabel,
                labelBuilder: (_, label) => UiBadge.soft(
                  size: .size1,
                  highContrast: true,
                  label: label.formattedValue,
                ),
              ),
              yAxis: uiDashboardNumericAxis(max: 60),
              style: uiDashboardLineStyle(),
            ),
          ),
          .groupedBars => UiBarChart(
            key: const ValueKey('charts-bar-grouped'),
            palette: palette,
            semanticsLabel: 'Monthly actual and planned revenue',
            groups: uiDashboardGroupedBars(palette),
            yAxis: uiDashboardNumericAxis(max: 60),
            style: uiDashboardBarStyle(),
          ),
          .stackedBars => UiBarChart(
            palette: palette,
            semanticsLabel: 'Monthly product and services revenue',
            groups: uiDashboardStackedBars(),
            yAxis: uiDashboardNumericAxis(max: 60),
            style: uiDashboardBarStyle(),
          ),
          .floatingBars => UiBarChart(
            palette: palette,
            semanticsLabel: 'Monthly floating inventory changes',
            groups: uiDashboardFloatingBars(),
            yAxis: uiDashboardNumericAxis(max: 40),
            style: uiDashboardBarStyle(),
          ),
          .trackedBars => UiBarChart(
            palette: palette,
            semanticsLabel: 'Monthly revenue against full-scale tracks',
            groups: uiDashboardTrackedBars(),
            yAxis: uiDashboardNumericAxis(max: 70),
            style: uiDashboardBarStyle(),
          ),
          .trafficPie => PieChart(
            style: uiPieChartStyle(
              palette: palette,
            ).slice(PieSliceStyler().radius(72)),
            semanticsLabel: 'Traffic share by device',
            slices: uiDashboardChannelSlices(),
            valueFormatter: (value) => '${value.toInt()}%',
          ),
          .interactivePie => PieChart(
            style: uiPieChartStyle(
              palette: palette,
              centerRadius: 40,
            ).slice(PieSliceStyler().radius(36)),
            semanticsLabel: 'Product mix',
            slices: uiDashboardProductSlices(),
            selectedSliceIds: {?selected},
            onSliceTap: (hit) => onSelected(hit.sliceId),
            valueFormatter: (value) => '${value.toInt()}%',
          ),
          .badgePie => PieChart(
            style: uiPieChartStyle(
              palette: palette,
              centerRadius: 34,
            ).slice(PieSliceStyler().radius(48).badgePosition(0.72)),
            semanticsLabel: 'Device traffic with badge markers',
            slices: uiDashboardChannelSlices(badges: true),
            valueFormatter: (value) => '${value.toInt()}%',
          ),
          .emptyPie => StackBox(
            style: StackBoxStyler().alignment(.center),
            children: [
              UiPieChart(
                palette: palette,
                centerRadius: 52,
                style: PieChartStyler().slice(PieSliceStyler().radius(32)),
                semanticsLabel: 'No channel data',
                slices: uiDashboardEmptySlices(),
              ),
              ColumnBox(
                style: FlexBoxStyler()
                    .mainAxisSize(.min)
                    .crossAxisAlignment(.center)
                    .spacing(6),
                children: [
                  StyledIcon(
                    icon: RemixIcons.box,
                    style: IconStyler().size(20).color(UiTokens.gray11()),
                  ),
                  StyledText(
                    'No data yet',
                    style: dashboardText(.size1, tone: .muted),
                  ),
                ],
              ),
            ],
          ),
        },
      ),
    );
  }
}

Widget? _chartLegend(UiDashboardChartCase chart, List<Color> palette) =>
    switch (chart) {
      .revenueMomentum => UiDashboardChartLegend(
        semanticLabel: 'Revenue series legend',
        items: [
          UiDashboardChartLegendItem(
            id: 'revenue',
            label: 'Revenue',
            color: palette[0],
          ),
        ],
      ),
      .linePatterns => UiDashboardChartLegend(
        semanticLabel: 'Actual and plan line patterns',
        items: [
          UiDashboardChartLegendItem(
            id: 'actual',
            label: 'Actual',
            color: palette[0],
          ),
          UiDashboardChartLegendItem(
            id: 'plan',
            label: 'Plan',
            color: palette[1],
            pattern: .dashed,
          ),
        ],
      ),
      .stepGaps => UiDashboardChartLegend(
        semanticLabel: 'Inventory series legend',
        items: [
          UiDashboardChartLegendItem(
            id: 'inventory',
            label: 'Inventory',
            color: palette[0],
          ),
        ],
      ),
      .viewportLabels => UiDashboardChartLegend(
        semanticLabel: 'Viewport revenue legend',
        items: [
          UiDashboardChartLegendItem(
            id: 'viewport-revenue',
            label: 'Revenue',
            color: palette[0],
          ),
        ],
      ),
      .groupedBars => UiDashboardChartLegend(
        semanticLabel: 'Actual and plan bar patterns',
        items: [
          UiDashboardChartLegendItem(
            id: 'actual',
            label: 'Actual',
            color: palette[0],
          ),
          UiDashboardChartLegendItem(
            id: 'plan',
            label: 'Plan',
            color: palette[1],
            pattern: .dashed,
          ),
        ],
      ),
      .stackedBars => UiDashboardChartLegend(
        semanticLabel: 'Revenue mix legend',
        items: [
          UiDashboardChartLegendItem(
            id: 'product',
            label: 'Product',
            color: palette[0],
          ),
          UiDashboardChartLegendItem(
            id: 'services',
            label: 'Services',
            color: palette[1],
          ),
        ],
      ),
      .floatingBars => UiDashboardChartLegend(
        semanticLabel: 'Floating changes legend',
        items: [
          UiDashboardChartLegendItem(
            id: 'change',
            label: 'Change range',
            color: palette[2],
          ),
        ],
      ),
      .trackedBars => UiDashboardChartLegend(
        semanticLabel: 'Tracked revenue legend',
        items: [
          UiDashboardChartLegendItem(
            id: 'tracked',
            label: 'Revenue',
            color: palette[0],
          ),
        ],
      ),
      .trafficPie => UiDashboardChartLegend(
        semanticLabel: 'Traffic channel legend',
        items: uiPercentagePieLegendItems(
          slices: uiDashboardChannelSlices(),
          palette: palette,
        ),
      ),
      .badgePie => UiDashboardChartLegend(
        semanticLabel: 'Badge marker chart legend',
        items: uiPercentagePieLegendItems(
          slices: uiDashboardChannelSlices(),
          palette: palette,
        ),
      ),
      .interactivePie => UiDashboardChartLegend(
        semanticLabel: 'Product mix legend',
        items: uiPercentagePieLegendItems(
          slices: uiDashboardProductSlices(),
          palette: palette,
        ),
      ),
      .emptyPie => null,
    };

UiDashboardAgentStyles _uiAgentStyles() {
  final message = uiAgentMessageRecipe();
  final answer = uiAgentAnswerRecipe();
  final transcript = uiAgentTranscriptRecipe();
  final plan = uiAgentPlanRecipe();
  final activity = uiAgentActivityRecipe();
  final permission = uiAgentPermissionRecipe();
  final execution = uiAgentExecutionRecipe();
  final composer = uiAgentComposerRecipe();
  return UiDashboardAgentStyles(
    buttonBuilder: (label, onPressed, tone) => switch (tone) {
      .primary => UiButton(label: label, onPressed: onPressed),
      .soft => UiButton.soft(label: label, onPressed: onPressed),
      .outline => UiButton.outline(label: label, onPressed: onPressed),
    },
    heading: uiTextStyle(size: .size6, weight: .bold),
    body: uiTextStyle(size: .size2, highContrast: false),
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
