import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import 'scenario.dart';
import 'specimen.dart';

/// Renders a [Specimen] as a static grid: rows x scenario columns.
///
/// Each cell is wrapped in a `WidgetStateProvider` carrying the scenario's
/// forced states, so cell builders resolve styles as if the interaction
/// were really happening.
class SpecimenSheet extends StatelessWidget {
  const SpecimenSheet({
    super.key,
    required this.specimen,
    this.title,
    this.labelColor = const Color(0x99000000),
    this.cellPadding = const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  });

  final Specimen specimen;

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
    specimen.validate();
    final tableRows = _tableRows(specimen);
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
                for (final scenario in specimen.scenarios)
                  Padding(
                    padding: cellPadding,
                    child: Text(
                      scenario.id,
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
                    for (final scenario in specimen.scenarios)
                      Padding(
                        padding: cellPadding,
                        child: Center(
                          child: _SpecimenCell(row: row, scenario: scenario),
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
                    for (final _ in specimen.scenarios) const SizedBox.shrink(),
                  ],
                ),
          ],
        ),
      ],
    );
  }
}

List<({SpecimenRow? row, String label})> _tableRows(Specimen specimen) {
  if (specimen.rowAxes.isEmpty) {
    return [for (final row in specimen.rows) (row: row, label: row.id)];
  }

  final result = <({SpecimenRow? row, String label})>[];
  List<String>? previousGroups;
  for (final row in specimen.rows) {
    final groups = specimen.rowAxes
        .take(specimen.rowAxes.length - 1)
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
    final rowLabel = row.values[specimen.rowAxes.last.id]!.label;
    result.add((row: row, label: rowLabel));
    previousGroups = groups;
  }
  return result;
}

class _SpecimenCell extends StatelessWidget {
  const _SpecimenCell({required this.row, required this.scenario});

  final SpecimenRow row;
  final SpecimenScenario scenario;

  @override
  Widget build(BuildContext context) {
    return WidgetStateProvider(
      states: scenario.states,
      child: Builder(
        builder: (context) => row.builder(context, SpecimenSim(scenario)),
      ),
    );
  }
}
