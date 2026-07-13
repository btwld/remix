import 'package:flutter/material.dart';
import 'package:mix_specimen/mix_specimen.dart';
import 'package:remix/remix.dart';

import 'fortal_themes.dart';

void _noop() {}
void _changed<T>(T? _) {}

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

SpecimenRow _sizeRow(Enum size, SpecimenCellBuilder builder) =>
    SpecimenRow(size.name, builder, values: {'size': _value(size)});

const _selectedHovered = SpecimenScenario(
  'selected-hovered',
  label: 'Selected + hovered',
  states: {WidgetState.selected, WidgetState.hovered},
);
const _loading = SpecimenScenario('loading', props: {'loading': true});

final fortalCatalog = SpecimenCatalog(
  id: 'fortal',
  label: 'Fortal',
  themes: fortalThemes,
  specimens: [
    _accordion(),
    _avatar(),
    _badge(),
    _button(),
    _callout(),
    _card(),
    _checkbox(),
    _dialog(),
    _divider(),
    _iconButton(),
    _menu(),
    _progress(),
    _radio(),
    _select(),
    _slider(),
    _spinner(),
    _switch(),
    _tabs(),
    _textField(),
    _toggle(),
    _tooltip(),
  ],
);

Specimen _avatar() => Specimen(
  id: 'avatar',
  label: 'Avatar',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [
    SpecimenScenario('label'),
    SpecimenScenario('icon', props: {'icon': true}),
  ],
  rows: [
    for (final variant in FortalAvatarVariant.values)
      for (final size in FortalAvatarSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, sim) => RemixAvatar(
            label: sim.propOr('icon', false) ? null : 'AB',
            icon: sim.propOr('icon', false) ? Icons.person : null,
            styleSpec: sim.resolve(
              context,
              fortalAvatarStyle(variant: variant, size: size),
            ),
          ),
        ),
  ],
);

Specimen _badge() => Specimen(
  id: 'badge',
  label: 'Badge',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [Scenarios.base],
  rows: [
    for (final variant in FortalBadgeVariant.values)
      for (final size in FortalBadgeSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, sim) => RemixBadge(
            label: 'Badge',
            styleSpec: sim.resolve(
              context,
              fortalBadgeStyle(variant: variant, size: size),
            ),
          ),
        ),
  ],
);

Specimen _button() => Specimen(
  id: 'button',
  label: 'Button',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [...Scenarios.interactive, _loading],
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
              RemixButtonStyler()
                  .mainAxisSize(MainAxisSize.min)
                  .merge(fortalButtonStyle(variant: variant, size: size)),
            ),
          ),
        ),
  ],
);

Specimen _callout() => Specimen(
  id: 'callout',
  label: 'Callout',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [SpecimenScenario('default-composed')],
  rows: [
    for (final variant in FortalCalloutVariant.values)
      for (final size in FortalCalloutSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, sim) => RemixCallout(
            icon: Icons.info_outline,
            text: 'Helpful information',
            styleSpec: sim.resolve(
              context,
              fortalCalloutStyle(variant: variant, size: size),
            ),
          ),
        ),
  ],
);

Specimen _card() => Specimen(
  id: 'card',
  label: 'Card',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [SpecimenScenario('default-composed')],
  rows: [
    for (final variant in FortalCardVariant.values)
      for (final size in FortalCardSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, sim) => RemixCard(
            styleSpec: sim.resolve(
              context,
              fortalCardStyle(variant: variant, size: size),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [Text('Card title'), Text('Supporting content')],
            ),
          ),
        ),
  ],
);

Specimen _checkbox() => Specimen(
  id: 'checkbox',
  label: 'Checkbox',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [
    ...Scenarios.selectable,
    _selectedHovered,
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
              onChanged: sim.disabled ? null : _changed,
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

Specimen _divider() => Specimen(
  id: 'divider',
  label: 'Divider',
  rowAxes: const [_sizeAxis],
  scenarios: const [Scenarios.base],
  rows: [
    for (final size in FortalDividerSize.values)
      _sizeRow(
        size,
        (context, sim) => SizedBox(
          width: 160,
          child: RemixDivider(
            styleSpec: sim.resolve(context, fortalDividerStyle(size: size)),
          ),
        ),
      ),
  ],
);

Specimen _iconButton() => Specimen(
  id: 'icon-button',
  label: 'Icon Button',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [...Scenarios.interactive, _loading],
  rows: [
    for (final variant in FortalIconButtonVariant.values)
      for (final size in FortalIconButtonSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, sim) => RemixIconButton(
            icon: Icons.add,
            loading: sim.propOr('loading', false),
            onPressed: sim.disabled ? null : _noop,
            styleSpec: sim
                .resolve(
                  context,
                  fortalIconButtonStyle(variant: variant, size: size),
                )
                .spec,
          ),
        ),
  ],
);

Specimen _progress() => Specimen(
  id: 'progress',
  label: 'Progress',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [
    SpecimenScenario('empty', props: {'value': 0.0}),
    SpecimenScenario('quarter', props: {'value': 0.25}),
    SpecimenScenario('half', props: {'value': 0.5}),
    SpecimenScenario('full', props: {'value': 1.0}),
  ],
  rows: [
    for (final variant in FortalProgressVariant.values)
      for (final size in FortalProgressSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, sim) => SizedBox(
            width: 140,
            child: RemixProgress(
              value: sim.propOr('value', 0.0),
              styleSpec: sim.resolve(
                context,
                fortalProgressStyle(variant: variant, size: size),
              ),
            ),
          ),
        ),
  ],
);

Specimen _spinner() => Specimen(
  id: 'spinner',
  label: 'Spinner',
  rowAxes: const [_sizeAxis],
  scenarios: const [Scenarios.base],
  rows: [
    for (final size in FortalSpinnerSize.values)
      _sizeRow(
        size,
        (context, sim) => RemixSpinner(
          styleSpec: sim.resolve(context, fortalSpinnerStyle(size: size)),
        ),
      ),
  ],
);

Specimen _radio() => Specimen(
  id: 'radio',
  label: 'Radio',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [...Scenarios.selectable, _selectedHovered],
  rows: [
    for (final variant in FortalRadioVariant.values)
      for (final size in FortalRadioSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, sim) => RemixRadioGroup<String>(
            groupValue: sim.selected ? 'value' : null,
            onChanged: _changed,
            child: RemixRadio<String>(
              value: 'value',
              enabled: !sim.disabled,
              styleSpec: sim
                  .resolve(
                    context,
                    fortalRadioStyle(variant: variant, size: size),
                  )
                  .spec,
            ),
          ),
        ),
  ],
);

Specimen _slider() => Specimen(
  id: 'slider',
  label: 'Slider',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [
    SpecimenScenario('mid', props: {'value': 0.5}),
    SpecimenScenario(
      'hovered',
      states: {WidgetState.hovered},
      props: {'value': 0.5},
    ),
    SpecimenScenario(
      'pressed',
      states: {WidgetState.pressed},
      props: {'value': 0.5},
    ),
    SpecimenScenario(
      'focused',
      states: {WidgetState.focused},
      props: {'value': 0.5},
    ),
    SpecimenScenario(
      'disabled',
      states: {WidgetState.disabled},
      props: {'value': 0.5},
    ),
    SpecimenScenario('minimum', props: {'value': 0.0}),
    SpecimenScenario('maximum', props: {'value': 1.0}),
  ],
  rows: [
    for (final variant in FortalSliderVariant.values)
      for (final size in FortalSliderSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, sim) => SizedBox(
            width: 160,
            child: RemixSlider(
              value: sim.propOr('value', 0.5),
              onChanged: _changed,
              enabled: !sim.disabled,
              styleSpec: sim
                  .resolve(
                    context,
                    fortalSliderStyle(variant: variant, size: size),
                  )
                  .spec,
            ),
          ),
        ),
  ],
);

Specimen _switch() => Specimen(
  id: 'switch',
  label: 'Switch',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [...Scenarios.selectable, _selectedHovered],
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
              onChanged: _changed,
              styleSpec: sim.resolve(context, style).spec,
            );
          },
        ),
  ],
);

Specimen _textField() => Specimen(
  id: 'text-field',
  label: 'Text Field',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [
    Scenarios.base,
    Scenarios.hovered,
    Scenarios.focused,
    Scenarios.disabled,
    SpecimenScenario(
      'error',
      states: {WidgetState.error},
      props: {'error': true},
    ),
    SpecimenScenario('populated', props: {'populated': true}),
  ],
  rows: [
    for (final variant in FortalTextFieldVariant.values)
      for (final size in FortalTextFieldSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, sim) => SizedBox(
            width: 190,
            child: RemixTextField(
              label: 'Label',
              hintText: sim.propOr('populated', false) ? null : 'Placeholder',
              controller: sim.propOr('populated', false)
                  ? TextEditingController(text: 'Value')
                  : null,
              enabled: !sim.disabled,
              error: sim.propOr('error', false),
              styleSpec: sim
                  .resolve(
                    context,
                    RemixTextFieldStyle()
                        .text(
                          TextStyler(style: TextStyleMix(fontFamily: 'Roboto')),
                        )
                        .merge(
                          fortalTextFieldStyle(variant: variant, size: size),
                        ),
                  )
                  .spec,
            ),
          ),
        ),
  ],
);

Specimen _toggle() => Specimen(
  id: 'toggle',
  label: 'Toggle',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [...Scenarios.selectable, _selectedHovered],
  rows: [
    for (final variant in FortalToggleVariant.values)
      for (final size in FortalToggleSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, sim) => RemixToggle(
            selected: sim.selected,
            enabled: !sim.disabled,
            onChanged: _changed,
            icon: Icons.format_bold,
            label: 'Bold',
            styleSpec: sim
                .resolve(
                  context,
                  fortalToggleStyle(variant: variant, size: size),
                )
                .spec,
          ),
        ),
  ],
);

Specimen _accordion() => Specimen(
  id: 'accordion',
  label: 'Accordion',
  scenarios: const [
    SpecimenScenario('collapsed'),
    SpecimenScenario('expanded', props: {'expanded': true}),
    Scenarios.hovered,
    Scenarios.pressed,
    Scenarios.focused,
    Scenarios.disabled,
  ],
  rows: [
    SpecimenRow(
      'default',
      (context, sim) => SizedBox(
        width: 240,
        child: RemixAccordionGroup<String>(
          controller: RemixAccordionController<String>(min: 0, max: 1),
          initialExpandedValues: sim.propOr('expanded', false)
              ? const ['a']
              : const [],
          child: RemixAccordion<String>(
            value: 'a',
            title: 'Accordion item',
            enabled: !sim.disabled,
            styleSpec: sim.resolve(context, fortalAccordionStyle()).spec,
            child: const Text('Expanded panel content'),
          ),
        ),
      ),
    ),
  ],
);

Specimen _tabs() => Specimen(
  id: 'tabs',
  label: 'Tabs',
  scenarios: const [...Scenarios.selectable],
  rows: [
    SpecimenRow(
      'default',
      (context, sim) => SizedBox(
        width: 260,
        child: RemixTabs(
          selectedTabId: sim.selected ? 'second' : 'first',
          onChanged: (_) {},
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RemixTabBar(
                child: Row(
                  children: [
                    RemixTab(
                      tabId: 'first',
                      label: 'First',
                      enabled: !sim.disabled,
                      styleSpec: sim.resolve(context, fortalTabStyle()).spec,
                    ),
                    RemixTab(
                      tabId: 'second',
                      label: 'Second',
                      styleSpec: sim.resolve(context, fortalTabStyle()).spec,
                    ),
                  ],
                ),
              ),
              const RemixTabView(tabId: 'first', child: Text('First panel')),
              const RemixTabView(tabId: 'second', child: Text('Second panel')),
            ],
          ),
        ),
      ),
    ),
  ],
);

Specimen _menu() => Specimen(
  id: 'menu',
  label: 'Menu',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [
    SpecimenScenario('closed'),
    Scenarios.hovered,
    Scenarios.focused,
    Scenarios.disabled,
    SpecimenScenario('open', props: {'open': true}),
  ],
  rows: [
    for (final variant in FortalMenuVariant.values)
      for (final size in FortalMenuSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, sim) => SizedBox(
            width: 220,
            height: 150,
            child: SpecimenOverlayHost(
              child: Align(
                alignment: Alignment.topLeft,
                child: _ResolvedMenuCell(
                  open: sim.propOr('open', false),
                  enabled: !sim.disabled,
                  itemStyle: fortalMenuItemStyle(variant: variant, size: size),
                  styleSpec: sim
                      .resolve(
                        context,
                        RemixMenuStyle()
                            .trigger(
                              RemixMenuTriggerStyle().mainAxisSize(
                                MainAxisSize.min,
                              ),
                            )
                            .overlay(
                              FlexBoxStyler()
                                  .mainAxisSize(MainAxisSize.min)
                                  .wrap(WidgetModifierConfig.intrinsicWidth()),
                            )
                            .merge(
                              fortalMenuStyle(variant: variant, size: size),
                            ),
                      )
                      .spec,
                ),
              ),
            ),
          ),
        ),
  ],
);

Specimen _select() => Specimen(
  id: 'select',
  label: 'Select',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [
    SpecimenScenario('placeholder'),
    SpecimenScenario('selected-value', props: {'selected': true}),
    Scenarios.hovered,
    Scenarios.focused,
    Scenarios.disabled,
    SpecimenScenario('open', props: {'open': true}),
  ],
  rows: [
    for (final variant in FortalSelectVariant.values)
      for (final size in FortalSelectSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, sim) => SizedBox(
            width: 220,
            height: 170,
            child: SpecimenOverlayHost(
              child: Align(
                alignment: Alignment.topLeft,
                child: _SelectCell(
                  open: sim.propOr('open', false),
                  enabled: !sim.disabled,
                  selected: sim.propOr('selected', false),
                  itemStyleSpec: sim
                      .resolve(
                        context,
                        fortalSelectMenuItemStyle(variant: variant, size: size),
                      )
                      .spec,
                  styleSpec: sim
                      .resolve(
                        context,
                        RemixSelectStyle()
                            .trigger(
                              RemixSelectTriggerStyle()
                                  .mainAxisSize(MainAxisSize.min)
                                  .wrap(WidgetModifierConfig.intrinsicWidth()),
                            )
                            .menuContainer(
                              FlexBoxStyler()
                                  .mainAxisSize(MainAxisSize.min)
                                  .wrap(WidgetModifierConfig.intrinsicWidth()),
                            )
                            .merge(
                              fortalSelectStyle(variant: variant, size: size),
                            ),
                      )
                      .spec,
                ),
              ),
            ),
          ),
        ),
  ],
);

Specimen _tooltip() => Specimen(
  id: 'tooltip',
  label: 'Tooltip',
  scenarios: const [
    SpecimenScenario('closed'),
    SpecimenScenario('open', props: {'open': true}),
  ],
  rows: [
    SpecimenRow(
      'default',
      (context, sim) => SizedBox(
        width: 180,
        height: 90,
        child: SpecimenOverlayHost(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: RemixTooltip(
              initiallyOpen: sim.propOr('open', false),
              tooltipChild: const Text('Helpful tooltip'),
              styleSpec: sim.resolve(context, fortalTooltipStyle()).spec,
              child: const Icon(Icons.info_outline),
            ),
          ),
        ),
      ),
    ),
  ],
);

Specimen _dialog() => Specimen(
  id: 'dialog',
  label: 'Dialog',
  scenarios: const [SpecimenScenario('modal')],
  rows: [
    SpecimenRow(
      'default',
      (context, sim) => SizedBox(
        width: 420,
        height: 300,
        child: SpecimenOverlayHost(
          child: _DialogCell(
            styleSpec: sim.resolve(context, fortalDialogStyle()).spec,
          ),
        ),
      ),
    ),
  ],
);

class _MenuCell extends StatefulWidget {
  const _MenuCell({
    required this.open,
    required this.enabled,
    required this.styleSpec,
    required this.normalItemSpec,
    required this.hoveredItemSpec,
    required this.disabledItemSpec,
  });
  final bool open;
  final bool enabled;
  final RemixMenuSpec styleSpec;
  final RemixMenuItemSpec normalItemSpec;
  final RemixMenuItemSpec hoveredItemSpec;
  final RemixMenuItemSpec disabledItemSpec;

  @override
  State<_MenuCell> createState() => _MenuCellState();
}

class _ResolvedMenuCell extends StatelessWidget {
  const _ResolvedMenuCell({
    required this.open,
    required this.enabled,
    required this.styleSpec,
    required this.itemStyle,
  });
  final bool open;
  final bool enabled;
  final RemixMenuSpec styleSpec;
  final RemixMenuItemStyle itemStyle;

  @override
  Widget build(BuildContext context) {
    final normal = itemStyle.build(context).spec;
    return WidgetStateProvider(
      states: const {WidgetState.hovered},
      child: Builder(
        builder: (hoveredContext) => WidgetStateProvider(
          states: const {WidgetState.disabled},
          child: Builder(
            builder: (disabledContext) => _MenuCell(
              open: open,
              enabled: enabled,
              styleSpec: styleSpec,
              normalItemSpec: normal,
              hoveredItemSpec: itemStyle.build(hoveredContext).spec,
              disabledItemSpec: itemStyle.build(disabledContext).spec,
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectCell extends StatefulWidget {
  const _SelectCell({
    required this.open,
    required this.enabled,
    required this.selected,
    required this.styleSpec,
    required this.itemStyleSpec,
  });
  final bool open;
  final bool enabled;
  final bool selected;
  final RemixSelectSpec styleSpec;
  final RemixSelectMenuItemSpec itemStyleSpec;

  @override
  State<_SelectCell> createState() => _SelectCellState();
}

class _SelectCellState extends State<_SelectCell> {
  final controller = MenuController();

  @override
  void initState() {
    super.initState();
    if (widget.open) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) controller.open();
      });
    }
  }

  @override
  Widget build(BuildContext context) => RemixSelect<String>(
    controller: controller,
    initiallyOpen: widget.open,
    trigger: const RemixSelectTrigger(placeholder: 'Choose option'),
    items: [
      RemixSelectItem(
        value: 'one',
        label: 'Option one',
        styleSpec: widget.itemStyleSpec,
      ),
      RemixSelectItem(
        value: 'two',
        label: 'Option two',
        styleSpec: widget.itemStyleSpec,
      ),
      RemixSelectItem(
        value: 'disabled',
        label: 'Disabled',
        enabled: false,
        styleSpec: widget.itemStyleSpec,
      ),
    ],
    selectedValue: widget.selected ? 'one' : null,
    enabled: widget.enabled,
    onChanged: _changed,
    styleSpec: widget.styleSpec,
  );
}

class _MenuCellState extends State<_MenuCell> {
  final controller = MenuController();

  @override
  void initState() {
    super.initState();
    if (widget.open) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) controller.open();
      });
    }
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
    ignoring: !widget.enabled,
    child: RemixMenu<String>(
      controller: controller,
      trigger: const RemixMenuTrigger(label: 'Actions'),
      items: [
        RemixMenuItem(
          value: 'normal',
          label: 'Normal',
          styleSpec: widget.normalItemSpec,
        ),
        RemixMenuItem(
          value: 'hovered',
          label: 'Hovered',
          styleSpec: widget.hoveredItemSpec,
        ),
        RemixMenuItem(
          value: 'disabled',
          label: 'Disabled',
          enabled: false,
          styleSpec: widget.disabledItemSpec,
        ),
      ],
      styleSpec: widget.styleSpec,
    ),
  );
}

class _DialogCell extends StatefulWidget {
  const _DialogCell({required this.styleSpec});
  final RemixDialogSpec styleSpec;

  @override
  State<_DialogCell> createState() => _DialogCellState();
}

class _DialogCellState extends State<_DialogCell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showGeneralDialog<void>(
        context: context,
        useRootNavigator: false,
        transitionDuration: Duration.zero,
        barrierDismissible: false,
        barrierColor: Colors.black54,
        pageBuilder: (context, animation, secondaryAnimation) => Center(
          child: RemixDialog(
            title: 'Dialog title',
            description: 'Dialog description',
            styleSpec: widget.styleSpec,
            actions: [RemixButton(label: 'Done', onPressed: _noop)],
            child: const Text('Dialog body'),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox(width: 320, height: 220);
}
