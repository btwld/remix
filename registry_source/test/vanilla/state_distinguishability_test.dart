import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';

import 'support.dart';

/// Every interactive state a recipe declares has to show.
///
/// The review that started this spec found hover and selected fills painted
/// in the same color as the hairlines around them (`accent` equalled
/// `border`), so a hovered row looked like a resting one and a selected toggle
/// needed a primary outline to be seen at all. This resolves each interactive
/// recipe at rest and in each state it styles, in both themes, and fails when
/// a state paints exactly what rest paints, or when its fill, laid on the
/// surface it sits on, is within [_minimumContrast] of the rest fill or of the
/// `border` hairline. Near-collisions the reference itself makes are listed in
/// [_accepted] with the reason they are kept.
///
/// Only the states the spec styles are listed: a checkbox, a radio, and a
/// switch have no hover fill there, so none is required here.
void main() {
  for (final entry in _cases) {
    group(entry.name, () {
      for (final theme in vanillaThemes) {
        testWidgets(theme.name, (tester) async {
          final rest = await entry.look(tester, theme.data, const {});
          final surface = entry.surface(theme.data);
          final border = Color.alphaBlend(theme.data.border, surface);
          final restFill = Color.alphaBlend(
            rest.first as Color? ?? const Color(0x00000000),
            surface,
          );

          for (final state in entry.states) {
            final look = await entry.look(tester, theme.data, {state});

            expect(
              look,
              isNot(equals(rest)),
              reason: '${state.name} paints exactly what rest paints',
            );
            final fill = look.first as Color?;
            if (fill == null || fill == rest.first) continue;
            final shown = Color.alphaBlend(fill, surface);
            for (final (against, color) in [
              ('rest', restFill),
              ('border', border),
            ]) {
              final key = '${entry.name}|${theme.name}|${state.name}|$against';
              final ratio = _contrast(shown, color);
              if (ratio >= _minimumContrast || _accepted.containsKey(key)) {
                continue;
              }
              fail(
                '${state.name} fill is ${ratio.toStringAsFixed(3)}:1 against '
                'the $against color; list `$key` in _accepted with a reason '
                'if the reference does the same',
              );
            }
          }
        });
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
}

/// The least contrast a state's fill may have against the rest fill or the
/// border hairline. Far below the 3:1 non-text floor on purpose: the
/// reference's own hover fills sit near 1.09:1, and this catches a state that
/// is barely different from what is already there, not one that is quiet.
const _minimumContrast = 1.05;

/// Near-collisions the reference makes too, keyed
/// `case|theme|state|rest or border`, with the reason each is kept.
const _accepted = <String, String>{
  'button secondary|light|hovered|rest':
      'hover:bg-secondary/80 over secondary; the label and pointer carry it.',
  'icon button secondary|light|hovered|rest':
      'hover:bg-secondary/80 over secondary, as the button.',
  'toggle ghost|dark|hovered|border':
      'dark accent (#262626) sits next to the border tone, as in the reference.',
  'toggle outline|dark|hovered|border': 'dark accent next to border, as above.',
  'toggle group ghost item|dark|hovered|border':
      'dark accent next to border, as above.',
  'data table row|light|hovered|rest':
      'hover:bg-muted/50 on the page; the reference keeps rows quiet.',
  'data table row|dark|selected|border':
      'dark muted (#262626) next to the border tone, as in the reference.',
  'sidebar destination|light|hovered|rest':
      'sidebar-accent (#F5F5F5) on sidebar (#FAFAFA), as in the reference.',
  'sidebar destination|light|selected|rest':
      'the hover surface again; the current row also sets medium weight.',
  'button secondary|light|pressed|rest':
      'a press lands on the hover fill: Vanilla has no pressed step.',
  'icon button secondary|light|pressed|rest': 'as the button.',
  'button secondary|dark|hovered|border':
      'dark secondary at 80% sits next to the border tone, as in the reference.',
  'icon button secondary|dark|hovered|border': 'as the button.',
  'toggle ghost|dark|selected|border':
      'the selected fill is dark accent, next to the border tone.',
  'toggle outline|dark|selected|border': 'as the ghost toggle.',
  'toggle group outline item|dark|hovered|border': 'as the toggles.',
  'toggle group outline item|dark|selected|border': 'as the toggles.',
  'toggle group ghost item|dark|selected|border': 'as the toggles.',
  'button secondary|dark|pressed|border':
      'a press lands on the hover fill, which sits next to the border tone.',
  'icon button secondary|dark|pressed|border': 'as the button.',
};

/// The WCAG contrast ratio of two opaque colors.
double _contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
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
}) => _Case(
  name,
  states: states,
  surface: surface,
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
    // A filled tab sits on the recessed `muted` list, not the page.
    surface: _muted,
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
    read: (spec) => _boxLook(spec.spec.bodyRow),
  ),
];
