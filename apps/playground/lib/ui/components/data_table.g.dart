// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_table.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's DataTable recipe.
///
/// A table in a frame: `background` fill, `border` hairline and `radiusMd`
/// corners around a header with no surface of its own. A row under the pointer
/// sits on `muted` at half strength and a selected row on `muted`.
///
/// This recipe depends on other items (`checkbox`, `icon_button`, `select`):
/// the selection column is a checkbox, the pager a pair of icon buttons and the
/// page-size control a select, so the table is handed the application's own
/// recipes rather than restating them.
class PlaygroundDataTable<T> extends StatelessWidget {
  const PlaygroundDataTable({
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
  });

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
  Widget build(BuildContext _) {
    return RemixDataTable<T>(
      style: playgroundDataTableStyle(style: style),
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
