import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_specimen/golden.dart';
import 'package:mix_specimen/mix_specimen.dart';
import 'package:remix/remix.dart';

import 'support/fortal_themes.dart';

void _noop() {}

Specimen _buttonSpecimen() {
  return Specimen(
    id: 'button',
    scenarios: [
      ...Scenarios.interactive,
      const SpecimenScenario('loading', props: {'loading': true}),
    ],
    rows: [
      for (final variant in FortalButtonVariant.values)
        SpecimenRow(variant.name, (context, sim) {
          return RemixButton(
            label: 'Button',
            leadingIcon: Icons.add,
            enabled: !sim.disabled,
            loading: sim.propOr('loading', false),
            onPressed: sim.disabled ? null : _noop,
            styleSpec: sim.resolve(
              context,
              fortalButtonStyle(variant: variant),
            ),
          );
        }),
    ],
  );
}

void main() {
  for (final theme in fortalThemes) {
    testWidgets('button specimen - ${theme.id}', (tester) async {
      await expectSpecimenGolden(
        tester,
        specimen: _buttonSpecimen(),
        theme: theme,
      );
    });
  }
}
