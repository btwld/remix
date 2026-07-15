import 'package:flutter/material.dart';
import 'package:mix_atlas/mix_atlas.dart';
import 'package:mix_atlas_capture/producer.dart';
import 'package:remix/remix.dart';

import 'fortal_portable_adapters.dart';

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
  atlases: [for (final entry in fortalAtlasEntries) entry.atlas],
);

final class FortalAtlasEntry {
  const FortalAtlasEntry({required this.atlas, required this.portableAdapter});

  final ComponentAtlas atlas;
  final AtlasPortableComponentBuilder Function(ComponentAtlas atlas)
  portableAdapter;

  AtlasPortableComponentBuilder buildPortable() => portableAdapter(atlas);
}

const _interactiveScenarios = [
  AtlasScenarios.base,
  AtlasScenarios.hovered,
  AtlasScenarios.pressed,
  AtlasScenarios.focused,
  AtlasScenario(
    'disabled',
    states: {WidgetState.disabled},
    props: {'enabled': false},
  ),
];

const _selectableScenarios = [
  AtlasScenarios.base,
  AtlasScenarios.hovered,
  AtlasScenarios.pressed,
  AtlasScenarios.focused,
  AtlasScenario(
    'selected',
    states: {WidgetState.selected},
    props: {'selected': true},
  ),
  AtlasScenario(
    'disabled',
    states: {WidgetState.disabled},
    props: {'enabled': false},
  ),
];

const _buttonScenarios = [
  AtlasScenarios.base,
  AtlasScenarios.hovered,
  AtlasScenarios.pressed,
  AtlasScenarios.focused,
  AtlasScenario(
    'disabled',
    states: {WidgetState.disabled},
    props: {'enabled': false},
  ),
  AtlasScenario(
    'loading',
    label: 'Loading',
    states: {WidgetState.disabled},
    props: {'enabled': false, 'loading': true},
  ),
];

final _accordionAtlas = _matrixAtlas(
  id: 'accordion',
  label: 'Accordion',
  variants: FortalAccordionVariant.values,
  sizes: FortalAccordionSize.values,
  scenarios: const [
    AtlasScenario('collapsed'),
    AtlasScenario(
      'expanded',
      props: {'expanded': true, 'trailingIcon': 'remove'},
    ),
    AtlasScenarios.hovered,
    AtlasScenarios.focused,
    AtlasScenario(
      'disabled',
      states: {WidgetState.disabled},
      props: {'enabled': false},
    ),
  ],
  builder: (variant, size, cell) => SizedBox(
    width: 240,
    child: RemixAccordionGroup<String>(
      controller: RemixAccordionController<String>(min: 0, max: 1),
      initialExpandedValues: cell.propOr('expanded', false)
          ? const ['atlas-item']
          : const [],
      child: FortalAccordion<String>(
        value: 'atlas-item',
        title: 'What is Fortal?',
        leadingIcon: Icons.info_outline,
        variant: variant,
        size: size,
        enabled: !cell.disabled,
        child: const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text('A component recipe built with Remix and Mix.'),
        ),
      ),
    ),
  ),
);

final _avatarAtlas = _matrixAtlas(
  id: 'avatar',
  label: 'Avatar',
  variants: FortalAvatarVariant.values,
  sizes: FortalAvatarSize.values,
  scenarios: const [AtlasScenarios.base],
  builder: (variant, size, _) => FortalAvatar(
    label: 'LF',
    icon: Icons.person,
    variant: variant,
    size: size,
  ),
);

final _badgeAtlas = _matrixAtlas(
  id: 'badge',
  label: 'Badge',
  variants: FortalBadgeVariant.values,
  sizes: FortalBadgeSize.values,
  scenarios: const [AtlasScenarios.base],
  builder: (variant, size, _) =>
      FortalBadge(label: 'New', variant: variant, size: size),
);

final _buttonAtlas = _matrixAtlas(
  id: 'button',
  label: 'Button',
  variants: FortalButtonVariant.values,
  sizes: FortalButtonSize.values,
  scenarios: _buttonScenarios,
  builder: (variant, size, cell) => FortalButton(
    variant: variant,
    size: size,
    label: 'Button',
    leadingIcon: Icons.add,
    enabled: !cell.disabled,
    loading: cell.propOr('loading', false),
    onPressed: () {},
  ),
);

final _calloutAtlas = _matrixAtlas(
  id: 'callout',
  label: 'Callout',
  variants: FortalCalloutVariant.values,
  sizes: FortalCalloutSize.values,
  scenarios: const [AtlasScenarios.base],
  builder: (variant, size, _) => SizedBox(
    width: 360,
    child: FortalCallout(
      icon: Icons.info_outline,
      text: 'Helpful information.',
      variant: variant,
      size: size,
    ),
  ),
);

final _cardAtlas = _matrixAtlas(
  id: 'card',
  label: 'Card',
  variants: FortalCardVariant.values,
  sizes: FortalCardSize.values,
  scenarios: const [AtlasScenarios.base],
  builder: (variant, size, _) => FortalCard(
    variant: variant,
    size: size,
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FortalAvatar.solid(label: 'LF', size: FortalAvatarSize.size2),
        SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text('Leo Farias'), Text('Flutter engineer')],
        ),
      ],
    ),
  ),
);

final _checkboxAtlas = _matrixAtlas(
  id: 'checkbox',
  label: 'Checkbox',
  variants: FortalCheckboxVariant.values,
  sizes: FortalCheckboxSize.values,
  scenarios: _selectableScenarios,
  builder: (variant, size, cell) => FortalCheckbox(
    selected: cell.selected,
    enabled: !cell.disabled,
    onChanged: (_) {},
    semanticLabel: 'Accept terms',
    variant: variant,
    size: size,
  ),
);

final _dialogAtlas = ComponentAtlas(
  id: 'dialog',
  label: 'Dialog',
  scenarios: const [AtlasScenarios.base],
  rows: [
    AtlasRow(
      'default',
      (_, _) => SizedBox(
        width: 340,
        child: FortalDialog(
          title: 'Revoke access',
          description:
              'This application will no longer be accessible to the user.',
          actions: [
            FortalButton.ghost(label: 'Cancel', onPressed: () {}),
            FortalButton(label: 'Revoke', onPressed: () {}),
          ],
        ),
      ),
    ),
  ],
);

final _dividerAtlas = _singleAxisAtlas(
  id: 'divider',
  label: 'Divider',
  axisId: 'size',
  axisLabel: 'Size',
  values: FortalDividerSize.values,
  scenarios: const [AtlasScenarios.base],
  builder: (size, _) => SizedBox(width: 180, child: FortalDivider(size: size)),
);

final _iconButtonAtlas = _matrixAtlas(
  id: 'icon-button',
  label: 'Icon Button',
  variants: FortalIconButtonVariant.values,
  sizes: FortalIconButtonSize.values,
  scenarios: _buttonScenarios,
  builder: (variant, size, cell) => FortalIconButton(
    icon: Icons.add,
    variant: variant,
    size: size,
    enabled: !cell.disabled,
    loading: cell.propOr('loading', false),
    onPressed: () {},
  ),
);

final _menuAtlas = _matrixAtlas(
  id: 'menu',
  label: 'Menu',
  variants: FortalMenuVariant.values,
  sizes: FortalMenuSize.values,
  scenarios: _interactiveScenarios,
  builder: (variant, size, _) => FortalMenu<String>(
    trigger: const RemixMenuTrigger(
      label: 'Actions',
      icon: Icons.keyboard_arrow_down,
    ),
    items: const [
      RemixMenuItem(value: 'edit', label: 'Edit', leadingIcon: Icons.edit),
      RemixMenuItem(value: 'copy', label: 'Copy', leadingIcon: Icons.copy),
    ],
    variant: variant,
    size: size,
    onSelected: (_) {},
  ),
);

final _progressAtlas = _matrixAtlas(
  id: 'progress',
  label: 'Progress',
  variants: FortalProgressVariant.values,
  sizes: FortalProgressSize.values,
  scenarios: const [
    AtlasScenario('empty', props: {'value': 0.0}),
    AtlasScenario('half', props: {'value': 0.5}),
    AtlasScenario('complete', props: {'value': 1.0}),
  ],
  builder: (variant, size, cell) => SizedBox(
    width: 180,
    child: FortalProgress(
      value: cell.propOr('value', 0.5),
      variant: variant,
      size: size,
    ),
  ),
);

final _radioAtlas = _matrixAtlas(
  id: 'radio',
  label: 'Radio',
  variants: FortalRadioVariant.values,
  sizes: FortalRadioSize.values,
  scenarios: _selectableScenarios,
  builder: (variant, size, cell) => RemixRadioGroup<String>(
    groupValue: cell.selected ? 'atlas-option' : null,
    onChanged: (_) {},
    child: FortalRadio<String>(
      value: 'atlas-option',
      enabled: !cell.disabled,
      variant: variant,
      size: size,
    ),
  ),
);

final _selectAtlas = _matrixAtlas(
  id: 'select',
  label: 'Select',
  variants: FortalSelectVariant.values,
  sizes: FortalSelectSize.values,
  scenarios: _interactiveScenarios,
  builder: (variant, size, cell) => FortalSelect<String>(
    trigger: const RemixSelectTrigger(placeholder: 'Choose fruit'),
    items: const [
      RemixSelectItem(value: 'apple', label: 'Apple'),
      RemixSelectItem(value: 'banana', label: 'Banana'),
    ],
    selectedValue: 'apple',
    enabled: !cell.disabled,
    variant: variant,
    size: size,
    onChanged: (_) {},
  ),
);

final _sliderAtlas = _matrixAtlas(
  id: 'slider',
  label: 'Slider',
  variants: FortalSliderVariant.values,
  sizes: FortalSliderSize.values,
  scenarios: _interactiveScenarios,
  builder: (variant, size, cell) => SizedBox(
    width: 180,
    child: FortalSlider(
      value: 0.55,
      enabled: !cell.disabled,
      variant: variant,
      size: size,
      onChanged: (_) {},
    ),
  ),
);

final _spinnerAtlas = _singleAxisAtlas(
  id: 'spinner',
  label: 'Spinner',
  axisId: 'size',
  axisLabel: 'Size',
  values: FortalSpinnerSize.values,
  scenarios: const [AtlasScenarios.base],
  builder: (size, _) => FortalSpinner(size: size),
);

final _switchAtlas = _matrixAtlas(
  id: 'switch',
  label: 'Switch',
  variants: FortalSwitchVariant.values,
  sizes: FortalSwitchSize.values,
  scenarios: _selectableScenarios,
  builder: (variant, size, cell) => FortalSwitch(
    selected: cell.selected,
    enabled: !cell.disabled,
    variant: variant,
    size: size,
    onChanged: (_) {},
    semanticLabel: 'Notifications',
  ),
);

final _tabsAtlas = ComponentAtlas(
  id: 'tabs',
  label: 'Tabs',
  scenarios: const [
    AtlasScenario('first', props: {'tab': 'first'}),
    AtlasScenario('second', props: {'tab': 'second'}),
  ],
  rows: [
    AtlasRow(
      'default',
      (_, cell) => SizedBox(
        width: 280,
        child: RemixTabs(
          selectedTabId: cell.propOr('tab', 'first'),
          onChanged: (_) {},
          child: ColumnBox(
            style: FlexBoxStyler().spacing(12),
            children: const [
              FortalTabBar(
                child: RowBox(
                  children: [
                    FortalTab(tabId: 'first', label: 'Overview'),
                    FortalTab(tabId: 'second', label: 'Activity'),
                  ],
                ),
              ),
              RowBox(
                children: [
                  FortalTabView(
                    tabId: 'first',
                    child: Text('Overview content'),
                  ),
                  FortalTabView(
                    tabId: 'second',
                    child: Text('Activity content'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  ],
);

final _textFieldAtlas = _matrixAtlas(
  id: 'textfield',
  label: 'Text Field',
  variants: FortalTextFieldVariant.values,
  sizes: FortalTextFieldSize.values,
  scenarios: const [
    ..._interactiveScenarios,
    AtlasScenario(
      'error',
      states: {WidgetState.error},
      props: {'error': true, 'helperText': 'Enter a valid address'},
    ),
  ],
  builder: (variant, size, cell) => SizedBox(
    width: 220,
    child: FortalTextField(
      label: 'Email',
      hintText: 'name@example.com',
      helperText: cell.error ? 'Enter a valid address' : 'Required',
      error: cell.propOr('error', false),
      enabled: !cell.disabled,
      leading: const Icon(Icons.email_outlined),
      variant: variant,
      size: size,
    ),
  ),
);

final _toggleAtlas = _matrixAtlas(
  id: 'toggle',
  label: 'Toggle',
  variants: FortalToggleVariant.values,
  sizes: FortalToggleSize.values,
  scenarios: _selectableScenarios,
  builder: (variant, size, cell) => FortalToggle(
    label: 'Bold',
    icon: Icons.format_bold,
    selected: cell.selected,
    enabled: !cell.disabled,
    variant: variant,
    size: size,
    onChanged: (_) {},
  ),
);

final _tooltipAtlas = ComponentAtlas(
  id: 'tooltip',
  label: 'Tooltip',
  scenarios: const [
    AtlasScenario('default', props: {'buttonState': 'default'}),
    AtlasScenario(
      'hovered',
      states: {WidgetState.hovered},
      props: {'buttonState': 'hovered'},
    ),
    AtlasScenario(
      'focused',
      states: {WidgetState.focused},
      props: {'buttonState': 'focused'},
    ),
  ],
  rows: [
    AtlasRow(
      'default',
      (_, _) => FortalTooltip(
        tooltipChild: const Text('Helpful context'),
        tooltipSemantics: 'Helpful context',
        child: FortalButton(label: 'Hover me', onPressed: () {}),
      ),
    ),
  ],
);

ComponentAtlas _matrixAtlas<V extends Enum, S extends Enum>({
  required String id,
  required String label,
  required List<V> variants,
  required List<S> sizes,
  required List<AtlasScenario> scenarios,
  required Widget Function(V variant, S size, AtlasCellContext cell) builder,
}) {
  return ComponentAtlas(
    id: id,
    label: label,
    rowAxes: const [AtlasAxis('variant', 'Variant'), AtlasAxis('size', 'Size')],
    scenarios: scenarios,
    rows: [
      for (final variant in variants)
        for (final size in sizes)
          AtlasRow(
            '${variant.name}-${size.name}',
            (_, cell) => builder(variant, size, cell),
            values: {
              'variant': AtlasAxisValue(variant.name, _title(variant.name)),
              'size': AtlasAxisValue(size.name, _enumSizeLabel(size)),
            },
          ),
    ],
  );
}

ComponentAtlas _singleAxisAtlas<T extends Enum>({
  required String id,
  required String label,
  required String axisId,
  required String axisLabel,
  required List<T> values,
  required List<AtlasScenario> scenarios,
  required Widget Function(T value, AtlasCellContext cell) builder,
}) {
  return ComponentAtlas(
    id: id,
    label: label,
    rowAxes: [AtlasAxis(axisId, axisLabel)],
    scenarios: scenarios,
    rows: [
      for (final value in values)
        AtlasRow(
          value.name,
          (_, cell) => builder(value, cell),
          values: {axisId: AtlasAxisValue(value.name, _enumSizeLabel(value))},
        ),
    ],
  );
}

String _enumSizeLabel(Enum value) {
  final match = RegExp(r'^size([0-9]+)$').firstMatch(value.name);

  return match == null ? _title(value.name) : 'Size ${match.group(1)}';
}

String _title(String value) => '${value[0].toUpperCase()}${value.substring(1)}';

final fortalAtlasEntries = <FortalAtlasEntry>[
  FortalAtlasEntry(
    atlas: _accordionAtlas,
    portableAdapter: buildFortalAccordionPortable,
  ),
  FortalAtlasEntry(
    atlas: _avatarAtlas,
    portableAdapter: buildFortalAvatarPortable,
  ),
  FortalAtlasEntry(
    atlas: _badgeAtlas,
    portableAdapter: buildFortalBadgePortable,
  ),
  FortalAtlasEntry(
    atlas: _buttonAtlas,
    portableAdapter: buildFortalButtonPortable,
  ),
  FortalAtlasEntry(
    atlas: _calloutAtlas,
    portableAdapter: buildFortalCalloutPortable,
  ),
  FortalAtlasEntry(atlas: _cardAtlas, portableAdapter: buildFortalCardPortable),
  FortalAtlasEntry(
    atlas: _checkboxAtlas,
    portableAdapter: buildFortalCheckboxPortable,
  ),
  FortalAtlasEntry(
    atlas: _dialogAtlas,
    portableAdapter: buildFortalDialogPortable,
  ),
  FortalAtlasEntry(
    atlas: _dividerAtlas,
    portableAdapter: buildFortalDividerPortable,
  ),
  FortalAtlasEntry(
    atlas: _iconButtonAtlas,
    portableAdapter: buildFortalIconButtonPortable,
  ),
  FortalAtlasEntry(atlas: _menuAtlas, portableAdapter: buildFortalMenuPortable),
  FortalAtlasEntry(
    atlas: _progressAtlas,
    portableAdapter: buildFortalProgressPortable,
  ),
  FortalAtlasEntry(
    atlas: _radioAtlas,
    portableAdapter: buildFortalRadioPortable,
  ),
  FortalAtlasEntry(
    atlas: _selectAtlas,
    portableAdapter: buildFortalSelectPortable,
  ),
  FortalAtlasEntry(
    atlas: _sliderAtlas,
    portableAdapter: buildFortalSliderPortable,
  ),
  FortalAtlasEntry(
    atlas: _spinnerAtlas,
    portableAdapter: buildFortalSpinnerPortable,
  ),
  FortalAtlasEntry(
    atlas: _switchAtlas,
    portableAdapter: buildFortalSwitchPortable,
  ),
  FortalAtlasEntry(atlas: _tabsAtlas, portableAdapter: buildFortalTabsPortable),
  FortalAtlasEntry(
    atlas: _textFieldAtlas,
    portableAdapter: buildFortalTextFieldPortable,
  ),
  FortalAtlasEntry(
    atlas: _toggleAtlas,
    portableAdapter: buildFortalTogglePortable,
  ),
  FortalAtlasEntry(
    atlas: _tooltipAtlas,
    portableAdapter: buildFortalTooltipPortable,
  ),
];
