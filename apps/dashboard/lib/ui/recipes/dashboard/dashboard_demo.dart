import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/sidebar_layout.dart';
import '../../components/tooltip.dart';
import '../agent_glyphs_recipe.dart';
import '../answer_recipe.dart';
import '../composer_recipe.dart';
import '../conversation_recipe.dart';
import '../message_recipe.dart';
import '../sources_recipe.dart';
import '../steps_recipe.dart';
import '../suggestions_recipe.dart';
import '../tool_call_recipe.dart';
import 'dashboard_demo_base.dart';
import 'dashboard_demo_chat.dart';
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

  static const _actions = [
    UiAction(value: 'profile', label: 'View profile'),
    UiAction(value: 'preferences', label: 'Preferences'),
    UiAction(value: 'signout', label: 'Sign out', dividerBefore: true),
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
      .symmetric(horizontal: UiTokens.space2(), vertical: UiTokens.space3()),
    ),
    child: UiActionMenu(
      key: const ValueKey('sidebar-account-trigger'),
      trigger: RemixMenuTrigger.builder(
        label: 'Workspace account menu',
        builder: (_, _, _) => RemixCard(
          style: CardStyler()
              .borderRadius(.all(UiTokens.radius2()))
              .onFocusVisible(CardStyler().containerEffects(uiFocusOutline())),
          child: RowBox(
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
                icon: RemixIcons.more,
                style: IconStyler().size(18).color(UiTokens.gray11()),
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
class UiDashboardSidebarAccountRail extends StatelessWidget {
  const UiDashboardSidebarAccountRail({super.key});

  @override
  Widget build(BuildContext context) => Box(
    style: BoxStyler()
        .alignment(.center)
        .padding(.symmetric(vertical: UiTokens.space3())),
    child: UiActionMenu(
      key: const ValueKey('sidebar-account-rail-trigger'),
      trigger: RemixMenuTrigger.control(
        builder: (_, menu) => UiTooltip(
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
            iconBuilder: (_, _, _) => const UiAvatar(label: 'LF', size: .size2),
          ),
        ),
      ),
      actions: UiDashboardSidebarAccount._actions,
      onSelected: (value) =>
          UiDashboardSidebarAccount._onSelected(context, value),
    ),
  );
}

/// Application-owned toolbar actions supplied to the dashboard shell.
class UiDashboardTopBar extends StatefulWidget {
  const UiDashboardTopBar({super.key, this.activities = const []});

  /// The activities listed in the notifications menu.
  final List<UiDashboardActivity> activities;

  @override
  State<UiDashboardTopBar> createState() => _UiDashboardTopBarState();
}

class _UiDashboardTopBarState extends State<UiDashboardTopBar> {
  final _notificationsController = MenuController();
  final _themeController = MenuController();
  bool _notificationsRead = false;
  bool? _wasDark;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final dark = UiTheme.of(context).isDark;
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
                                    ? UiTokens.gray6()
                                    : UiTokens.accentIndicator(),
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
                      child: IgnorePointer(child: _UiUnreadDot()),
                    ),
                  ),
              ],
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
            // The popover surface adds `space4` padding on each side; leave a
            // 16px margin to the viewport edges on narrow phones.
            style: BoxStyler()
                .width(
                  math.min(
                    400,
                    MediaQuery.sizeOf(context).width -
                        32 -
                        2 * UiTokens.space4.resolve(context),
                  ),
                )
                .maxHeight(650),
            child: const SingleChildScrollView(child: UiThemePanel()),
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
          UiActionMenu(
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
                    const UiAvatar(label: 'LF', size: .size2),
              ),
            ),
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

class _UiUnreadDot extends StatelessWidget {
  const _UiUnreadDot();

  @override
  Widget build(BuildContext context) => Box(
    style: BoxStyler()
        .width(8)
        .height(8)
        .color(UiTokens.accentIndicator())
        .borderRadius(.circular(4))
        .border(.all(.color(UiTokens.colorPanelSolid()).width(1.5))),
  );
}

final _toolbarButtonStyle = uiIconButtonStyle(variant: .ghost)
    .width(40)
    .height(40)
    .padding(.all(0))
    .margin(.all(0))
    .container(.alignment(.center));

/// Full dashboard demo.
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

  /// The brand mark in the sidebar header.
  final Widget brand;

  /// The account control in the sidebar footer. Defaults to a sample account
  /// menu when [builtInChrome] is on.
  final Widget? account;

  /// Actions shown in the header, after the built-in ones.
  final List<Widget> headerActions;

  /// Called with the header search text as it changes.
  final ValueChanged<String>? onSearchChanged;

  /// The metrics, revenue, records and activity the Overview page shows, and
  /// the activity the notifications menu lists. The Customers and Orders
  /// pages read their own lists.
  final UiDashboardSampleData data;

  /// The page shown first.
  final UiDashboardDemoPage initialPage;

  /// The theme settings the demo starts with.
  final UiThemeSettings initialSettings;

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
            headerTitle: widget.builtInChrome
                ? _UiBreadcrumb(page: selectedValue)
                : null,
            brand: widget.brand,
            account:
                widget.account ??
                (widget.builtInChrome
                    ? const UiDashboardSidebarAccount()
                    : null),
            collapsedAccount: widget.account == null && widget.builtInChrome
                ? const UiDashboardSidebarAccountRail()
                : null,
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
    if (ambientScope != null) return demo;
    return UiDashboardThemeScope(
      settings: _settings,
      onChanged: onSettingsChanged,
      child: _UiDemoTheme(
        key: const ValueKey('dashboard-theme-scope'),
        mode: isDark ? UiThemeMode.dark : UiThemeMode.light,
        accent: _settings.accentColor,
        panelBackground: _settings.panelBackground,
        radius: _settings.radius,
        scaling: _settings.scaling,
        child: RemixToastScope(style: uiToastStyle(), child: demo),
      ),
    );
  }
}

UiDashboardAgentStyles _uiAgentStyles() {
  final conversation = uiAgentConversationRecipe();
  final message = uiAgentMessageRecipe();
  final steps = uiAgentStepsRecipe();
  final toolCall = uiAgentToolCallRecipe();
  final answer = uiAgentAnswerRecipe();
  final sources = uiAgentSourcesRecipe();
  final suggestions = uiAgentSuggestionsRecipe();
  final composer = uiAgentComposerRecipe();
  return UiDashboardAgentStyles(
    buttonBuilder: (label, onPressed, tone) => switch (tone) {
      .primary => UiButton(label: label, onPressed: onPressed),
      .soft => UiButton.soft(label: label, onPressed: onPressed),
      .outline => UiButton.outline(label: label, onPressed: onPressed),
    },
    glyphBuilder: uiAgentGlyph,
    composerLeadingBuilder: (onPressed) => UiIconButton.outline(
      icon: RemixIcons.plus,
      semanticLabel: 'Add checkout context',
      onPressed: onPressed,
      style: IconButtonStyler()
          .wrap(WidgetModifierConfig.reset())
          .size(UiTokens.space6(), UiTokens.space6())
          .icon(.size(UiTokens.space4()).color(UiTokens.gray11()))
          .borderRadius(.circular(999)),
    ),
    heading: uiTextStyle(size: .size6, weight: .bold),
    body: uiTextStyle(size: .size1, highContrast: false),
    dockStyle: BoxStyler()
        .maxWidth(UiTokens.messageContentMaxWidth())
        .padding(.horizontal(UiTokens.space4())),
    conversationStyle: conversation.style,
    latestStyle: conversation.latestStyle,
    messageStyle: message.style,
    messageToggleStyle: message.toggleStyle,
    stepsStyle: steps.style,
    stepStyle: steps.stepStyle,
    stepsDisclosureStyle: steps.disclosureStyle,
    toolCallStyle: toolCall.style,
    toolCallDisclosureStyle: toolCall.disclosureStyle,
    toolInputStyle: toolCall.inputStyle,
    allowOnceStyle: toolCall.allowOnceStyle,
    alwaysAllowStyle: toolCall.alwaysAllowStyle,
    denyStyle: toolCall.denyStyle,
    answerStyle: answer.style,
    answerActionStyle: answer.actionStyle,
    sourcesStyle: sources.style,
    sourcesDisclosureStyle: sources.disclosureStyle,
    sourceStyle: sources.sourceStyle,
    suggestionsStyle: suggestions.style,
    suggestionStyle: suggestions.suggestionStyle,
    composerStyle: composer.style,
    composerFieldStyle: composer.fieldStyle,
    submitStyle: composer.submitStyle,
    stopStyle: composer.stopStyle,
  );
}

class _UiBreadcrumb extends StatelessWidget {
  const _UiBreadcrumb({required this.page});
  final UiDashboardDemoPage page;

  @override
  Widget build(BuildContext context) => Padding(
    // The app bar insets its toolbar by `space4`; the page body uses the
    // wide page padding, so the difference lines the breadcrumb up with the
    // page title. In compact mode the menu button leads, so there is none.
    padding: EdgeInsetsDirectional.only(
      start: UiSidebarLayoutScope.of(context).isCompact
          ? 0
          : uiPagePadding(double.infinity).left -
                UiTokens.space4.resolve(context),
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
          style: IconStyler().size(12).color(UiTokens.gray11()),
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
class _UiDemoTheme extends UiTheme {
  const _UiDemoTheme({
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
    final root = UiTheme.maybeOf(context) == null;
    final scope = super.build(context) as InheritedTheme;
    return scope.wrap(
      context,
      Builder(
        builder: (context) {
          final theme = UiTheme.of(context);
          final foreground = MixScope.tokenOf(UiTokens.gray12, context);
          final body = root
              ? MixScope.tokenOf(
                  UiTokens.text3,
                  context,
                ).copyWith(fontWeight: FontWeight.w400)
              : DefaultTextStyle.of(context).style;
          return ColoredBox(
            color: theme.hasBackground
                ? MixScope.tokenOf(UiTokens.colorBackground, context)
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
