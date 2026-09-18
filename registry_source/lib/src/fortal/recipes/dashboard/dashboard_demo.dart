import 'package:flutter/widgets.dart';
import 'package:mix_chart/mix_chart.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../../dashboard/dashboard_demo_base.dart';
import '../../../dashboard/dashboard_demo_chat.dart';
import '../../../dashboard/dashboard_demo_charts.dart';
import '../../../dashboard/dashboard_demo_content.dart';
import '../../../dashboard/dashboard_sample_data.dart';
import '../../components/badge.dart';
import '../../components/button.dart';
import '../../components/card.dart';
import '../../components/chart.dart';
import '../../components/checkbox.dart';
import '../../components/code.dart';
import '../../components/data_table.dart';
import '../../components/disclosure.dart';
import '../../components/heading.dart';
import '../../components/icon_button.dart';
import '../../components/kbd.dart';
import '../../components/link.dart';
import '../../components/menu.dart';
import '../../components/popover.dart';
import '../../components/progress.dart';
import '../../components/switch.dart';
import '../../components/tabs.dart';
import '../../components/text.dart';
import '../../components/textfield.dart';
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
    this.brand = const Text('Northstar'),
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
  bool _dark = false;

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
        .settings => const FortalDashboardSettingsPage(),
        .actions => const GalleryActionsPage(),
        .forms => const GalleryFormsPage(),
        .dataDisplay => const GalleryDisplayPage(),
        .overlays => const GalleryOverlaysPage(),
        .navigation => const GalleryNavigationPage(),
        .typography => const GalleryTypographyPage(),
        _ => RegistryDashboardDemoContent(
          page: page,
          searchQuery: query,
          kit: kit,
          onSelected: onSelected,
          data: widget.data,
        ),
      },
    );
    if (!widget.builtInChrome) return demo;
    return FortalScope(
      brightness: _dark ? Brightness.dark : Brightness.light,
      child: RemixToastScope(style: fortalToastStyle(), child: demo),
    );
  }

  List<Widget> _chromeActions() => [
    FortalIconButton.ghost(
      key: const ValueKey('dashboard-appearance-toggle'),
      icon: _dark ? RemixIcons.sun : RemixIcons.moon,
      semanticLabel: _dark ? 'Use light appearance' : 'Use dark appearance',
      onPressed: () => setState(() => _dark = !_dark),
    ),
    const FortalPopover(
      semanticLabel: 'Notifications',
      popoverChild: SizedBox(
        width: 280,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FortalText('Notifications', weight: .bold),
              SizedBox(height: 8),
              FortalText('Order ORD-1047 requires review.', size: .size2),
              SizedBox(height: 6),
              FortalText(
                'Three customer invitations are pending.',
                size: .size2,
              ),
            ],
          ),
        ),
      ),
      child: FortalIconButton.ghost(
        icon: RemixIcons.bell,
        semanticLabel: 'Open notifications',
      ),
    ),
    FortalPopover(
      semanticLabel: 'Theme settings',
      popoverChild: SizedBox(
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const FortalText('Theme settings', size: .size4, weight: .bold),
              const SizedBox(height: 12),
              _settingLine('Appearance', _dark ? 'Dark' : 'Light'),
              _settingLine('Accent color', 'Indigo'),
              _settingLine('Gray color', 'Slate'),
              _settingLine('Radius', 'Medium'),
              _settingLine('Scaling', '100%'),
            ],
          ),
        ),
      ),
      child: const FortalIconButton.ghost(
        icon: RemixIcons.gear,
        semanticLabel: 'Open theme settings',
      ),
    ),
  ];

  Widget _settingLine(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Expanded(child: FortalText(label, size: .size2)),
        FortalText(value, size: .size1, highContrast: false),
      ],
    ),
  );
}

class _FortalBreadcrumb extends StatelessWidget {
  const _FortalBreadcrumb({required this.page});
  final RegistryDashboardDemoPage page;

  @override
  Widget build(BuildContext context) => Row(
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
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text('/'),
      ),
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
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const FortalText(
        'Northstar workspace',
        size: .size1,
        highContrast: false,
      ),
      const SizedBox(height: 8),
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
  Widget pageHeader(String title, String description) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      FortalHeading(title, size: .size7),
      const SizedBox(height: 6),
      FortalText(description, size: .size2, highContrast: false),
    ],
  );

  @override
  Widget section(String title, String description, Widget child) =>
      FortalCard.surface(
        size: .size2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FortalHeading(title, headingLevel: 2, size: .size4),
            const SizedBox(height: 4),
            FortalText(description, size: .size2, highContrast: false),
            const SizedBox(height: 16),
            child,
          ],
        ),
      );

  @override
  Widget surface(Widget child) =>
      FortalCard.surface(size: .size2, child: child);

  @override
  Widget text(String value, {bool emphasized = false, bool muted = false}) =>
      FortalText(
        value,
        size: .size2,
        weight: emphasized ? .bold : .regular,
        highContrast: !muted,
      );

  @override
  Widget button(String label, {int emphasis = 0, VoidCallback? onPressed}) =>
      switch (emphasis) {
        1 => FortalButton.soft(label: label, onPressed: onPressed),
        2 => FortalButton.outline(label: label, onPressed: onPressed),
        3 => FortalButton.ghost(label: label, onPressed: onPressed),
        4 => FortalButton.classic(label: label, onPressed: onPressed),
        _ => FortalButton.solid(label: label, onPressed: onPressed),
      };

  @override
  Widget badge(String label, {int emphasis = 0}) => switch (emphasis) {
    1 => FortalBadge.soft(label: label),
    2 => FortalBadge.surface(label: label),
    3 => FortalBadge.outline(label: label),
    _ => FortalBadge.solid(label: label),
  };

  @override
  Widget textField({
    required String hintText,
    ValueChanged<String>? onChanged,
  }) => FortalTextField(hintText: hintText, onChanged: onChanged);

  @override
  Widget checkbox({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) => FortalCheckbox(
    selected: value,
    semanticLabel: 'Receive account alerts',
    onChanged: (next) => onChanged(next ?? false),
  );

  @override
  Widget switchControl({
    required bool value,
    required ValueChanged<bool> onChanged,
  }) => FortalSwitch(
    selected: value,
    semanticLabel: 'Toggle setting',
    onChanged: onChanged,
  );

  @override
  Widget progress(double value) => FortalProgress(
    value: value,
    semanticsLabel: 'Completion',
    semanticsValue: '${(value * 100).round()} percent',
  );

  @override
  Widget charts(RegistryDashboardSampleData data) =>
      _FortalDashboardCharts(data: data);

  @override
  Widget records({required bool orders, required String query}) {
    final rows = registryDashboardSampleData.records.where((record) {
      if (query.isEmpty) return true;
      return record.id.toLowerCase().contains(query) ||
          record.customer.toLowerCase().contains(query) ||
          record.status.toLowerCase().contains(query);
    }).toList();
    return FortalDataTable<RegistryDashboardRecord>.surface(
      semanticLabel: orders ? 'Orders' : 'Customers',
      rows: rows,
      minimumWidth: 620,
      columns: [
        RemixDataTableColumn(
          id: orders ? 'order' : 'customer',
          label: orders ? 'Order' : 'Customer',
          width: const FlexColumnWidth(2),
          cellBuilder: (_, record) =>
              text(orders ? record.id : record.customer, emphasized: true),
        ),
        RemixDataTableColumn(
          id: 'status',
          label: 'Status',
          width: const FixedColumnWidth(140),
          cellBuilder: (_, record) => badge(record.status, emphasis: 1),
        ),
        RemixDataTableColumn(
          id: orders ? 'amount' : 'plan',
          label: orders ? 'Amount' : 'Plan',
          width: const FixedColumnWidth(120),
          cellBuilder: (_, record) =>
              text(orders ? record.amount : _planFor(record.id)),
        ),
      ],
    );
  }

  @override
  Widget overlays(VoidCallback onAction) => Wrap(
    spacing: 12,
    runSpacing: 12,
    children: [
      FortalPopover(
        semanticLabel: 'Invite teammates',
        popoverChild: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              text('Invite teammates', emphasized: true),
              const SizedBox(height: 8),
              text('Share this workspace with collaborators.', muted: true),
              const SizedBox(height: 12),
              button('Copy invite link', onPressed: onAction),
            ],
          ),
        ),
        child: const FortalButton.outline(label: 'Open popover'),
      ),
      button('Show toast', emphasis: 1, onPressed: onAction),
      button('Open menu', emphasis: 3, onPressed: onAction),
    ],
  );

  @override
  Widget navigation() => const _FortalNavigationDemo();

  @override
  Widget typography(VoidCallback onAction) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const FortalHeading(
        'Build products with owned source',
        headingLevel: 2,
        size: .size6,
      ),
      const SizedBox(height: 8),
      const FortalText(
        'Body copy inherits the application theme and remains editable.',
        size: .size3,
      ),
      const SizedBox(height: 12),
      FortalLink('Interactive link', onPressed: onAction),
      const SizedBox(height: 12),
      const Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          FortalCode('remix add dashboard_demo'),
          FortalKbd('⌘'),
          FortalKbd('K'),
        ],
      ),
    ],
  );
}

class _FortalNavigationDemo extends StatefulWidget {
  const _FortalNavigationDemo();

  @override
  State<_FortalNavigationDemo> createState() => _FortalNavigationDemoState();
}

class _FortalNavigationDemoState extends State<_FortalNavigationDemo> {
  String _selected = 'overview';

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      RemixTabs(
        selectedTabId: _selected,
        onChanged: (value) => setState(() => _selected = value),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FortalTabBar(
              child: Row(
                children: [
                  FortalTab(tabId: 'overview', label: 'Overview'),
                  FortalTab(tabId: 'activity', label: 'Activity'),
                ],
              ),
            ),
            FortalTabView(
              tabId: 'overview',
              child: FortalText('Overview content'),
            ),
            FortalTabView(
              tabId: 'activity',
              child: FortalText('Activity content'),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      const FortalDisclosure.surface(
        trigger: FortalText('What is the dashboard demo?'),
        content: FortalText(
          'A complete, editable reference app installed into your project.',
        ),
      ),
    ],
  );
}

class _FortalDashboardCharts extends StatelessWidget {
  const _FortalDashboardCharts({required this.data});

  final RegistryDashboardSampleData data;

  @override
  Widget build(BuildContext context) => RegistryDashboardCharts(
    cardBuilder: _chartCard,
    sectionBuilder: (title, description, cards) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FortalHeading(title, headingLevel: 2, size: .size4),
        const SizedBox(height: 4),
        FortalText(description, size: .size2, highContrast: false),
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
        yAxis: registryDashboardNumericAxis(max: 100),
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
      ),
      .groupedBars => FortalBarChart(
        semanticsLabel: 'Monthly actual and planned revenue',
        groups: registryDashboardGroupedBars(),
      ),
      .stackedBars => FortalBarChart(
        semanticsLabel: 'Monthly product and services revenue',
        groups: registryDashboardStackedBars(),
      ),
      .floatingBars => FortalBarChart(
        semanticsLabel: 'Monthly floating inventory changes',
        groups: registryDashboardFloatingBars(),
      ),
      .trackedBars => FortalBarChart(
        semanticsLabel: 'Monthly revenue against full-scale tracks',
        groups: registryDashboardTrackedBars(),
        yAxis: registryDashboardNumericAxis(max: 70),
      ),
      .trafficPie => FortalPieChart(
        semanticsLabel: 'Traffic share by device',
        slices: registryDashboardChannelSlices(),
        valueFormatter: (value) => '${value.toInt()}%',
      ),
      .interactivePie => FortalPieChart(
        centerRadius: 40,
        semanticsLabel: 'Product mix',
        slices: registryDashboardProductSlices(),
        selectedSliceIds: {?selected},
        onSliceTap: (hit) => onSelected(hit.sliceId),
        valueFormatter: (value) => '${value.toInt()}%',
      ),
      .badgePie => FortalPieChart(
        centerRadius: 34,
        semanticsLabel: 'Device traffic with badge markers',
        slices: registryDashboardChannelSlices(badges: true),
      ),
      .emptyPie => Stack(
        alignment: Alignment.center,
        children: [
          FortalPieChart(
            centerRadius: 52,
            semanticsLabel: 'No channel data',
            slices: registryDashboardEmptySlices(),
          ),
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(RemixIcons.box, size: 20),
              SizedBox(height: 6),
              FortalText('No data yet', size: .size1),
            ],
          ),
        ],
      ),
    },
  );
}

Widget _chartCard(String title, String description, Widget chart) =>
    FortalCard.surface(
      size: .size2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FortalHeading(title, headingLevel: 3, size: .size3),
          const SizedBox(height: 4),
          FortalText(description, size: .size1, highContrast: false),
          const SizedBox(height: 12),
          SizedBox(height: 240, child: chart),
        ],
      ),
    );

String _planFor(String id) => switch (id) {
  'ORD-1048' => 'Enterprise',
  'ORD-1047' => 'Pro',
  'ORD-1046' => 'Pro',
  _ => 'Starter',
};

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
