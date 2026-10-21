import 'package:flutter/widgets.dart';
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
import 'dashboard_demo_chat.dart';
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
      trigger: RowBox(
        style: FlexBoxStyler()
            .minHeight(48)
            .crossAxisAlignment(.center)
            .spacing(10),
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
          StyledIcon(
            icon: RemixIcons.dotsHorizontal,
            style: IconStyler().size(18).color(UiTokens.gray11()),
          ),
        ],
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
/// This is the open-code Ui product dashboard starter: it includes the
/// Overview, Chat, Customers, Orders, and Settings destinations, live Radix
/// theme customization, interactive Agent chat, and revenue/activity charts.
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
