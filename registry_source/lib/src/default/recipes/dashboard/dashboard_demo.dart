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
import '../../theme/tokens.dart';
import '../../theme/theme_data.dart';
import '../../theme/theme_scope.dart';
import 'dashboard_demo_records.dart';
import 'dashboard_demo_settings.dart';
import 'dashboard_overview.dart';
import 'dashboard_shell.dart';

/// Full default-preset dashboard demo.
///
/// This is the open-code equivalent of the repository's Fortal showcase: it
/// includes the same Workspace, Data, Manage, and Components destinations,
/// while demonstrating the smaller default preset vocabulary honestly.
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
  State<VanillaDashboardDemo> createState() => _VanillaDashboardDemoState();
}

class _VanillaDashboardDemoState extends State<VanillaDashboardDemo> {
  /// The appearance the toggle chose, or null to follow the scope this demo
  /// is placed in.
  bool? _dark;
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
        ),
      },
    );
    if (!widget.builtInChrome) return demo;
    return VanillaTheme(
      mode: _isDark ? VanillaThemeMode.dark : VanillaThemeMode.light,
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
    VanillaPopover(
      semanticLabel: 'Notifications',
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
      child: StackBox(
        style: StackBoxStyler().clipBehavior(.none),
        children: [
          const VanillaIconButton.ghost(
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
                      .color(VanillaTokens.primary()),
                ),
              ),
            ),
        ],
      ),
    ),
    VanillaPopover(
      semanticLabel: 'Theme settings',
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
            ColumnBox(
              style: FlexBoxStyler()
                  .crossAxisAlignment(.stretch)
                  .spacing(VanillaTokens.s2),
              children: [
                _settingLine('Appearance', _isDark ? 'Dark' : 'Light'),
                _settingLine('Accent color', 'Neutral'),
                _settingLine('Radius', 'Medium'),
                _settingLine('Density', 'Comfortable'),
              ],
            ),
          ],
        ),
      ),
      child: const VanillaIconButton.ghost(
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
      StyledText('/', style: _textStyle(muted: true)),
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
      icon: RemixIcons.person,
      builder: (context, _, _) => Box(
        style: BoxStyler()
            .padding(
              .symmetric(
                horizontal: VanillaTokens.s2_5,
                vertical: VanillaTokens.s2,
              ),
            )
            .borderRadius(.all(VanillaTokens.radiusMd()))
            .border(.all(.color(VanillaTokens.border())))
            .color(VanillaTokens.card()),
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
              icon: RemixIcons.dotsHorizontal,
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
