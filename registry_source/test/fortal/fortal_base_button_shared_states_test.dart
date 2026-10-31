import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

void main() {
  group('Fortal BaseButton shared states', () {
    late FocusHighlightStrategy previousHighlightStrategy;

    setUp(() {
      previousHighlightStrategy = FocusManager.instance.highlightStrategy;
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.alwaysTraditional;
    });

    tearDown(() {
      FocusManager.instance.highlightStrategy = previousHighlightStrategy;
    });

    for (final dark in [false, true]) {
      for (final variants in _variantPairs) {
        for (final highContrast in [false, true]) {
          testWidgets(
            '${dark ? 'dark' : 'light'}/${variants.button.name} shared states match'
            '${highContrast ? ' at high contrast' : ''}',
            (tester) async {
              for (final stateCase in _stateCases) {
                final resolved = await _resolveBaseButtons(
                  tester,
                  dark: dark,
                  buttonVariant: variants.button,
                  iconButtonVariant: variants.iconButton,
                  highContrast: highContrast,
                  states: stateCase.states,
                );
                final reason =
                    '${variants.button.name}/${stateCase.name}'
                    '${highContrast ? '/highContrast' : ''}';

                expect(
                  _buttonBackground(resolved.button),
                  _iconButtonBackground(resolved.iconButton),
                  reason: '$reason background',
                );
                expect(
                  resolved.button.spec.containerEffects,
                  resolved.iconButton.spec.containerEffects,
                  reason: '$reason effects',
                );
                expect(
                  resolved.button.widgetModifiers,
                  resolved.iconButton.widgetModifiers,
                  reason: '$reason filters',
                );

                final iconForeground = resolved.iconButton.spec.icon.spec.color;
                expect(
                  resolved.button.spec.label.spec.style?.color,
                  iconForeground,
                  reason: '$reason label foreground',
                );
                expect(
                  resolved.button.spec.icon.spec.color,
                  iconForeground,
                  reason: '$reason icon foreground',
                );
                expect(
                  resolved.button.spec.spinner.spec.color,
                  resolved.iconButton.spec.spinner.spec.color,
                  reason: '$reason spinner foreground',
                );
                expect(
                  resolved.button.spec.spinner.spec.opacity,
                  resolved.iconButton.spec.spinner.spec.opacity,
                  reason: '$reason spinner opacity',
                );

                // Solid states recolor the fill; none filters the painted
                // subtree, which would also shift the focus ring.
                expect(
                  _filterOperations(resolved.button),
                  isEmpty,
                  reason: '$reason subtree filter',
                );

                if (stateCase.name == 'focused') {
                  final effects = resolved.button.spec.containerEffects!;
                  expect(
                    effects.outline.width,
                    2,
                    reason: '$reason focus width',
                  );
                  expect(
                    effects.outlineOffset,
                    2,
                    reason: '$reason focus offset',
                  );
                } else if (stateCase.name == 'focused+disabled') {
                  expect(
                    resolved.button.spec.containerEffects?.outline.style,
                    BorderStyle.none,
                    reason: '$reason disabled focus precedence',
                  );
                }
              }
            },
          );
        }
      }
    }

    testWidgets('caller filters merge with every state and disabled clears', (
      tester,
    ) async {
      const dim = [RemixCssColorFilterOperation.brightness(0.9)];
      for (final highContrast in [false, true]) {
        for (final stateCase in _stateCases) {
          final resolved = await _resolveBaseButtons(
            tester,
            buttonVariant: .solid,
            iconButtonVariant: .solid,
            highContrast: highContrast,
            states: stateCase.states,
            buttonStyle: ButtonStyler()
                .wrap(fortalModeAwareFilter(light: dim, dark: dim))
                .onPressed(ButtonStyler().wrap(fortalClearFilter())),
            iconButtonStyle: IconButtonStyler()
                .wrap(fortalModeAwareFilter(light: dim, dark: dim))
                .onPressed(IconButtonStyler().wrap(fortalClearFilter())),
          );
          final states = stateCase.states;
          final expected =
              states.contains(WidgetState.disabled) ||
                  states.contains(WidgetState.pressed)
              ? isEmpty
              : equals(dim);
          final reason = '${stateCase.name}${highContrast ? '/hc' : ''}';
          expect(_filterOperations(resolved.button), expected, reason: reason);
          expect(
            _filterOperations(resolved.iconButton),
            expected,
            reason: '$reason icon button',
          );
        }
      }
    });
  });
}

List<RemixCssColorFilterOperation> _filterOperations(StyleSpec<Spec> style) => [
  for (final modifier in style.widgetModifiers ?? const <WidgetModifier>[])
    if (modifier is RemixOrderedColorFilterModifier) ...modifier.operations,
];

const _variantPairs =
    <({FortalButtonVariant button, FortalIconButtonVariant iconButton})>[
      (button: .solid, iconButton: .solid),
      (button: .soft, iconButton: .soft),
      (button: .surface, iconButton: .surface),
      (button: .outline, iconButton: .outline),
      (button: .ghost, iconButton: .ghost),
    ];

const _stateCases = <({String name, Set<WidgetState> states})>[
  (name: 'idle', states: <WidgetState>{}),
  (name: 'hovered', states: {WidgetState.hovered}),
  (name: 'pressed', states: {WidgetState.pressed}),
  (name: 'focused', states: {WidgetState.focused}),
  (name: 'disabled', states: {WidgetState.disabled}),
  (
    name: 'focused+disabled',
    states: {WidgetState.focused, WidgetState.disabled},
  ),
  // Combined interaction states merge every active fragment, including the
  // press, hover and disabled filter modifiers, so they must stay compatible.
  (name: 'hovered+pressed', states: {WidgetState.hovered, WidgetState.pressed}),
  (name: 'focused+pressed', states: {WidgetState.focused, WidgetState.pressed}),
  (
    name: 'hovered+focused+pressed',
    states: {WidgetState.hovered, WidgetState.focused, WidgetState.pressed},
  ),
  (
    name: 'disabled+hovered+pressed',
    states: {WidgetState.disabled, WidgetState.hovered, WidgetState.pressed},
  ),
];

Future<({StyleSpec<ButtonSpec> button, StyleSpec<IconButtonSpec> iconButton})>
_resolveBaseButtons(
  WidgetTester tester, {
  required FortalButtonVariant buttonVariant,
  required FortalIconButtonVariant iconButtonVariant,
  FortalButtonSize buttonSize = .size2,
  FortalIconButtonSize iconButtonSize = .size2,
  bool highContrast = false,
  bool dark = false,
  Set<WidgetState> states = const {},
  ButtonStyler buttonStyle = const ButtonStyler.create(),
  IconButtonStyler iconButtonStyle = const IconButtonStyler.create(),
}) async {
  late ({StyleSpec<ButtonSpec> button, StyleSpec<IconButtonSpec> iconButton})
  resolved;

  await tester.pumpWidget(
    FortalTheme(
      accent: .mar,
      mode: dark ? .dark : .light,
      child: WidgetsApp(
        color: Colors.black,
        builder: (context, child) => WidgetStateProvider(
          states: states,
          child: Builder(
            builder: (context) {
              expect(
                FortalTheme.of(context).brightness,
                dark ? Brightness.dark : Brightness.light,
              );
              resolved = (
                button: fortalButtonStyle(
                  variant: buttonVariant,
                  size: buttonSize,
                  highContrast: highContrast,
                  style: buttonStyle,
                ).build(context),
                iconButton: fortalIconButtonStyle(
                  variant: iconButtonVariant,
                  size: iconButtonSize,
                  highContrast: highContrast,
                  style: iconButtonStyle,
                ).build(context),
              );
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    ),
  );

  return resolved;
}

Color? _buttonBackground(StyleSpec<ButtonSpec> style) =>
    (style.spec.container.spec.box?.spec.decoration as BoxDecoration?)?.color;

Color? _iconButtonBackground(StyleSpec<IconButtonSpec> style) =>
    (style.spec.container.spec.decoration as BoxDecoration?)?.color;
