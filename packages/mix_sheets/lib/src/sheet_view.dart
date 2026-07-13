import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import 'component_sheet.dart';
import 'scenario.dart';

/// Renders a [ComponentSheet] as a static grid: rows x scenario columns.
///
/// Each cell is wrapped in a `WidgetStateProvider` carrying the scenario's
/// forced states, so cell builders resolve styles as if the interaction
/// were really happening.
class SheetView extends StatelessWidget {
  const SheetView({
    super.key,
    required this.sheet,
    this.title,
    this.labelColor = const Color(0x99000000),
    this.cellPadding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  });

  final ComponentSheet sheet;

  /// Optional heading, e.g. `button - fortal-light`.
  final String? title;

  final Color labelColor;

  final EdgeInsets cellPadding;

  TextStyle get _labelStyle => TextStyle(
    color: labelColor,
    decoration: TextDecoration.none,
    fontFamily: 'Roboto',
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    sheet.validate();
    final tableRows = _tableRows(sheet);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              title!,
              style: _labelStyle.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        Table(
          defaultColumnWidth: const IntrinsicColumnWidth(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                const SizedBox.shrink(),
                for (final scenario in sheet.scenarios)
                  Padding(
                    padding: cellPadding,
                    child: Text(
                      scenario.label ?? scenario.id,
                      style: _labelStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
            for (final tableRow in tableRows)
              if (tableRow.row case final row?)
                TableRow(
                  children: [
                    Padding(
                      padding: cellPadding,
                      child: Text(tableRow.label, style: _labelStyle),
                    ),
                    for (final scenario in sheet.scenarios)
                      Padding(
                        padding: cellPadding,
                        child: Center(
                          child: _SheetCell(row: row, scenario: scenario),
                        ),
                      ),
                  ],
                )
              else
                TableRow(
                  children: [
                    Padding(
                      padding: cellPadding,
                      child: Text(
                        tableRow.label,
                        style: _labelStyle.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    for (final _ in sheet.scenarios) const SizedBox.shrink(),
                  ],
                ),
          ],
        ),
      ],
    );
  }
}

List<({SheetRow? row, String label})> _tableRows(ComponentSheet sheet) {
  if (sheet.rowAxes.isEmpty) {
    return [
      for (final row in sheet.rows) (row: row, label: row.label ?? row.id),
    ];
  }

  final result = <({SheetRow? row, String label})>[];
  List<String>? previousGroups;
  for (final row in sheet.rows) {
    final groups = sheet.rowAxes
        .take(sheet.rowAxes.length - 1)
        .map((axis) => row.values[axis.id]!.label)
        .toList();
    var ancestorChanged = previousGroups == null;
    for (var depth = 0; depth < groups.length; depth++) {
      ancestorChanged =
          ancestorChanged ||
          previousGroups!.length <= depth ||
          previousGroups[depth] != groups[depth];
      if (ancestorChanged) {
        result.add((row: null, label: groups[depth]));
      }
    }
    final rowLabel = row.values[sheet.rowAxes.last.id]!.label;
    result.add((row: row, label: rowLabel));
    previousGroups = groups;
  }
  return result;
}

class _SheetCell extends StatelessWidget {
  const _SheetCell({required this.row, required this.scenario});

  final SheetRow row;
  final SheetScenario scenario;

  @override
  Widget build(BuildContext context) {
    return WidgetStateProvider(
      states: scenario.states,
      child: Builder(
        builder: (context) => row.builder(context, SheetCellContext(scenario)),
      ),
    );
  }
}
