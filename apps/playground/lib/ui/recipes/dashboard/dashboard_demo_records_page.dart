import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/avatar.dart';
import '../../components/badge.dart';
import '../../components/button.dart';
import '../../components/data_table.dart';
import '../../components/icon_button.dart';
import '../../components/menu.dart';
import '../../components/segmented_control.dart';
import '../../components/textfield.dart';
import '../../theme/tokens.dart';
import 'dashboard_demo_records.dart';
import 'dashboard_demo_text.dart';

enum _OrderFilter { all, paid, pending, refunded, cancelled }

/// Shared layout for the selected-row badge cluster in the records toolbar.
final playgroundSelectedBadgesStyle = WrapBoxStyler()
    .spacing(PlaygroundTokens.s1_5)
    .crossAxisAlignment(.center);

class PlaygroundDashboardCustomersPage extends StatefulWidget {
  const PlaygroundDashboardCustomersPage({super.key, this.globalQuery = ''});
  final String globalQuery;

  @override
  State<PlaygroundDashboardCustomersPage> createState() =>
      _PlaygroundDashboardCustomersPageState();
}

class _PlaygroundDashboardCustomersPageState
    extends State<PlaygroundDashboardCustomersPage> {
  String _query = '';
  RemixDataTableSort _sort = const RemixDataTableSort(
    columnId: 'joined',
    direction: .descending,
  );
  Set<Object> _selectedIds = {};
  int _page = 0;
  int _rowsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    final globalQuery = widget.globalQuery.toLowerCase();
    final filtered = playgroundDashboardCustomers.where((customer) {
      final haystack = '${customer.name} ${customer.email} ${customer.plan}'
          .toLowerCase();
      return haystack.contains(_query) && haystack.contains(globalQuery);
    }).toList()..sort(_compare);
    final page = playgroundDashboardPaginate(
      filtered,
      page: _page,
      rowsPerPage: _rowsPerPage,
    );
    return _Page(
      title: 'Customers',
      description: 'Manage customer access, plans, and account status.',
      action: PlaygroundButton(
        label: 'Add customer',
        leadingIcon: RemixIcons.plus,
        onPressed: () =>
            playgroundDashboardToast(context, 'Customer invitation started'),
      ),
      children: [
        WrapBox(
          style: WrapBoxStyler()
              .wrapAlignment(.spaceBetween)
              .crossAxisAlignment(.center)
              .spacing(PlaygroundTokens.s3)
              .runSpacing(PlaygroundTokens.s2_5),
          children: [
            Box(
              style: BoxStyler().maxWidth(300),
              child: PlaygroundTextField(
                key: const ValueKey('customer-search'),
                leading: const StyledIcon(icon: RemixIcons.magnifyingGlass),
                hintText: 'Search customers…',
                onChanged: (value) => setState(() {
                  _query = value.trim().toLowerCase();
                  _page = 0;
                }),
              ),
            ),
            if (_selectedIds.isNotEmpty)
              playgroundSelectedBadgesStyle(
                children: [
                  PlaygroundBadge.secondary(
                    label: '${_selectedIds.length} selected',
                  ),
                  PlaygroundButton.ghost(
                    size: .small,
                    label: 'Export',
                    onPressed: () => playgroundDashboardToast(
                      context,
                      'Export prepared for ${_selectedIds.length} customers',
                    ),
                  ),
                  PlaygroundButton.ghost(
                    size: .small,
                    label: 'Archive',
                    onPressed: () => showRemixToast(
                      context,
                      RemixToastData(
                        title: '${_selectedIds.length} customers archived',
                        icon: RemixIcons.checkCircled,
                        action: const RemixToastAction(
                          label: 'Undo',
                          onPressed: _noop,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        PlaygroundDataTable<PlaygroundDashboardCustomer>(
          key: const ValueKey('data-grid-customers'),
          rows: page.items,
          columns: _customerColumns(context),
          semanticLabel: 'Customers',
          minimumWidth: 840,
          sort: _sort,
          onSortChanged: (sort) => setState(() {
            _sort = sort;
            _page = 0;
          }),
          rowId: (customer) => customer.id,
          selectedRowIds: _selectedIds,
          onSelectionChanged: (ids) => setState(() => _selectedIds = ids),
          totalRows: filtered.length,
          pageIndex: page.page,
          pageSize: _rowsPerPage,
          pageSizeOptions: const [5, 10, 20],
          onPageChanged: (value) => setState(() => _page = value),
          onPageSizeChanged: (value) => setState(() {
            _rowsPerPage = value;
            _page = 0;
          }),
          emptyBuilder: (_) => const _Empty(
            title: 'No customers found',
            body: 'Try a different name or email address.',
          ),
        ),
      ],
    );
  }

  int _compare(PlaygroundDashboardCustomer a, PlaygroundDashboardCustomer b) {
    final result = _sort.columnId == 'name'
        ? a.name.compareTo(b.name)
        : a.joinedAt.compareTo(b.joinedAt);
    return _sort.direction == .ascending ? result : -result;
  }
}

class PlaygroundDashboardOrdersPage extends StatefulWidget {
  const PlaygroundDashboardOrdersPage({super.key, this.globalQuery = ''});
  final String globalQuery;

  @override
  State<PlaygroundDashboardOrdersPage> createState() =>
      _PlaygroundDashboardOrdersPageState();
}

class _PlaygroundDashboardOrdersPageState
    extends State<PlaygroundDashboardOrdersPage> {
  _OrderFilter _filter = .all;
  RemixDataTableSort _sort = const RemixDataTableSort(
    columnId: 'date',
    direction: .descending,
  );
  int _page = 0;
  int _rowsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    final filtered = playgroundDashboardOrders.where((order) {
      final statusMatches =
          _filter == .all || order.status.name == _filter.name;
      final query = widget.globalQuery.toLowerCase();
      return statusMatches &&
          '${order.id} ${order.customer} ${order.status.name}'
              .toLowerCase()
              .contains(query);
    }).toList()..sort(_compare);
    final page = playgroundDashboardPaginate(
      filtered,
      page: _page,
      rowsPerPage: _rowsPerPage,
    );
    return _Page(
      title: 'Orders',
      description: 'Review transactions and fulfillment status.',
      action: PlaygroundButton(
        label: 'Export',
        leadingIcon: RemixIcons.download,
        onPressed: () =>
            playgroundDashboardToast(context, 'Order export prepared'),
      ),
      children: [
        Box(
          style: BoxStyler().alignment(.centerStart),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: PlaygroundSegmentedControl<_OrderFilter>(
              semanticLabel: 'Filter orders by status',
              selectedValue: _filter,
              items: const [
                RemixSegmentedControlItem(value: .all, label: 'All'),
                RemixSegmentedControlItem(value: .paid, label: 'Paid'),
                RemixSegmentedControlItem(value: .pending, label: 'Pending'),
                RemixSegmentedControlItem(value: .refunded, label: 'Refunded'),
                RemixSegmentedControlItem(
                  value: .cancelled,
                  label: 'Cancelled',
                ),
              ],
              onChanged: (value) => setState(() {
                _filter = value;
                _page = 0;
              }),
            ),
          ),
        ),
        PlaygroundDataTable<PlaygroundDashboardOrder>(
          key: const ValueKey('data-grid-orders'),
          rows: page.items,
          columns: _orderColumns(context),
          semanticLabel: 'Orders',
          minimumWidth: 840,
          sort: _sort,
          onSortChanged: (sort) => setState(() {
            _sort = sort;
            _page = 0;
          }),
          totalRows: filtered.length,
          pageIndex: page.page,
          pageSize: _rowsPerPage,
          pageSizeOptions: const [5, 10, 20],
          onPageChanged: (value) => setState(() => _page = value),
          onPageSizeChanged: (value) => setState(() {
            _rowsPerPage = value;
            _page = 0;
          }),
          emptyBuilder: (_) => _Empty(
            title: 'No matching orders',
            body: 'Choose another status to see more orders.',
            action: _filter != .all
                ? PlaygroundButton.outline(
                    size: .small,
                    label: 'Clear filters',
                    onPressed: () => setState(() => _filter = .all),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  int _compare(PlaygroundDashboardOrder a, PlaygroundDashboardOrder b) {
    final result = _sort.columnId == 'amount'
        ? a.amount.compareTo(b.amount)
        : a.date.compareTo(b.date);
    return _sort.direction == .ascending ? result : -result;
  }
}

List<RemixDataTableColumn<PlaygroundDashboardCustomer>> _customerColumns(
  BuildContext context,
) => [
  RemixDataTableColumn(
    id: 'name',
    label: 'Customer',
    sortable: true,
    width: const FlexColumnWidth(2),
    cellBuilder: (_, value) => RowBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(.center)
          .spacing(PlaygroundTokens.s2),
      children: [
        PlaygroundAvatar(label: value.initials),
        Flexible(child: PlaygroundDashboardText(value.name, emphasized: true)),
      ],
    ),
  ),
  RemixDataTableColumn(
    id: 'email',
    label: 'Email',
    width: const FlexColumnWidth(2),
    cellBuilder: (_, value) => PlaygroundDashboardText(value.email),
  ),
  RemixDataTableColumn(
    id: 'plan',
    label: 'Plan',
    width: const FixedColumnWidth(110),
    cellBuilder: (_, value) =>
        PlaygroundDashboardText(value.plan, emphasized: true),
  ),
  RemixDataTableColumn(
    id: 'status',
    label: 'Status',
    width: const FixedColumnWidth(110),
    cellBuilder: (_, value) => _status(value.status.name),
  ),
  RemixDataTableColumn(
    id: 'joined',
    label: 'Joined',
    sortable: true,
    width: const FixedColumnWidth(118),
    cellBuilder: (_, value) {
      return PlaygroundDashboardText(
        playgroundDashboardShortDate(value.joinedAt),
      );
    },
  ),
  RemixDataTableColumn(
    id: 'actions',
    header: const SizedBox.shrink(),
    semanticLabel: 'Actions',
    width: const FixedColumnWidth(64),
    cellBuilder: (_, value) => _actions(context, value.name),
  ),
];

List<RemixDataTableColumn<PlaygroundDashboardOrder>> _orderColumns(
  BuildContext context,
) => [
  RemixDataTableColumn(
    id: 'id',
    label: 'Order',
    width: const FixedColumnWidth(120),
    cellBuilder: (_, value) =>
        PlaygroundDashboardText(value.id, emphasized: true),
  ),
  RemixDataTableColumn(
    id: 'customer',
    label: 'Customer',
    width: const FlexColumnWidth(2),
    cellBuilder: (_, value) =>
        PlaygroundDashboardText(value.customer, emphasized: true),
  ),
  RemixDataTableColumn(
    id: 'date',
    label: 'Date',
    sortable: true,
    width: const FixedColumnWidth(120),
    cellBuilder: (_, value) =>
        PlaygroundDashboardText(playgroundDashboardShortDate(value.date)),
  ),
  RemixDataTableColumn(
    id: 'amount',
    label: 'Amount',
    sortable: true,
    width: const FixedColumnWidth(120),
    alignment: AlignmentDirectional.centerEnd,
    cellBuilder: (_, value) => PlaygroundDashboardText(
      '\$${value.amount.toStringAsFixed(2)}',
      emphasized: true,
    ),
  ),
  RemixDataTableColumn(
    id: 'status',
    label: 'Status',
    width: const FixedColumnWidth(118),
    cellBuilder: (_, value) => _status(value.status.name),
  ),
  RemixDataTableColumn(
    id: 'actions',
    header: const SizedBox.shrink(),
    semanticLabel: 'Actions',
    width: const FixedColumnWidth(64),
    cellBuilder: (_, value) => _actions(context, value.id),
  ),
];

Widget _actions(BuildContext context, String value) => PlaygroundMenu<String>(
  trigger: RemixMenuTrigger.control(
    builder: (_, menu) => PlaygroundIconButton.ghost(
      size: .small,
      icon: RemixIcons.dotsHorizontal,
      semanticLabel: 'Actions for $value',
      focusNode: menu.focusNode,
      onPressed: menu.toggle,
      style: IconButtonStyler().icon(
        .color(PlaygroundTokens.mutedForeground()),
      ),
    ),
  ),
  items: const [
    RemixMenuItem(value: 'view', label: 'View'),
    RemixMenuItem(value: 'download', label: 'Download'),
    RemixMenuDivider(),
    RemixMenuItem(value: 'archive', label: 'Archive'),
  ],
  onSelected: (action) =>
      playgroundDashboardToast(context, '$action selected for $value'),
);

Widget _status(String value) => switch (value) {
  'active' || 'paid' => PlaygroundBadge(label: value),
  'suspended' || 'cancelled' => PlaygroundBadge.destructive(label: value),
  'invited' || 'pending' => PlaygroundBadge.secondary(label: value),
  _ => PlaygroundBadge.outline(label: value),
};

class _Page extends StatelessWidget {
  const _Page({
    required this.title,
    required this.description,
    required this.action,
    required this.children,
  });
  final String title;
  final String description;
  final Widget action;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(PlaygroundTokens.s8),
    child: ColumnBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(.stretch)
          .spacing(PlaygroundTokens.s5),
      children: [
        RowBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.start)
              .spacing(PlaygroundTokens.s4),
          children: [
            Expanded(
              child: ColumnBox(
                style: FlexBoxStyler()
                    .crossAxisAlignment(.start)
                    .spacing(PlaygroundTokens.s1),
                children: [
                  PlaygroundDashboardText(
                    title,
                    token: PlaygroundTokens.text3xl,
                    emphasized: true,
                  ),
                  PlaygroundDashboardText(description, muted: true),
                ],
              ),
            ),
            action,
          ],
        ),
        ...children,
      ],
    ),
  );
}

class _Empty extends StatelessWidget {
  const _Empty({required this.title, required this.body, this.action});
  final String title;
  final String body;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Box(
    style: BoxStyler().padding(.all(PlaygroundTokens.s8)),
    child: ColumnBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(.center)
          .spacing(PlaygroundTokens.s3),
      children: [
        Box(
          style: BoxStyler()
              .size(40, 40)
              .alignment(.center)
              .borderRadius(.all(PlaygroundTokens.radiusMd()))
              .color(PlaygroundTokens.secondary()),
          child: StyledIcon(
            icon: RemixIcons.magnifyingGlass,
            style: IconStyler()
                .size(PlaygroundTokens.s5)
                .color(PlaygroundTokens.secondaryForeground()),
          ),
        ),
        ColumnBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.center)
              .spacing(PlaygroundTokens.s1),
          children: [
            PlaygroundDashboardText(title, emphasized: true),
            PlaygroundDashboardText(body, muted: true),
          ],
        ),
        ?action,
      ],
    ),
  );
}

void _noop() {}
