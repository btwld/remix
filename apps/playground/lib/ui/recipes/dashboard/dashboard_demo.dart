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
import '../../theme/theme_data.dart';
import '../../theme/theme_scope.dart';
import '../../theme/tokens.dart';
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

  final Widget brand;
  final Widget? account;
  final List<Widget> headerActions;
  final ValueChanged<String>? onSearchChanged;
  final PlaygroundDashboardSampleData data;
  final PlaygroundDashboardDemoPage initialPage;
  final bool? collapsed;
  final bool initiallyCollapsed;
  final ValueChanged<bool>? onCollapsedChanged;
  final bool builtInChrome;
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
    if (!widget.builtInChrome) return demo;
    final radius = _radius;
    return PlaygroundTheme(
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
    PlaygroundPopover(
      semanticLabel: 'Notifications',
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
      child: StackBox(
        style: StackBoxStyler().clipBehavior(.none),
        children: [
          const PlaygroundIconButton.ghost(
            icon: RemixIcons.bell,
            semanticLabel: 'Open notifications',
          ),
          if (!_notificationsRead)
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
    ),
    PlaygroundPopover(
      semanticLabel: 'Theme settings',
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
      child: const PlaygroundIconButton.ghost(
        icon: RemixIcons.gear,
        semanticLabel: 'Open theme settings',
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
      StyledText('/', style: _textStyle(muted: true)),
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
      icon: RemixIcons.person,
      builder: (context, _, _) => Box(
        style: BoxStyler()
            .padding(
              .symmetric(
                horizontal: PlaygroundTokens.s2_5,
                vertical: PlaygroundTokens.s2,
              ),
            )
            .borderRadius(.all(PlaygroundTokens.radiusMd()))
            .border(.all(.color(PlaygroundTokens.border())))
            .color(PlaygroundTokens.card()),
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
              icon: RemixIcons.dotsHorizontal,
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
  final message = playgroundAgentMessageRecipe();
  final answer = playgroundAgentAnswerRecipe();
  final transcript = playgroundAgentTranscriptRecipe();
  final plan = playgroundAgentPlanRecipe();
  final activity = playgroundAgentActivityRecipe();
  final permission = playgroundAgentPermissionRecipe();
  final execution = playgroundAgentExecutionRecipe();
  final composer = playgroundAgentComposerRecipe();
  return PlaygroundDashboardAgentStyles(
    buttonBuilder: (label, onPressed, tone) => switch (tone) {
      .primary => PlaygroundButton(label: label, onPressed: onPressed),
      .soft => PlaygroundButton.secondary(label: label, onPressed: onPressed),
      .outline => PlaygroundButton.outline(label: label, onPressed: onPressed),
    },
    heading: _textStyle(
      token: PlaygroundTokens.text2xl,
      weight: FontWeight.w700,
    ),
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
