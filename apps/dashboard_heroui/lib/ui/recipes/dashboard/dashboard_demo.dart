import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/avatar.dart';
import '../../components/button.dart';
import '../../components/dropdown.dart';
import '../../components/popover.dart';
import '../../components/separator.dart';
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
import 'dashboard_demo_base.dart';
import 'dashboard_demo_chat.dart';
import 'dashboard_demo_records_page.dart';
import 'dashboard_demo_settings.dart';
import 'dashboard_demo_text.dart';
import 'dashboard_overview.dart';
import 'dashboard_sample_data.dart';
import 'dashboard_shell.dart';

/// Dashboard with Overview, Chat, Customers, Orders, and Settings.
///
/// An extension: HeroUI web 3.2.6 has no dashboard. The pages, sample data,
/// navigation and behavior are the other presets'; only the components are
/// HeroUI's.
class UiDashboardDemo extends StatefulWidget {
  const UiDashboardDemo({
    super.key,
    this.brand = const _UiBrand(),
    this.account,
    this.headerActions = const [],
    this.onSearchChanged,
    this.data = uiDashboardSampleData,
    this.initialPage = UiDashboardDemoPage.overview,
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
  final bool? collapsed;
  final bool initiallyCollapsed;
  final ValueChanged<bool>? onCollapsedChanged;
  final bool builtInChrome;
  final Duration chatStepDelay;

  @override
  State<UiDashboardDemo> createState() => _UiDashboardDemoState();
}

class _UiDashboardDemoState extends State<UiDashboardDemo> {
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
    final ambient = UiTheme.maybeOf(context)?.brightness;
    if (_ambientBrightness != null && ambient != _ambientBrightness) {
      _dark = null;
    }
    _ambientBrightness = ambient;
  }

  bool get _isDark =>
      _dark ?? (UiTheme.maybeOf(context)?.brightness == Brightness.dark);

  @override
  Widget build(BuildContext context) {
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
                (widget.builtInChrome ? const _UiAccount() : null),
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
          darkMode: _dark,
          onDarkModeChanged: (value) => setState(() => _dark = value),
          onRadiusChanged: (value) => setState(() => _radius = value),
        ),
      },
    );
    if (!widget.builtInChrome) return demo;
    return _UiDemoTheme(
      dark: _isDark,
      radius: _radius,
      child: Box(
        style: BoxStyler().color(UiTokens.background()),
        child: RemixToastScope(style: uiToastStyle(), child: demo),
      ),
    );
  }

  List<Widget> _chromeActions() => [
    UiIconButton.ghost(
      key: const ValueKey('dashboard-appearance-toggle'),
      icon: _isDark ? RemixIcons.sun : RemixIcons.moon,
      semanticLabel: _isDark ? 'Use light appearance' : 'Use dark appearance',
      onPressed: () => setState(() => _dark = !_isDark),
    ),
    _UiHeaderPopover(
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
                  child: UiDashboardText('Notifications', emphasized: true),
                ),
                if (!_notificationsRead)
                  UiButton.ghost(
                    size: .sm,
                    label: 'Mark all read',
                    onPressed: () => setState(() => _notificationsRead = true),
                  ),
              ],
            ),
            const UiSeparator(),
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
    _UiHeaderPopover(
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
            const UiDashboardText('Theme settings', type: .h6),
            UiDashboardSegments<bool>(
              semanticLabel: 'Theme appearance',
              selectedValue: _isDark,
              items: const [
                (value: false, label: 'Light'),
                (value: true, label: 'Dark'),
              ],
              onChanged: (value) => setState(() => _dark = value),
            ),
            const UiSeparator(),
            _settingLine('Appearance', _isDark ? 'Dark' : 'Light'),
          ],
        ),
      ),
    ),
  ];

  Widget _settingLine(String label, String value) => RowBox(
    style: FlexBoxStyler().crossAxisAlignment(.center),
    children: [
      Expanded(child: UiDashboardText(label)),
      UiDashboardText(value, muted: true),
    ],
  );

  Widget _notificationItem(
    String message,
    String time, {
    required bool unread,
  }) => Box(
    style: BoxStyler()
        .padding(.all(8))
        .borderRadius(.all(UiTokens.radiusXl()))
        .color(unread ? UiTokens.defaultColor() : UiTokens.transparent),
    child: ColumnBox(
      style: FlexBoxStyler()
          .mainAxisSize(.min)
          .crossAxisAlignment(.start)
          .spacing(2),
      children: [
        UiDashboardText(message, type: .bodyXs, emphasized: unread),
        UiDashboardText(time, type: .bodyXs, muted: true),
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
class _UiDemoTheme extends StatelessWidget {
  const _UiDemoTheme({
    required this.dark,
    required this.radius,
    required this.child,
  });

  final bool dark;
  final double? radius;
  final Widget child;

  UiThemeMode get _mode => dark ? UiThemeMode.dark : UiThemeMode.light;

  @override
  Widget build(BuildContext context) {
    final radius = this.radius;
    if (UiTheme.maybeOf(context) == null) {
      return UiTheme(
        mode: _mode,
        theme: radius == null ? null : UiThemeData.light(radius: radius),
        darkTheme: radius == null ? null : UiThemeData.dark(radius: radius),
        child: child,
      );
    }
    return UiTheme(
      mode: UiThemeMode.light,
      child: Builder(
        builder: (lightContext) {
          final light = UiTheme.of(lightContext);
          return UiTheme(
            mode: UiThemeMode.dark,
            child: Builder(
              builder: (darkContext) {
                final dark = UiTheme.of(darkContext);
                return UiTheme(
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
class _UiHeaderPopover extends StatefulWidget {
  const _UiHeaderPopover({
    required this.icon,
    required this.semanticLabel,
    required this.popoverChild,
    this.showBadge = false,
  });

  final IconData icon;
  final String semanticLabel;
  final Widget popoverChild;
  final bool showBadge;

  @override
  State<_UiHeaderPopover> createState() => _UiHeaderPopoverState();
}

class _UiHeaderPopoverState extends State<_UiHeaderPopover> {
  final _controller = MenuController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => UiPopover(
    controller: _controller,
    openOnTap: false,
    triggerFocusNode: _focusNode,
    popoverChild: widget.popoverChild,
    child: StackBox(
      style: StackBoxStyler().clipBehavior(.none),
      children: [
        UiIconButton.ghost(
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
                    .color(UiTokens.accent())
                    .border(.all(.color(UiTokens.background()).width(1.5))),
              ),
            ),
          ),
      ],
    ),
  );
}

class _UiBrand extends StatelessWidget {
  const _UiBrand();

  @override
  Widget build(BuildContext context) => StyledText(
    'Northstar',
    style: uiDashboardTextStyle(
      emphasized: true,
    ).fontWeight(.w600).maxLines(1).softWrap(false).overflow(.ellipsis),
  );
}

class _UiBreadcrumb extends StatelessWidget {
  const _UiBreadcrumb({required this.page});
  final UiDashboardDemoPage page;

  @override
  Widget build(BuildContext context) => RowBox(
    style: FlexBoxStyler().crossAxisAlignment(.center).spacing(8),
    children: [
      Flexible(
        child: StyledText(
          page.section.label,
          style: uiDashboardTextStyle(
            muted: true,
          ).maxLines(1).softWrap(false).overflow(.ellipsis),
        ),
      ),
      StyledIcon(
        icon: RemixIcons.chevronRight,
        style: IconStyler().size(12).color(UiTokens.muted()),
      ),
      Flexible(
        child: StyledText(
          page.label,
          style: uiDashboardTextStyle(
            type: .h6,
          ).maxLines(1).softWrap(false).overflow(.ellipsis),
        ),
      ),
    ],
  );
}

class _UiAccount extends StatelessWidget {
  const _UiAccount();

  @override
  Widget build(BuildContext context) => UiDropdown<String>(
    trigger: RemixMenuTrigger.builder(
      label: 'Ada Chen',
      icon: RemixIcons.user,
      builder: (context, _, _) => RemixCard(
        style: CardStyler()
            .padding(.symmetric(horizontal: 8, vertical: 8))
            .borderRadius(.all(UiTokens.radius2xl()))
            .color(UiTokens.transparent)
            .onHovered(CardStyler().color(UiTokens.defaultColor()))
            .onFocusVisible(CardStyler().containerEffects(uiInsetFocusRing)),
        child: RowBox(
          style: FlexBoxStyler().crossAxisAlignment(.center).spacing(10),
          children: [
            const UiAvatar.soft(label: 'AC', color: .accent, size: .sm),
            Expanded(
              child: ColumnBox(
                style: FlexBoxStyler()
                    .mainAxisSize(.min)
                    .crossAxisAlignment(.start),
                children: [
                  StyledText(
                    'Ada Chen',
                    style: uiDashboardTextStyle(
                      emphasized: true,
                    ).maxLines(1).softWrap(false).overflow(.ellipsis),
                  ),
                  StyledText(
                    'Northstar workspace',
                    style: uiDashboardTextStyle(
                      type: .bodyXs,
                      muted: true,
                    ).maxLines(1).softWrap(false).overflow(.ellipsis),
                  ),
                ],
              ),
            ),
            StyledIcon(
              icon: RemixIcons.more,
              style: IconStyler().size(16).color(UiTokens.muted()),
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
      .soft => UiButton.secondary(label: label, onPressed: onPressed),
      .outline => UiButton.outline(label: label, onPressed: onPressed),
    },
    heading: uiDashboardTextStyle(type: .h3),
    body: uiDashboardTextStyle(muted: true),
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
