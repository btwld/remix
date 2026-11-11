import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../components/avatar.dart';
import '../../components/button.dart';
import '../../components/checkbox.dart';
import '../../components/chip.dart';
import '../../components/dropdown.dart';
import '../../components/search_field.dart';
import '../../components/table.dart';
import '../../theme/theme.dart';
import 'dashboard_demo_records.dart';
import 'dashboard_demo_text.dart';
import 'dashboard_overview.dart';

enum _OrderFilter { all, paid, pending, refunded, cancelled }

/// Shared layout for the selected-row cluster in the records toolbar.
final uiSelectedBadgesStyle = WrapBoxStyler()
    .spacing(6)
    .crossAxisAlignment(.center);

class UiDashboardCustomersPage extends StatefulWidget {
  const UiDashboardCustomersPage({super.key, this.globalQuery = ''});
  final String globalQuery;

  @override
  State<UiDashboardCustomersPage> createState() =>
      _UiDashboardCustomersPageState();
}

class _UiDashboardCustomersPageState extends State<UiDashboardCustomersPage> {
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
    final filtered = uiDashboardCustomers.where((customer) {
      final haystack = '${customer.name} ${customer.email} ${customer.plan}'
          .toLowerCase();
      return haystack.contains(_query) && haystack.contains(globalQuery);
    }).toList()..sort(_compare);
    final page = uiDashboardPaginate(
      filtered,
      page: _page,
      rowsPerPage: _rowsPerPage,
    );
    return _Page(
      title: 'Customers',
      description: 'Manage customer access, plans, and account status.',
      action: UiButton(
        label: 'Add customer',
        leadingIcon: RemixIcons.plus,
        onPressed: () =>
            uiDashboardToast(context, 'Customer invitation started'),
      ),
      children: [
        WrapBox(
          style: WrapBoxStyler()
              .wrapAlignment(.spaceBetween)
              .crossAxisAlignment(.center)
              .spacing(12)
              .runSpacing(10),
          children: [
            Box(
              style: BoxStyler().maxWidth(300),
              child: UiSearchField(
                key: const ValueKey('customer-search'),
                leading: const UiSearchIcon(),
                hintText: 'Search customers…',
                onChanged: (value) => setState(() {
                  _query = value.trim().toLowerCase();
                  _page = 0;
                }),
              ),
            ),
            if (_selectedIds.isNotEmpty)
              uiSelectedBadgesStyle(
                children: [
                  UiChip.soft(
                    color: .accent,
                    label: '${_selectedIds.length} selected',
                  ),
                  UiButton.ghost(
                    size: .sm,
                    label: 'Export',
                    onPressed: () => uiDashboardToast(
                      context,
                      'Export prepared for ${_selectedIds.length} customers',
                    ),
                  ),
                  UiButton.ghost(
                    size: .sm,
                    label: 'Archive',
                    onPressed: () => showRemixToast(
                      context,
                      RemixToastData(
                        title: '${_selectedIds.length} customers archived',
                        icon: RemixIcons.checkCircle,
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
        UiTable<UiDashboardCustomer>(
          key: const ValueKey('data-grid-customers'),
          // Rows sit on `surface`, the primary checkbox's own fill, so the
          // selection column takes the `secondary` checkbox, edged so an
          // unchecked box shows on the card.
          style: DataTableStyler().selectionCheckbox(
            uiCheckboxStyle(
              variant: .secondary,
              style: uiDashboardCardCheckboxStyle,
            ),
          ),
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

  int _compare(UiDashboardCustomer a, UiDashboardCustomer b) {
    final result = _sort.columnId == 'name'
        ? a.name.compareTo(b.name)
        : a.joinedAt.compareTo(b.joinedAt);
    return _sort.direction == .ascending ? result : -result;
  }
}

class UiDashboardOrdersPage extends StatefulWidget {
  const UiDashboardOrdersPage({super.key, this.globalQuery = ''});
  final String globalQuery;

  @override
  State<UiDashboardOrdersPage> createState() => _UiDashboardOrdersPageState();
}

class _UiDashboardOrdersPageState extends State<UiDashboardOrdersPage> {
  _OrderFilter _filter = .all;
  RemixDataTableSort _sort = const RemixDataTableSort(
    columnId: 'date',
    direction: .descending,
  );
  int _page = 0;
  int _rowsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    final filtered = uiDashboardOrders.where((order) {
      final statusMatches =
          _filter == .all || order.status.name == _filter.name;
      final query = widget.globalQuery.toLowerCase();
      return statusMatches &&
          '${order.id} ${order.customer} ${order.status.name}'
              .toLowerCase()
              .contains(query);
    }).toList()..sort(_compare);
    final page = uiDashboardPaginate(
      filtered,
      page: _page,
      rowsPerPage: _rowsPerPage,
    );
    return _Page(
      title: 'Orders',
      description: 'Review transactions and fulfillment status.',
      action: UiButton(
        label: 'Export',
        leadingIcon: RemixIcons.download,
        onPressed: () => uiDashboardToast(context, 'Order export prepared'),
      ),
      children: [
        Box(
          style: BoxStyler().alignment(.centerStart),
          child: UiDashboardSegments<_OrderFilter>(
            semanticLabel: 'Filter orders by status',
            selectedValue: _filter,
            items: const [
              (value: .all, label: 'All'),
              (value: .paid, label: 'Paid'),
              (value: .pending, label: 'Pending'),
              (value: .refunded, label: 'Refunded'),
              (value: .cancelled, label: 'Cancelled'),
            ],
            onChanged: (value) => setState(() {
              _filter = value;
              _page = 0;
            }),
          ),
        ),
        UiTable<UiDashboardOrder>(
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
                ? UiButton.outline(
                    size: .sm,
                    label: 'Clear filters',
                    onPressed: () => setState(() => _filter = .all),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  int _compare(UiDashboardOrder a, UiDashboardOrder b) {
    final result = _sort.columnId == 'amount'
        ? a.amount.compareTo(b.amount)
        : a.date.compareTo(b.date);
    return _sort.direction == .ascending ? result : -result;
  }
}

List<RemixDataTableColumn<UiDashboardCustomer>> _customerColumns(
  BuildContext context,
) => [
  RemixDataTableColumn(
    id: 'name',
    label: 'Customer',
    sortable: true,
    width: const FlexColumnWidth(2),
    cellBuilder: (_, value) => RowBox(
      style: FlexBoxStyler().crossAxisAlignment(.center).spacing(8),
      children: [
        UiAvatar.soft(label: value.initials, size: .sm),
        Flexible(child: UiDashboardText(value.name, emphasized: true)),
      ],
    ),
  ),
  RemixDataTableColumn(
    id: 'email',
    label: 'Email',
    width: const FlexColumnWidth(2),
    cellBuilder: (_, value) => UiDashboardText(value.email, muted: true),
  ),
  RemixDataTableColumn(
    id: 'plan',
    label: 'Plan',
    width: const FixedColumnWidth(110),
    cellBuilder: (_, value) => UiDashboardText(value.plan, emphasized: true),
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
    // A date on one line inside the table's 16px cell insets.
    width: const FixedColumnWidth(136),
    cellBuilder: (_, value) =>
        UiDashboardText(uiDashboardShortDate(value.joinedAt)),
  ),
  RemixDataTableColumn(
    id: 'actions',
    header: const SizedBox.shrink(),
    semanticLabel: 'Actions',
    width: const FixedColumnWidth(64),
    cellBuilder: (_, value) => _actions(context, value.name),
  ),
];

List<RemixDataTableColumn<UiDashboardOrder>> _orderColumns(
  BuildContext context,
) => [
  RemixDataTableColumn(
    id: 'id',
    label: 'Order',
    width: const FixedColumnWidth(120),
    cellBuilder: (_, value) => UiDashboardText(value.id, emphasized: true),
  ),
  RemixDataTableColumn(
    id: 'customer',
    label: 'Customer',
    width: const FlexColumnWidth(2),
    cellBuilder: (_, value) =>
        UiDashboardText(value.customer, emphasized: true),
  ),
  RemixDataTableColumn(
    id: 'date',
    label: 'Date',
    sortable: true,
    width: const FixedColumnWidth(136),
    cellBuilder: (_, value) =>
        UiDashboardText(uiDashboardShortDate(value.date)),
  ),
  RemixDataTableColumn(
    id: 'amount',
    label: 'Amount',
    sortable: true,
    width: const FixedColumnWidth(120),
    alignment: AlignmentDirectional.centerEnd,
    cellBuilder: (_, value) => UiDashboardText(
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

Widget _actions(BuildContext context, String value) => UiDropdown<String>(
  trigger: RemixMenuTrigger.control(
    builder: (_, menu) => UiIconButton.ghost(
      size: .sm,
      icon: RemixIcons.more,
      semanticLabel: 'Actions for $value',
      focusNode: menu.focusNode,
      onPressed: menu.toggle,
      style: _kebabStyle(open: menu.isOpen),
    ),
  ),
  items: [
    const RemixMenuItem(value: 'view', label: 'View'),
    const RemixMenuItem(value: 'download', label: 'Download'),
    const RemixMenuDivider(),
    RemixMenuItem(
      value: 'archive',
      label: 'Archive',
      style: uiDropdownItemStyle(variant: .danger),
    ),
  ],
  onSelected: (action) =>
      uiDashboardToast(context, '$action selected for $value'),
);

/// The kebab: a `muted` glyph, filled with `default` while its menu is open.
/// Hover and press come after the base in Mix, so the open look repeats there
/// to stay in force under the pointer.
IconButtonStyler _kebabStyle({required bool open}) {
  final resting = IconButtonStyler().icon(.color(UiTokens.muted()));
  if (!open) return resting;

  final filled = IconButtonStyler()
      .color(UiTokens.defaultColor())
      .icon(.color(UiTokens.defaultForeground()));

  return filled.onHovered(filled).onPressed(filled);
}

Widget _status(String value) => Align(
  alignment: AlignmentDirectional.centerStart,
  child: uiDashboardStatusChip(value),
);

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
    padding: const EdgeInsets.all(32),
    child: ColumnBox(
      style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(20),
      children: [
        RowBox(
          style: FlexBoxStyler().crossAxisAlignment(.start).spacing(16),
          children: [
            Expanded(
              child: ColumnBox(
                style: FlexBoxStyler().crossAxisAlignment(.start).spacing(4),
                children: [
                  UiDashboardText(title, type: .h3),
                  UiDashboardText(description, muted: true),
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
    style: BoxStyler().padding(.all(32)),
    child: ColumnBox(
      style: FlexBoxStyler().crossAxisAlignment(.center).spacing(12),
      children: [
        Box(
          style: BoxStyler()
              .size(40, 40)
              .alignment(.center)
              .borderRadius(.all(UiTokens.radiusXl()))
              .color(UiTokens.defaultColor()),
          child: StyledIcon(
            icon: RemixIcons.search,
            style: IconStyler().size(20).color(UiTokens.defaultForeground()),
          ),
        ),
        ColumnBox(
          style: FlexBoxStyler().crossAxisAlignment(.center).spacing(4),
          children: [
            UiDashboardText(title, emphasized: true),
            UiDashboardText(body, muted: true),
          ],
        ),
        ?action,
      ],
    ),
  );
}

void _noop() {}
