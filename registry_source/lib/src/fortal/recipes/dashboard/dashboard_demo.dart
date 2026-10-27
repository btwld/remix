import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../../dashboard/dashboard_demo_base.dart';
import '../../../dashboard/dashboard_demo_chat.dart';
import '../../../dashboard/dashboard_sample_data.dart';
import '../activity_recipe.dart';
import '../answer_recipe.dart';
import '../composer_recipe.dart';
import '../execution_recipe.dart';
import '../message_recipe.dart';
import '../permission_recipe.dart';
import '../plan_recipe.dart';
import '../transcript_recipe.dart';
import 'dashboard_demo_records.dart';
import 'dashboard_demo_settings.dart';
import 'dashboard_demo_text.dart';
import 'dashboard_demo_theme.dart';
import 'dashboard_demo_theme_panel.dart';
import 'dashboard_demo_typography.dart';
import 'dashboard_demo_ui.dart';
import 'dashboard_demo_widgets.dart';
import 'dashboard_overview.dart';
import 'dashboard_shell.dart';

/// Product brand supplied through the installed shell's brand slot.
class FortalDashboardBrand extends StatelessWidget {
  const FortalDashboardBrand({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    key: const ValueKey('dashboard-brand'),
    label: 'Dashboard',
    excludeSemantics: true,
    child: const FortalText(
      'Dashboard',
      size: .size5,
      weight: .bold,
      softWrap: false,
      truncate: true,
    ),
  );
}

/// Product account menu supplied through the installed shell's footer slot.
class FortalDashboardSidebarAccount extends StatelessWidget {
  const FortalDashboardSidebarAccount({super.key});

  @override
  Widget build(BuildContext context) => Box(
    style: BoxStyler().padding(
      .symmetric(
        horizontal: FortalTokens.space2(),
        vertical: FortalTokens.space3(),
      ),
    ),
    child: FortalActionMenu(
      key: const ValueKey('sidebar-account-trigger'),
      trigger: RemixMenuTrigger.builder(
        label: 'Workspace account menu',
        builder: (_, _, _) => RowBox(
          style: FlexBoxStyler()
              .minHeight(48)
              .crossAxisAlignment(.center)
              .spacing(10)
              .onFocusVisible(FlexBoxStyler().onBuilder(_accountRowFocusRing)),
          children: [
            const FortalAvatar(label: 'LF', size: .size2),
            Expanded(
              child: ColumnBox(
                style: FlexBoxStyler()
                    .mainAxisSize(.min)
                    .crossAxisAlignment(.start),
                children: [
                  const FortalText(
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
            StyledIcon(
              icon: RemixIcons.dotsHorizontal,
              style: IconStyler().size(18).color(FortalTokens.gray11()),
            ),
          ],
        ),
      ),
      actions: const [
        FortalAction(value: 'profile', label: 'View profile'),
        FortalAction(value: 'preferences', label: 'Preferences'),
        FortalAction(value: 'signout', label: 'Sign out', dividerBefore: true),
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

FlexBoxStyler _accountRowFocusRing(BuildContext context) {
  final ring = fortalFocusRingDecoration(context);
  return ring == null
      ? FlexBoxStyler()
      : FlexBoxStyler().foregroundDecoration(ring);
}

/// Application-owned toolbar actions supplied to the Fortal dashboard shell.
class FortalDashboardTopBar extends StatefulWidget {
  const FortalDashboardTopBar({super.key, this.activities = const []});

  final List<RegistryDashboardActivity> activities;

  @override
  State<FortalDashboardTopBar> createState() => _FortalDashboardTopBarState();
}

class _FortalDashboardTopBarState extends State<FortalDashboardTopBar> {
  final _notificationsController = MenuController();
  final _themeController = MenuController();
  bool _notificationsRead = false;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;
    final isDark = FortalTheme.of(context).isDark;

    return RowBox(
      style: FlexBoxStyler().spacing(FortalTokens.space2()),
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
              final theme = FortalDashboardThemeScope.of(context);
              theme.onChanged(
                theme.settings.copyWith(appearance: isDark ? .light : .dark),
              );
            },
            icon: isDark ? RemixIcons.sun : RemixIcons.moon,
          ),
        ),
        if (!compact)
          FortalPopover(
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
                        child: FortalHeading(
                          'Notifications',
                          headingLevel: 2,
                          size: .size3,
                          weight: .medium,
                        ),
                      ),
                      if (!_notificationsRead)
                        FortalButton.ghost(
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
                                    ? FortalTokens.gray6()
                                    : FortalTokens.accent9(),
                              )
                              .borderRadius(.circular(4)),
                        ),
                        Expanded(
                          child: ColumnBox(
                            style: FlexBoxStyler()
                                .crossAxisAlignment(.start)
                                .spacing(2),
                            children: [
                              FortalText(
                                event.title,
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
              iconBuilder: (context, spec, icon) => StackBox(
                style: StackBoxStyler().clipBehavior(.none),
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
                            .color(FortalTokens.accent9())
                            .borderRadius(.circular(4)),
                      ),
                    ),
                ],
              ),
            ),
          ),
        FortalPopover(
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
            child: const SingleChildScrollView(child: FortalThemePanel()),
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
          FortalActionMenu(
            key: const ValueKey('topbar-account-trigger'),
            positioning: const OverlayPositionConfig(
              side: .bottom,
              alignment: .end,
              sideOffset: 8,
            ),
            trigger: RemixMenuTrigger.control(
              builder: (_, menu) => RemixIconButton(
                semanticLabel: 'Account menu',
                style: _toolbarButtonStyle,
                focusNode: menu.focusNode,
                onPressed: menu.toggle,
                icon: RemixIcons.person,
                iconBuilder: (_, _, _) =>
                    const FortalAvatar(label: 'LF', size: .size2),
              ),
            ),
            actions: const [
              FortalAction(value: 'profile', label: 'Profile'),
              FortalAction(value: 'preferences', label: 'Preferences'),
              FortalAction(
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

final _toolbarButtonStyle = fortalIconButtonStyle(variant: .ghost)
    .width(40)
    .height(40)
    .padding(.all(0))
    .margin(.all(0))
    .container(.alignment(.center));

/// Full Fortal dashboard demo.
///
/// This is the open-code Fortal product dashboard starter: it includes the
/// Overview, Chat, Customers, Orders, and Settings destinations, live Radix
/// theme customization, interactive Agent chat, and revenue/activity charts.
class FortalDashboardDemo extends StatefulWidget {
  const FortalDashboardDemo({
    super.key,
    this.brand = const FortalDashboardBrand(),
    this.account,
    this.headerActions = const [],
    this.onSearchChanged,
    this.data = registryDashboardSampleData,
    this.initialPage = RegistryDashboardDemoPage.overview,
    this.initialSettings = const FortalThemeSettings(),
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
  final FortalThemeSettings initialSettings;
  final bool? collapsed;
  final bool initiallyCollapsed;
  final ValueChanged<bool>? onCollapsedChanged;
  final bool builtInChrome;
  final Duration chatStepDelay;

  @override
  State<FortalDashboardDemo> createState() => _FortalDashboardDemoState();
}

class _FortalDashboardDemoState extends State<FortalDashboardDemo> {
  late FortalThemeSettings _settings = widget.initialSettings;
  bool? _ambientIsDark;

  @override
  void didUpdateWidget(covariant FortalDashboardDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSettings != oldWidget.initialSettings) {
      _settings = widget.initialSettings;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ambient = FortalTheme.maybeOf(context)?.isDark;
    if (_ambientIsDark != null && ambient != _ambientIsDark) {
      _settings = _settings.copyWith(appearance: .system);
    }
    _ambientIsDark = ambient;
  }

  bool _resolveIsDark(BuildContext context, FortalThemeSettings settings) {
    final platformDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final ambientDark = FortalTheme.maybeOf(context)?.isDark ?? false;
    return switch (settings.appearance) {
      .light => false,
      .dark => true,
      .system => platformDark || ambientDark,
    };
  }

  @override
  Widget build(BuildContext context) {
    final ambientScope = FortalDashboardThemeScope.maybeOf(context);
    final activeSettings = ambientScope?.settings ?? _settings;
    final onSettingsChanged =
        ambientScope?.onChanged ??
        (FortalThemeSettings next) => setState(() => _settings = next);
    final isDark = _resolveIsDark(context, activeSettings);
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
            brand: widget.brand,
            account:
                widget.account ??
                (widget.builtInChrome
                    ? const FortalDashboardSidebarAccount()
                    : null),
            headerActions: [
              if (widget.builtInChrome)
                FortalDashboardTopBar(activities: widget.data.activities),
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
      },
    );
    if (!widget.builtInChrome || ambientScope != null) return demo;
    return FortalDashboardThemeScope(
      settings: _settings,
      onChanged: onSettingsChanged,
      child: FortalTheme(
        key: const ValueKey('dashboard-theme-scope'),
        mode: isDark ? FortalThemeMode.dark : FortalThemeMode.light,
        accent: _settings.accentColor,
        gray: _settings.grayColor,
        panelBackground: _settings.panelBackground,
        radius: _settings.radius,
        scaling: _settings.scaling,
        child: RemixToastScope(style: fortalToastStyle(), child: demo),
      ),
    );
  }
}

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
