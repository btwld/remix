import 'package:flutter/widgets.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import 'dashboard_demo_page_header.dart';
import 'dashboard_demo_records.dart';
import 'dashboard_demo_ui.dart';
import 'dashboard_demo_widgets.dart';

enum _OrderFilter { all, paid, pending, refunded, cancelled }

/// Shared layout for the selected-row badge cluster in the records toolbar.
final uiSelectedBadgesStyle = WrapBoxStyler()
    .spacing(6)
    .runSpacing(6)
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
        onPressed: () => _toast(context, 'Customer invitation started'),
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
              child: UiTextField(
                key: const ValueKey('customer-search'),
                leading: const StyledIcon(icon: RemixIcons.search),
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
                  UiBadge(
                    size: .size2,
                    highContrast: true,
                    label: '${_selectedIds.length} selected',
                  ),
                  UiButton.ghost(
                    size: .size1,
                    label: 'Export',
                    onPressed: () => _toast(
                      context,
                      'Export prepared for ${_selectedIds.length} customers',
                    ),
                  ),
                  UiButton.ghost(
                    size: .size1,
                    label: 'Archive',
                    onPressed: () => _toast(
                      context,
                      '${_selectedIds.length} customers archived',
                    ),
                  ),
                ],
              ),
          ],
        ),
        UiDataTable<UiDashboardCustomer>.surface(
          key: const ValueKey('data-grid-customers'),
          rows: page.items,
          columns: _customerColumns,
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
          emptyBuilder: (_) => const UiEmptyState(
            icon: RemixIcons.search,
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
      action: UiButton.soft(
        label: 'Export',
        leadingIcon: RemixIcons.download,
        onPressed: () => _toast(context, 'Order export prepared'),
      ),
      children: [
        Box(
          style: BoxStyler().alignment(.centerStart),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: UiSegmentedControl<_OrderFilter>(
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
        UiDataTable<UiDashboardOrder>.surface(
          key: const ValueKey('data-grid-orders'),
          rows: page.items,
          columns: _orderColumns,
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
          emptyBuilder: (_) => UiEmptyState(
            icon: LucideIcons.table,
            title: 'No matching orders',
            body: 'Choose another status to see more orders.',
            action: _filter == .all
                ? null
                : UiButton.soft(
                    size: .size1,
                    label: 'Clear filters',
                    onPressed: () => setState(() => _filter = .all),
                  ),
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

final _customerColumns = <RemixDataTableColumn<UiDashboardCustomer>>[
  RemixDataTableColumn(
    id: 'name',
    label: 'Customer',
    sortable: true,
    width: const FlexColumnWidth(2),
    cellBuilder: (_, customer) => RowBox(
      style: FlexBoxStyler()
          .mainAxisSize(.min)
          .crossAxisAlignment(.center)
          .spacing(9),
      children: [
        UiAvatar(size: .size2, label: customer.initials),
        Flexible(child: UiDataTableCellText(customer.name, primary: true)),
      ],
    ),
  ),
  RemixDataTableColumn(
    id: 'email',
    label: 'Email',
    width: const FlexColumnWidth(2),
    cellBuilder: (_, customer) => UiDataTableCellText(customer.email),
  ),
  RemixDataTableColumn(
    id: 'plan',
    label: 'Plan',
    width: const FixedColumnWidth(110),
    cellBuilder: (_, customer) =>
        UiDataTableCellText(customer.plan, primary: true),
  ),
  RemixDataTableColumn(
    id: 'status',
    label: 'Status',
    width: const FixedColumnWidth(110),
    cellBuilder: (_, customer) => UiStatusBadge.customer(customer.status),
  ),
  RemixDataTableColumn(
    id: 'joined',
    label: 'Joined',
    sortable: true,
    width: const FixedColumnWidth(118),
    cellBuilder: (_, customer) =>
        UiDataTableCellText(uiDashboardShortDate(customer.joinedAt)),
  ),
  RemixDataTableColumn(
    id: 'actions',
    header: const SizedBox.shrink(),
    semanticLabel: 'Actions',
    width: const FixedColumnWidth(64),
    alignment: AlignmentDirectional.centerEnd,
    cellBuilder: (context, customer) => UiActionMenu(
      key: ValueKey('customer-actions-${customer.id}'),
      semanticLabel: 'Actions for ${customer.name}',
      positioning: uiDataTableActionsPositioning,
      trigger: uiDataTableActionsTrigger,
      actions: const [
        UiAction(value: 'view', label: 'View profile'),
        UiAction(value: 'email', label: 'Send email'),
        UiAction(value: 'archive', label: 'Archive', dividerBefore: true),
      ],
      onSelected: (value) =>
          _toast(context, '$value selected for ${customer.name}'),
    ),
  ),
];

final _orderColumns = <RemixDataTableColumn<UiDashboardOrder>>[
  RemixDataTableColumn(
    id: 'id',
    label: 'Order',
    width: const FixedColumnWidth(120),
    cellBuilder: (_, order) => UiDataTableCellText(order.id, primary: true),
  ),
  RemixDataTableColumn(
    id: 'customer',
    label: 'Customer',
    width: const FlexColumnWidth(2),
    cellBuilder: (_, order) =>
        UiDataTableCellText(order.customer, primary: true),
  ),
  RemixDataTableColumn(
    id: 'date',
    label: 'Date',
    sortable: true,
    width: const FixedColumnWidth(120),
    cellBuilder: (_, order) =>
        UiDataTableCellText(uiDashboardShortDate(order.date)),
  ),
  RemixDataTableColumn(
    id: 'amount',
    label: 'Amount',
    sortable: true,
    width: const FixedColumnWidth(120),
    alignment: AlignmentDirectional.centerEnd,
    cellBuilder: (_, order) => UiDataTableCellText(
      '\$${order.amount.toStringAsFixed(2)}',
      primary: true,
    ),
  ),
  RemixDataTableColumn(
    id: 'status',
    label: 'Status',
    width: const FixedColumnWidth(118),
    cellBuilder: (_, order) => UiStatusBadge.order(order.status),
  ),
  RemixDataTableColumn(
    id: 'actions',
    header: const SizedBox.shrink(),
    semanticLabel: 'Actions',
    width: const FixedColumnWidth(64),
    alignment: AlignmentDirectional.centerEnd,
    cellBuilder: (context, order) => UiActionMenu(
      key: ValueKey('order-actions-${order.id}'),
      semanticLabel: 'Actions for ${order.id}',
      positioning: uiDataTableActionsPositioning,
      trigger: uiDataTableActionsTrigger,
      actions: const [
        UiAction(value: 'view', label: 'View order'),
        UiAction(value: 'receipt', label: 'Download receipt'),
        UiAction(value: 'refund', label: 'Issue refund', dividerBefore: true),
      ],
      onSelected: (value) => _toast(context, '$value selected for ${order.id}'),
    ),
  ),
];

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
        UiPageHeader(title: title, description: description, actions: action),
        ...children,
      ],
    ),
  );
}

void _toast(BuildContext context, String title) => showRemixToast(
  context,
  RemixToastData(title: title, icon: LucideIcons.circleCheck),
);
