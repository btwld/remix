import 'package:flutter/material.dart';
import 'package:mix_specimen/mix_specimen.dart';
import 'package:remix/remix.dart';

import 'fortal_themes.dart';

void _noop() {}

const _variantAxis = SpecimenAxis('variant', 'Variant');
const _sizeAxis = SpecimenAxis('size', 'Size');

SpecimenAxisValue _value(Enum value) =>
    SpecimenAxisValue(value.name, _label(value.name));

String _label(String value) =>
    '${value[0].toUpperCase()}${value.substring(1).replaceAllMapped(RegExp(r'([0-9]+)'), (match) => ' ${match[1]}')}';

SpecimenRow _row({
  required Enum variant,
  required Enum size,
  required SpecimenCellBuilder builder,
}) => SpecimenRow(
  '${variant.name}-${size.name}',
  builder,
  values: {'variant': _value(variant), 'size': _value(size)},
);

final fortalCatalog = SpecimenCatalog(
  id: 'fortal',
  themes: fortalThemes,
  specimens: [_buttonSpecimen(), _checkboxSpecimen(), _switchSpecimen()],
);

Specimen _buttonSpecimen() => Specimen(
  id: 'button',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [
    ...Scenarios.interactive,
    SpecimenScenario('loading', props: {'loading': true}),
  ],
  rows: [
    for (final variant in FortalButtonVariant.values)
      for (final size in FortalButtonSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, sim) => RemixButton(
            label: 'Button',
            leadingIcon: Icons.add,
            enabled: !sim.disabled,
            loading: sim.propOr('loading', false),
            onPressed: sim.disabled ? null : _noop,
            styleSpec: sim.resolve(
              context,
              fortalButtonStyle(variant: variant, size: size),
            ),
          ),
        ),
  ],
);

Specimen _checkboxSpecimen() => Specimen(
  id: 'checkbox',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [
    ...Scenarios.selectable,
    SpecimenScenario(
      'selected-hovered',
      states: {WidgetState.selected, WidgetState.hovered},
    ),
    SpecimenScenario('indeterminate', props: {'indeterminate': true}),
  ],
  rows: [
    for (final variant in FortalCheckboxVariant.values)
      for (final size in FortalCheckboxSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, sim) {
            final indeterminate = sim.propOr('indeterminate', false);
            return RemixCheckbox(
              selected: indeterminate ? null : sim.selected,
              tristate: indeterminate,
              enabled: !sim.disabled,
              onChanged: sim.disabled ? null : (_) {},
              styleSpec: sim
                  .resolve(
                    context,
                    fortalCheckboxStyle(variant: variant, size: size),
                  )
                  .spec,
            );
          },
        ),
  ],
);

Specimen _switchSpecimen() => Specimen(
  id: 'switch',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [
    ...Scenarios.selectable,
    SpecimenScenario(
      'selected-hovered',
      states: {WidgetState.selected, WidgetState.hovered},
    ),
  ],
  rows: [
    for (final variant in FortalSwitchVariant.values)
      for (final size in FortalSwitchSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, sim) {
            final style = RemixSwitchStyle()
                .alignment(Alignment.centerLeft)
                .onSelected(RemixSwitchStyle().alignment(Alignment.centerRight))
                .merge(fortalSwitchStyle(variant: variant, size: size));
            return RemixSwitch(
              selected: sim.selected,
              enabled: !sim.disabled,
              onChanged: (_) {},
              styleSpec: sim.resolve(context, style).spec,
            );
          },
        ),
  ],
);
