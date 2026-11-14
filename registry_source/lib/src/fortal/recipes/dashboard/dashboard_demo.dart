import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../../dashboard/dashboard_demo_chat.dart';
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
import 'dashboard_demo_collection.dart';
import 'dashboard_demo_data.dart';
import 'dashboard_demo_records.dart';
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
enum FortalDashboardDemoSection {
  workspace('Workspace'),
  catalog('Catalog'),
  manage('Manage');

  const FortalDashboardDemoSection(this.label);

  /// The heading shown above the section's destinations.
  final String label;
}

/// The navigation destinations of the dashboard demo.
enum FortalDashboardDemoPage {
  overview(.workspace, 'Overview', RemixIcons.dashboard),
  analytics(.workspace, 'Analytics', RemixIcons.chart),
  schedule(.workspace, 'Schedule', RemixIcons.calendar),
  chat(.workspace, 'Chat', RemixIcons.chat),
  collection(.catalog, 'Collection', RemixIcons.layers),
  customers(.catalog, 'Customers', RemixIcons.user),
  orders(.catalog, 'Orders', RemixIcons.box),
  themes(.manage, 'Themes', RemixIcons.wand),
  settings(.manage, 'Settings', RemixIcons.sliders);

  const FortalDashboardDemoPage(this.section, this.label, this.icon);

  /// The navigation group the page belongs to.
  final FortalDashboardDemoSection section;

  /// The destination's label and the page title.
  final String label;

  /// The destination's icon.
  final IconData icon;
}

/// The sidebar sections and destinations of the dashboard demo.
final fortalDashboardDemoSections =
    List<RemixSidebarSection<FortalDashboardDemoPage>>.unmodifiable([
      for (final section in FortalDashboardDemoSection.values)
        RemixSidebarSection(
          label: section.label,
          destinations: [
            for (final page in FortalDashboardDemoPage.values)
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
class FortalDashboardBrand extends StatelessWidget {
  const FortalDashboardBrand({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    key: const ValueKey('dashboard-brand'),
    label: 'Northstar',
    excludeSemantics: true,
    child: RowBox(
      style: FlexBoxStyler()
          .mainAxisSize(.min)
          .crossAxisAlignment(.center)
          .spacing(FortalTokens.space2()),
      children: [
        Box(
          style: BoxStyler()
              .size(24, 24)
              .color(FortalTokens.accentSolid())
              .borderRadius(.all(FortalTokens.radius2()))
              .alignment(.center),
          child: Box(
            style: BoxStyler()
                .size(10, 10)
                .color(FortalTokens.accentContrast())
                .borderRadius(
                  .only(
                    topLeft: const Radius.circular(10),
                    bottomRight: const Radius.circular(10),
                  ),
                ),
          ),
        ),
        const Flexible(
          child: FortalText(
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
  FortalAction(value: 'profile', label: 'View profile'),
  FortalAction(value: 'preferences', label: 'Preferences'),
  FortalAction(value: 'signout', label: 'Sign out', dividerBefore: true),
];

void _onAccountAction(BuildContext context, String value) =>
    fortalDashboardToast(
      context,
      value == 'signout' ? 'Signed out of demo' : '${capitalize(value)} opened',
    );

/// The account menu supplied through the shell's footer slot.
class FortalDashboardSidebarAccount extends StatelessWidget {
  const FortalDashboardSidebarAccount({super.key});

  @override
  Widget build(BuildContext context) => Box(
    style: BoxStyler().padding(
      .symmetric(
        horizontal: FortalTokens.space2(),
        vertical: FortalTokens.space3(),
      ),
    ),
    child: FortalActionMenu(
      key: const ValueKey('sidebar-account-trigger'),
      trigger: RemixMenuTrigger.builder(
        label: 'Workspace account menu',
        builder: (_, _, _) => RemixCard(
          style: CardStyler()
              .borderRadius(.all(FortalTokens.radius2()))
              .onFocusVisible(
                CardStyler().containerEffects(fortalFocusOutline()),
              ),
          child: RowBox(
            style: FlexBoxStyler()
                .minHeight(48)
                .crossAxisAlignment(.center)
                .spacing(10),
            children: [
              const FortalAvatar(label: 'LF', size: .size2, fallbackLength: 2),
              Expanded(
                child: ColumnBox(
                  style: FlexBoxStyler()
                      .mainAxisSize(.min)
                      .crossAxisAlignment(.start),
                  children: [
                    const FortalText(
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
                style: IconStyler().size(18).color(FortalTokens.gray11()),
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
class FortalDashboardSidebarAccountRail extends StatelessWidget {
  const FortalDashboardSidebarAccountRail({super.key});

  @override
  Widget build(BuildContext context) => Box(
    style: BoxStyler()
        .alignment(.center)
        .padding(.symmetric(vertical: FortalTokens.space3())),
    child: FortalActionMenu(
      key: const ValueKey('sidebar-account-rail-trigger'),
      trigger: RemixMenuTrigger.control(
        builder: (_, menu) => FortalTooltip(
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
            iconBuilder: (_, _, _) => const FortalAvatar(
              label: 'LF',
              size: .size2,
              fallbackLength: 2,
            ),
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
final class FortalQuickFindEntry {
  const FortalQuickFindEntry({
    required this.page,
    required this.label,
    required this.detail,
    this.query = '',
    this.accent,
  });

  /// The page the entry opens.
  final FortalDashboardDemoPage page;

  /// The entry's name, matched against what is typed.
  final String label;

  /// What kind of thing the entry is.
  final String detail;

  /// The search the destination page is filled with. Empty for a page.
  final String query;

  /// The palette the entry applies. Null for anything but a palette.
  final FortalAccentColor? accent;
}

/// A search field in the header that lists matching pages, editions,
/// customers and orders, and jumps to the one chosen.
///
/// The entries are indexed once per data set, not on every keystroke.
class FortalDashboardQuickFind extends StatefulWidget {
  const FortalDashboardQuickFind({
    super.key,
    required this.data,
    required this.onSelected,
    this.width = 280,
  });

  /// The records searched.
  final FortalDashboardData data;

  /// Called with the entry the user picks.
  final ValueChanged<FortalQuickFindEntry> onSelected;

  /// The width of the field.
  final double width;

  @override
  State<FortalDashboardQuickFind> createState() =>
      _FortalDashboardQuickFindState();
}

class _FortalDashboardQuickFindState extends State<FortalDashboardQuickFind> {
  static const _limit = 7;

  final _controller = TextEditingController();
  final _focusNode = FocusNode(debugLabel: 'dashboard quick find');
  late List<FortalQuickFindEntry> _entries = _index(widget.data);

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_focusFromShortcut);
  }

  @override
  void didUpdateWidget(FortalDashboardQuickFind oldWidget) {
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

  static List<FortalQuickFindEntry> _index(FortalDashboardData data) => [
    for (final page in FortalDashboardDemoPage.values)
      FortalQuickFindEntry(page: page, label: page.label, detail: 'Page'),
    for (final edition in data.editions)
      FortalQuickFindEntry(
        page: .collection,
        label: edition.title,
        detail: 'Edition · ${edition.artist}',
        query: edition.title,
      ),
    for (final customer in data.customers)
      FortalQuickFindEntry(
        page: .customers,
        label: customer.name,
        detail: 'Customer · ${customer.city}',
        query: customer.name,
      ),
    for (final order in data.orders)
      FortalQuickFindEntry(
        page: .orders,
        label: order.id,
        detail: 'Order · ${order.customer}',
        query: order.id,
      ),
    for (final accent in FortalAccentColor.values)
      FortalQuickFindEntry(
        page: .themes,
        label: enumLabel(accent),
        detail: 'Palette · ${fortalPaletteNotes[accent]!.pairing}',
        accent: accent,
      ),
  ];

  Iterable<FortalQuickFindEntry> _matches(TextEditingValue value) {
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

  void _select(FortalQuickFindEntry entry) {
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
    child: FortalCombobox<FortalQuickFindEntry>(
      key: const ValueKey('dashboard-search'),
      controller: _controller,
      focusNode: _focusNode,
      semanticLabel: 'Search the dashboard',
      optionsBuilder: _matches,
      displayStringForOption: (entry) => entry.label,
      onSelected: _select,
      fieldBuilder: (context, _, controller, focusNode, onFieldSubmitted) =>
          FortalTextField(
            controller: controller,
            focusNode: focusNode,
            hintText: 'Search or jump to…',
            semanticLabel: 'Search the dashboard',
            leading: const StyledIcon(icon: RemixIcons.search),
            // The shortcut that reaches this field from anywhere.
            trailing: ExcludeSemantics(
              child: FortalKbd(fortalQuickFindShortcut),
            ),
            onSubmitted: (_) => onFieldSubmitted(),
          ),
      optionBuilder: (context, entry) => RowBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.center)
            .spacing(FortalTokens.space3()),
        children: [
          StyledIcon(
            icon: entry.page.icon,
            style: IconStyler().size(16).color(FortalTokens.gray11()),
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
class FortalDashboardTopBar extends StatefulWidget {
  const FortalDashboardTopBar({super.key, this.activities = const []});

  /// The activities listed in the notifications menu.
  final List<FortalDashboardActivity> activities;

  @override
  State<FortalDashboardTopBar> createState() => _FortalDashboardTopBarState();
}

class _FortalDashboardTopBarState extends State<FortalDashboardTopBar> {
  final _notificationsController = MenuController();
  final _themeController = MenuController();
  bool _notificationsRead = false;
  bool? _wasDark;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final dark = FortalTheme.of(context).isDark;
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
    final isDark = FortalTheme.of(context).isDark;

    return RowBox(
      style: FlexBoxStyler().spacing(FortalTokens.space2()),
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
              final theme = FortalDashboardThemeScope.of(context);
              theme.onChanged(
                theme.settings.copyWith(appearance: isDark ? .light : .dark),
              );
            },
            icon: isDark ? RemixIcons.sun : RemixIcons.moon,
          ),
        ),
        if (!compact)
          FortalPopover(
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
                fortalDashboardToast(context, 'All notifications marked read');
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
        FortalPopover(
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
                        2 * FortalTokens.space4.resolve(context),
                  ),
                )
                .maxHeight(650),
            child: const SingleChildScrollView(child: FortalThemePanel()),
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
          FortalActionMenu(
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
                iconBuilder: (_, _, _) => const FortalAvatar(
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

  final List<FortalDashboardActivity> activities;
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
          .spacing(FortalTokens.space3()),
      children: [
        RowBox(
          style: FlexBoxStyler().crossAxisAlignment(.center),
          children: [
            const Expanded(
              child: FortalHeading(
                'Notifications',
                headingLevel: 2,
                size: .size3,
                weight: .medium,
              ),
            ),
            if (!read)
              FortalButton.ghost(
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
                .spacing(FortalTokens.space3()),
            children: [
              FortalActivityIcon(kind: event.kind),
              Expanded(
                child: ColumnBox(
                  style: FlexBoxStyler().crossAxisAlignment(.start),
                  children: [
                    FortalText(
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
        .color(FortalTokens.accentIndicator())
        .borderRadius(.circular(4))
        .border(.all(.color(FortalTokens.colorPanelSolid()).width(1.5))),
  );
}

final _toolbarButtonStyle = fortalIconButtonStyle(variant: .ghost)
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
class FortalDashboardDemo extends StatefulWidget {
  const FortalDashboardDemo({
    super.key,
    this.brand = const FortalDashboardBrand(),
    this.account,
    this.headerActions = const [],
    this.data,
    this.initialPage = .overview,
    this.initialSettings = const FortalThemeSettings(),
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

  /// The records every page shows. Defaults to [fortalDashboardSampleData].
  final FortalDashboardData? data;

  /// The page shown first.
  final FortalDashboardDemoPage initialPage;

  /// The theme settings the demo starts with.
  final FortalThemeSettings initialSettings;

  /// Whether the sidebar is collapsed, when the caller controls it.
  final bool? collapsed;

  /// Whether the sidebar starts collapsed when [collapsed] is null.
  final bool initiallyCollapsed;

  /// Called when the user collapses or expands the sidebar.
  final ValueChanged<bool>? onCollapsedChanged;

  /// Called when the user opens another page.
  final ValueChanged<FortalDashboardDemoPage>? onPageChanged;

  /// Whether to add the breadcrumb, quick find, appearance toggle,
  /// notifications, theme settings and sample account.
  final bool builtInChrome;

  /// The pause between the scripted steps of the chat page.
  final Duration chatStepDelay;

  @override
  State<FortalDashboardDemo> createState() => _FortalDashboardDemoState();
}

class _FortalDashboardDemoState extends State<FortalDashboardDemo> {
  late FortalThemeSettings _settings = widget.initialSettings;
  late FortalDashboardDemoPage _selected = widget.initialPage;
  bool? _ambientIsDark;

  /// The pages visited so far. Each is built once and reused, so selecting
  /// another page rebuilds the shell around them and not the pages.
  final _pages = <FortalDashboardDemoPage, Widget>{};

  final _collectionSearch = TextEditingController();
  final _customerSearch = TextEditingController();
  final _orderSearch = TextEditingController();

  /// Fired for a page when quick find fills its search to show one record.
  final _collectionReset = _FilterReset();
  final _customerReset = _FilterReset();
  final _orderReset = _FilterReset();

  FortalDashboardData get _data => widget.data ?? fortalDashboardSampleData;

  @override
  void didUpdateWidget(covariant FortalDashboardDemo oldWidget) {
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
    final ambient = FortalTheme.maybeOf(context)?.isDark;
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
    _collectionReset.dispose();
    _customerReset.dispose();
    _orderReset.dispose();
    super.dispose();
  }

  void _select(FortalDashboardDemoPage page) {
    if (_selected == page) return;
    setState(() => _selected = page);
    widget.onPageChanged?.call(page);
  }

  void _jumpTo(FortalQuickFindEntry entry) {
    final (search, reset) = switch (entry.page) {
      .collection => (_collectionSearch, _collectionReset),
      .customers => (_customerSearch, _customerReset),
      .orders => (_orderSearch, _orderReset),
      _ => (null, null),
    };
    if (entry.query.isNotEmpty) {
      // A filter left on from earlier would hide the record being opened.
      search?.text = entry.query;
      reset?.fire();
    }
    if (entry.accent case final accent?) {
      final theme = FortalDashboardThemeScope.maybeOf(context);
      if (theme != null) {
        theme.onChanged(theme.settings.copyWith(accentColor: accent));
      } else {
        setState(() => _settings = _settings.copyWith(accentColor: accent));
      }
    }
    _select(entry.page);
  }

  Widget _build(FortalDashboardDemoPage page) => switch (page) {
    .overview => FortalDashboardOverview(
      data: _data,
      onViewOrders: () => _select(.orders),
      onViewCollection: () => _select(.collection),
      onViewSchedule: () => _select(.schedule),
      onViewThemes: () => _select(.themes),
    ),
    .analytics => FortalDashboardAnalyticsPage(data: _data),
    .schedule => FortalDashboardSchedulePage(data: _data),
    .chat => RegistryDashboardChatPage(
      styles: _fortalAgentStyles(),
      stepDelay: widget.chatStepDelay,
    ),
    .collection => FortalDashboardCollectionPage(
      data: _data,
      searchController: _collectionSearch,
      filterReset: _collectionReset,
    ),
    .customers => FortalDashboardCustomersPage(
      data: _data,
      searchController: _customerSearch,
      filterReset: _customerReset,
    ),
    .orders => FortalDashboardOrdersPage(
      data: _data,
      searchController: _orderSearch,
      filterReset: _orderReset,
    ),
    .themes => const FortalDashboardThemesPage(),
    .settings => FortalDashboardSettingsPage(data: _data),
  };

  bool _resolveIsDark(BuildContext context) {
    final platformDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final ambientDark = FortalTheme.maybeOf(context)?.isDark ?? false;
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
    final demo = FortalDashboardShell<FortalDashboardDemoPage>(
      sections: fortalDashboardDemoSections,
      selectedValue: _selected,
      onSelected: _select,
      title: _selected.label,
      headerTitle: chrome ? FortalDashboardBreadcrumb(page: _selected) : null,
      brand: widget.brand,
      account:
          widget.account ??
          (chrome ? const FortalDashboardSidebarAccount() : null),
      collapsedAccount: widget.account == null && chrome
          ? const FortalDashboardSidebarAccountRail()
          : null,
      headerActions: [
        if (chrome) ...[
          if (MediaQuery.sizeOf(context).width >= 960)
            FortalDashboardQuickFind(data: _data, onSelected: _jumpTo),
          FortalDashboardTopBar(activities: _data.activities),
        ],
        ...widget.headerActions,
      ],
      collapsed: widget.collapsed,
      initiallyCollapsed: widget.initiallyCollapsed,
      onCollapsedChanged: widget.onCollapsedChanged,
      body: FortalDashboardPageStack(selected: _selected, pages: _pages),
    );
    if (FortalDashboardThemeScope.maybeOf(context) != null) return demo;

    return FortalDashboardThemeScope(
      settings: _settings,
      onChanged: (next) => setState(() => _settings = next),
      child: _FortalDemoTheme(
        key: const ValueKey('dashboard-theme-scope'),
        mode: _resolveIsDark(context) ? .dark : .light,
        accent: _settings.accentColor,
        panelBackground: _settings.panelBackground,
        radius: _settings.radius,
        scaling: _settings.scaling,
        child: RemixToastScope(style: fortalToastStyle(), child: demo),
      ),
    );
  }
}

/// Tells a records page to drop every filter but its search.
final class _FilterReset extends ChangeNotifier {
  void fire() => notifyListeners();
}

/// Shows [selected] from [pages] and keeps the others alive behind it.
///
/// The page shown fades and rises into place. The others are not painted,
/// hit-tested, focusable or announced, and their animations are paused. They
/// also keep the size and the theme they last had on screen, so resizing the
/// window, collapsing the sidebar or changing the palette works on one page
/// instead of all of them.
class FortalDashboardPageStack extends StatefulWidget {
  const FortalDashboardPageStack({
    super.key,
    required this.selected,
    required this.pages,
  });

  /// The page on screen.
  final FortalDashboardDemoPage selected;

  /// The pages built so far.
  final Map<FortalDashboardDemoPage, Widget> pages;

  @override
  State<FortalDashboardPageStack> createState() =>
      _FortalDashboardPageStackState();
}

class _FortalDashboardPageStackState extends State<FortalDashboardPageStack>
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
  void didUpdateWidget(FortalDashboardPageStack oldWidget) {
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
      for (final page in FortalDashboardDemoPage.values)
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
  FortalDashboardThemeScope? _settings;
  Map<MixToken<Object?>, Object>? _tokens;
  List<Type>? _orderOfModifiers;
  DefaultTextStyle? _textRun;
  IconThemeData? _iconRun;

  @override
  Widget build(BuildContext context) {
    // Read on every build, hidden or not, so the slot stays subscribed and
    // is rebuilt, cheaply, when any of these changes.
    FortalTheme.maybeOf(context);
    final settings = FortalDashboardThemeScope.maybeOf(context);
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

    // Innermost first. The captured themes re-install the Fortal theme with
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
      page = FortalDashboardThemeScope(
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

RegistryDashboardAgentStyles _fortalAgentStyles() {
  final conversation = fortalAgentConversationRecipe();
  final message = fortalAgentMessageRecipe();
  final steps = fortalAgentStepsRecipe();
  final toolCall = fortalAgentToolCallRecipe();
  final answer = fortalAgentAnswerRecipe();
  final sources = fortalAgentSourcesRecipe();
  final suggestions = fortalAgentSuggestionsRecipe();
  final composer = fortalAgentComposerRecipe();
  return RegistryDashboardAgentStyles(
    buttonBuilder: (label, onPressed, tone) => switch (tone) {
      .primary => FortalButton(label: label, onPressed: onPressed),
      .soft => FortalButton.soft(label: label, onPressed: onPressed),
      .outline => FortalButton.outline(label: label, onPressed: onPressed),
    },
    glyphBuilder: fortalAgentGlyph,
    toolIconBuilder: fortalAgentToolIcon,
    composerLeadingBuilder: (onPressed) => FortalIconButton.outline(
      icon: RemixIcons.plus,
      semanticLabel: 'Add checkout context',
      onPressed: onPressed,
      style: IconButtonStyler()
          .wrap(WidgetModifierConfig.reset())
          .size(FortalTokens.space6(), FortalTokens.space6())
          .icon(.size(FortalTokens.space4()).color(FortalTokens.gray11()))
          .borderRadius(.circular(999)),
    ),
    heading: fortalTextStyle(size: .size6, weight: .bold),
    body: fortalTextStyle(size: .size1, highContrast: false),
    dockStyle: BoxStyler()
        .maxWidth(FortalTokens.messageContentMaxWidth())
        .padding(.horizontal(FortalTokens.space4())),
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
        .spacing(FortalTokens.space3()),
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
class FortalDashboardBreadcrumb extends StatelessWidget {
  const FortalDashboardBreadcrumb({super.key, required this.page});

  /// The page on screen.
  final FortalDashboardDemoPage page;

  @override
  Widget build(BuildContext context) => Padding(
    // The app bar insets its toolbar by `space4`; the page body uses the
    // wide page padding, so the difference lines the breadcrumb up with the
    // page title. In compact mode the menu button leads, so there is none.
    padding: EdgeInsetsDirectional.only(
      start: FortalSidebarLayoutScope.of(context).isCompact
          ? 0
          : 24 - FortalTokens.space4.resolve(context),
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
            style: IconStyler().size(12).color(FortalTokens.gray11()),
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
class _FortalDemoTheme extends FortalTheme {
  const _FortalDemoTheme({
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
    final root = FortalTheme.maybeOf(context) == null;
    final scope = super.build(context) as InheritedTheme;
    return scope.wrap(
      context,
      Builder(
        builder: (context) {
          final theme = FortalTheme.of(context);
          final foreground = MixScope.tokenOf(FortalTokens.gray12, context);
          final body = root
              ? MixScope.tokenOf(
                  FortalTokens.text3,
                  context,
                ).copyWith(fontWeight: FontWeight.w400)
              : DefaultTextStyle.of(context).style;
          return ColoredBox(
            color: theme.hasBackground
                ? MixScope.tokenOf(FortalTokens.colorBackground, context)
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
