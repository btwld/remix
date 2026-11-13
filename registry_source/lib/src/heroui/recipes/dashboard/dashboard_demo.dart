import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../../dashboard/dashboard_demo_base.dart';
import '../../../dashboard/dashboard_demo_chat.dart';
import '../../../dashboard/dashboard_sample_data.dart';
import '../../components/avatar.dart';
import '../../components/button.dart';
import '../../components/dropdown.dart';
import '../../components/popover.dart';
import '../../components/separator.dart';
import '../../components/toast.dart';
import '../agent_glyphs_recipe.dart';
import '../answer_recipe.dart';
import '../composer_recipe.dart';
import '../conversation_recipe.dart';
import '../message_recipe.dart';
import '../sources_recipe.dart';
import '../steps_recipe.dart';
import '../suggestions_recipe.dart';
import '../tool_call_recipe.dart';
import '../../theme/theme.dart';
import 'dashboard_demo_records.dart';
import 'dashboard_demo_settings.dart';
import 'dashboard_demo_text.dart';
import 'dashboard_overview.dart';
import 'dashboard_shell.dart';

/// Dashboard with Overview, Chat, Customers, Orders, and Settings.
///
/// An extension: HeroUI web 3.2.6 has no dashboard. The pages, sample data,
/// navigation and behavior are the other presets'; only the components are
/// HeroUI's.
class HeroUiDashboardDemo extends StatefulWidget {
  const HeroUiDashboardDemo({
    super.key,
    this.brand = const _HeroUiBrand(),
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

  /// The brand mark in the sidebar header.
  final Widget brand;

  /// The account control in the sidebar footer. Defaults to a sample account
  /// menu when [builtInChrome] is on.
  final Widget? account;

  /// Actions shown in the header, after the built-in ones.
  final List<Widget> headerActions;

  /// Called with the header search text as it changes.
  final ValueChanged<String>? onSearchChanged;

  /// The metrics, revenue, records and activity the Overview page shows. The
  /// Customers and Orders pages read their own lists.
  final RegistryDashboardSampleData data;

  /// The page shown first.
  final RegistryDashboardDemoPage initialPage;

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
  State<HeroUiDashboardDemo> createState() => _HeroUiDashboardDemoState();
}

class _HeroUiDashboardDemoState extends State<HeroUiDashboardDemo> {
  /// The appearance the toggle chose, or null to follow the scope this demo
  /// is placed in.
  bool? _dark;

  /// Base radius (`--radius`) chosen from Settings, or null to keep the
  /// inherited theme's radius.
  double? _radius;
  Brightness? _ambientBrightness;
  bool _notificationsRead = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ambient = HeroUiTheme.maybeOf(context)?.brightness;
    if (_ambientBrightness != null && ambient != _ambientBrightness) {
      _dark = null;
    }
    _ambientBrightness = ambient;
  }

  bool get _isDark =>
      _dark ?? (HeroUiTheme.maybeOf(context)?.brightness == Brightness.dark);

  @override
  Widget build(BuildContext context) {
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
          }) => HeroUiDashboardShell<RegistryDashboardDemoPage>(
            sections: sections,
            selectedValue: selectedValue,
            onSelected: onSelected,
            body: body,
            title: title,
            headerTitle: widget.builtInChrome
                ? _HeroUiBreadcrumb(page: selectedValue)
                : null,
            brand: widget.brand,
            account:
                widget.account ??
                (widget.builtInChrome ? const _HeroUiAccount() : null),
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
        .overview => HeroUiDashboardOverview(
          data: widget.data,
          onViewOrders: () => onSelected(RegistryDashboardDemoPage.orders),
        ),
        .chat => RegistryDashboardChatPage(
          styles: _heroUiAgentStyles(),
          stepDelay: widget.chatStepDelay,
        ),
        .customers => HeroUiDashboardCustomersPage(globalQuery: query),
        .orders => HeroUiDashboardOrdersPage(globalQuery: query),
        .settings => HeroUiDashboardSettingsPage(
          darkMode: _dark,
          onDarkModeChanged: (value) => setState(() => _dark = value),
          onRadiusChanged: (value) => setState(() => _radius = value),
        ),
      },
    );
    return _HeroUiDemoTheme(
      dark: _isDark,
      radius: _radius,
      child: Box(
        style: BoxStyler().color(HeroUiTokens.background()),
        child: RemixToastScope(style: heroUiToastStyle(), child: demo),
      ),
    );
  }

  List<Widget> _chromeActions() => [
    HeroUiIconButton.ghost(
      key: const ValueKey('dashboard-appearance-toggle'),
      icon: _isDark ? RemixIcons.sun : RemixIcons.moon,
      semanticLabel: _isDark ? 'Use light appearance' : 'Use dark appearance',
      onPressed: () => setState(() => _dark = !_isDark),
    ),
    _HeroUiHeaderPopover(
      dark: _isDark,
      icon: RemixIcons.bell,
      semanticLabel: 'Open notifications',
      showBadge: !_notificationsRead,
      popoverChild: Box(
        style: BoxStyler().width(_popoverWidth),
        child: ColumnBox(
          style: FlexBoxStyler()
              .mainAxisSize(.min)
              .crossAxisAlignment(.stretch)
              .spacing(8),
          children: [
            RowBox(
              style: FlexBoxStyler()
                  .mainAxisAlignment(.spaceBetween)
                  .crossAxisAlignment(.center),
              children: [
                const Flexible(
                  child: HeroUiDashboardText('Notifications', emphasized: true),
                ),
                if (!_notificationsRead)
                  HeroUiButton.ghost(
                    size: .sm,
                    label: 'Mark all read',
                    onPressed: () => setState(() => _notificationsRead = true),
                  ),
              ],
            ),
            const HeroUiSeparator(),
            _notificationItem(
              'Order ORD-1047 requires review.',
              '14m ago',
              unread: !_notificationsRead,
            ),
            _notificationItem(
              'Three customer invitations are pending.',
              '1h ago',
              unread: !_notificationsRead,
            ),
            _notificationItem(
              'Payout batch #29 was settled.',
              '3h ago',
              unread: false,
            ),
          ],
        ),
      ),
    ),
    _HeroUiHeaderPopover(
      dark: _isDark,
      icon: RemixIcons.gear,
      semanticLabel: 'Open theme settings',
      popoverChild: Box(
        style: BoxStyler().width(_popoverWidth),
        child: ColumnBox(
          style: FlexBoxStyler()
              .mainAxisSize(.min)
              .crossAxisAlignment(.stretch)
              .spacing(12),
          children: [
            const HeroUiDashboardText('Theme settings', type: .h6),
            HeroUiDashboardSegments<bool>(
              semanticLabel: 'Theme appearance',
              selectedValue: _isDark,
              items: const [
                (value: false, label: 'Light'),
                (value: true, label: 'Dark'),
              ],
              onChanged: (value) => setState(() => _dark = value),
            ),
            const HeroUiSeparator(),
            _settingLine('Appearance', _isDark ? 'Dark' : 'Light'),
          ],
        ),
      ),
    ),
  ];

  Widget _settingLine(String label, String value) => RowBox(
    style: FlexBoxStyler().crossAxisAlignment(.center),
    children: [
      Expanded(child: HeroUiDashboardText(label)),
      HeroUiDashboardText(value, muted: true),
    ],
  );

  Widget _notificationItem(
    String message,
    String time, {
    required bool unread,
  }) => Box(
    style: BoxStyler()
        .padding(.all(8))
        .borderRadius(.all(HeroUiTokens.radiusXl()))
        .color(unread ? HeroUiTokens.defaultColor() : HeroUiTokens.transparent),
    child: ColumnBox(
      style: FlexBoxStyler()
          .mainAxisSize(.min)
          .crossAxisAlignment(.start)
          .spacing(2),
      children: [
        HeroUiDashboardText(message, type: .bodyXs, emphasized: unread),
        HeroUiDashboardText(time, type: .bodyXs, muted: true),
      ],
    ),
  );
}

/// The popover's content width.
const _popoverWidth = 288.0;

/// Selects the demo's appearance and radius under the theme it is placed in.
///
/// HeroUI exposes only the selected theme, so two probe scopes read the
/// host's light and dark themes; the radius from Settings is copied onto
/// both, so each brightness keeps its own colors. The probes are always
/// present below a host theme, so moving the slider never rebuilds the pages
/// under a different parent.
class _HeroUiDemoTheme extends StatelessWidget {
  const _HeroUiDemoTheme({
    required this.dark,
    required this.radius,
    required this.child,
  });

  final bool dark;
  final double? radius;
  final Widget child;

  HeroUiThemeMode get _mode =>
      dark ? HeroUiThemeMode.dark : HeroUiThemeMode.light;

  @override
  Widget build(BuildContext context) {
    final radius = this.radius;
    if (HeroUiTheme.maybeOf(context) == null) {
      return _HeroUiStableDemoTheme(
        mode: _mode,
        theme: radius == null ? null : HeroUiThemeData.light(radius: radius),
        darkTheme: radius == null ? null : HeroUiThemeData.dark(radius: radius),
        child: child,
      );
    }
    return HeroUiTheme(
      mode: HeroUiThemeMode.light,
      child: Builder(
        builder: (lightContext) {
          final light = HeroUiTheme.of(lightContext);
          return HeroUiTheme(
            mode: HeroUiThemeMode.dark,
            child: Builder(
              builder: (darkContext) {
                final dark = HeroUiTheme.of(darkContext);
                return _HeroUiStableDemoTheme(
                  mode: _mode,
                  theme: radius == null ? null : light.copyWith(radius: radius),
                  darkTheme: radius == null
                      ? null
                      : dark.copyWith(radius: radius),
                  child: child,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// A header icon button that opens a popover.
///
/// The button owns activation (`openOnTap: false`), so the popover adds no
/// focus stop of its own, and the one node shared with `triggerFocusNode` is
/// what closing returns focus to.
class _HeroUiHeaderPopover extends StatefulWidget {
  const _HeroUiHeaderPopover({
    required this.dark,
    required this.icon,
    required this.semanticLabel,
    required this.popoverChild,
    this.showBadge = false,
  });

  final bool dark;
  final IconData icon;
  final String semanticLabel;
  final Widget popoverChild;
  final bool showBadge;

  @override
  State<_HeroUiHeaderPopover> createState() => _HeroUiHeaderPopoverState();
}

class _HeroUiHeaderPopoverState extends State<_HeroUiHeaderPopover> {
  final _controller = MenuController();
  final _focusNode = FocusNode();

  @override
  void didUpdateWidget(covariant _HeroUiHeaderPopover oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Appearance changes used to dismiss the popover by remounting the demo.
    // Keep that behavior while retaining the dashboard's page state.
    if (widget.dark != oldWidget.dark) _controller.close();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HeroUiPopover(
    controller: _controller,
    openOnTap: false,
    triggerFocusNode: _focusNode,
    popoverChild: widget.popoverChild,
    child: StackBox(
      style: StackBoxStyler().clipBehavior(.none),
      children: [
        HeroUiIconButton.ghost(
          icon: widget.icon,
          semanticLabel: widget.semanticLabel,
          focusNode: _focusNode,
          onPressed: () =>
              _controller.isOpen ? _controller.close() : _controller.open(),
        ),
        if (widget.showBadge)
          Positioned(
            right: 8,
            top: 8,
            child: IgnorePointer(
              child: Box(
                style: BoxStyler()
                    .size(8, 8)
                    .borderRadius(.circular(99))
                    .color(HeroUiTokens.accent())
                    .border(.all(.color(HeroUiTokens.background()).width(1.5))),
              ),
            ),
          ),
      ],
    ),
  );
}

class _HeroUiBrand extends StatelessWidget {
  const _HeroUiBrand();

  @override
  Widget build(BuildContext context) => StyledText(
    'Northstar',
    style: heroUiDashboardTextStyle(
      emphasized: true,
    ).fontWeight(.w600).maxLines(1).softWrap(false).overflow(.ellipsis),
  );
}

class _HeroUiBreadcrumb extends StatelessWidget {
  const _HeroUiBreadcrumb({required this.page});
  final RegistryDashboardDemoPage page;

  @override
  Widget build(BuildContext context) => RowBox(
    style: FlexBoxStyler().crossAxisAlignment(.center).spacing(8),
    children: [
      Flexible(
        child: StyledText(
          page.section.label,
          style: heroUiDashboardTextStyle(
            muted: true,
          ).maxLines(1).softWrap(false).overflow(.ellipsis),
        ),
      ),
      Transform.flip(
        key: const ValueKey('dashboard-breadcrumb-separator'),
        flipX: Directionality.of(context) == TextDirection.rtl,
        child: StyledIcon(
          icon: RemixIcons.chevronRight,
          style: IconStyler().size(12).color(HeroUiTokens.muted()),
        ),
      ),
      Flexible(
        child: StyledText(
          page.label,
          style: heroUiDashboardTextStyle(
            type: .h6,
          ).maxLines(1).softWrap(false).overflow(.ellipsis),
        ),
      ),
    ],
  );
}

class _HeroUiAccount extends StatelessWidget {
  const _HeroUiAccount();

  @override
  Widget build(BuildContext context) => HeroUiDropdown<String>(
    trigger: RemixMenuTrigger.builder(
      label: 'Ada Chen',
      icon: RemixIcons.user,
      builder: (context, _, _) => RemixCard(
        style: CardStyler()
            .padding(.symmetric(horizontal: 8, vertical: 8))
            .borderRadius(.all(HeroUiTokens.radius2xl()))
            .color(HeroUiTokens.transparent)
            .onHovered(CardStyler().color(HeroUiTokens.defaultColor()))
            .onFocusVisible(
              CardStyler().containerEffects(heroUiInsetFocusRing),
            ),
        child: RowBox(
          style: FlexBoxStyler().crossAxisAlignment(.center).spacing(10),
          children: [
            const HeroUiAvatar.soft(label: 'AC', color: .accent, size: .sm),
            Expanded(
              child: ColumnBox(
                style: FlexBoxStyler()
                    .mainAxisSize(.min)
                    .crossAxisAlignment(.start),
                children: [
                  StyledText(
                    'Ada Chen',
                    style: heroUiDashboardTextStyle(
                      emphasized: true,
                    ).maxLines(1).softWrap(false).overflow(.ellipsis),
                  ),
                  StyledText(
                    'Northstar workspace',
                    style: heroUiDashboardTextStyle(
                      type: .bodyXs,
                      muted: true,
                    ).maxLines(1).softWrap(false).overflow(.ellipsis),
                  ),
                ],
              ),
            ),
            StyledIcon(
              icon: RemixIcons.more,
              style: IconStyler().size(16).color(HeroUiTokens.muted()),
            ),
          ],
        ),
      ),
    ),
    items: const [
      RemixMenuItem(value: 'account', label: 'Account settings'),
      RemixMenuItem(value: 'workspace', label: 'Switch workspace'),
      RemixMenuDivider(),
      RemixMenuItem(value: 'sign-out', label: 'Sign out'),
    ],
    onSelected: (value) =>
        showRemixToast(context, RemixToastData(title: '$value selected')),
  );
}

RegistryDashboardAgentStyles _heroUiAgentStyles() {
  final conversation = heroUiAgentConversationRecipe();
  final message = heroUiAgentMessageRecipe();
  final steps = heroUiAgentStepsRecipe();
  final toolCall = heroUiAgentToolCallRecipe();
  final answer = heroUiAgentAnswerRecipe();
  final sources = heroUiAgentSourcesRecipe();
  final suggestions = heroUiAgentSuggestionsRecipe();
  final composer = heroUiAgentComposerRecipe();
  return RegistryDashboardAgentStyles(
    buttonBuilder: (label, onPressed, tone) => switch (tone) {
      .primary => HeroUiButton(label: label, onPressed: onPressed),
      .soft => HeroUiButton.secondary(label: label, onPressed: onPressed),
      .outline => HeroUiButton.outline(label: label, onPressed: onPressed),
    },
    glyphBuilder: heroUiAgentGlyph,
    toolIconBuilder: heroUiAgentToolIcon,
    composerLeadingBuilder: (onPressed) => HeroUiIconButton.outline(
      icon: RemixIcons.plus,
      semanticLabel: 'Add checkout context',
      onPressed: onPressed,
      style: IconButtonStyler().borderRadius(.circular(999)),
    ),
    heading: heroUiDashboardTextStyle(type: .h3),
    body: heroUiDashboardTextStyle(muted: true),
    dockStyle: BoxStyler().maxWidth(768).padding(.horizontal(16)),
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
    answerBodyStyle: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(12),
    answerActionStyle: answer.actionStyle,
    answerSelectedActionStyle: answer.selectedActionStyle,
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

/// Keeps the demo's theme, text and icon ancestors present in both appearances.
/// The ordinary theme conditionally inserts recoloring widgets under a host.
/// Reuse its resolved inherited scope via [InheritedTheme.wrap], which installs
/// the theme and Mix tokens without those conditional presentation wrappers.
/// The dashboard host supplies MediaQuery, as required by its shell.
class _HeroUiStableDemoTheme extends HeroUiTheme {
  const _HeroUiStableDemoTheme({
    super.theme,
    super.darkTheme,
    super.mode,
    required super.child,
  });

  @override
  Widget build(BuildContext context) {
    final root = HeroUiTheme.maybeOf(context) == null;
    final scope = super.build(context) as InheritedTheme;
    return scope.wrap(
      context,
      Builder(
        builder: (context) {
          final theme = HeroUiTheme.of(context);
          final foreground = theme.color(HeroUiTokens.foreground);
          final body = root
              ? MixScope.tokenOf(
                  HeroUiTokens.textBase,
                  context,
                ).copyWith(fontWeight: FontWeight.w400)
              : DefaultTextStyle.of(context).style;
          return ColoredBox(
            color: theme.color(HeroUiTokens.background),
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
