import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/avatar.dart';
import '../../components/button.dart';
import '../../components/divider.dart';
import '../../components/icon_button.dart';
import '../../components/menu.dart';
import '../../components/popover.dart';
import '../../components/segmented_control.dart';
import '../../components/toast.dart';
import '../../theme/effects.dart';
import '../../theme/theme_data.dart';
import '../../theme/theme_scope.dart';
import '../../theme/tokens.dart';
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
import 'dashboard_demo_records_page.dart';
import 'dashboard_demo_settings.dart';
import 'dashboard_overview.dart';
import 'dashboard_sample_data.dart';
import 'dashboard_shell.dart';

/// Dashboard with Overview, Chat, Customers, Orders, and Settings.
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
  final PlaygroundDashboardSampleData data;

  /// The page shown first.
  final PlaygroundDashboardDemoPage initialPage;

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
  State<PlaygroundDashboardDemo> createState() =>
      _PlaygroundDashboardDemoState();
}

class _PlaygroundDashboardDemoState extends State<PlaygroundDashboardDemo> {
  /// The appearance the toggle chose, or null to follow the scope this demo
  /// is placed in.
  bool? _dark;

  /// Base corner radius chosen from Settings, or null to keep the inherited
  /// theme's radius.
  double? _radius;

  /// The enclosing theme's brightness when last read. When it changes, the
  /// toggle's choice is dropped.
  Brightness? _ambientBrightness;

  bool _notificationsRead = false;

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

  /// [brightness]'s inherited values, or the preset default, with [radius].
  PlaygroundThemeData _themeWithRadius(Brightness brightness, double radius) {
    final themes = PlaygroundTheme.themesOf(context);
    final base = switch (brightness) {
      Brightness.light => themes?.light ?? const PlaygroundThemeData.light(),
      Brightness.dark => themes?.dark ?? const PlaygroundThemeData.dark(),
    };
    return base.copyWith(radius: Radius.circular(radius));
  }

  @override
  Widget build(BuildContext context) {
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
          onRadiusChanged: (value) => setState(() => _radius = value),
        ),
      },
    );
    final radius = _radius;
    return _PlaygroundDemoTheme(
      mode: _isDark ? PlaygroundThemeMode.dark : PlaygroundThemeMode.light,
      // One explicit half would be reused for the other brightness. Copy the
      // radius onto both so light and dark keep their own colors.
      theme: radius == null ? null : _themeWithRadius(Brightness.light, radius),
      darkTheme: radius == null
          ? null
          : _themeWithRadius(Brightness.dark, radius),
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
    _PlaygroundHeaderPopover(
      dark: _isDark,
      icon: RemixIcons.bell,
      semanticLabel: 'Open notifications',
      showBadge: !_notificationsRead,
      popoverChild: Box(
        style: BoxStyler()
            .width(PlaygroundTokens.popoverWidth)
            .padding(.all(PlaygroundTokens.s4)),
        child: ColumnBox(
          style: FlexBoxStyler()
              .mainAxisSize(.min)
              .crossAxisAlignment(.stretch)
              .spacing(PlaygroundTokens.s2),
          children: [
            RowBox(
              style: FlexBoxStyler()
                  .mainAxisAlignment(.spaceBetween)
                  .crossAxisAlignment(.center),
              children: [
                Flexible(
                  child: StyledText(
                    'Notifications',
                    style: _textStyle(weight: FontWeight.w600),
                  ),
                ),
                if (!_notificationsRead)
                  PlaygroundButton.ghost(
                    size: .small,
                    label: 'Mark all read',
                    onPressed: () => setState(() => _notificationsRead = true),
                  ),
              ],
            ),
            const PlaygroundDivider(),
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
    _PlaygroundHeaderPopover(
      dark: _isDark,
      icon: RemixIcons.gear,
      semanticLabel: 'Open theme settings',
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
            PlaygroundSegmentedControl<bool>(
              semanticLabel: 'Theme appearance',
              selectedValue: _isDark,
              items: const [
                RemixSegmentedControlItem(value: false, label: 'Light'),
                RemixSegmentedControlItem(value: true, label: 'Dark'),
              ],
              onChanged: (value) => setState(() => _dark = value),
            ),
            const PlaygroundDivider(),
            _settingLine('Appearance', _isDark ? 'Dark' : 'Light'),
          ],
        ),
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

  Widget _notificationItem(
    String message,
    String time, {
    required bool unread,
  }) => Box(
    style: BoxStyler()
        .padding(.all(PlaygroundTokens.s2))
        .borderRadius(.all(PlaygroundTokens.radiusMd()))
        .color(unread ? PlaygroundTokens.secondary() : const Color(0x00000000)),
    child: ColumnBox(
      style: FlexBoxStyler()
          .mainAxisSize(.min)
          .crossAxisAlignment(.start)
          .spacing(PlaygroundTokens.s0_5),
      children: [
        StyledText(
          message,
          style: _textStyle(
            token: PlaygroundTokens.textXs,
            weight: unread ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
        StyledText(
          time,
          style: _textStyle(token: PlaygroundTokens.textXs, muted: true),
        ),
      ],
    ),
  );
}

/// A header icon button that opens a popover.
///
/// The button owns activation (`openOnTap: false`), so the popover adds no
/// focus stop of its own, and the one node shared with `triggerFocusNode` is
/// what closing returns focus to.
class _PlaygroundHeaderPopover extends StatefulWidget {
  const _PlaygroundHeaderPopover({
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
  State<_PlaygroundHeaderPopover> createState() =>
      _PlaygroundHeaderPopoverState();
}

class _PlaygroundHeaderPopoverState extends State<_PlaygroundHeaderPopover> {
  final _controller = MenuController();
  final _focusNode = FocusNode();

  @override
  void didUpdateWidget(covariant _PlaygroundHeaderPopover oldWidget) {
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
  Widget build(BuildContext context) => PlaygroundPopover(
    controller: _controller,
    openOnTap: false,
    triggerFocusNode: _focusNode,
    popoverChild: widget.popoverChild,
    child: StackBox(
      style: StackBoxStyler().clipBehavior(.none),
      children: [
        PlaygroundIconButton.ghost(
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
                    .size(7, 7)
                    .borderRadius(.circular(99))
                    .color(PlaygroundTokens.primary()),
              ),
            ),
          ),
      ],
    ),
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
      Transform.flip(
        key: const ValueKey('dashboard-breadcrumb-separator'),
        flipX: Directionality.of(context) == TextDirection.rtl,
        child: StyledIcon(
          icon: RemixIcons.chevronRight,
          style: IconStyler()
              .size(12)
              .color(PlaygroundTokens.mutedForeground()),
        ),
      ),
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
  Widget build(BuildContext context) => PlaygroundMenu<String>(
    trigger: RemixMenuTrigger.builder(
      label: 'Ada Chen',
      icon: RemixIcons.user,
      builder: (context, _, _) => RemixCard(
        style: CardStyler()
            .padding(
              .symmetric(
                horizontal: PlaygroundTokens.s2_5,
                vertical: PlaygroundTokens.s2,
              ),
            )
            .borderRadius(.all(PlaygroundTokens.radiusMd()))
            .border(.all(.color(PlaygroundTokens.border())))
            .color(PlaygroundTokens.card())
            .onFocusVisible(
              CardStyler()
                  .containerEffects(playgroundFocusRing())
                  .border(playgroundFocusBorder()),
            ),
        child: RowBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.center)
              .spacing(PlaygroundTokens.s2_5),
          children: [
            const PlaygroundAvatar(label: 'AC'),
            Expanded(
              child: ColumnBox(
                style: FlexBoxStyler()
                    .mainAxisSize(.min)
                    .crossAxisAlignment(.start),
                children: [
                  StyledText(
                    'Ada Chen',
                    style: _textStyle(
                      weight: FontWeight.w500,
                    ).maxLines(1).softWrap(false).overflow(.ellipsis),
                  ),
                  StyledText(
                    'Northstar workspace',
                    style: _textStyle(
                      token: PlaygroundTokens.textXs,
                      muted: true,
                    ).maxLines(1).softWrap(false).overflow(.ellipsis),
                  ),
                ],
              ),
            ),
            StyledIcon(
              icon: RemixIcons.more,
              style: IconStyler()
                  .size(PlaygroundTokens.icon)
                  .color(PlaygroundTokens.mutedForeground()),
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

/// The demo's text: [token] at [weight], in the muted or foreground color.
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
  final conversation = playgroundAgentConversationRecipe();
  final message = playgroundAgentMessageRecipe();
  final steps = playgroundAgentStepsRecipe();
  final toolCall = playgroundAgentToolCallRecipe();
  final answer = playgroundAgentAnswerRecipe();
  final sources = playgroundAgentSourcesRecipe();
  final suggestions = playgroundAgentSuggestionsRecipe();
  final composer = playgroundAgentComposerRecipe();
  return PlaygroundDashboardAgentStyles(
    buttonBuilder: (label, onPressed, tone) => switch (tone) {
      .primary => PlaygroundButton(label: label, onPressed: onPressed),
      .soft => PlaygroundButton.secondary(label: label, onPressed: onPressed),
      .outline => PlaygroundButton.outline(label: label, onPressed: onPressed),
    },
    glyphBuilder: playgroundAgentGlyph,
    toolIconBuilder: playgroundAgentToolIcon,
    composerLeadingBuilder: (onPressed) => PlaygroundIconButton.outline(
      icon: RemixIcons.plus,
      semanticLabel: 'Add checkout context',
      onPressed: onPressed,
      style: IconButtonStyler().borderRadius(.circular(999)),
    ),
    heading: _textStyle(
      token: PlaygroundTokens.text2xl,
      weight: FontWeight.w700,
    ),
    body: _textStyle(muted: true),
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
    answerBodyStyle: FlexBoxStyler()
        .crossAxisAlignment(.stretch)
        .spacing(PlaygroundTokens.s3),
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
class _PlaygroundDemoTheme extends PlaygroundTheme {
  const _PlaygroundDemoTheme({
    super.theme,
    super.darkTheme,
    super.mode,
    required super.child,
  });

  @override
  Widget build(BuildContext context) {
    final root = PlaygroundTheme.maybeOf(context) == null;
    final scope = super.build(context) as InheritedTheme;
    return scope.wrap(
      context,
      Builder(
        builder: (context) {
          final theme = PlaygroundTheme.of(context);
          final foreground = theme.foreground;
          final body = root
              ? MixScope.tokenOf(
                  PlaygroundTokens.textSm,
                  context,
                ).copyWith(fontWeight: FontWeight.w400)
              : DefaultTextStyle.of(context).style;
          return ColoredBox(
            color: theme.background,
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
