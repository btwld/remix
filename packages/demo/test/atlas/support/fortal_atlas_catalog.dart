import 'package:flutter/material.dart';
import 'package:mix_atlas/mix_atlas.dart';
import 'package:remix/remix.dart';

final fortalAtlasCatalog = AtlasCatalog(
  id: 'fortal',
  label: 'Fortal Design System',
  themes: [
    AtlasTheme(
      'light',
      label: 'Light',
      background: Colors.white,
      builder: (_, child) => FortalScope(child: child),
    ),
    AtlasTheme(
      'dark',
      label: 'Dark',
      brightness: Brightness.dark,
      background: const Color(0xFF111111),
      builder: (_, child) =>
          FortalScope(brightness: Brightness.dark, child: child),
    ),
  ],
  atlases: [_buttonAtlas],
);

final _buttonAtlas = ComponentAtlas(
  id: 'button',
  label: 'Button',
  rowAxes: const [AtlasAxis('variant', 'Variant'), AtlasAxis('size', 'Size')],
  scenarios: const [
    ...AtlasScenarios.interactive,
    AtlasScenario('loading', label: 'Loading', props: {'loading': true}),
  ],
  rows: [
    for (final variant in FortalButtonVariant.values)
      for (final size in FortalButtonSize.values) _buttonRow(variant, size),
  ],
);

AtlasRow _buttonRow(FortalButtonVariant variant, FortalButtonSize size) {
  return AtlasRow(
    '${variant.name}-${size.name}',
    (context, cell) => FortalButton(
      variant: variant,
      size: size,
      label: 'Button',
      leadingIcon: Icons.add,
      enabled: !cell.disabled,
      loading: cell.propOr('loading', false),
      onPressed: () {},
    ),
    values: {
      'variant': AtlasAxisValue(variant.name, _title(variant.name)),
      'size': AtlasAxisValue(size.name, _sizeLabel(size)),
    },
  );
}

String _sizeLabel(FortalButtonSize size) => switch (size) {
  FortalButtonSize.size1 => 'Size 1',
  FortalButtonSize.size2 => 'Size 2',
  FortalButtonSize.size3 => 'Size 3',
  FortalButtonSize.size4 => 'Size 4',
};

String _title(String value) => '${value[0].toUpperCase()}${value.substring(1)}';
