import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import 'dashboard_demo_data.dart';
import 'dashboard_demo_page_header.dart';
import 'dashboard_demo_text.dart';
import 'dashboard_demo_theme.dart';
import 'dashboard_demo_typography.dart';
import 'dashboard_demo_ui.dart';
import 'dashboard_demo_widgets.dart';
import 'dashboard_overview.dart';

/// The tiers the Customers page filters by, after everyone.
enum _TierFilter {
  all('All'),
  patron('Patron'),
  collector('Collector'),
  member('Member');

  const _TierFilter(this.label);

  final String label;

  bool matches(UiDashboardCustomerTier tier) =>
      this == all || name == tier.name;
}

/// The statuses the Orders page filters by, after everything.
enum _OrderFilter {
  all,
  paid,
  pending,
  shipped,
  refunded,
  cancelled;

  bool matches(UiDashboardOrderStatus status) =>
      this == all || name == status.name;
}

/// One figure summarizing a table, on a quiet surface.
class UiRecordStat extends StatelessWidget {
  const UiRecordStat({
    super.key,
    required this.label,
    required this.value,
    required this.detail,
  });

  /// What the figure counts.
  final String label;

  /// The figure, already formatted.
  final String value;

  /// A line of context under the figure.
  final String detail;

  @override
  Widget build(BuildContext context) => UiSurface(
    emphasis: .quiet,
    child: ColumnBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(.start)
          .spacing(UiTokens.space1()),
      children: [
        StyledText(label, style: dashboardTextLine(.size2, tone: .muted)),
        UiText(value, size: .size6, weight: .bold, truncate: true),
        StyledText(detail, style: dashboardTextLine(.size1, tone: .subtle)),
      ],
    ),
  );
}

/// The Customers page: a searchable, sortable, selectable table of
/// collectors under four summary figures.
class UiDashboardCustomersPage extends StatefulWidget {
  const UiDashboardCustomersPage({
    super.key,
    this.data,
    this.searchController,
    this.filterReset,
  });

  /// The records the page shows. Defaults to [uiDashboardSampleData].
  final UiDashboardData? data;

  /// Controls the search field, so a host can fill it. The page creates its
  /// own when null.
  final TextEditingController? searchController;

  /// Notifies when the page should drop every filter but its search. A host
  /// that fills the search to show one record fires it, so a filter left on
  /// from earlier cannot hide that record.
  final Listenable? filterReset;

  @override
  State<UiDashboardCustomersPage> createState() =>
      _UiDashboardCustomersPageState();
}

class _UiDashboardCustomersPageState extends State<UiDashboardCustomersPage> {
  TextEditingController? _ownSearch;
  _TierFilter _tier = .all;
  RemixDataTableSort _sort = const RemixDataTableSort(
    columnId: 'joined',
    direction: .descending,
  );
  Set<Object> _selectedIds = {};
  int _page = 0;
  int _rowsPerPage = 10;

  /// The filtered, sorted rows. Kept until a filter or the sort changes, so a
  /// rebuild for any other reason, such as a theme change, does not redo it.
  List<UiDashboardCustomer>? _rows;

  UiDashboardData get _data => widget.data ?? uiDashboardSampleData;

  TextEditingController get _search =>
      widget.searchController ?? (_ownSearch ??= TextEditingController());

  @override
  void initState() {
    super.initState();
    _search.addListener(_onFilterChanged);
    widget.filterReset?.addListener(_resetFilters);
  }

  @override
  void didUpdateWidget(UiDashboardCustomersPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) _rows = null;
    if (widget.filterReset != oldWidget.filterReset) {
      oldWidget.filterReset?.removeListener(_resetFilters);
      widget.filterReset?.addListener(_resetFilters);
    }
    if (widget.searchController == oldWidget.searchController) return;
    (oldWidget.searchController ?? _ownSearch)?.removeListener(
      _onFilterChanged,
    );
    _search.addListener(_onFilterChanged);
    _rows = null;
  }

  @override
  void dispose() {
    _search.removeListener(_onFilterChanged);
    widget.filterReset?.removeListener(_resetFilters);
    _ownSearch?.dispose();
    super.dispose();
  }

  void _onFilterChanged() => setState(() {
    _rows = null;
    _page = 0;
  });

  void _resetFilters() {
    if (_tier == .all) return;
    setState(() {
      _tier = .all;
      _rows = null;
      _page = 0;
    });
  }

  List<UiDashboardCustomer> _computeRows() {
    final query = _search.text.trim().toLowerCase();
    return [
      for (final customer in _data.customers)
        if (_tier.matches(customer.tier) &&
            '${customer.name} ${customer.email} ${customer.city}'
                .toLowerCase()
                .contains(query))
          customer,
    ]..sort((a, b) {
      final result = switch (_sort.columnId) {
        'name' => a.name.compareTo(b.name),
        'spent' => a.spent.compareTo(b.spent),
        _ => a.joinedAt.compareTo(b.joinedAt),
      };
      return _sort.direction == .ascending ? result : -result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final customers = _data.customers;
    final rows = _rows ??= _computeRows();
    final page = uiDashboardPaginate(
      rows,
      page: _page,
      rowsPerPage: _rowsPerPage,
    );
    final spent = customers.fold(0.0, (sum, customer) => sum + customer.spent);
    int count(bool Function(UiDashboardCustomer) test) =>
        customers.where(test).length;

    return UiPage(
      key: const ValueKey('dashboard-customers'),
      title: 'Customers',
      description: 'The collectors behind every edition.',
      actions: [
        UiButton(
          label: 'Invite collector',
          leadingIcon: RemixIcons.plus,
          onPressed: () =>
              uiDashboardToast(context, 'Collector invitation started'),
        ),
      ],
      children: [
        GridBox(
          key: const ValueKey('customers-summary'),
          style: uiMetricsGrid,
          children: [
            UiRecordStat(
              label: 'Collectors',
              value: uiDashboardCount(customers.length),
              detail: '${count((c) => c.status == .active)} active',
            ),
            UiRecordStat(
              label: 'Patrons',
              value: uiDashboardCount(count((c) => c.tier == .patron)),
              detail: 'The top collecting tier',
            ),
            UiRecordStat(
              label: 'Invitations',
              value: uiDashboardCount(count((c) => c.status == .invited)),
              detail: 'Waiting to be accepted',
            ),
            UiRecordStat(
              label: 'Lifetime value',
              value: uiDashboardCurrency(spent, cents: false),
              detail: 'Across every collector',
            ),
          ],
        ),
        WrapBox(
          style: WrapBoxStyler()
              .wrapAlignment(.spaceBetween)
              .crossAxisAlignment(.center)
              .spacing(UiTokens.space3())
              .runSpacing(UiTokens.space3()),
          children: [
            WrapBox(
              style: WrapBoxStyler()
                  .crossAxisAlignment(.center)
                  .spacing(UiTokens.space3())
                  .runSpacing(UiTokens.space3()),
              children: [
                Box(
                  style: BoxStyler().width(280),
                  child: UiTextField(
                    key: const ValueKey('customer-search'),
                    controller: _search,
                    leading: const StyledIcon(icon: RemixIcons.search),
                    hintText: 'Search customers…',
                    semanticLabel: 'Search customers',
                  ),
                ),
                UiFilterTabs<_TierFilter>(
                  key: const ValueKey('customer-tier'),
                  semanticLabel: 'Filter customers by tier',
                  values: _TierFilter.values,
                  selected: _tier,
                  labelOf: (tier) => tier.label,
                  onChanged: (tier) => setState(() {
                    _tier = tier;
                    _rows = null;
                    _page = 0;
                  }),
                ),
              ],
            ),
            if (_selectedIds.isNotEmpty)
              WrapBox(
                key: const ValueKey('customer-selection-actions'),
                style: WrapBoxStyler()
                    .crossAxisAlignment(.center)
                    .spacing(UiTokens.space2())
                    .runSpacing(UiTokens.space2()),
                children: [
                  UiBadge(
                    size: .size2,
                    highContrast: true,
                    label: '${_selectedIds.length} selected',
                  ),
                  UiButton.ghost(
                    size: .size1,
                    label: 'Export',
                    onPressed: () => uiDashboardToast(
                      context,
                      'Export prepared for ${_selectedIds.length} customers',
                    ),
                  ),
                  UiButton.ghost(
                    size: .size1,
                    label: 'Archive',
                    onPressed: () => uiDashboardToast(
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
          minimumWidth: 940,
          sort: _sort,
          onSortChanged: (sort) => setState(() {
            _sort = sort;
            _rows = null;
            _page = 0;
          }),
          rowId: (customer) => customer.id,
          selectedRowIds: _selectedIds,
          onSelectionChanged: (ids) => setState(() => _selectedIds = ids),
          totalRows: rows.length,
          pageIndex: page.page,
          pageSize: _rowsPerPage,
          pageSizeOptions: const [5, 10, 20],
          onPageChanged: (value) => setState(() => _page = value),
          onPageSizeChanged: (value) => setState(() {
            _rowsPerPage = value;
            _page = 0;
          }),
          emptyBuilder: (_) => UiEmptyState(
            icon: RemixIcons.search,
            title: 'No customers found',
            body: 'Try a different name, email or city.',
            action: UiButton.soft(
              size: .size1,
              label: 'Clear filters',
              onPressed: () {
                _search.clear();
                setState(() {
                  _tier = .all;
                  _rows = null;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// The Orders page: a filterable, sortable table of orders under four
/// summary figures.
class UiDashboardOrdersPage extends StatefulWidget {
  const UiDashboardOrdersPage({
    super.key,
    this.data,
    this.searchController,
    this.filterReset,
  });

  /// The records the page shows. Defaults to [uiDashboardSampleData].
  final UiDashboardData? data;

  /// Controls the search field, so a host can fill it. The page creates its
  /// own when null.
  final TextEditingController? searchController;

  /// Notifies when the page should drop every filter but its search. A host
  /// that fills the search to show one record fires it, so a filter left on
  /// from earlier cannot hide that record.
  final Listenable? filterReset;

  @override
  State<UiDashboardOrdersPage> createState() => _UiDashboardOrdersPageState();
}

class _UiDashboardOrdersPageState extends State<UiDashboardOrdersPage> {
  TextEditingController? _ownSearch;
  _OrderFilter _status = .all;
  RemixDataTableSort _sort = const RemixDataTableSort(
    columnId: 'date',
    direction: .descending,
  );
  int _page = 0;
  int _rowsPerPage = 10;

  /// See `_UiDashboardCustomersPageState._rows`.
  List<UiDashboardOrder>? _rows;

  /// The table columns. Built once per data set: the edition column looks a
  /// cover up by title.
  List<RemixDataTableColumn<UiDashboardOrder>>? _columns;

  UiDashboardData get _data => widget.data ?? uiDashboardSampleData;

  TextEditingController get _search =>
      widget.searchController ?? (_ownSearch ??= TextEditingController());

  @override
  void initState() {
    super.initState();
    _search.addListener(_onFilterChanged);
    widget.filterReset?.addListener(_resetFilters);
  }

  @override
  void didUpdateWidget(UiDashboardOrdersPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      _rows = null;
      _columns = null;
    }
    if (widget.filterReset != oldWidget.filterReset) {
      oldWidget.filterReset?.removeListener(_resetFilters);
      widget.filterReset?.addListener(_resetFilters);
    }
    if (widget.searchController == oldWidget.searchController) return;
    (oldWidget.searchController ?? _ownSearch)?.removeListener(
      _onFilterChanged,
    );
    _search.addListener(_onFilterChanged);
    _rows = null;
  }

  @override
  void dispose() {
    _search.removeListener(_onFilterChanged);
    widget.filterReset?.removeListener(_resetFilters);
    _ownSearch?.dispose();
    super.dispose();
  }

  void _onFilterChanged() => setState(() {
    _rows = null;
    _page = 0;
  });

  void _resetFilters() {
    if (_status == .all) return;
    setState(() {
      _status = .all;
      _rows = null;
      _page = 0;
    });
  }

  List<UiDashboardOrder> _computeRows() {
    final query = _search.text.trim().toLowerCase();
    return [
      for (final order in _data.orders)
        if (_status.matches(order.status) &&
            '${order.id} ${order.customer} ${order.edition} ${order.channel}'
                .toLowerCase()
                .contains(query))
          order,
    ]..sort((a, b) {
      final result = _sort.columnId == 'amount'
          ? a.amount.compareTo(b.amount)
          : a.date.compareTo(b.date);
      return _sort.direction == .ascending ? result : -result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orders = _data.orders;
    final rows = _rows ??= _computeRows();
    final page = uiDashboardPaginate(
      rows,
      page: _page,
      rowsPerPage: _rowsPerPage,
    );
    Iterable<UiDashboardOrder> having(UiDashboardOrderStatus status) =>
        orders.where((order) => order.status == status);
    double total(Iterable<UiDashboardOrder> orders) =>
        orders.fold(0, (sum, order) => sum + order.amount);

    return UiPage(
      key: const ValueKey('dashboard-orders'),
      title: 'Orders',
      description: 'Every order, from payment to the collector’s door.',
      actions: [
        UiButton.soft(
          label: 'Export',
          leadingIcon: RemixIcons.download,
          onPressed: () => uiDashboardToast(context, 'Order export prepared'),
        ),
      ],
      children: [
        GridBox(
          key: const ValueKey('orders-summary'),
          style: uiMetricsGrid,
          children: [
            UiRecordStat(
              label: 'Orders',
              value: uiDashboardCount(orders.length),
              detail:
                  '${uiDashboardCurrency(total(orders), cents: false)} in total',
            ),
            UiRecordStat(
              label: 'Awaiting payment',
              value: uiDashboardCount(having(.pending).length),
              detail:
                  '${uiDashboardCurrency(total(having(.pending)), cents: false)} outstanding',
            ),
            UiRecordStat(
              label: 'On the way',
              value: uiDashboardCount(having(.shipped).length),
              detail: 'Shipped, not yet delivered',
            ),
            UiRecordStat(
              label: 'Refunded',
              value: uiDashboardCurrency(
                total(having(.refunded)),
                cents: false,
              ),
              detail: '${having(.refunded).length} orders returned',
            ),
          ],
        ),
        WrapBox(
          style: WrapBoxStyler()
              .wrapAlignment(.spaceBetween)
              .crossAxisAlignment(.center)
              .spacing(UiTokens.space3())
              .runSpacing(UiTokens.space3()),
          children: [
            UiFilterTabs<_OrderFilter>(
              key: const ValueKey('order-status'),
              semanticLabel: 'Filter orders by status',
              values: _OrderFilter.values,
              selected: _status,
              labelOf: (status) => capitalize(status.name),
              onChanged: (status) => setState(() {
                _status = status;
                _rows = null;
                _page = 0;
              }),
            ),
            Box(
              style: BoxStyler().width(280),
              child: UiTextField(
                key: const ValueKey('order-search'),
                controller: _search,
                leading: const StyledIcon(icon: RemixIcons.search),
                hintText: 'Search orders…',
                semanticLabel: 'Search orders',
              ),
            ),
          ],
        ),
        UiDataTable<UiDashboardOrder>.surface(
          key: const ValueKey('data-grid-orders'),
          rows: page.items,
          columns: _columns ??= _orderColumns(_data.editions),
          semanticLabel: 'Orders',
          minimumWidth: 980,
          sort: _sort,
          onSortChanged: (sort) => setState(() {
            _sort = sort;
            _rows = null;
            _page = 0;
          }),
          totalRows: rows.length,
          pageIndex: page.page,
          pageSize: _rowsPerPage,
          pageSizeOptions: const [5, 10, 20],
          onPageChanged: (value) => setState(() => _page = value),
          onPageSizeChanged: (value) => setState(() {
            _rowsPerPage = value;
            _page = 0;
          }),
          emptyBuilder: (_) => UiEmptyState(
            icon: RemixIcons.table,
            title: 'No matching orders',
            body: 'Try another status or search term.',
            action: UiButton.soft(
              size: .size1,
              label: 'Clear filters',
              onPressed: () {
                _search.clear();
                setState(() {
                  _status = .all;
                  _rows = null;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Returns the [items] on [page] with [rowsPerPage] rows per page.
///
/// A [page] past either end is clamped to the nearest page, and the returned
/// `page` is the one actually used.
({int page, List<T> items}) uiDashboardPaginate<T>(
  List<T> items, {
  required int page,
  required int rowsPerPage,
}) {
  final pages = (items.length / rowsPerPage).ceil();
  final safePage = pages == 0 ? 0 : page.clamp(0, pages - 1);
  final start = safePage * rowsPerPage;
  final end = (start + rowsPerPage).clamp(0, items.length);
  return (page: safePage, items: items.sublist(start, end));
}

/// The accents customer avatars cycle through, so a long table is not one
/// flat column of gray tiles.
const _avatarAccents = <UiAccentColor>[.ceu, .mar, .caju, .sol, .duna, .serra];

final _customerColumns = <RemixDataTableColumn<UiDashboardCustomer>>[
  RemixDataTableColumn(
    id: 'name',
    label: 'Customer',
    sortable: true,
    width: const FlexColumnWidth(3),
    cellBuilder: (_, customer) => RowBox(
      style: FlexBoxStyler()
          .crossAxisAlignment(.center)
          .spacing(UiTokens.space3()),
      children: [
        UiAccentScope(
          accent:
              _avatarAccents[customer.name.codeUnitAt(0) %
                  _avatarAccents.length],
          child: UiAvatar(
            size: .size2,
            label: customer.initials,
            fallbackLength: 2,
          ),
        ),
        Flexible(
          child: ColumnBox(
            style: FlexBoxStyler()
                .mainAxisSize(.min)
                .crossAxisAlignment(.start),
            children: [
              UiDataTableCellText(customer.name, primary: true),
              StyledText(
                customer.email,
                style: dashboardTextLine(.size1, tone: .muted),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
  RemixDataTableColumn(
    id: 'city',
    label: 'City',
    width: const FlexColumnWidth(2),
    cellBuilder: (_, customer) => UiDataTableCellText(customer.city),
  ),
  RemixDataTableColumn(
    id: 'tier',
    label: 'Tier',
    width: const FixedColumnWidth(108),
    cellBuilder: (_, customer) => UiBadge.outline(label: customer.tier.label),
  ),
  RemixDataTableColumn(
    id: 'spent',
    label: 'Spent',
    sortable: true,
    width: const FixedColumnWidth(112),
    alignment: AlignmentDirectional.centerEnd,
    cellBuilder: (_, customer) => UiDataTableCellText(
      uiDashboardCurrency(customer.spent, cents: false),
      primary: true,
    ),
  ),
  RemixDataTableColumn(
    id: 'status',
    label: 'Status',
    width: const FixedColumnWidth(104),
    cellBuilder: (_, customer) => UiStatusBadge.customer(customer.status),
  ),
  RemixDataTableColumn(
    id: 'joined',
    label: 'Joined',
    sortable: true,
    width: const FixedColumnWidth(124),
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
      positioning: uiDataTableActionsPositioning,
      trigger: uiDataTableActionsTrigger('Actions for ${customer.name}'),
      actions: const [
        UiAction(value: 'view', label: 'View profile'),
        UiAction(value: 'email', label: 'Send email'),
        UiAction(value: 'archive', label: 'Archive', dividerBefore: true),
      ],
      onSelected: (value) =>
          uiDashboardToast(context, '$value selected for ${customer.name}'),
    ),
  ),
];

List<RemixDataTableColumn<UiDashboardOrder>> _orderColumns(
  List<UiDashboardEdition> editions,
) {
  final byTitle = {for (final edition in editions) edition.title: edition};
  return [
    RemixDataTableColumn(
      id: 'id',
      label: 'Order',
      width: const FixedColumnWidth(108),
      cellBuilder: (_, order) => UiDataTableCellText(order.id, primary: true),
    ),
    RemixDataTableColumn(
      id: 'edition',
      label: 'Edition',
      width: const FlexColumnWidth(3),
      cellBuilder: (_, order) => RowBox(
        style: FlexBoxStyler()
            .crossAxisAlignment(.center)
            .spacing(UiTokens.space3()),
        children: [
          if (byTitle[order.edition] case final edition?)
            UiEditionThumbnail(edition, extent: 32),
          Flexible(child: UiDataTableCellText(order.edition, primary: true)),
        ],
      ),
    ),
    RemixDataTableColumn(
      id: 'customer',
      label: 'Customer',
      width: const FlexColumnWidth(2),
      cellBuilder: (_, order) => UiDataTableCellText(order.customer),
    ),
    RemixDataTableColumn(
      id: 'date',
      label: 'Date',
      sortable: true,
      width: const FixedColumnWidth(124),
      cellBuilder: (_, order) =>
          UiDataTableCellText(uiDashboardShortDate(order.date)),
    ),
    RemixDataTableColumn(
      id: 'channel',
      label: 'Channel',
      width: const FixedColumnWidth(124),
      cellBuilder: (_, order) => UiDataTableCellText(order.channel),
    ),
    RemixDataTableColumn(
      id: 'amount',
      label: 'Amount',
      sortable: true,
      width: const FixedColumnWidth(116),
      alignment: AlignmentDirectional.centerEnd,
      cellBuilder: (_, order) =>
          UiDataTableCellText(uiDashboardCurrency(order.amount), primary: true),
    ),
    RemixDataTableColumn(
      id: 'status',
      label: 'Status',
      width: const FixedColumnWidth(108),
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
        positioning: uiDataTableActionsPositioning,
        trigger: uiDataTableActionsTrigger('Actions for ${order.id}'),
        actions: const [
          UiAction(value: 'view', label: 'View order'),
          UiAction(value: 'receipt', label: 'Download receipt'),
          UiAction(value: 'refund', label: 'Issue refund', dividerBefore: true),
        ],
        onSelected: (value) =>
            uiDashboardToast(context, '$value selected for ${order.id}'),
      ),
    ),
  ];
}
