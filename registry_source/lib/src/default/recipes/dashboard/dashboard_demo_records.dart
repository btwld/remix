import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../../dashboard/dashboard_demo_records.dart';
import '../../components/avatar.dart';
import '../../components/badge.dart';
import '../../components/button.dart';
import '../../components/data_table.dart';
import '../../components/menu.dart';
import '../../components/segmented_control.dart';
import '../../components/textfield.dart';
import '../../theme/tokens.dart';

enum _OrderFilter { all, paid, pending, refunded, cancelled }

class VanillaDashboardCustomersPage extends StatefulWidget {
  const VanillaDashboardCustomersPage({super.key, this.globalQuery = ''});
  final String globalQuery;

  @override
  State<VanillaDashboardCustomersPage> createState() =>
      _VanillaDashboardCustomersPageState();
}

class _VanillaDashboardCustomersPageState
    extends State<VanillaDashboardCustomersPage> {
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
    final filtered = registryDashboardCustomers.where((customer) {
      final haystack = '${customer.name} ${customer.email} ${customer.plan}'
          .toLowerCase();
      return haystack.contains(_query) && haystack.contains(globalQuery);
    }).toList()..sort(_compare);
    final page = registryDashboardPaginate(
      filtered,
      page: _page,
      rowsPerPage: _rowsPerPage,
    );
    return _Page(
      title: 'Customers',
      description: 'Manage customer access, plans, and account status.',
      action: VanillaButton(
        label: 'Add customer',
        leadingIcon: RemixIcons.plus,
        onPressed: () => _toast(context, 'Customer invitation started'),
      ),
      children: [
        WrapBox(
          style: WrapBoxStyler()
              .wrapAlignment(.spaceBetween)
              .crossAxisAlignment(.center)
              .spacing(VanillaTokens.s3)
              .runSpacing(VanillaTokens.s2_5),
          children: [
            Box(
              style: BoxStyler().maxWidth(300),
              child: VanillaTextField(
                key: const ValueKey('customer-search'),
                leading: const Icon(
                  RemixIcons.magnifyingGlass,
                  size: VanillaTokens.icon,
                ),
                hintText: 'Search customers…',
                onChanged: (value) => setState(() {
                  _query = value.trim().toLowerCase();
                  _page = 0;
                }),
              ),
            ),
            if (_selectedIds.isNotEmpty)
              WrapBox(
                style: WrapBoxStyler()
                    .spacing(VanillaTokens.s1_5)
                    .crossAxisAlignment(.center),
                children: [
                  VanillaBadge.secondary(
                    label: '${_selectedIds.length} selected',
                  ),
                  VanillaButton.ghost(
                    size: .small,
                    label: 'Export',
                    onPressed: () => _toast(
                      context,
                      'Export prepared for ${_selectedIds.length} customers',
                    ),
                  ),
                  VanillaButton.ghost(
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
        VanillaDataTable<RegistryDashboardCustomer>(
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

  int _compare(RegistryDashboardCustomer a, RegistryDashboardCustomer b) {
    final result = _sort.columnId == 'name'
        ? a.name.compareTo(b.name)
        : a.joinedAt.compareTo(b.joinedAt);
    return _sort.direction == .ascending ? result : -result;
  }
}

class VanillaDashboardOrdersPage extends StatefulWidget {
  const VanillaDashboardOrdersPage({super.key, this.globalQuery = ''});
  final String globalQuery;

  @override
  State<VanillaDashboardOrdersPage> createState() =>
      _VanillaDashboardOrdersPageState();
}

class _VanillaDashboardOrdersPageState
    extends State<VanillaDashboardOrdersPage> {
  _OrderFilter _filter = .all;
  RemixDataTableSort _sort = const RemixDataTableSort(
    columnId: 'date',
    direction: .descending,
  );
  int _page = 0;
  int _rowsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    final filtered = registryDashboardOrders.where((order) {
      final statusMatches =
          _filter == .all || order.status.name == _filter.name;
      final query = widget.globalQuery.toLowerCase();
      return statusMatches &&
          '${order.id} ${order.customer} ${order.status.name}'
              .toLowerCase()
              .contains(query);
    }).toList()..sort(_compare);
    final page = registryDashboardPaginate(
      filtered,
      page: _page,
      rowsPerPage: _rowsPerPage,
    );
    return _Page(
      title: 'Orders',
      description: 'Review transactions and fulfillment status.',
      action: VanillaButton(
        label: 'Export',
        leadingIcon: RemixIcons.download,
        onPressed: () => _toast(context, 'Order export prepared'),
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: VanillaSegmentedControl<_OrderFilter>(
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
        VanillaDataTable<RegistryDashboardOrder>(
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
                ? VanillaButton.outline(
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

  int _compare(RegistryDashboardOrder a, RegistryDashboardOrder b) {
    final result = _sort.columnId == 'amount'
        ? a.amount.compareTo(b.amount)
        : a.date.compareTo(b.date);
    return _sort.direction == .ascending ? result : -result;
  }
}

List<RemixDataTableColumn<RegistryDashboardCustomer>> _customerColumns(
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
          .spacing(VanillaTokens.s2),
      children: [
        VanillaAvatar(label: value.initials),
        Flexible(child: _Text(value.name, emphasized: true)),
      ],
    ),
  ),
  RemixDataTableColumn(
    id: 'email',
    label: 'Email',
    width: const FlexColumnWidth(2),
    cellBuilder: (_, value) => _Text(value.email),
  ),
  RemixDataTableColumn(
    id: 'plan',
    label: 'Plan',
    width: const FixedColumnWidth(110),
    cellBuilder: (_, value) => _Text(value.plan, emphasized: true),
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
      return _Text(registryDashboardShortDate(value.joinedAt));
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

List<RemixDataTableColumn<RegistryDashboardOrder>> _orderColumns(
  BuildContext context,
) => [
  RemixDataTableColumn(
    id: 'id',
    label: 'Order',
    width: const FixedColumnWidth(120),
    cellBuilder: (_, value) => _Text(value.id, emphasized: true),
  ),
  RemixDataTableColumn(
    id: 'customer',
    label: 'Customer',
    width: const FlexColumnWidth(2),
    cellBuilder: (_, value) => _Text(value.customer, emphasized: true),
  ),
  RemixDataTableColumn(
    id: 'date',
    label: 'Date',
    sortable: true,
    width: const FixedColumnWidth(120),
    cellBuilder: (_, value) => _Text(registryDashboardShortDate(value.date)),
  ),
  RemixDataTableColumn(
    id: 'amount',
    label: 'Amount',
    sortable: true,
    width: const FixedColumnWidth(120),
    alignment: AlignmentDirectional.centerEnd,
    cellBuilder: (_, value) =>
        _Text('\$${value.amount.toStringAsFixed(2)}', emphasized: true),
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

Widget _actions(BuildContext context, String value) => VanillaMenu<String>(
  trigger: RemixMenuTrigger.builder(
    label: 'Actions for $value',
    icon: RemixIcons.dotsHorizontal,
    builder: (_, _, _) => Semantics(
      label: 'Actions for $value',
      button: true,
      child: Box(
        style: BoxStyler()
            .size(28, 28)
            .alignment(.center)
            .borderRadius(.all(VanillaTokens.radiusSm())),
        child: StyledIcon(
          icon: RemixIcons.dotsHorizontal,
          style: IconStyler()
              .size(VanillaTokens.icon)
              .color(VanillaTokens.mutedForeground()),
        ),
      ),
    ),
  ),
  items: const [
    RemixMenuItem(value: 'view', label: 'View'),
    RemixMenuItem(value: 'download', label: 'Download'),
    RemixMenuDivider(),
    RemixMenuItem(value: 'archive', label: 'Archive'),
  ],
  onSelected: (action) => _toast(context, '$action selected for $value'),
);

Widget _status(String value) => switch (value) {
  'active' || 'paid' => VanillaBadge(label: value),
  'suspended' || 'cancelled' => VanillaBadge.destructive(label: value),
  'invited' || 'pending' => VanillaBadge.secondary(label: value),
  _ => VanillaBadge.outline(label: value),
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
    padding: const EdgeInsets.all(VanillaTokens.s8),
    child: ColumnBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(.stretch)
          .spacing(VanillaTokens.s5),
      children: [
        RowBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.start)
              .spacing(VanillaTokens.s4),
          children: [
            Expanded(
              child: ColumnBox(
                style: FlexBoxStyler()
                    .crossAxisAlignment(.start)
                    .spacing(VanillaTokens.s1),
                children: [
                  _Text(title, token: VanillaTokens.text3xl, emphasized: true),
                  _Text(description, muted: true),
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
    style: BoxStyler().padding(.all(VanillaTokens.s8)),
    child: ColumnBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(.center)
          .spacing(VanillaTokens.s3),
      children: [
        Box(
          style: BoxStyler()
              .size(40, 40)
              .alignment(.center)
              .borderRadius(.all(VanillaTokens.radiusMd()))
              .color(VanillaTokens.secondary()),
          child: StyledIcon(
            icon: RemixIcons.magnifyingGlass,
            style: IconStyler()
                .size(VanillaTokens.s5)
                .color(VanillaTokens.secondaryForeground()),
          ),
        ),
        ColumnBox(
          style: FlexBoxStyler()
              .crossAxisAlignment(.center)
              .spacing(VanillaTokens.s1),
          children: [_Text(title, emphasized: true), _Text(body, muted: true)],
        ),
        ?action,
      ],
    ),
  );
}

class _Text extends StatelessWidget {
  const _Text(
    this.value, {
    this.token = VanillaTokens.textSm,
    this.emphasized = false,
    this.muted = false,
  });
  final String value;
  final TextStyleToken token;
  final bool emphasized;
  final bool muted;
  @override
  Widget build(BuildContext context) => StyledText(
    value,
    style: TextStyler()
        .style(token.mix())
        .fontWeight(emphasized ? FontWeight.w600 : FontWeight.w400)
        .color(
          muted ? VanillaTokens.mutedForeground() : VanillaTokens.foreground(),
        ),
  );
}

void _toast(BuildContext context, String title) => showRemixToast(
  context,
  RemixToastData(title: title, icon: RemixIcons.checkCircled),
);
void _noop() {}
