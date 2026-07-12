import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_specimen/golden.dart';
import 'package:mix_specimen/mix_specimen.dart';
import 'package:remix/remix.dart';

import 'support/fortal_themes.dart';

Specimen _switchSpecimen() {
  return Specimen(
    id: 'switch',
    scenarios: [
      ...Scenarios.selectable,
      const SpecimenScenario(
        'selected-hovered',
        states: {WidgetState.selected, WidgetState.hovered},
      ),
    ],
    rows: [
      for (final variant in FortalSwitchVariant.values)
        SpecimenRow(variant.name, (context, sim) {
          // Mirrors RemixSwitch's private base style: thumb sits left and
          // moves right when selected. styleSpec bypasses the widget's own
          // defaults, so they must be part of the resolved style.
          final style = RemixSwitchStyle()
              .alignment(Alignment.centerLeft)
              .onSelected(RemixSwitchStyle().alignment(Alignment.centerRight))
              .merge(fortalSwitchStyle(variant: variant));

          return RemixSwitch(
            selected: sim.selected,
            enabled: !sim.disabled,
            onChanged: (_) {},
            styleSpec: sim.resolve(context, style).spec,
          );
        }),
    ],
  );
}

void main() {
  for (final theme in fortalThemes) {
    testWidgets('switch specimen - ${theme.id}', (tester) async {
      await expectSpecimenGolden(
        tester,
        specimen: _switchSpecimen(),
        theme: theme,
      );
    });
  }
}
