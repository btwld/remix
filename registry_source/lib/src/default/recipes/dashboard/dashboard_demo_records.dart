import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../../dashboard/dashboard_demo_records.dart';
import '../../components/avatar.dart';
import '../../components/badge.dart';
import '../../components/button.dart';
import '../../components/data_table.dart';
import '../../components/icon_button.dart';
import '../../components/menu.dart';
import '../../components/segmented_control.dart';
import '../../components/textfield.dart';
import '../../theme/tokens.dart';
import 'dashboard_demo_text.dart';

enum _OrderFilter { all, paid, pending, refunded, cancelled }

/// Shared layout for the selected-row badge cluster in the records toolbar.
final vanillaSelectedBadgesStyle = WrapBoxStyler()
    .spacing(VanillaTokens.s1_5)
    .crossAxisAlignment(.center);

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
        onPressed: () =>
            vanillaDashboardToast(context, 'Customer invitation started'),
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
                leading: const StyledIcon(icon: RemixIcons.magnifyingGlass),
                hintText: 'Search customers…',
                onChanged: (value) => setState(() {
                  _query = value.trim().toLowerCase();
                  _page = 0;
                }),
              ),
            ),
            if (_selectedIds.isNotEmpty)
              vanillaSelectedBadgesStyle(
                children: [
                  VanillaBadge.secondary(
                    label: '${_selectedIds.length} selected',
                  ),
                  VanillaButton.ghost(
                    size: .small,
                    label: 'Export',
                    onPressed: () => vanillaDashboardToast(
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
        onPressed: () =>
            vanillaDashboardToast(context, 'Order export prepared'),
      ),
      children: [
        Box(
          style: BoxStyler().alignment(.centerStart),
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
        Flexible(child: VanillaDashboardText(value.name, emphasized: true)),
      ],
    ),
  ),
  RemixDataTableColumn(
    id: 'email',
    label: 'Email',
    width: const FlexColumnWidth(2),
    cellBuilder: (_, value) => VanillaDashboardText(value.email),
  ),
  RemixDataTableColumn(
    id: 'plan',
    label: 'Plan',
    width: const FixedColumnWidth(110),
    cellBuilder: (_, value) =>
        VanillaDashboardText(value.plan, emphasized: true),
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
      return VanillaDashboardText(registryDashboardShortDate(value.joinedAt));
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
    cellBuilder: (_, value) => VanillaDashboardText(value.id, emphasized: true),
  ),
  RemixDataTableColumn(
    id: 'customer',
    label: 'Customer',
    width: const FlexColumnWidth(2),
    cellBuilder: (_, value) =>
        VanillaDashboardText(value.customer, emphasized: true),
  ),
  RemixDataTableColumn(
    id: 'date',
    label: 'Date',
    sortable: true,
    width: const FixedColumnWidth(120),
    cellBuilder: (_, value) =>
        VanillaDashboardText(registryDashboardShortDate(value.date)),
  ),
  RemixDataTableColumn(
    id: 'amount',
    label: 'Amount',
    sortable: true,
    width: const FixedColumnWidth(120),
    alignment: AlignmentDirectional.centerEnd,
    cellBuilder: (_, value) => VanillaDashboardText(
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

Widget _actions(BuildContext context, String value) => VanillaMenu<String>(
  trigger: RemixMenuTrigger.control(
    builder: (_, menu) => VanillaIconButton.ghost(
      size: .small,
      icon: RemixIcons.dotsHorizontal,
      semanticLabel: 'Actions for $value',
      focusNode: menu.focusNode,
      onPressed: menu.toggle,
      style: _kebabStyle(open: menu.isOpen),
    ),
  ),
  items: const [
    RemixMenuItem(value: 'view', label: 'View'),
    RemixMenuItem(value: 'download', label: 'Download'),
    RemixMenuDivider(),
    RemixMenuItem(value: 'archive', label: 'Archive'),
  ],
  onSelected: (action) =>
      vanillaDashboardToast(context, '$action selected for $value'),
);

/// The kebab: a muted glyph, filled with `muted` while its menu is open. Hover
/// and press come after the base in Mix, so the open look repeats there to stay
/// in force under the pointer.
IconButtonStyler _kebabStyle({required bool open}) {
  final resting = IconButtonStyler().icon(
    .color(VanillaTokens.mutedForeground()),
  );
  if (!open) return resting;

  final filled = resting.color(VanillaTokens.muted());

  return filled.onHovered(filled).onPressed(filled);
}

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
                  VanillaDashboardText(
                    title,
                    token: VanillaTokens.text3xl,
                    emphasized: true,
                  ),
                  VanillaDashboardText(description, muted: true),
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
          children: [
            VanillaDashboardText(title, emphasized: true),
            VanillaDashboardText(body, muted: true),
          ],
        ),
        ?action,
      ],
    ),
  );
}

void _noop() {}
