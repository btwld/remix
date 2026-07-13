import 'package:flutter/material.dart';
import 'package:mix_sheets/mix_sheets.dart';
import 'package:remix/remix.dart';

import 'fortal_themes.dart';

void _noop() {}
void _changed<T>(T? _) {}

const _variantAxis = SheetAxis('variant', 'Variant');
const _sizeAxis = SheetAxis('size', 'Size');

SheetAxisValue _value(Enum value) =>
    SheetAxisValue(value.name, _label(value.name));

String _label(String value) =>
    '${value[0].toUpperCase()}${value.substring(1).replaceAllMapped(RegExp(r'([0-9]+)'), (match) => ' ${match[1]}')}';

SheetRow _row({
  required Enum variant,
  required Enum size,
  required SheetCellBuilder builder,
}) => SheetRow(
  '${variant.name}-${size.name}',
  builder,
  values: {'variant': _value(variant), 'size': _value(size)},
);

SheetRow _sizeRow(Enum size, SheetCellBuilder builder) =>
    SheetRow(size.name, builder, values: {'size': _value(size)});

const _selectedHovered = SheetScenario(
  'selected-hovered',
  label: 'Selected + hovered',
  states: {WidgetState.selected, WidgetState.hovered},
);
const _loading = SheetScenario('loading', props: {'loading': true});

final fortalCatalog = SheetCatalog(
  id: 'fortal',
  label: 'Fortal',
  themes: fortalThemes,
  sheets: [
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

ComponentSheet _avatar() => ComponentSheet(
  id: 'avatar',
  label: 'Avatar',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [
    SheetScenario('label'),
    SheetScenario('icon', props: {'icon': true}),
  ],
  rows: [
    for (final variant in FortalAvatarVariant.values)
      for (final size in FortalAvatarSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, cell) => RemixAvatar(
            label: cell.propOr('icon', false) ? null : 'AB',
            icon: cell.propOr('icon', false) ? Icons.person : null,
            styleSpec: cell.resolve(
              context,
              fortalAvatarStyle(variant: variant, size: size),
            ),
          ),
        ),
  ],
);

ComponentSheet _badge() => ComponentSheet(
  id: 'badge',
  label: 'Badge',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [SheetScenarios.base],
  rows: [
    for (final variant in FortalBadgeVariant.values)
      for (final size in FortalBadgeSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, cell) => RemixBadge(
            label: 'Badge',
            styleSpec: cell.resolve(
              context,
              fortalBadgeStyle(variant: variant, size: size),
            ),
          ),
        ),
  ],
);

ComponentSheet _button() => ComponentSheet(
  id: 'button',
  label: 'Button',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [...SheetScenarios.interactive, _loading],
  rows: [
    for (final variant in FortalButtonVariant.values)
      for (final size in FortalButtonSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, cell) => RemixButton(
            label: 'Button',
            leadingIcon: Icons.add,
            enabled: !cell.disabled,
            loading: cell.propOr('loading', false),
            onPressed: cell.disabled ? null : _noop,
            styleSpec: cell.resolve(
              context,
              RemixButtonStyler()
                  .mainAxisSize(MainAxisSize.min)
                  .merge(fortalButtonStyle(variant: variant, size: size)),
            ),
          ),
        ),
  ],
);

ComponentSheet _callout() => ComponentSheet(
  id: 'callout',
  label: 'Callout',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [SheetScenario('default-composed')],
  rows: [
    for (final variant in FortalCalloutVariant.values)
      for (final size in FortalCalloutSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, cell) => RemixCallout(
            icon: Icons.info_outline,
            text: 'Helpful information',
            styleSpec: cell.resolve(
              context,
              fortalCalloutStyle(variant: variant, size: size),
            ),
          ),
        ),
  ],
);

ComponentSheet _card() => ComponentSheet(
  id: 'card',
  label: 'Card',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [SheetScenario('default-composed')],
  rows: [
    for (final variant in FortalCardVariant.values)
      for (final size in FortalCardSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, cell) => RemixCard(
            styleSpec: cell.resolve(
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

ComponentSheet _checkbox() => ComponentSheet(
  id: 'checkbox',
  label: 'Checkbox',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [
    ...SheetScenarios.selectable,
    _selectedHovered,
    SheetScenario('indeterminate', props: {'indeterminate': true}),
  ],
  rows: [
    for (final variant in FortalCheckboxVariant.values)
      for (final size in FortalCheckboxSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, cell) {
            final indeterminate = cell.propOr('indeterminate', false);
            return RemixCheckbox(
              selected: indeterminate ? null : cell.selected,
              tristate: indeterminate,
              enabled: !cell.disabled,
              onChanged: cell.disabled ? null : _changed,
              styleSpec: cell
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

ComponentSheet _divider() => ComponentSheet(
  id: 'divider',
  label: 'Divider',
  rowAxes: const [_sizeAxis],
  scenarios: const [SheetScenarios.base],
  rows: [
    for (final size in FortalDividerSize.values)
      _sizeRow(
        size,
        (context, cell) => SizedBox(
          width: 160,
          child: RemixDivider(
            styleSpec: cell.resolve(context, fortalDividerStyle(size: size)),
          ),
        ),
      ),
  ],
);

ComponentSheet _iconButton() => ComponentSheet(
  id: 'icon-button',
  label: 'Icon Button',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [...SheetScenarios.interactive, _loading],
  rows: [
    for (final variant in FortalIconButtonVariant.values)
      for (final size in FortalIconButtonSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, cell) => RemixIconButton(
            icon: Icons.add,
            loading: cell.propOr('loading', false),
            onPressed: cell.disabled ? null : _noop,
            styleSpec: cell
                .resolve(
                  context,
                  fortalIconButtonStyle(variant: variant, size: size),
                )
                .spec,
          ),
        ),
  ],
);

ComponentSheet _progress() => ComponentSheet(
  id: 'progress',
  label: 'Progress',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [
    SheetScenario('empty', props: {'value': 0.0}),
    SheetScenario('quarter', props: {'value': 0.25}),
    SheetScenario('half', props: {'value': 0.5}),
    SheetScenario('full', props: {'value': 1.0}),
  ],
  rows: [
    for (final variant in FortalProgressVariant.values)
      for (final size in FortalProgressSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, cell) => SizedBox(
            width: 140,
            child: RemixProgress(
              value: cell.propOr('value', 0.0),
              styleSpec: cell.resolve(
                context,
                fortalProgressStyle(variant: variant, size: size),
              ),
            ),
          ),
        ),
  ],
);

ComponentSheet _spinner() => ComponentSheet(
  id: 'spinner',
  label: 'Spinner',
  rowAxes: const [_sizeAxis],
  scenarios: const [SheetScenarios.base],
  rows: [
    for (final size in FortalSpinnerSize.values)
      _sizeRow(
        size,
        (context, cell) => RemixSpinner(
          styleSpec: cell.resolve(context, fortalSpinnerStyle(size: size)),
        ),
      ),
  ],
);

ComponentSheet _radio() => ComponentSheet(
  id: 'radio',
  label: 'Radio',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [...SheetScenarios.selectable, _selectedHovered],
  rows: [
    for (final variant in FortalRadioVariant.values)
      for (final size in FortalRadioSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, cell) => RemixRadioGroup<String>(
            groupValue: cell.selected ? 'value' : null,
            onChanged: _changed,
            child: RemixRadio<String>(
              value: 'value',
              enabled: !cell.disabled,
              styleSpec: cell
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

ComponentSheet _slider() => ComponentSheet(
  id: 'slider',
  label: 'Slider',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [
    SheetScenario('mid', props: {'value': 0.5}),
    SheetScenario(
      'hovered',
      states: {WidgetState.hovered},
      props: {'value': 0.5},
    ),
    SheetScenario(
      'pressed',
      states: {WidgetState.pressed},
      props: {'value': 0.5},
    ),
    SheetScenario(
      'focused',
      states: {WidgetState.focused},
      props: {'value': 0.5},
    ),
    SheetScenario(
      'disabled',
      states: {WidgetState.disabled},
      props: {'value': 0.5},
    ),
    SheetScenario('minimum', props: {'value': 0.0}),
    SheetScenario('maximum', props: {'value': 1.0}),
  ],
  rows: [
    for (final variant in FortalSliderVariant.values)
      for (final size in FortalSliderSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, cell) => SizedBox(
            width: 160,
            child: RemixSlider(
              value: cell.propOr('value', 0.5),
              onChanged: _changed,
              enabled: !cell.disabled,
              styleSpec: cell
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

ComponentSheet _switch() => ComponentSheet(
  id: 'switch',
  label: 'Switch',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [...SheetScenarios.selectable, _selectedHovered],
  rows: [
    for (final variant in FortalSwitchVariant.values)
      for (final size in FortalSwitchSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, cell) {
            final style = RemixSwitchStyle()
                .alignment(Alignment.centerLeft)
                .onSelected(RemixSwitchStyle().alignment(Alignment.centerRight))
                .merge(fortalSwitchStyle(variant: variant, size: size));
            return RemixSwitch(
              selected: cell.selected,
              enabled: !cell.disabled,
              onChanged: _changed,
              styleSpec: cell.resolve(context, style).spec,
            );
          },
        ),
  ],
);

ComponentSheet _textField() => ComponentSheet(
  id: 'text-field',
  label: 'Text Field',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [
    SheetScenarios.base,
    SheetScenarios.hovered,
    SheetScenarios.focused,
    SheetScenarios.disabled,
    SheetScenario('error', states: {WidgetState.error}, props: {'error': true}),
    SheetScenario('populated', props: {'populated': true}),
  ],
  rows: [
    for (final variant in FortalTextFieldVariant.values)
      for (final size in FortalTextFieldSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, cell) => SizedBox(
            width: 190,
            child: RemixTextField(
              label: 'Label',
              hintText: cell.propOr('populated', false) ? null : 'Placeholder',
              controller: cell.propOr('populated', false)
                  ? TextEditingController(text: 'Value')
                  : null,
              enabled: !cell.disabled,
              error: cell.propOr('error', false),
              styleSpec: cell
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

ComponentSheet _toggle() => ComponentSheet(
  id: 'toggle',
  label: 'Toggle',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [...SheetScenarios.selectable, _selectedHovered],
  rows: [
    for (final variant in FortalToggleVariant.values)
      for (final size in FortalToggleSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, cell) => RemixToggle(
            selected: cell.selected,
            enabled: !cell.disabled,
            onChanged: _changed,
            icon: Icons.format_bold,
            label: 'Bold',
            styleSpec: cell
                .resolve(
                  context,
                  fortalToggleStyle(variant: variant, size: size),
                )
                .spec,
          ),
        ),
  ],
);

ComponentSheet _accordion() => ComponentSheet(
  id: 'accordion',
  label: 'Accordion',
  scenarios: const [
    SheetScenario('collapsed'),
    SheetScenario('expanded', props: {'expanded': true}),
    SheetScenarios.hovered,
    SheetScenarios.pressed,
    SheetScenarios.focused,
    SheetScenarios.disabled,
  ],
  rows: [
    SheetRow(
      'default',
      (context, cell) => SizedBox(
        width: 240,
        child: RemixAccordionGroup<String>(
          controller: RemixAccordionController<String>(min: 0, max: 1),
          initialExpandedValues: cell.propOr('expanded', false)
              ? const ['a']
              : const [],
          child: RemixAccordion<String>(
            value: 'a',
            title: 'Accordion item',
            enabled: !cell.disabled,
            styleSpec: cell.resolve(context, fortalAccordionStyle()).spec,
            child: const Text('Expanded panel content'),
          ),
        ),
      ),
    ),
  ],
);

ComponentSheet _tabs() => ComponentSheet(
  id: 'tabs',
  label: 'Tabs',
  scenarios: const [...SheetScenarios.selectable],
  rows: [
    SheetRow(
      'default',
      (context, cell) => SizedBox(
        width: 260,
        child: RemixTabs(
          selectedTabId: cell.selected ? 'second' : 'first',
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
                      enabled: !cell.disabled,
                      styleSpec: cell.resolve(context, fortalTabStyle()).spec,
                    ),
                    RemixTab(
                      tabId: 'second',
                      label: 'Second',
                      styleSpec: cell.resolve(context, fortalTabStyle()).spec,
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

ComponentSheet _menu() => ComponentSheet(
  id: 'menu',
  label: 'Menu',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [
    SheetScenario('closed'),
    SheetScenarios.hovered,
    SheetScenarios.focused,
    SheetScenarios.disabled,
    SheetScenario('open', props: {'open': true}),
  ],
  rows: [
    for (final variant in FortalMenuVariant.values)
      for (final size in FortalMenuSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, cell) => SizedBox(
            width: 220,
            height: 150,
            child: SheetOverlayHost(
              child: Align(
                alignment: Alignment.topLeft,
                child: _ResolvedMenuCell(
                  open: cell.propOr('open', false),
                  enabled: !cell.disabled,
                  itemStyle: fortalMenuItemStyle(variant: variant, size: size),
                  styleSpec: cell
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

ComponentSheet _select() => ComponentSheet(
  id: 'select',
  label: 'Select',
  rowAxes: const [_variantAxis, _sizeAxis],
  scenarios: const [
    SheetScenario('placeholder'),
    SheetScenario('selected-value', props: {'selected': true}),
    SheetScenarios.hovered,
    SheetScenarios.focused,
    SheetScenarios.disabled,
    SheetScenario('open', props: {'open': true}),
  ],
  rows: [
    for (final variant in FortalSelectVariant.values)
      for (final size in FortalSelectSize.values)
        _row(
          variant: variant,
          size: size,
          builder: (context, cell) => SizedBox(
            width: 220,
            height: 170,
            child: SheetOverlayHost(
              child: Align(
                alignment: Alignment.topLeft,
                child: _SelectCell(
                  open: cell.propOr('open', false),
                  enabled: !cell.disabled,
                  selected: cell.propOr('selected', false),
                  itemStyleSpec: cell
                      .resolve(
                        context,
                        fortalSelectMenuItemStyle(variant: variant, size: size),
                      )
                      .spec,
                  styleSpec: cell
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

ComponentSheet _tooltip() => ComponentSheet(
  id: 'tooltip',
  label: 'Tooltip',
  scenarios: const [
    SheetScenario('closed'),
    SheetScenario('open', props: {'open': true}),
  ],
  rows: [
    SheetRow(
      'default',
      (context, cell) => SizedBox(
        width: 180,
        height: 90,
        child: SheetOverlayHost(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: RemixTooltip(
              initiallyOpen: cell.propOr('open', false),
              tooltipChild: const Text('Helpful tooltip'),
              styleSpec: cell.resolve(context, fortalTooltipStyle()).spec,
              child: const Icon(Icons.info_outline),
            ),
          ),
        ),
      ),
    ),
  ],
);

ComponentSheet _dialog() => ComponentSheet(
  id: 'dialog',
  label: 'Dialog',
  scenarios: const [SheetScenario('modal')],
  rows: [
    SheetRow(
      'default',
      (context, cell) => SizedBox(
        width: 420,
        height: 300,
        child: SheetOverlayHost(
          child: _DialogCell(
            styleSpec: cell.resolve(context, fortalDialogStyle()).spec,
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
