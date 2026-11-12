import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../../dashboard/dashboard_demo_base.dart';
import '../../../dashboard/dashboard_demo_chat.dart';
import '../../../dashboard/dashboard_sample_data.dart';
import '../../components/avatar.dart';
import '../../components/button.dart';
import '../../components/divider.dart';
import '../../components/icon_button.dart';
import '../../components/menu.dart';
import '../../components/popover.dart';
import '../../components/segmented_control.dart';
import '../../components/toast.dart';
import '../activity_recipe.dart';
import '../answer_recipe.dart';
import '../composer_recipe.dart';
import '../execution_recipe.dart';
import '../message_recipe.dart';
import '../permission_recipe.dart';
import '../plan_recipe.dart';
import '../transcript_recipe.dart';
import '../../theme/effects.dart';
import '../../theme/tokens.dart';
import '../../theme/theme_data.dart';
import '../../theme/theme_scope.dart';
import 'dashboard_demo_records.dart';
import 'dashboard_demo_settings.dart';
import 'dashboard_overview.dart';
import 'dashboard_shell.dart';

/// Dashboard with Overview, Chat, Customers, Orders, and Settings.
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
  State<VanillaDashboardDemo> createState() => _VanillaDashboardDemoState();
}

class _VanillaDashboardDemoState extends State<VanillaDashboardDemo> {
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
    final ambient = VanillaTheme.maybeOf(context)?.brightness;
    if (_ambientBrightness != null && ambient != _ambientBrightness) {
      _dark = null;
    }
    _ambientBrightness = ambient;
  }

  bool get _isDark =>
      _dark ?? (VanillaTheme.maybeOf(context)?.brightness == Brightness.dark);

  /// [brightness]'s inherited values, or the preset default, with [radius].
  VanillaThemeData _themeWithRadius(Brightness brightness, double radius) {
    final themes = VanillaTheme.themesOf(context);
    final base = switch (brightness) {
      Brightness.light => themes?.light ?? const VanillaThemeData.light(),
      Brightness.dark => themes?.dark ?? const VanillaThemeData.dark(),
    };
    return base.copyWith(radius: Radius.circular(radius));
  }

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
        .customers => VanillaDashboardCustomersPage(globalQuery: query),
        .orders => VanillaDashboardOrdersPage(globalQuery: query),
        .settings => VanillaDashboardSettingsPage(
          darkMode: _dark,
          onDarkModeChanged: (value) => setState(() => _dark = value),
          onRadiusChanged: (value) => setState(() => _radius = value),
        ),
      },
    );
    final radius = _radius;
    return _VanillaDemoTheme(
      mode: _isDark ? VanillaThemeMode.dark : VanillaThemeMode.light,
      // One explicit half would be reused for the other brightness. Copy the
      // radius onto both so light and dark keep their own colors.
      theme: radius == null ? null : _themeWithRadius(Brightness.light, radius),
      darkTheme: radius == null
          ? null
          : _themeWithRadius(Brightness.dark, radius),
      child: Box(
        style: BoxStyler().color(VanillaTokens.background()),
        child: RemixToastScope(style: vanillaToastStyle(), child: demo),
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
    _VanillaHeaderPopover(
      dark: _isDark,
      icon: RemixIcons.bell,
      semanticLabel: 'Open notifications',
      showBadge: !_notificationsRead,
      popoverChild: Box(
        style: BoxStyler()
            .width(VanillaTokens.popoverWidth)
            .padding(.all(VanillaTokens.s4)),
        child: ColumnBox(
          style: FlexBoxStyler()
              .mainAxisSize(.min)
              .crossAxisAlignment(.stretch)
              .spacing(VanillaTokens.s2),
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
                  VanillaButton.ghost(
                    size: .small,
                    label: 'Mark all read',
                    onPressed: () => setState(() => _notificationsRead = true),
                  ),
              ],
            ),
            const VanillaDivider(),
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
    _VanillaHeaderPopover(
      dark: _isDark,
      icon: RemixIcons.gear,
      semanticLabel: 'Open theme settings',
      popoverChild: Box(
        style: BoxStyler()
            .width(VanillaTokens.popoverWidth)
            .padding(.all(VanillaTokens.s4)),
        child: ColumnBox(
          style: FlexBoxStyler()
              .mainAxisSize(.min)
              .crossAxisAlignment(.stretch)
              .spacing(VanillaTokens.s3),
          children: [
            StyledText(
              'Theme settings',
              style: _textStyle(
                token: VanillaTokens.textBase,
                weight: FontWeight.w600,
              ),
            ),
            VanillaSegmentedControl<bool>(
              semanticLabel: 'Theme appearance',
              selectedValue: _isDark,
              items: const [
                RemixSegmentedControlItem(value: false, label: 'Light'),
                RemixSegmentedControlItem(value: true, label: 'Dark'),
              ],
              onChanged: (value) => setState(() => _dark = value),
            ),
            const VanillaDivider(),
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
        .padding(.all(VanillaTokens.s2))
        .borderRadius(.all(VanillaTokens.radiusMd()))
        .color(unread ? VanillaTokens.secondary() : const Color(0x00000000)),
    child: ColumnBox(
      style: FlexBoxStyler()
          .mainAxisSize(.min)
          .crossAxisAlignment(.start)
          .spacing(VanillaTokens.s0_5),
      children: [
        StyledText(
          message,
          style: _textStyle(
            token: VanillaTokens.textXs,
            weight: unread ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
        StyledText(
          time,
          style: _textStyle(token: VanillaTokens.textXs, muted: true),
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
class _VanillaHeaderPopover extends StatefulWidget {
  const _VanillaHeaderPopover({
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
  State<_VanillaHeaderPopover> createState() => _VanillaHeaderPopoverState();
}

class _VanillaHeaderPopoverState extends State<_VanillaHeaderPopover> {
  final _controller = MenuController();
  final _focusNode = FocusNode();

  @override
  void didUpdateWidget(covariant _VanillaHeaderPopover oldWidget) {
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
  Widget build(BuildContext context) => VanillaPopover(
    controller: _controller,
    openOnTap: false,
    triggerFocusNode: _focusNode,
    popoverChild: widget.popoverChild,
    child: StackBox(
      style: StackBoxStyler().clipBehavior(.none),
      children: [
        VanillaIconButton.ghost(
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
                    .color(VanillaTokens.primary()),
              ),
            ),
          ),
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
  Widget build(BuildContext context) => RowBox(
    style: FlexBoxStyler()
        .crossAxisAlignment(.center)
        .spacing(VanillaTokens.s2),
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
          style: IconStyler().size(12).color(VanillaTokens.mutedForeground()),
        ),
      ),
      Flexible(
        child: StyledText(
          page.label,
          style: _textStyle(
            token: VanillaTokens.textBase,
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
  Widget build(BuildContext context) => VanillaMenu<String>(
    trigger: RemixMenuTrigger.builder(
      label: 'Ada Chen',
      icon: RemixIcons.user,
      builder: (context, _, _) => RemixCard(
        style: CardStyler()
            .padding(
              .symmetric(
                horizontal: VanillaTokens.s2_5,
                vertical: VanillaTokens.s2,
              ),
            )
            .borderRadius(.all(VanillaTokens.radiusMd()))
            .border(.all(.color(VanillaTokens.border())))
            .color(VanillaTokens.card())
            .onFocusVisible(
              CardStyler()
                  .containerEffects(vanillaFocusRing())
                  .border(vanillaFocusBorder()),
            ),
        child: RowBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.center)
              .spacing(VanillaTokens.s2_5),
          children: [
            const VanillaAvatar(label: 'AC'),
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
                      token: VanillaTokens.textXs,
                      muted: true,
                    ).maxLines(1).softWrap(false).overflow(.ellipsis),
                  ),
                ],
              ),
            ),
            StyledIcon(
              icon: RemixIcons.more,
              style: IconStyler()
                  .size(VanillaTokens.icon)
                  .color(VanillaTokens.mutedForeground()),
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
  TextStyleToken token = VanillaTokens.textSm,
  FontWeight weight = FontWeight.w400,
  bool muted = false,
}) => TextStyler()
    .style(token.mix())
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
    heading: _textStyle(token: VanillaTokens.text2xl, weight: FontWeight.w700),
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

/// Keeps the demo's theme, text and icon ancestors present in both appearances.
/// The ordinary theme conditionally inserts recoloring widgets under a host.
/// Reuse its resolved inherited scope via [InheritedTheme.wrap], which installs
/// the theme and Mix tokens without those conditional presentation wrappers.
/// The dashboard host supplies MediaQuery, as required by its shell.
class _VanillaDemoTheme extends VanillaTheme {
  const _VanillaDemoTheme({
    super.theme,
    super.darkTheme,
    super.mode,
    required super.child,
  });

  @override
  Widget build(BuildContext context) {
    final root = VanillaTheme.maybeOf(context) == null;
    final scope = super.build(context) as InheritedTheme;
    return scope.wrap(
      context,
      Builder(
        builder: (context) {
          final theme = VanillaTheme.of(context);
          final foreground = theme.foreground;
          final body = root
              ? MixScope.tokenOf(
                  VanillaTokens.textSm,
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
