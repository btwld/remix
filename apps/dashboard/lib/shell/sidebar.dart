import 'package:flutter/material.dart';
import 'package:remix/remix.dart';

import '../ui/ui.dart';
import '../utils/text.dart';
import '../widgets/action_menu.dart';
import '../widgets/typography.dart';

/// Product brand supplied through the installed shell's brand slot.
class DashboardBrand extends StatelessWidget {
  const DashboardBrand({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    key: const ValueKey('dashboard-brand'),
    label: 'Dashboard',
    excludeSemantics: true,
    child: const UiText('Dashboard', size: .size5, weight: .bold),
  );
}

/// Product account menu supplied through the installed shell's footer slot.
class DashboardSidebarAccount extends StatelessWidget {
  const DashboardSidebarAccount({super.key});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Box(
      style: BoxStyler().padding(
        .symmetric(horizontal: UiTokens.space2(), vertical: UiTokens.space3()),
      ),
      child: DashboardActionMenu(
        key: const ValueKey('sidebar-account-trigger'),
        semanticLabel: 'Workspace account menu',
        trigger: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: constraints.maxWidth < 180
              ? const Center(
                  child: UiAvatar(label: 'LF', size: .size2),
                )
              : RowBox(
                  style: FlexBoxStyler().spacing(10),
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
                          ),
                          StyledText(
                            'leo@remix.dev',
                            style: dashboardText(
                              .size1,
                              tone: .muted,
                            ).maxLines(1).softWrap(false),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.more_horiz,
                      size: 18,
                      color: MixScope.tokenOf(UiTokens.gray11, context),
                    ),
                  ],
                ),
        ),
        actions: const [
          DashboardAction(value: 'profile', label: 'View profile'),
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
                : '${capitalize(value)} opened',
            icon: Icons.check_circle_outline,
          ),
        ),
      ),
    ),
  );
}
