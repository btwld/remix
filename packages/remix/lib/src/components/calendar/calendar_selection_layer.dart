part of 'calendar.dart';

/// One cell of a month grid: a week row and a weekday column.
///
/// Row 0 is the first week shown. Column 0 is the first weekday column, at
/// the start edge, so it is on the right in a right-to-left calendar.
@immutable
final class RemixCalendarCell {
  const RemixCalendarCell({required this.row, required this.column});

  final int row;
  final int column;

  @override
  bool operator ==(Object other) =>
      other is RemixCalendarCell && row == other.row && column == other.column;

  @override
  int get hashCode => Object.hash(row, column);

  @override
  String toString() => 'RemixCalendarCell($row, $column)';
}

/// The selected days of one week row, from [startColumn] to [endColumn]
/// inclusive.
@immutable
final class RemixCalendarSelectionSegment {
  const RemixCalendarSelectionSegment({
    required this.row,
    required this.startColumn,
    required this.endColumn,
  });

  final int row;
  final int startColumn;
  final int endColumn;

  @override
  bool operator ==(Object other) =>
      other is RemixCalendarSelectionSegment &&
      row == other.row &&
      startColumn == other.startColumn &&
      endColumn == other.endColumn;

  @override
  int get hashCode => Object.hash(row, startColumn, endColumn);

  @override
  String toString() =>
      'RemixCalendarSelectionSegment($row, $startColumn-$endColumn)';
}

/// What a [RemixCalendarSelectionLayerBuilder] receives: the geometry of one
/// month grid and the part of the selection it shows.
///
/// A single-date calendar selects one day, so [start] and [end] are the same
/// cell and there is one segment. A range calendar describes its painted
/// interval: the draft while one is anchored, otherwise the committed value.
/// It has one segment per week row the interval covers, and [start] or [end]
/// is null while that end of the interval is in another month.
@immutable
final class RemixCalendarSelection {
  const RemixCalendarSelection({
    required this.cellSize,
    required this.rowSpacing,
    required this.textDirection,
    this.start,
    this.end,
    this.segments = const [],
  });

  /// The size of one day cell: a seventh of the grid width by the day's
  /// minimum height. Columns have no gap between them.
  final Size cellSize;

  /// The vertical gap between week rows.
  final double rowSpacing;

  /// The direction the weekday columns run in.
  final TextDirection textDirection;

  /// The cell of the first selected day, when it is in this grid.
  final RemixCalendarCell? start;

  /// The cell of the last selected day, when it is in this grid.
  final RemixCalendarCell? end;

  /// The selected days of each week row, top to bottom. Empty when nothing
  /// selected is in this grid.
  final List<RemixCalendarSelectionSegment> segments;

  /// Whether nothing selected is in this grid.
  bool get isEmpty => segments.isEmpty;

  /// The bounds of [cell] in the layer.
  Rect cellRect(RemixCalendarCell cell) =>
      _rect(cell.row, cell.column, cell.column);

  /// The bounds of [segment] in the layer, from its first to its last cell.
  Rect segmentRect(RemixCalendarSelectionSegment segment) =>
      _rect(segment.row, segment.startColumn, segment.endColumn);

  Rect _rect(int row, int startColumn, int endColumn) {
    final ltr = textDirection == TextDirection.ltr;
    final left = ltr ? startColumn : 6 - endColumn;
    return Rect.fromLTWH(
      left * cellSize.width,
      row * (cellSize.height + rowSpacing),
      (endColumn - startColumn + 1) * cellSize.width,
      cellSize.height,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemixCalendarSelection &&
          cellSize == other.cellSize &&
          rowSpacing == other.rowSpacing &&
          textDirection == other.textDirection &&
          start == other.start &&
          end == other.end &&
          listEquals(segments, other.segments);

  @override
  int get hashCode => Object.hash(
    cellSize,
    rowSpacing,
    textDirection,
    start,
    end,
    Object.hashAll(segments),
  );
}

/// Paints beneath the days of one month grid, sized to the grid.
///
/// The layer stays mounted while the selection changes within a month, so an
/// implicitly animated child can glide between days. It is decorative: it
/// receives no pointer events and adds no semantics.
typedef RemixCalendarSelectionLayerBuilder =
    Widget Function(BuildContext context, RemixCalendarSelection selection);

RemixCalendarSelection _calendarSelection({
  required List<List<DateTime?>> weeks,
  required CivilDateRange? selected,
  required Size cellSize,
  required double rowSpacing,
  required TextDirection textDirection,
}) {
  RemixCalendarCell? start;
  RemixCalendarCell? end;
  final segments = <RemixCalendarSelectionSegment>[];
  if (selected != null) {
    for (final (row, week) in weeks.indexed) {
      int? first;
      int? last;
      for (final (column, date) in week.indexed) {
        if (date == null || !selected.contains(date)) continue;
        first ??= column;
        last = column;
        if (isSameCivilDate(date, selected.start)) {
          start = RemixCalendarCell(row: row, column: column);
        }
        if (isSameCivilDate(date, selected.end)) {
          end = RemixCalendarCell(row: row, column: column);
        }
      }
      if (first != null) {
        segments.add(
          RemixCalendarSelectionSegment(
            row: row,
            startColumn: first,
            endColumn: last!,
          ),
        );
      }
    }
  }
  return RemixCalendarSelection(
    cellSize: cellSize,
    rowSpacing: rowSpacing,
    textDirection: textDirection,
    start: start,
    end: end,
    segments: List.unmodifiable(segments),
  );
}
