import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_specimen/golden.dart';
import 'package:mix_specimen/mix_specimen.dart';
import 'package:remix/remix.dart';

import 'support/fortal_themes.dart';

Specimen _checkboxSpecimen() {
  return Specimen(
    id: 'checkbox',
    scenarios: [
      ...Scenarios.selectable,
      const SpecimenScenario(
        'selected-hovered',
        states: {WidgetState.selected, WidgetState.hovered},
      ),
      const SpecimenScenario('indeterminate', props: {'indeterminate': true}),
    ],
    rows: [
      for (final variant in FortalCheckboxVariant.values)
        SpecimenRow(variant.name, (context, sim) {
          final indeterminate = sim.propOr('indeterminate', false);

          return RemixCheckbox(
            selected: indeterminate ? null : sim.selected,
            tristate: indeterminate,
            enabled: !sim.disabled,
            onChanged: sim.disabled ? null : (_) {},
            styleSpec: sim
                .resolve(context, fortalCheckboxStyle(variant: variant))
                .spec,
          );
        }),
    ],
  );
}

void main() {
  for (final theme in fortalThemes) {
    testWidgets('checkbox specimen - ${theme.id}', (tester) async {
      await expectSpecimenGolden(
        tester,
        specimen: _checkboxSpecimen(),
        theme: theme,
      );
    });
  }
}
