// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_table.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal DataTable recipe.
///
/// It reads top to bottom: the cells, rows, footer and the controls inside
/// them at the size, then the variant's panel.
class UiDataTable<T> extends StatelessWidget {
  const UiDataTable({
    super.key,
    this.size = .size2,
    this.variant = .ghost,
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

  /// A panel with a 1px frame and a tinted header.
  const UiDataTable.surface({
    super.key,
    this.size = .size2,
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
  }) : variant = UiDataTableVariant.surface;

  /// No panel or frame: rows on the page.
  const UiDataTable.ghost({
    super.key,
    this.size = .size2,
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
  }) : variant = UiDataTableVariant.ghost;

  final UiDataTableSize size;

  final UiDataTableVariant variant;

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
      style: uiDataTableStyle(size: size, variant: variant, style: style),
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
