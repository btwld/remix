import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../../dashboard/dashboard_demo_base.dart';
import '../../../dashboard/dashboard_demo_chat.dart';
import '../../../dashboard/dashboard_sample_data.dart';
import '../../components/sidebar_layout.dart';
import '../../components/tooltip.dart';
import '../activity_recipe.dart';
import '../answer_recipe.dart';
import '../composer_recipe.dart';
import '../execution_recipe.dart';
import '../message_recipe.dart';
import '../permission_recipe.dart';
import '../plan_recipe.dart';
import '../transcript_recipe.dart';
import 'dashboard_demo_page_header.dart';
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

  static const _actions = [
    FortalAction(value: 'profile', label: 'View profile'),
    FortalAction(value: 'preferences', label: 'Preferences'),
    FortalAction(value: 'signout', label: 'Sign out', dividerBefore: true),
  ];

  static void _onSelected(BuildContext context, String value) => showRemixToast(
    context,
    RemixToastData(
      title: value == 'signout'
          ? 'Signed out of demo'
          : '${capitalize(value)} opened',
      icon: RemixIcons.checkCircle,
    ),
  );

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
        builder: (_, _, _) => RemixCard(
          style: CardStyler()
              .borderRadius(.all(FortalTokens.radius2()))
              .onFocusVisible(
                CardStyler().containerEffects(fortalFocusOutline()),
              ),
          child: RowBox(
            style: FlexBoxStyler()
                .minHeight(48)
                .crossAxisAlignment(.center)
                .spacing(10),
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
                icon: RemixIcons.more,
                style: IconStyler().size(18).color(FortalTokens.gray11()),
              ),
            ],
          ),
        ),
      ),
      actions: _actions,
      onSelected: (value) => _onSelected(context, value),
    ),
  );
}

/// The account menu as a lone avatar, supplied through the shell's
/// `collapsedAccount` slot so the collapsed rail keeps the account.
class FortalDashboardSidebarAccountRail extends StatelessWidget {
  const FortalDashboardSidebarAccountRail({super.key});

  @override
  Widget build(BuildContext context) => Box(
    style: BoxStyler()
        .alignment(.center)
        .padding(.symmetric(vertical: FortalTokens.space3())),
    child: FortalActionMenu(
      key: const ValueKey('sidebar-account-rail-trigger'),
      trigger: RemixMenuTrigger.control(
        builder: (_, menu) => FortalTooltip(
          positioning: OverlayPositionConfig(
            side: Directionality.of(context) == TextDirection.ltr
                ? .right
                : .left,
            alignment: .center,
            sideOffset: 8,
          ),
          tooltipChild: const StyledText('Leo Farias'),
          child: RemixIconButton(
            semanticLabel: 'Workspace account menu',
            style: _toolbarButtonStyle,
            focusNode: menu.focusNode,
            onPressed: menu.toggle,
            icon: null,
            iconBuilder: (_, _, _) =>
                const FortalAvatar(label: 'LF', size: .size2),
          ),
        ),
      ),
      actions: FortalDashboardSidebarAccount._actions,
      onSelected: (value) =>
          FortalDashboardSidebarAccount._onSelected(context, value),
    ),
  );
}

/// Application-owned toolbar actions supplied to the dashboard shell.
class FortalDashboardTopBar extends StatefulWidget {
  const FortalDashboardTopBar({super.key, this.activities = const []});

  /// The activities listed in the notifications menu.
  final List<RegistryDashboardActivity> activities;

  @override
  State<FortalDashboardTopBar> createState() => _FortalDashboardTopBarState();
}

class _FortalDashboardTopBarState extends State<FortalDashboardTopBar> {
  final _notificationsController = MenuController();
  final _themeController = MenuController();
  bool _notificationsRead = false;
  bool? _wasDark;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final dark = FortalTheme.of(context).isDark;
    // Appearance changes used to dismiss these by remounting the demo.
    // Keep that behavior while retaining the dashboard's page state.
    if (_wasDark != null && _wasDark != dark) {
      _themeController.close();
      _notificationsController.close();
    }
    _wasDark = dark;
  }

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
                                icon: RemixIcons.checkCircle,
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
                                    : FortalTokens.accentIndicator(),
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
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                RemixIconButton(
                  semanticLabel: 'Notifications',
                  style: _toolbarButtonStyle,
                  onPressed: _toggleNotifications,
                  icon: RemixIcons.bell,
                ),
                // Sits in the button's top-right corner, outside the glyph's
                // box, so the icon builder's clip cannot cut it.
                if (!_notificationsRead)
                  const PositionedDirectional(
                    end: 8,
                    top: 8,
                    child: ExcludeSemantics(
                      child: IgnorePointer(child: _FortalUnreadDot()),
                    ),
                  ),
              ],
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
            // The popover surface adds `space4` padding on each side; leave a
            // 16px margin to the viewport edges on narrow phones.
            style: BoxStyler()
                .width(
                  math.min(
                    400,
                    MediaQuery.sizeOf(context).width -
                        32 -
                        2 * FortalTokens.space4.resolve(context),
                  ),
                )
                .maxHeight(650),
            child: const SingleChildScrollView(child: FortalThemePanel()),
          ),
          child: RemixIconButton(
            key: const ValueKey('theme-panel-trigger'),
            semanticLabel: 'Theme settings',
            style: _toolbarButtonStyle,
            onPressed: _toggleTheme,
            icon: RemixIcons.sliders,
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
                icon: null,
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
                icon: RemixIcons.checkCircle,
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

class _FortalUnreadDot extends StatelessWidget {
  const _FortalUnreadDot();

  @override
  Widget build(BuildContext context) => Box(
    style: BoxStyler()
        .width(8)
        .height(8)
        .color(FortalTokens.accentIndicator())
        .borderRadius(.circular(4))
        .border(.all(.color(FortalTokens.colorPanelSolid()).width(1.5))),
  );
}

final _toolbarButtonStyle = fortalIconButtonStyle(variant: .ghost)
    .width(40)
    .height(40)
    .padding(.all(0))
    .margin(.all(0))
    .container(.alignment(.center));

/// Full dashboard demo.
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

  /// The brand mark in the sidebar header.
  final Widget brand;

  /// The account control in the sidebar footer. Defaults to a sample account
  /// menu when [builtInChrome] is on.
  final Widget? account;

  /// Actions shown in the header, after the built-in ones.
  final List<Widget> headerActions;

  /// Called with the header search text as it changes.
  final ValueChanged<String>? onSearchChanged;

  /// The records the pages display.
  final RegistryDashboardSampleData data;

  /// The page shown first.
  final RegistryDashboardDemoPage initialPage;

  /// The theme settings the demo starts with.
  final FortalThemeSettings initialSettings;

  /// Whether the sidebar is collapsed, when the caller controls it.
  final bool? collapsed;

  /// Whether the sidebar starts collapsed when [collapsed] is null.
  final bool initiallyCollapsed;

  /// Called when the user collapses or expands the sidebar.
  final ValueChanged<bool>? onCollapsedChanged;

  /// Whether to add the breadcrumb, search, appearance toggle, notifications,
  /// theme settings and sample account.
  final bool builtInChrome;

  /// The pause between the scripted steps of the chat page.
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
            headerTitle: widget.builtInChrome
                ? _FortalBreadcrumb(page: selectedValue)
                : null,
            brand: widget.brand,
            account:
                widget.account ??
                (widget.builtInChrome
                    ? const FortalDashboardSidebarAccount()
                    : null),
            collapsedAccount: widget.account == null && widget.builtInChrome
                ? const FortalDashboardSidebarAccountRail()
                : null,
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
    if (ambientScope != null) return demo;
    return FortalDashboardThemeScope(
      settings: _settings,
      onChanged: onSettingsChanged,
      child: _FortalDemoTheme(
        key: const ValueKey('dashboard-theme-scope'),
        mode: isDark ? FortalThemeMode.dark : FortalThemeMode.light,
        accent: _settings.accentColor,
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

class _FortalBreadcrumb extends StatelessWidget {
  const _FortalBreadcrumb({required this.page});
  final RegistryDashboardDemoPage page;

  @override
  Widget build(BuildContext context) => Padding(
    // The app bar insets its toolbar by `space4`; the page body uses the
    // wide page padding, so the difference lines the breadcrumb up with the
    // page title. In compact mode the menu button leads, so there is none.
    padding: EdgeInsetsDirectional.only(
      start: FortalSidebarLayoutScope.of(context).isCompact
          ? 0
          : fortalPagePadding(double.infinity).left -
                FortalTokens.space4.resolve(context),
    ),
    child: _breadcrumbRow(context),
  );

  Widget _breadcrumbRow(BuildContext context) => RowBox(
    style: FlexBoxStyler().crossAxisAlignment(.center).spacing(8),
    children: [
      Flexible(
        child: StyledText(
          page.section.label,
          style: dashboardText(
            .size2,
            tone: .muted,
          ).maxLines(1).softWrap(false).overflow(.ellipsis),
        ),
      ),
      Transform.flip(
        key: const ValueKey('dashboard-breadcrumb-separator'),
        flipX: Directionality.of(context) == TextDirection.rtl,
        child: StyledIcon(
          icon: RemixIcons.chevronRight,
          style: IconStyler().size(12).color(FortalTokens.gray11()),
        ),
      ),
      Flexible(
        child: StyledText(
          page.label,
          style: dashboardText(
            .size2,
          ).fontWeight(.w600).maxLines(1).softWrap(false).overflow(.ellipsis),
        ),
      ),
    ],
  );
}

/// Keeps the demo's theme, text and icon ancestors present in both appearances.
/// The ordinary theme conditionally inserts recoloring widgets under a host.
/// Reuse its resolved inherited scope via [InheritedTheme.wrap], which installs
/// the theme and Mix tokens without those conditional presentation wrappers.
/// The dashboard host supplies MediaQuery, as required by its shell.
class _FortalDemoTheme extends FortalTheme {
  const _FortalDemoTheme({
    super.key,
    super.mode,
    super.accent,
    super.panelBackground,
    super.radius,
    super.scaling,
    required super.child,
  });

  @override
  Widget build(BuildContext context) {
    final root = FortalTheme.maybeOf(context) == null;
    final scope = super.build(context) as InheritedTheme;
    return scope.wrap(
      context,
      Builder(
        builder: (context) {
          final theme = FortalTheme.of(context);
          final foreground = MixScope.tokenOf(FortalTokens.gray12, context);
          final body = root
              ? MixScope.tokenOf(
                  FortalTokens.text3,
                  context,
                ).copyWith(fontWeight: FontWeight.w400)
              : DefaultTextStyle.of(context).style;
          return ColoredBox(
            color: theme.hasBackground
                ? MixScope.tokenOf(FortalTokens.colorBackground, context)
                : const Color(0x00000000),
            child: DefaultTextStyle.merge(
              style: body.copyWith(color: foreground),
              child: IconTheme.merge(
                data: IconThemeData(color: foreground),
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
