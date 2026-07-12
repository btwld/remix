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
            for (final row in specimen.rows)
              TableRow(
                children: [
                  Padding(
                    padding: cellPadding,
                    child: Text(row.id, style: _labelStyle),
                  ),
                  for (final scenario in specimen.scenarios)
                    Padding(
                      padding: cellPadding,
                      child: Center(
                        child: _SpecimenCell(row: row, scenario: scenario),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ],
    );
  }
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
