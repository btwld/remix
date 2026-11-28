part of 'data_table.dart';

// Sorted-column states are not Flutter WidgetStates. Only cells of the column
// named by RemixDataTable.sort scope a direction, so these never apply to the
// table container, the footer, or other columns.
RemixDataTableSortDirection? _sortedColumnDirection(BuildContext context) =>
    _DataTableSortedColumnScope.maybeOf(context);

final _onSortedDataTableVariant = ContextVariant(
  'remix.data_table.sorted',
  (context) => _sortedColumnDirection(context) != null,
);

final _onSortedAscendingDataTableVariant = ContextVariant(
  'remix.data_table.sorted-ascending',
  (context) =>
      _sortedColumnDirection(context) == RemixDataTableSortDirection.ascending,
);

final _onSortedDescendingDataTableVariant = ContextVariant(
  'remix.data_table.sorted-descending',
  (context) =>
      _sortedColumnDirection(context) == RemixDataTableSortDirection.descending,
);

/// Style helpers for [RemixDataTable] typography and shared row chrome.
extension RemixDataTableStylerRemixHelpers on DataTableStyler {
  /// Styles the header cell and every body cell of the sorted column.
  ///
  /// The column is the one named by [RemixDataTable.sort]. Inside it, every
  /// per-cell region resolves this variant: [DataTableStyler.headerRow],
  /// [DataTableStyler.headerCell], [DataTableStyler.headerLabel],
  /// [DataTableStyler.sortIcon], [DataTableStyler.bodyRow],
  /// [DataTableStyler.lastBodyRow], [DataTableStyler.bodyCell], and
  /// [DataTableStyler.cellText]. The selection column is never sorted.
  ///
  /// Widget-state variants such as `onHovered` and `onSelected` take
  /// precedence on shared properties, so a hovered or selected row still
  /// reads as hovered or selected inside the sorted column.
  DataTableStyler onSorted(DataTableStyler value) {
    return variant(_onSortedDataTableVariant, value);
  }

  /// Like [onSorted], applied only while the sort is ascending.
  DataTableStyler onSortedAscending(DataTableStyler value) {
    return variant(_onSortedAscendingDataTableVariant, value);
  }

  /// Like [onSorted], applied only while the sort is descending.
  ///
  /// With the same icon passed for both directions, a rotation here turns one
  /// arrow instead of swapping glyphs.
  DataTableStyler onSortedDescending(DataTableStyler value) {
    return variant(_onSortedDescendingDataTableVariant, value);
  }

  DataTableStyler headerLabelTextStyle(TextStyleMix style) {
    return headerLabel(TextStyler(style: style));
  }

  DataTableStyler headerLabelColor(Color color) {
    return headerLabel(TextStyler(style: TextStyleMix(color: color)));
  }

  DataTableStyler footerLabelTextStyle(TextStyleMix style) {
    return footerLabel(TextStyler(style: style));
  }

  DataTableStyler footerLabelColor(Color color) {
    return footerLabel(TextStyler(style: TextStyleMix(color: color)));
  }

  DataTableStyler sortIconColor(Color color) {
    return sortIcon(IconStyler(color: color));
  }

  /// Applies [value] to the header cell and both body cell regions at once.
  ///
  /// The selection column shares the body cells' padding by default; call
  /// [DataTableStyler.selectionCell] afterwards to diverge.
  DataTableStyler cellPadding(EdgeInsetsGeometryMix value) {
    return headerCell(BoxStyler().padding(value))
        .bodyCell(BoxStyler().padding(value))
        .selectionCell(BoxStyler().padding(value));
  }

  /// Applies [value] as the divider drawn under header and body rows.
  DataTableStyler rowDivider(BorderSideMix value) {
    final divider = BoxStyler().border(BoxBorderMix.bottom(value));

    return headerRow(divider).bodyRow(divider);
  }
}
