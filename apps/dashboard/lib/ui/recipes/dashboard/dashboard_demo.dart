import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/combobox.dart';
import '../../components/kbd.dart';
import '../../components/sidebar_layout.dart';
import '../agent_glyphs_recipe.dart';
import '../answer_recipe.dart';
import '../composer_recipe.dart';
import '../conversation_recipe.dart';
import '../message_recipe.dart';
import '../sources_recipe.dart';
import '../steps_recipe.dart';
import '../suggestions_recipe.dart';
import '../tool_call_recipe.dart';
import 'dashboard_demo_analytics.dart';
import 'dashboard_demo_chat.dart';
import 'dashboard_demo_collection.dart';
import 'dashboard_demo_data.dart';
import 'dashboard_demo_records_page.dart';
import 'dashboard_demo_schedule.dart';
import 'dashboard_demo_settings.dart';
import 'dashboard_demo_text.dart';
import 'dashboard_demo_theme.dart';
import 'dashboard_demo_theme_panel.dart';
import 'dashboard_demo_themes.dart';
import 'dashboard_demo_typography.dart';
import 'dashboard_demo_ui.dart';
import 'dashboard_demo_widgets.dart';
import 'dashboard_overview.dart';
import 'dashboard_shell.dart';

/// The navigation groups of the dashboard demo.
enum UiDashboardDemoSection {
  workspace('Workspace'),
  catalog('Catalog'),
  manage('Manage');

  const UiDashboardDemoSection(this.label);

  /// The heading shown above the section's destinations.
  final String label;
}

/// The navigation destinations of the dashboard demo.
enum UiDashboardDemoPage {
  overview(.workspace, 'Overview', RemixIcons.dashboard),
  analytics(.workspace, 'Analytics', RemixIcons.chart),
  schedule(.workspace, 'Schedule', RemixIcons.calendar),
  chat(.workspace, 'Chat', RemixIcons.chat),
  collection(.catalog, 'Collection', RemixIcons.layers),
  customers(.catalog, 'Customers', RemixIcons.user),
  orders(.catalog, 'Orders', RemixIcons.box),
  themes(.manage, 'Themes', RemixIcons.wand),
  settings(.manage, 'Settings', RemixIcons.sliders);

  const UiDashboardDemoPage(this.section, this.label, this.icon);

  /// The navigation group the page belongs to.
  final UiDashboardDemoSection section;

  /// The destination's label and the page title.
  final String label;

  /// The destination's icon.
  final IconData icon;
}

/// The sidebar sections and destinations of the dashboard demo.
final uiDashboardDemoSections =
    List<RemixSidebarSection<UiDashboardDemoPage>>.unmodifiable([
      for (final section in UiDashboardDemoSection.values)
        RemixSidebarSection(
          label: section.label,
          destinations: [
            for (final page in UiDashboardDemoPage.values)
              if (page.section == section)
                RemixSidebarDestination(
                  value: page,
                  label: page.label,
                  icon: page.icon,
                ),
          ],
        ),
    ]);

/// The product brand supplied through the shell's brand slot: a cobogó mark
/// beside the studio's name.
class UiDashboardBrand extends StatelessWidget {
  const UiDashboardBrand({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    key: const ValueKey('dashboard-brand'),
    label: 'Northstar',
    excludeSemantics: true,
    child: RowBox(
      style: FlexBoxStyler()
          .mainAxisSize(.min)
          .crossAxisAlignment(.center)
          .spacing(UiTokens.space2()),
      children: [
        Box(
          style: BoxStyler()
              .size(24, 24)
              .color(UiTokens.accentSolid())
              .borderRadius(.all(UiTokens.radius2()))
              .alignment(.center),
          child: Box(
            style: BoxStyler()
                .size(10, 10)
                .color(UiTokens.accentContrast())
                .borderRadius(
                  .only(
                    topLeft: const Radius.circular(10),
                    bottomRight: const Radius.circular(10),
                  ),
                ),
          ),
        ),
        const Flexible(
          child: UiText(
            'Northstar',
            size: .size4,
            weight: .bold,
            softWrap: false,
            truncate: true,
          ),
        ),
      ],
    ),
  );
}

const _accountActions = [
  UiAction(value: 'profile', label: 'View profile'),
  UiAction(value: 'preferences', label: 'Preferences'),
  UiAction(value: 'signout', label: 'Sign out', dividerBefore: true),
];

void _onAccountAction(BuildContext context, String value) => uiDashboardToast(
  context,
  value == 'signout' ? 'Signed out of demo' : '${capitalize(value)} opened',
);

/// The account menu supplied through the shell's footer slot.
class UiDashboardSidebarAccount extends StatelessWidget {
  const UiDashboardSidebarAccount({super.key});

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
              const UiAvatar(label: 'LF', size: .size2, fallbackLength: 2),
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
                      'Northstar Editions',
                      style: dashboardTextLine(.size1, tone: .muted),
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
      actions: _accountActions,
      onSelected: (value) => _onAccountAction(context, value),
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
            iconBuilder: (_, _, _) =>
                const UiAvatar(label: 'LF', size: .size2, fallbackLength: 2),
          ),
        ),
      ),
      actions: _accountActions,
      onSelected: (value) => _onAccountAction(context, value),
    ),
  );
}

/// Something the quick-find field can jump to: a page, or a record on one.
@immutable
final class UiQuickFindEntry {
  const UiQuickFindEntry({
    required this.page,
    required this.label,
    required this.detail,
    this.query = '',
    this.accent,
  });

  /// The page the entry opens.
  final UiDashboardDemoPage page;

  /// The entry's name, matched against what is typed.
  final String label;

  /// What kind of thing the entry is.
  final String detail;

  /// The search the destination page is filled with. Empty for a page.
  final String query;

  /// The palette the entry applies. Null for anything but a palette.
  final UiAccentColor? accent;
}

/// A search field in the header that lists matching pages, editions,
/// customers and orders, and jumps to the one chosen.
///
/// The entries are indexed once per data set, not on every keystroke.
class UiDashboardQuickFind extends StatefulWidget {
  const UiDashboardQuickFind({
    super.key,
    required this.data,
    required this.onSelected,
    this.width = 280,
  });

  /// The records searched.
  final UiDashboardData data;

  /// Called with the entry the user picks.
  final ValueChanged<UiQuickFindEntry> onSelected;

  /// The width of the field.
  final double width;

  @override
  State<UiDashboardQuickFind> createState() => _UiDashboardQuickFindState();
}

class _UiDashboardQuickFindState extends State<UiDashboardQuickFind> {
  static const _limit = 7;

  final _controller = TextEditingController();
  final _focusNode = FocusNode(debugLabel: 'dashboard quick find');
  late List<UiQuickFindEntry> _entries = _index(widget.data);

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_focusFromShortcut);
  }

  @override
  void didUpdateWidget(UiDashboardQuickFind oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) _entries = _index(widget.data);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_focusFromShortcut);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  static List<UiQuickFindEntry> _index(UiDashboardData data) => [
    for (final page in UiDashboardDemoPage.values)
      UiQuickFindEntry(page: page, label: page.label, detail: 'Page'),
    for (final edition in data.editions)
      UiQuickFindEntry(
        page: .collection,
        label: edition.title,
        detail: 'Edition · ${edition.artist}',
        query: edition.title,
      ),
    for (final customer in data.customers)
      UiQuickFindEntry(
        page: .customers,
        label: customer.name,
        detail: 'Customer · ${customer.city}',
        query: customer.name,
      ),
    for (final order in data.orders)
      UiQuickFindEntry(
        page: .orders,
        label: order.id,
        detail: 'Order · ${order.customer}',
        query: order.id,
      ),
    for (final accent in UiAccentColor.values)
      UiQuickFindEntry(
        page: .themes,
        label: enumLabel(accent),
        detail: 'Palette · ${uiPaletteNotes[accent]!.pairing}',
        accent: accent,
      ),
  ];

  Iterable<UiQuickFindEntry> _matches(TextEditingValue value) {
    final query = value.text.trim().toLowerCase();
    if (query.isEmpty) return const [];
    return _entries
        .where((entry) => entry.label.toLowerCase().contains(query))
        .take(_limit);
  }

  /// Moves focus to the field, from anywhere in the application.
  bool _focusFromShortcut(KeyEvent event) {
    final keyboard = HardwareKeyboard.instance;
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.keyK ||
        !(keyboard.isMetaPressed || keyboard.isControlPressed)) {
      return false;
    }
    // A dialog or sheet above the dashboard owns the keyboard: do not pull
    // focus out from under it.
    if (!(ModalRoute.of(context)?.isCurrent ?? true)) return false;
    _focusNode.requestFocus();

    return true;
  }

  void _select(UiQuickFindEntry entry) {
    // The combobox writes the chosen label into the field as it selects.
    // Clearing it here, synchronously, leaves the field ready for the next
    // search instead of showing where the user already is.
    _controller.clear();
    _focusNode.unfocus();
    widget.onSelected(entry);
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: widget.width,
    child: UiCombobox<UiQuickFindEntry>(
      key: const ValueKey('dashboard-search'),
      controller: _controller,
      focusNode: _focusNode,
      semanticLabel: 'Search the dashboard',
      optionsBuilder: _matches,
      displayStringForOption: (entry) => entry.label,
      onSelected: _select,
      fieldBuilder: (context, _, controller, focusNode, onFieldSubmitted) =>
          UiTextField(
            controller: controller,
            focusNode: focusNode,
            hintText: 'Search or jump to…',
            semanticLabel: 'Search the dashboard',
            leading: const StyledIcon(icon: RemixIcons.search),
            // The shortcut that reaches this field from anywhere.
            trailing: ExcludeSemantics(child: UiKbd(uiQuickFindShortcut)),
            onSubmitted: (_) => onFieldSubmitted(),
          ),
      optionBuilder: (context, entry) => RowBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.center)
            .spacing(UiTokens.space3()),
        children: [
          StyledIcon(
            icon: entry.page.icon,
            style: IconStyler().size(16).color(UiTokens.gray11()),
          ),
          Expanded(
            child: ColumnBox(
              style: FlexBoxStyler()
                  .mainAxisSize(.min)
                  .crossAxisAlignment(.start),
              children: [
                StyledText(
                  entry.label,
                  style: dashboardTextLine(.size2, weight: .medium),
                ),
                StyledText(
                  entry.detail,
                  style: dashboardTextLine(.size1, tone: .muted),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// The toolbar actions supplied to the dashboard shell: appearance,
/// notifications, theme settings and the account.
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
    // A popover left open across an appearance change would keep the old
    // appearance's surface for a frame; close both instead.
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
            popoverChild: _Notifications(
              activities: widget.activities,
              read: _notificationsRead,
              onMarkRead: () {
                setState(() => _notificationsRead = true);
                _notificationsController.close();
                uiDashboardToast(context, 'All notifications marked read');
              },
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                RemixIconButton(
                  semanticLabel: 'Notifications',
                  style: _toolbarButtonStyle,
                  onPressed: () => _toggle(_notificationsController),
                  icon: RemixIcons.bell,
                ),
                // Sits in the button's top-right corner, outside the glyph's
                // box, so the icon builder's clip cannot cut it.
                if (!_notificationsRead)
                  const PositionedDirectional(
                    end: 8,
                    top: 8,
                    child: ExcludeSemantics(
                      child: IgnorePointer(child: _UnreadDot()),
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
            onPressed: () => _toggle(_themeController),
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
                iconBuilder: (_, _, _) => const UiAvatar(
                  label: 'LF',
                  size: .size2,
                  fallbackLength: 2,
                ),
              ),
            ),
            actions: _accountActions,
            onSelected: (value) => _onAccountAction(context, value),
          ),
      ],
    );
  }

  void _toggle(MenuController controller) =>
      controller.isOpen ? controller.close() : controller.open();
}

class _Notifications extends StatelessWidget {
  const _Notifications({
    required this.activities,
    required this.read,
    required this.onMarkRead,
  });

  final List<UiDashboardActivity> activities;
  final bool read;
  final VoidCallback onMarkRead;

  @override
  Widget build(BuildContext context) => Box(
    key: const ValueKey('topbar-notifications-content'),
    style: BoxStyler().width(330),
    child: ColumnBox(
      style: FlexBoxStyler()
          .mainAxisSize(.min)
          .crossAxisAlignment(.stretch)
          .spacing(UiTokens.space3()),
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
            if (!read)
              UiButton.ghost(
                size: .size1,
                onPressed: onMarkRead,
                label: 'Mark all read',
              ),
          ],
        ),
        for (final event in activities.take(4))
          RowBox(
            style: FlexBoxStyler()
                .crossAxisAlignment(.center)
                .spacing(UiTokens.space3()),
            children: [
              UiActivityIcon(kind: event.kind),
              Expanded(
                child: ColumnBox(
                  style: FlexBoxStyler().crossAxisAlignment(.start),
                  children: [
                    UiText(
                      event.title,
                      size: .size2,
                      weight: read ? .regular : .medium,
                    ),
                    StyledText(
                      event.relativeTime,
                      style: dashboardText(.size1, tone: .muted),
                    ),
                  ],
                ),
              ),
              if (!read) const ExcludeSemantics(child: _UnreadDot()),
            ],
          ),
      ],
    ),
  );
}

class _UnreadDot extends StatelessWidget {
  const _UnreadDot();

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

/// The full dashboard demo: a shell around nine pages of one product.
///
/// A page is built the first time it is visited and then kept, with its
/// scroll position, filters and drafts, while another is shown. Kept pages
/// are not rebuilt when the selection changes: only the shell is.
class UiDashboardDemo extends StatefulWidget {
  const UiDashboardDemo({
    super.key,
    this.brand = const UiDashboardBrand(),
    this.account,
    this.headerActions = const [],
    this.data,
    this.initialPage = .overview,
    this.initialSettings = const UiThemeSettings(),
    this.collapsed,
    this.initiallyCollapsed = false,
    this.onCollapsedChanged,
    this.onPageChanged,
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

  /// The records every page shows. Defaults to [uiDashboardSampleData].
  final UiDashboardData? data;

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

  /// Called when the user opens another page.
  final ValueChanged<UiDashboardDemoPage>? onPageChanged;

  /// Whether to add the breadcrumb, quick find, appearance toggle,
  /// notifications, theme settings and sample account.
  final bool builtInChrome;

  /// The pause between the scripted steps of the chat page.
  final Duration chatStepDelay;

  @override
  State<UiDashboardDemo> createState() => _UiDashboardDemoState();
}

class _UiDashboardDemoState extends State<UiDashboardDemo> {
  late UiThemeSettings _settings = widget.initialSettings;
  late UiDashboardDemoPage _selected = widget.initialPage;
  bool? _ambientIsDark;

  /// The pages visited so far. Each is built once and reused, so selecting
  /// another page rebuilds the shell around them and not the pages.
  final _pages = <UiDashboardDemoPage, Widget>{};

  final _collectionSearch = TextEditingController();
  final _customerSearch = TextEditingController();
  final _orderSearch = TextEditingController();

  UiDashboardData get _data => widget.data ?? uiDashboardSampleData;

  @override
  void didUpdateWidget(covariant UiDashboardDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSettings != oldWidget.initialSettings) {
      _settings = widget.initialSettings;
    }
    if (widget.initialPage != oldWidget.initialPage &&
        _selected == oldWidget.initialPage) {
      _selected = widget.initialPage;
    }
    if (widget.data != oldWidget.data ||
        widget.chatStepDelay != oldWidget.chatStepDelay) {
      _pages.clear();
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

  @override
  void dispose() {
    _collectionSearch.dispose();
    _customerSearch.dispose();
    _orderSearch.dispose();
    super.dispose();
  }

  void _select(UiDashboardDemoPage page) {
    if (_selected == page) return;
    setState(() => _selected = page);
    widget.onPageChanged?.call(page);
  }

  void _jumpTo(UiQuickFindEntry entry) {
    final search = switch (entry.page) {
      .collection => _collectionSearch,
      .customers => _customerSearch,
      .orders => _orderSearch,
      _ => null,
    };
    if (entry.query.isNotEmpty) search?.text = entry.query;
    if (entry.accent case final accent?) {
      final theme = UiDashboardThemeScope.maybeOf(context);
      if (theme != null) {
        theme.onChanged(theme.settings.copyWith(accentColor: accent));
      } else {
        setState(() => _settings = _settings.copyWith(accentColor: accent));
      }
    }
    _select(entry.page);
  }

  Widget _build(UiDashboardDemoPage page) => switch (page) {
    .overview => UiDashboardOverview(
      data: _data,
      onViewOrders: () => _select(.orders),
      onViewCollection: () => _select(.collection),
      onViewSchedule: () => _select(.schedule),
      onViewThemes: () => _select(.themes),
    ),
    .analytics => UiDashboardAnalyticsPage(data: _data),
    .schedule => UiDashboardSchedulePage(data: _data),
    .chat => UiDashboardChatPage(
      styles: _uiAgentStyles(),
      stepDelay: widget.chatStepDelay,
    ),
    .collection => UiDashboardCollectionPage(
      data: _data,
      searchController: _collectionSearch,
    ),
    .customers => UiDashboardCustomersPage(
      data: _data,
      searchController: _customerSearch,
    ),
    .orders => UiDashboardOrdersPage(
      data: _data,
      searchController: _orderSearch,
    ),
    .themes => const UiDashboardThemesPage(),
    .settings => UiDashboardSettingsPage(data: _data),
  };

  bool _resolveIsDark(BuildContext context) {
    final platformDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final ambientDark = UiTheme.maybeOf(context)?.isDark ?? false;
    return switch (_settings.appearance) {
      .light => false,
      .dark => true,
      .system => platformDark || ambientDark,
    };
  }

  @override
  Widget build(BuildContext context) {
    _pages[_selected] ??= _build(_selected);
    final chrome = widget.builtInChrome;
    final demo = UiDashboardShell<UiDashboardDemoPage>(
      sections: uiDashboardDemoSections,
      selectedValue: _selected,
      onSelected: _select,
      title: _selected.label,
      headerTitle: chrome ? UiDashboardBreadcrumb(page: _selected) : null,
      brand: widget.brand,
      account:
          widget.account ?? (chrome ? const UiDashboardSidebarAccount() : null),
      collapsedAccount: widget.account == null && chrome
          ? const UiDashboardSidebarAccountRail()
          : null,
      headerActions: [
        if (chrome) ...[
          if (MediaQuery.sizeOf(context).width >= 960)
            UiDashboardQuickFind(data: _data, onSelected: _jumpTo),
          UiDashboardTopBar(activities: _data.activities),
        ],
        ...widget.headerActions,
      ],
      collapsed: widget.collapsed,
      initiallyCollapsed: widget.initiallyCollapsed,
      onCollapsedChanged: widget.onCollapsedChanged,
      body: UiDashboardPageStack(selected: _selected, pages: _pages),
    );
    if (UiDashboardThemeScope.maybeOf(context) != null) return demo;

    return UiDashboardThemeScope(
      settings: _settings,
      onChanged: (next) => setState(() => _settings = next),
      child: _UiDemoTheme(
        key: const ValueKey('dashboard-theme-scope'),
        mode: _resolveIsDark(context) ? .dark : .light,
        accent: _settings.accentColor,
        panelBackground: _settings.panelBackground,
        radius: _settings.radius,
        scaling: _settings.scaling,
        child: RemixToastScope(style: uiToastStyle(), child: demo),
      ),
    );
  }
}

/// Shows [selected] from [pages] and keeps the others alive behind it.
///
/// The page shown fades and rises into place. The others are not painted,
/// hit-tested, focusable or announced, and their animations are paused. They
/// also keep the size and the theme they last had on screen, so resizing the
/// window, collapsing the sidebar or changing the palette works on one page
/// instead of all of them.
class UiDashboardPageStack extends StatefulWidget {
  const UiDashboardPageStack({
    super.key,
    required this.selected,
    required this.pages,
  });

  /// The page on screen.
  final UiDashboardDemoPage selected;

  /// The pages built so far.
  final Map<UiDashboardDemoPage, Widget> pages;

  @override
  State<UiDashboardPageStack> createState() => _UiDashboardPageStackState();
}

class _UiDashboardPageStackState extends State<UiDashboardPageStack>
    with SingleTickerProviderStateMixin {
  late final _enter = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
    value: 1,
  );
  late final _fade = CurvedAnimation(parent: _enter, curve: Curves.easeOut);
  late final _rise = Tween(
    begin: const Offset(0, 0.012),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _enter, curve: Curves.easeOutCubic));

  @override
  void didUpdateWidget(UiDashboardPageStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected == oldWidget.selected) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _enter.value = 1;
    } else {
      _enter.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _fade.dispose();
    _enter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
    key: const ValueKey('dashboard-demo-pages'),
    fit: StackFit.expand,
    children: [
      for (final page in UiDashboardDemoPage.values)
        if (widget.pages[page] case final child?)
          _PageSlot(
            key: ValueKey('dashboard-page-${page.name}'),
            active: page == widget.selected,
            fade: _fade,
            rise: _rise,
            child: child,
          ),
    ],
  );
}

class _PageSlot extends StatefulWidget {
  const _PageSlot({
    super.key,
    required this.active,
    required this.fade,
    required this.rise,
    required this.child,
  });

  final bool active;
  final Animation<double> fade;
  final Animation<Offset> rise;
  final Widget child;

  @override
  State<_PageSlot> createState() => _PageSlotState();
}

/// Holds what a page inherits still while the page is hidden.
///
/// A theme change reaches every widget that reads the theme, a token, the
/// text run or the icon run, and a kept page is thousands of them. The slot
/// reads those itself and hands them down. While its page is on screen it
/// passes along what it reads; while the page is hidden it keeps passing what
/// it read last, so the page hears nothing and rebuilds nothing. The page
/// catches up in the frame it is shown again.
class _PageSlotState extends State<_PageSlot> {
  /// Keeps the page's state should the themes captured around it change in
  /// number, which would otherwise move it to another depth.
  final _page = GlobalKey();

  CapturedThemes? _themes;
  UiDashboardThemeScope? _settings;
  Map<MixToken<Object?>, Object>? _tokens;
  List<Type>? _orderOfModifiers;
  DefaultTextStyle? _textRun;
  IconThemeData? _iconRun;

  @override
  Widget build(BuildContext context) {
    // Read on every build, hidden or not, so the slot stays subscribed and
    // is rebuilt, cheaply, when any of these changes.
    UiTheme.maybeOf(context);
    final settings = UiDashboardThemeScope.maybeOf(context);
    final scope = MixScope.maybeOf(context);
    final textRun = DefaultTextStyle.of(context);
    final iconRun = IconTheme.of(context);
    if (widget.active || _themes == null) {
      _themes = InheritedTheme.capture(from: context, to: null);
      _settings = settings;
      _tokens = scope?.tokens;
      _orderOfModifiers = scope?.orderOfModifiers;
      _textRun = textRun;
      _iconRun = iconRun;
    }
    final heldText = _textRun!;

    // Innermost first. The captured themes re-install the Ui theme with
    // its own tokens, so the tokens read here, which include any override a
    // host placed above the dashboard, go back on below them.
    Widget page = KeyedSubtree(key: _page, child: widget.child);
    page = IconTheme(data: _iconRun!, child: page);
    page = DefaultTextStyle(
      style: heldText.style,
      textAlign: heldText.textAlign,
      softWrap: heldText.softWrap,
      overflow: heldText.overflow,
      maxLines: heldText.maxLines,
      textWidthBasis: heldText.textWidthBasis,
      textHeightBehavior: heldText.textHeightBehavior,
      child: page,
    );
    page = MixScope(
      tokens: _tokens,
      orderOfModifiers: _orderOfModifiers,
      child: page,
    );
    if (_settings case final held?) {
      page = UiDashboardThemeScope(
        settings: held.settings,
        onChanged: held.onChanged,
        child: page,
      );
    }

    return TickerMode(
      enabled: widget.active,
      child: ExcludeFocus(
        excluding: !widget.active,
        child: _KeepLastLayout(
          active: widget.active,
          // The fade and the rise move one retained layer: the page itself is
          // painted once, not on every frame of its entrance.
          child: FadeTransition(
            opacity: widget.active ? widget.fade : kAlwaysCompleteAnimation,
            child: SlideTransition(
              position: widget.active
                  ? widget.rise
                  : const AlwaysStoppedAnimation(Offset.zero),
              child: RepaintBoundary(child: _themes!.wrap(page)),
            ),
          ),
        ),
      ),
    );
  }
}

/// Lays an inactive page out with the constraints it last had while active,
/// and neither paints, hit-tests nor announces it.
class _KeepLastLayout extends SingleChildRenderObjectWidget {
  const _KeepLastLayout({required this.active, required super.child});

  final bool active;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderKeepLastLayout(active);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderKeepLastLayout renderObject,
  ) {
    renderObject.active = active;
  }
}

class _RenderKeepLastLayout extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  _RenderKeepLastLayout(this._active);

  bool _active;
  BoxConstraints? _lastActiveConstraints;

  bool get active => _active;
  set active(bool value) {
    if (_active == value) return;
    _active = value;
    markNeedsPaint();
    markNeedsSemanticsUpdate();
    if (value) markNeedsLayout();
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    final effective = _active
        ? (_lastActiveConstraints = constraints)
        : (_lastActiveConstraints ?? constraints);
    if (constraints.isTight) {
      child.layout(effective);
      size = constraints.biggest;
    } else {
      child.layout(effective, parentUsesSize: true);
      size = constraints.constrain(child.size);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!_active) return;
    final child = this.child;
    if (child != null) context.paintChild(child, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      _active && (child?.hitTest(result, position: position) ?? false);

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    if (_active) super.visitChildrenForSemantics(visitor);
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
    toolIconBuilder: uiAgentToolIcon,
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
    answerBodyStyle: FlexBoxStyler()
        .crossAxisAlignment(.stretch)
        .spacing(UiTokens.space3()),
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

/// The header title: the page's section, then the page.
class UiDashboardBreadcrumb extends StatelessWidget {
  const UiDashboardBreadcrumb({super.key, required this.page});

  /// The page on screen.
  final UiDashboardDemoPage page;

  @override
  Widget build(BuildContext context) => Padding(
    // The app bar insets its toolbar by `space4`; the page body uses the
    // wide page padding, so the difference lines the breadcrumb up with the
    // page title. In compact mode the menu button leads, so there is none.
    padding: EdgeInsetsDirectional.only(
      start: UiSidebarLayoutScope.of(context).isCompact
          ? 0
          : 24 - UiTokens.space4.resolve(context),
    ),
    child: RowBox(
      style: FlexBoxStyler().crossAxisAlignment(.center).spacing(8),
      children: [
        Flexible(
          child: StyledText(
            page.section.label,
            style: dashboardTextLine(.size2, tone: .muted),
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
            style: dashboardTextLine(.size2, weight: .medium),
          ),
        ),
      ],
    ),
  );
}

/// Keeps the demo's theme, text and icon ancestors present in both
/// appearances.
///
/// The ordinary theme conditionally inserts recoloring widgets under a host,
/// which would remount the demo when the appearance changes. This reuses the
/// theme's resolved inherited scope through [InheritedTheme.wrap], which
/// installs the theme and Mix tokens without those conditional wrappers.
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
