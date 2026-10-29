// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixDataTable].
///
/// Sorting, selection, and paging stay with Remix; the composed selection
/// checkbox and page-size select take their HeroUI recipes.
class HeroUiTable<T> extends StatelessWidget {
  const HeroUiTable({
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
    this.labels = const RemixDataTableLabels(),
    this.pageRangeFormatter = remixDefaultDataTablePageRangeFormatter,
    this.sortableIcon,
    this.sortAscendingIcon,
    this.sortDescendingIcon,
    this.previousPageIcon,
    this.nextPageIcon,
  });

  const HeroUiTable.primary({
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
    this.labels = const RemixDataTableLabels(),
    this.pageRangeFormatter = remixDefaultDataTablePageRangeFormatter,
    this.sortableIcon,
    this.sortAscendingIcon,
    this.sortDescendingIcon,
    this.previousPageIcon,
    this.nextPageIcon,
  }) : variant = HeroUiTableVariant.primary;

  const HeroUiTable.secondary({
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
    this.labels = const RemixDataTableLabels(),
    this.pageRangeFormatter = remixDefaultDataTablePageRangeFormatter,
    this.sortableIcon,
    this.sortAscendingIcon,
    this.sortDescendingIcon,
    this.previousPageIcon,
    this.nextPageIcon,
  }) : variant = HeroUiTableVariant.secondary;

  final HeroUiTableVariant variant;

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

  final RemixDataTableLabels labels;

  final RemixDataTablePageRangeFormatter pageRangeFormatter;

  final IconData? sortableIcon;

  final IconData? sortAscendingIcon;

  final IconData? sortDescendingIcon;

  final IconData? previousPageIcon;

  final IconData? nextPageIcon;

  @override
  Widget build(BuildContext context) {
    return RemixDataTable<T>(
      key: this.key,
      style: heroUiTableStyle(variant: this.variant, style: this.style),
      rows: this.rows,
      columns: this.columns,
      semanticLabel: this.semanticLabel,
      sort: this.sort,
      onSortChanged: this.onSortChanged,
      rowId: this.rowId,
      selectedRowIds: this.selectedRowIds,
      onSelectionChanged: this.onSelectionChanged,
      totalRows: this.totalRows,
      pageIndex: this.pageIndex,
      pageSize: this.pageSize,
      pageSizeOptions: this.pageSizeOptions,
      onPageChanged: this.onPageChanged,
      onPageSizeChanged: this.onPageSizeChanged,
      minimumWidth: this.minimumWidth,
      emptyBuilder: this.emptyBuilder,
      labels: this.labels,
      pageRangeFormatter: this.pageRangeFormatter,
      sortableIcon: this.sortableIcon,
      sortAscendingIcon: this.sortAscendingIcon,
      sortDescendingIcon: this.sortDescendingIcon,
      previousPageIcon: this.previousPageIcon,
      nextPageIcon: this.nextPageIcon,
    );
  }
}
