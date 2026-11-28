// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixDataTable].
///
/// Sorting, selection, and paging stay with Remix; the composed selection
/// checkbox and page-size select take their HeroUI recipes.
class UiTable<T> extends StatelessWidget {
  const UiTable({
    super.key,
    this.variant = .primary,
    this.style = const DataTableStyler.create(),
    required this.rows,
    required this.columns,
    this.semanticLabel,
    this.sort,
    this.onSortChanged,
    this.rowId,
    this.selectedRowIds = const {},
    this.onSelectionChanged,
    this.totalRows,
    this.pageIndex = 0,
    this.pageSize = 10,
    this.pageSizeOptions = const [10, 20, 50],
    this.onPageChanged,
    this.onPageSizeChanged,
    this.minimumWidth = 0,
    this.emptyBuilder,
    this.footerBuilder,
    this.labels = const RemixDataTableLabels(),
    this.pageRangeFormatter = remixDefaultDataTablePageRangeFormatter,
    this.sortableIcon,
    this.sortAscendingIcon,
    this.sortDescendingIcon,
    this.previousPageIcon,
    this.nextPageIcon,
  });

  /// A white card on a gray frame.
  const UiTable.primary({
    super.key,
    this.style = const DataTableStyler.create(),
    required this.rows,
    required this.columns,
    this.semanticLabel,
    this.sort,
    this.onSortChanged,
    this.rowId,
    this.selectedRowIds = const {},
    this.onSelectionChanged,
    this.totalRows,
    this.pageIndex = 0,
    this.pageSize = 10,
    this.pageSizeOptions = const [10, 20, 50],
    this.onPageChanged,
    this.onPageSizeChanged,
    this.minimumWidth = 0,
    this.emptyBuilder,
    this.footerBuilder,
    this.labels = const RemixDataTableLabels(),
    this.pageRangeFormatter = remixDefaultDataTablePageRangeFormatter,
    this.sortableIcon,
    this.sortAscendingIcon,
    this.sortDescendingIcon,
    this.previousPageIcon,
    this.nextPageIcon,
  }) : variant = UiTableVariant.primary;

  /// A gray header over bare rows.
  const UiTable.secondary({
    super.key,
    this.style = const DataTableStyler.create(),
    required this.rows,
    required this.columns,
    this.semanticLabel,
    this.sort,
    this.onSortChanged,
    this.rowId,
    this.selectedRowIds = const {},
    this.onSelectionChanged,
    this.totalRows,
    this.pageIndex = 0,
    this.pageSize = 10,
    this.pageSizeOptions = const [10, 20, 50],
    this.onPageChanged,
    this.onPageSizeChanged,
    this.minimumWidth = 0,
    this.emptyBuilder,
    this.footerBuilder,
    this.labels = const RemixDataTableLabels(),
    this.pageRangeFormatter = remixDefaultDataTablePageRangeFormatter,
    this.sortableIcon,
    this.sortAscendingIcon,
    this.sortDescendingIcon,
    this.previousPageIcon,
    this.nextPageIcon,
  }) : variant = UiTableVariant.secondary;

  final UiTableVariant variant;

  final DataTableStyler style;

  final List<T> rows;

  final List<RemixDataTableColumn<T>> columns;

  final String? semanticLabel;

  final RemixDataTableSort? sort;

  final ValueChanged<RemixDataTableSort>? onSortChanged;

  final Object Function(T row)? rowId;

  final Set<Object> selectedRowIds;

  final ValueChanged<Set<Object>>? onSelectionChanged;

  final int? totalRows;

  final int pageIndex;

  final int pageSize;

  final List<int> pageSizeOptions;

  final ValueChanged<int>? onPageChanged;

  final ValueChanged<int>? onPageSizeChanged;

  final double minimumWidth;

  final WidgetBuilder? emptyBuilder;

  final WidgetBuilder? footerBuilder;

  final RemixDataTableLabels labels;

  final RemixDataTablePageRangeFormatter pageRangeFormatter;

  final IconData? sortableIcon;

  final IconData? sortAscendingIcon;

  final IconData? sortDescendingIcon;

  final IconData? previousPageIcon;

  final IconData? nextPageIcon;

  @override
  Widget build(BuildContext _) {
    return RemixDataTable<T>(
      style: uiTableStyle(variant: variant, style: style),
      rows: rows,
      columns: columns,
      semanticLabel: semanticLabel,
      sort: sort,
      onSortChanged: onSortChanged,
      rowId: rowId,
      selectedRowIds: selectedRowIds,
      onSelectionChanged: onSelectionChanged,
      totalRows: totalRows,
      pageIndex: pageIndex,
      pageSize: pageSize,
      pageSizeOptions: pageSizeOptions,
      onPageChanged: onPageChanged,
      onPageSizeChanged: onPageSizeChanged,
      minimumWidth: minimumWidth,
      emptyBuilder: emptyBuilder,
      footerBuilder: footerBuilder,
      labels: labels,
      pageRangeFormatter: pageRangeFormatter,
      sortableIcon: sortableIcon,
      sortAscendingIcon: sortAscendingIcon,
      sortDescendingIcon: sortDescendingIcon,
      previousPageIcon: previousPageIcon,
      nextPageIcon: nextPageIcon,
    );
  }
}
