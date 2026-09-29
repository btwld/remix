import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';

import 'support.dart';
import 'vanilla_spec.dart';

/// Every interactive state a recipe declares has to show.
///
/// The review that started this spec found hover and selected fills painted
/// in the same color as the hairlines around them (`accent` equalled
/// `border`), so a hovered row looked like a resting one and a selected toggle
/// needed a primary outline to be seen at all. This resolves each interactive
/// recipe at rest and in each state it styles, in both themes, and fails when
/// a state paints exactly what rest paints, or paints its fill in the
/// `border` color of the surface it sits on.
///
/// Only the states shadcn styles are listed: a checkbox, a radio, and a
/// switch have no hover fill there, so none is required here.
void main() {
  for (final entry in _cases) {
    group(entry.name, () {
      for (final theme in vanillaThemes) {
        final enforced =
            entry.phase == null || enforcedPhases.contains(entry.phase);

        testWidgets(
          enforced ? theme.name : '${theme.name} (pending ${entry.phase})',
          (tester) async {
            final rest = await entry.look(tester, theme.data, const {});
            final surface = entry.surface(theme.data);
            final border = Color.alphaBlend(theme.data.border, surface);

            for (final state in entry.states) {
              final look = await entry.look(tester, theme.data, {state});

              expect(
                look,
                isNot(equals(rest)),
                reason: '${state.name} paints exactly what rest paints',
              );
              final fill = look.first as Color?;
              if (fill != null && fill != rest.first) {
                expect(
                  Color.alphaBlend(fill, surface),
                  isNot(border),
                  reason: '${state.name} fills in the border color',
                );
              }
            }
          },
          skip: !enforced,
        );
      }
    });
  }
}

/// One interactive recipe and the states it has to show.
final class _Case {
  const _Case(
    this.name, {
    required this.states,
    required this.look,
    this.surface = _page,
    this.phase,
  });

  final String name;

  /// The states this recipe styles.
  final List<WidgetState> states;

  /// What the recipe paints under a theme and a set of states. The first
  /// element is the fill, which is also checked against `border`.
  final Future<List<Object?>> Function(
    WidgetTester tester,
    VanillaThemeData theme,
    Set<WidgetState> states,
  )
  look;

  /// The surface the recipe sits on.
  final Color Function(VanillaThemeData theme) surface;

  /// The pull request that makes this case pass, while it does not yet.
  final String? phase;
}

Color _page(VanillaThemeData theme) => theme.background;

Color _muted(VanillaThemeData theme) => theme.muted;

Color _popover(VanillaThemeData theme) => theme.popover;

Color _sidebarSurface(VanillaThemeData theme) => theme.sidebar;

/// A case whose recipe resolves faithfully from plain widget states.
_Case _resolved<S extends Spec<S>>(
  String name, {
  required Style<S> Function() style,
  required List<WidgetState> states,
  required List<Object?> Function(StyleSpec<S> spec) read,
  Color Function(VanillaThemeData theme) surface = _page,
  String? phase,
}) => _Case(
  name,
  states: states,
  surface: surface,
  phase: phase,
  look: (tester, theme, active) async =>
      read(await resolveVanilla(tester, style(), theme: theme, states: active)),
);

List<Object?> _flexLook(
  StyleSpec<FlexBoxSpec> container, {
  TextStyle? label,
  Color? icon,
  RemixBoxEffectsSpec? effects,
}) {
  final box = boxOf(container);
  final decoration = box?.decoration as BoxDecoration?;

  return [
    decoration?.color,
    decoration?.border,
    decoration?.boxShadow,
    box?.foregroundDecoration,
    label?.color,
    label?.fontWeight,
    label?.decoration,
    label?.decorationColor,
    icon,
    effects?.outline,
  ];
}

List<Object?> _boxLook(
  StyleSpec<BoxSpec> container, {
  TextStyle? label,
  Color? icon,
  RemixBoxEffectsSpec? effects,
}) {
  final box = container.spec;
  final decoration = box.decoration as BoxDecoration?;

  return [
    decoration?.color,
    decoration?.border,
    decoration?.boxShadow,
    box.foregroundDecoration,
    label?.color,
    label?.fontWeight,
    label?.decoration,
    label?.decorationColor,
    icon,
    effects?.outline,
  ];
}

const _pointer = [WidgetState.hovered, WidgetState.pressed];
const _focus = [WidgetState.focused];

final _cases = <_Case>[
  for (final variant in VanillaButtonVariant.values)
    _resolved<ButtonSpec>(
      'button ${variant.name}',
      style: () => vanillaButtonStyle(variant: variant),
      states: [..._pointer, ..._focus],
      read: (spec) => _flexLook(
        spec.spec.container,
        label: spec.spec.label.spec.style,
        icon: spec.spec.icon.spec.color,
        effects: spec.spec.containerEffects,
      ),
    ),
  for (final variant in VanillaIconButtonVariant.values)
    _resolved<IconButtonSpec>(
      'icon button ${variant.name}',
      style: () => vanillaIconButtonStyle(variant: variant),
      states: [..._pointer, ..._focus],
      read: (spec) => _boxLook(
        spec.spec.container,
        icon: spec.spec.icon.spec.color,
        effects: spec.spec.containerEffects,
      ),
    ),
  _resolved<LinkSpec>(
    'link',
    style: vanillaLinkStyle,
    states: [WidgetState.hovered, ..._focus],
    read: (spec) => _boxLook(
      spec.spec.container,
      label: spec.spec.label.spec.style,
      effects: spec.spec.containerEffects,
    ),
  ),
  for (final variant in VanillaToggleVariant.values)
    _resolved<ToggleSpec>(
      'toggle ${variant.name}',
      style: () => vanillaToggleStyle(variant: variant),
      states: const [
        WidgetState.hovered,
        WidgetState.selected,
        WidgetState.focused,
      ],
      read: (spec) => _flexLook(
        spec.spec.container,
        label: spec.spec.label.spec.style,
        icon: spec.spec.icon.spec.color,
      ),
    ),
  for (final variant in VanillaToggleGroupVariant.values)
    _resolved<ToggleGroupSpec>(
      'toggle group ${variant.name} item',
      style: () => vanillaToggleGroupStyle(variant: variant),
      states: const [
        WidgetState.hovered,
        WidgetState.selected,
        WidgetState.focused,
      ],
      read: (spec) => _flexLook(
        spec.spec.item.spec.container,
        label: spec.spec.item.spec.label.spec.style,
        icon: spec.spec.item.spec.icon.spec.color,
      ),
    ),
  _resolved<TabSpec>(
    'tab',
    style: vanillaTabStyle,
    states: const [
      WidgetState.hovered,
      WidgetState.selected,
      WidgetState.focused,
    ],
    read: (spec) => _flexLook(
      spec.spec.container,
      label: spec.spec.label.spec.style,
      icon: spec.spec.icon.spec.color,
    ),
  ),
  _resolved<SegmentedControlSpec>(
    'segmented control segment',
    style: vanillaSegmentedControlStyle,
    states: const [
      WidgetState.hovered,
      WidgetState.selected,
      WidgetState.focused,
    ],
    surface: _muted,
    read: (spec) => _boxLook(
      spec.spec.item.spec.container,
      label: spec.spec.item.spec.label.spec.style,
      effects: spec.spec.item.spec.containerEffects,
    ),
  ),
  _Case(
    'checkbox',
    states: const [WidgetState.selected, WidgetState.focused],
    look: (tester, theme, states) async {
      final spec = await interactedSpec<CheckboxSpec>(
        tester,
        (focusNode) => VanillaCheckbox(
          selected: states.contains(WidgetState.selected),
          label: 'Probe',
          focusNode: focusNode,
          onChanged: (_) {},
        ),
        theme: theme,
        focused: states.contains(WidgetState.focused),
      );

      return _boxLook(
        spec.spec.container,
        icon: spec.spec.indicator.spec.color,
        effects: spec.spec.containerEffects,
      );
    },
  ),
  _resolved<RadioSpec>(
    'radio',
    style: vanillaRadioStyle,
    states: const [WidgetState.selected, WidgetState.focused],
    read: (spec) => [
      ..._boxLook(spec.spec.container, effects: spec.spec.containerEffects),
      decorationOf(spec.spec.indicator)?.color,
    ],
  ),
  _resolved<SwitchSpec>(
    'switch',
    style: vanillaSwitchStyle,
    states: const [WidgetState.selected, WidgetState.focused],
    read: (spec) => [
      ..._boxLook(spec.spec.container, effects: spec.spec.trackEffects),
      decorationOf(spec.spec.thumb)?.color,
    ],
  ),
  _resolved<SliderSpec>(
    'slider thumb',
    style: vanillaSliderStyle,
    states: const [WidgetState.hovered, WidgetState.focused],
    read: (spec) => [
      ..._boxLook(spec.spec.thumb, effects: spec.spec.thumbEffects),
      spec.spec.thumbFocusEffects?.outline,
    ],
  ),
  _resolved<TextFieldSpec>(
    'text field',
    style: vanillaTextFieldStyle,
    states: const [WidgetState.focused, WidgetState.error],
    read: (spec) => [
      ..._boxLook(spec.spec.container, effects: spec.spec.containerEffects),
      spec.spec.helperText.spec.style?.color,
    ],
  ),
  _resolved<SelectSpec>(
    'select trigger',
    style: vanillaSelectStyle,
    states: _focus,
    read: (spec) => _flexLook(
      spec.spec.trigger.spec.container,
      label: spec.spec.trigger.spec.label.spec.style,
      effects: spec.spec.trigger.spec.containerEffects,
    ),
  ),
  _resolved<SelectSpec>(
    'select option',
    style: vanillaSelectStyle,
    states: const [WidgetState.hovered, WidgetState.focused],
    surface: _popover,
    read: (spec) => _flexLook(
      spec.spec.item.spec.container,
      label: spec.spec.item.spec.text.spec.style,
      icon: spec.spec.item.spec.icon.spec.color,
    ),
  ),
  _resolved<MenuSpec>(
    'menu row',
    style: vanillaMenuStyle,
    states: const [WidgetState.hovered, WidgetState.focused],
    surface: _popover,
    read: (spec) => _flexLook(
      spec.spec.item.spec.container,
      label: spec.spec.item.spec.label.spec.style,
      icon: spec.spec.item.spec.leadingIcon.spec.color,
    ),
  ),
  _resolved<AccordionSpec>(
    'accordion',
    style: vanillaAccordionStyle,
    states: const [
      WidgetState.hovered,
      WidgetState.selected,
      WidgetState.focused,
    ],
    read: (spec) => [
      ..._flexLook(spec.spec.trigger, label: spec.spec.title.spec.style),
      spec.spec.containerEffects?.outline,
      spec.spec.trailingIcon.spec.color,
    ],
  ),
  _Case(
    'disclosure',
    states: const [WidgetState.hovered, WidgetState.focused],
    look: (tester, theme, states) async {
      final spec = await interactedSpec<DisclosureSpec>(
        tester,
        (focusNode) => SizedBox(
          width: 320,
          child: VanillaDisclosure(
            trigger: const Text('Details'),
            content: const Text('Body'),
            focusNode: focusNode,
          ),
        ),
        theme: theme,
        hovered: states.contains(WidgetState.hovered),
        focused: states.contains(WidgetState.focused),
      );

      return [
        ..._boxLook(spec.spec.trigger, effects: spec.spec.containerEffects),
        spec.spec.trigger.widgetModifiers,
      ];
    },
  ),
  _resolved<SidebarSpec>(
    'sidebar destination',
    style: vanillaSidebarStyle,
    states: const [
      WidgetState.hovered,
      WidgetState.selected,
      WidgetState.focused,
    ],
    surface: _sidebarSurface,
    read: (spec) => _flexLook(
      spec.spec.destination.spec.container,
      label: spec.spec.destination.spec.label.spec.style,
      icon: spec.spec.destination.spec.icon.spec.color,
    ),
  ),
  _resolved<DataTableSpec>(
    'data table row',
    style: vanillaDataTableStyle,
    states: const [WidgetState.hovered, WidgetState.selected],
    phase: 'F5',
    read: (spec) => _boxLook(spec.spec.bodyRow),
  ),
];
