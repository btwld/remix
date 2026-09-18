import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import '../data/activity.dart';
import '../theme/theme_scope.dart';
import '../ui/ui.dart';
import '../widgets/action_menu.dart';
import '../widgets/theme_panel.dart';
import '../widgets/typography.dart';

/// Application-owned actions supplied to the installed dashboard shell.
class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  final _notificationsController = MenuController();
  final _themeController = MenuController();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 600;
    return RowBox(
      style: FlexBoxStyler().spacing(UiTokens.space2()),
      children: [
        RemixIconButton(
          key: const ValueKey('theme-quick-toggle'),
          semanticLabel: 'Toggle dark mode',
          style: _toolbarButtonStyle,
          onPressed: () {
            final theme = ThemeScope.of(context);
            final isDark = UiTheme.of(context).isDark;
            theme.onChanged(
              theme.settings.copyWith(appearance: isDark ? .light : .dark),
            );
          },
          icon: UiTheme.of(context).isDark
              ? Icons.light_mode_outlined
              : Icons.dark_mode_outlined,
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
                    children: [
                      const Expanded(
                        child: UiHeading(
                          'Notifications',
                          headingLevel: 2,
                          size: .size3,
                          weight: .medium,
                        ),
                      ),
                      UiButton.ghost(
                        size: .size1,
                        onPressed: () {
                          _notificationsController.close();
                          showRemixToast(
                            context,
                            RemixToastData(
                              title: 'All notifications marked read',
                              icon: Icons.check_circle_outline,
                            ),
                          );
                        },
                        label: 'Mark all read',
                      ),
                    ],
                  ),
                  for (final event in activityEvents.take(4))
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
                              .color(UiTokens.accent9())
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
                                weight: .medium,
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
              icon: Icons.notifications_none,
              iconBuilder: (context, spec, icon) => Stack(
                clipBehavior: .none,
                children: [
                  StyledIcon(
                    icon: icon,
                    styleSpec: StyleSpec(spec: spec),
                  ),
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
            child: const SingleChildScrollView(child: ThemePanel()),
          ),
          child: RemixIconButton(
            key: const ValueKey('theme-panel-trigger'),
            semanticLabel: 'Theme settings',
            style: _toolbarButtonStyle,
            onPressed: _toggleTheme,
            icon: Icons.palette_outlined,
          ),
        ),
        if (!compact)
          DashboardActionMenu(
            key: const ValueKey('topbar-account-trigger'),
            semanticLabel: 'Account menu',
            positioning: const OverlayPositionConfig(
              side: .bottom,
              alignment: .end,
              sideOffset: 8,
            ),
            trigger: const UiAvatar(label: 'LF', size: .size2),
            actions: const [
              DashboardAction(value: 'profile', label: 'Profile'),
              DashboardAction(value: 'preferences', label: 'Preferences'),
              DashboardAction(
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
                icon: Icons.check_circle_outline,
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
