import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

void main() {
  group('Fortal high-contrast recipes', () {
    testWidgets('solid controls retain dark high-contrast interaction roles', (
      tester,
    ) async {
      for (final state in [WidgetState.hovered, WidgetState.pressed]) {
        final button = await _resolveFortalStyle(
          tester,
          (context) => fortalButtonStyle(highContrast: true).build(context),
          brightness: .dark,
          states: {state},
        );
        final iconButton = await _resolveFortalStyle(
          tester,
          (context) => fortalIconButtonStyle(highContrast: true).build(context),
          brightness: .dark,
          states: {state},
        );

        expect(
          _flexBoxColor(button.spec.container),
          ceu.dark.scale.step(12),
          reason: 'Button ${state.name} background must remain high contrast.',
        );
        expect(_textColor(button.spec.label), calcadao.dark.scale.step(1));
        expect(
          _boxColor(iconButton.spec.container),
          ceu.dark.scale.step(12),
          reason:
              'Icon button ${state.name} background must remain high contrast.',
        );
        expect(iconButton.spec.icon.spec.color, calcadao.dark.scale.step(1));
      }
    });

    testWidgets('soft and surface controls retain distinct base fills', (
      tester,
    ) async {
      final softButton = await _resolveFortalStyle(
        tester,
        (context) => fortalButtonStyle(variant: .soft).build(context),
      );
      final surfaceButton = await _resolveFortalStyle(
        tester,
        (context) => fortalButtonStyle(variant: .surface).build(context),
      );
      final softIconButton = await _resolveFortalStyle(
        tester,
        (context) => fortalIconButtonStyle(variant: .soft).build(context),
      );
      final surfaceIconButton = await _resolveFortalStyle(
        tester,
        (context) => fortalIconButtonStyle(variant: .surface).build(context),
      );

      expect(
        _flexBoxColor(softButton.spec.container),
        ceu.light.scale.alphaStep(3),
      );
      expect(_flexBoxColor(surfaceButton.spec.container), ceu.light.surface);
      expect(
        _boxColor(softIconButton.spec.container),
        ceu.light.scale.alphaStep(3),
      );
      expect(_boxColor(surfaceIconButton.spec.container), ceu.light.surface);
    });

    testWidgets('solid interactions meet contrast for every accent and mode', (
      tester,
    ) async {
      for (final brightness in Brightness.values) {
        for (final accent in FortalAccentColor.values) {
          for (final state in [WidgetState.hovered, WidgetState.pressed]) {
            final button = await _resolveFortalStyle(
              tester,
              (context) => fortalButtonStyle(highContrast: true).build(context),
              accent: accent,
              brightness: brightness,
              states: {state},
            );
            final iconButton = await _resolveFortalStyle(
              tester,
              (context) =>
                  fortalIconButtonStyle(highContrast: true).build(context),
              accent: accent,
              brightness: brightness,
              states: {state},
            );

            final buttonBackground = _flexBoxColor(button.spec.container)!;
            final buttonForeground = _textColor(button.spec.label)!;
            final iconBackground = _boxColor(iconButton.spec.container)!;
            final iconForeground = iconButton.spec.icon.spec.color!;

            expect(
              _contrastRatio(buttonBackground, buttonForeground),
              greaterThanOrEqualTo(4.5),
              reason: '$accent $brightness button ${state.name}',
            );
            expect(
              _contrastRatio(iconBackground, iconForeground),
              greaterThanOrEqualTo(3.0),
              reason: '$accent $brightness icon button ${state.name}',
            );
          }
        }
      }
    });

    testWidgets('icon button variants resolve stronger accent roles', (
      tester,
    ) async {
      for (final variant in FortalIconButtonVariant.values) {
        final normal = await _resolveFortalStyle(
          tester,
          (context) => fortalIconButtonStyle(variant: variant).build(context),
        );
        final highContrast = await _resolveFortalStyle(
          tester,
          (context) => fortalIconButtonStyle(
            variant: variant,
            highContrast: true,
          ).build(context),
        );

        if (variant == .solid) {
          expect(_boxColor(normal.spec.container), ceu.light.scale.step(9));
          expect(
            _boxColor(highContrast.spec.container),
            ceu.light.scale.step(12),
          );
          expect(normal.spec.icon.spec.color, ceu.light.contrast);
          expect(
            highContrast.spec.icon.spec.color,
            calcadao.light.scale.step(1),
          );
        } else {
          expect(normal.spec.icon.spec.color, ceu.light.scale.alphaStep(11));
          expect(highContrast.spec.icon.spec.color, ceu.light.scale.step(12));
        }
      }
    });

    testWidgets('badge variants resolve stronger accent roles', (tester) async {
      for (final variant in FortalBadgeVariant.values) {
        final normal = await _resolveFortalStyle(
          tester,
          (context) => fortalBadgeStyle(variant: variant).build(context),
        );
        final highContrast = await _resolveFortalStyle(
          tester,
          (context) => fortalBadgeStyle(
            variant: variant,
            highContrast: true,
          ).build(context),
        );

        if (variant == .solid) {
          expect(_boxColor(normal.spec.container), ceu.light.scale.step(9));
          expect(
            _boxColor(highContrast.spec.container),
            ceu.light.scale.step(12),
          );
          expect(_textColor(normal.spec.label), ceu.light.contrast);
          expect(_textColor(highContrast.spec.label), ceu.light.scale.step(1));
        } else {
          expect(_textColor(normal.spec.label), ceu.light.scale.alphaStep(11));
          expect(_textColor(highContrast.spec.label), ceu.light.scale.step(12));
        }
      }
    });

    testWidgets('callout variants resolve accent12 foregrounds', (
      tester,
    ) async {
      for (final variant in FortalCalloutVariant.values) {
        final normal = await _resolveFortalStyle(
          tester,
          (context) => fortalCalloutStyle(variant: variant).build(context),
        );
        final highContrast = await _resolveFortalStyle(
          tester,
          (context) => fortalCalloutStyle(
            variant: variant,
            highContrast: true,
          ).build(context),
        );

        expect(_textColor(normal.spec.text), ceu.light.scale.alphaStep(11));
        expect(_textColor(highContrast.spec.text), ceu.light.scale.step(12));
        expect(normal.spec.icon.spec.color, ceu.light.scale.alphaStep(11));
        expect(highContrast.spec.icon.spec.color, ceu.light.scale.step(12));
      }
    });

    testWidgets('selected checkbox variants resolve stronger roles', (
      tester,
    ) async {
      for (final variant in FortalCheckboxVariant.values) {
        final normal = await _resolveFortalStyle(
          tester,
          (context) => fortalCheckboxStyle(variant: variant).build(context),
          states: {WidgetState.selected},
        );
        final highContrast = await _resolveFortalStyle(
          tester,
          (context) => fortalCheckboxStyle(
            variant: variant,
            highContrast: true,
          ).build(context),
          states: {WidgetState.selected},
        );

        if (variant == .surface) {
          expect(_boxColor(normal.spec.container), ceu.light.indicator);
          expect(
            _boxColor(highContrast.spec.container),
            ceu.light.scale.step(12),
          );
          expect(normal.spec.indicator.spec.color, ceu.light.contrast);
          expect(
            highContrast.spec.indicator.spec.color,
            ceu.light.scale.step(1),
          );
        } else {
          expect(
            normal.spec.indicator.spec.color,
            ceu.light.scale.alphaStep(11),
          );
          expect(
            highContrast.spec.indicator.spec.color,
            ceu.light.scale.step(12),
          );
        }
      }
    });

    testWidgets('selected radio variants resolve stronger roles', (
      tester,
    ) async {
      for (final variant in FortalRadioVariant.values) {
        final normal = await _resolveFortalStyle(
          tester,
          (context) => fortalRadioStyle(variant: variant).build(context),
          states: {WidgetState.selected},
        );
        final highContrast = await _resolveFortalStyle(
          tester,
          (context) => fortalRadioStyle(
            variant: variant,
            highContrast: true,
          ).build(context),
          states: {WidgetState.selected},
        );

        if (variant == .surface) {
          expect(_boxColor(normal.spec.container), ceu.light.indicator);
          expect(
            _boxColor(highContrast.spec.container),
            ceu.light.scale.step(12),
          );
          expect(_boxColor(normal.spec.indicator), ceu.light.contrast);
          expect(
            _boxColor(highContrast.spec.indicator),
            ceu.light.scale.step(1),
          );
        } else {
          expect(_boxColor(normal.spec.indicator), ceu.light.scale.step(11));
          expect(
            _boxColor(highContrast.spec.indicator),
            ceu.light.scale.step(12),
          );
        }
      }
    });

    testWidgets('selected switch variants resolve accent12 tracks', (
      tester,
    ) async {
      for (final variant in FortalSwitchVariant.values) {
        final normal = await _resolveFortalStyle(
          tester,
          (context) => fortalSwitchStyle(variant: variant).build(context),
          states: {WidgetState.selected},
        );
        final highContrast = await _resolveFortalStyle(
          tester,
          (context) => fortalSwitchStyle(
            variant: variant,
            highContrast: true,
          ).build(context),
          states: {WidgetState.selected},
        );

        final expectedNormal = switch (variant) {
          .surface => ceu.light.track,
          .soft => ceu.light.scale.alphaStep(4),
        };
        final expectedHighContrast = switch (variant) {
          .surface => ceu.light.scale.step(12),
          .soft => ceu.light.scale.alphaStep(6),
        };
        expect(_boxColor(normal.spec.container), expectedNormal);
        expect(_boxColor(highContrast.spec.container), expectedHighContrast);
      }
    });

    testWidgets('pressed switches retain selection and disabled precedence', (
      tester,
    ) async {
      for (final brightness in Brightness.values) {
        for (final variant in FortalSwitchVariant.values) {
          for (final highContrast in [false, true]) {
            Future<SwitchSpec> resolve(Set<WidgetState> states) =>
                _resolveFortalStyle(
                  tester,
                  (context) => fortalSwitchStyle(
                    variant: variant,
                    highContrast: highContrast,
                  ).build(context).spec,
                  brightness: brightness,
                  states: states,
                );
            final pressed = await resolve({WidgetState.pressed});
            final selectedPressed = await resolve({
              WidgetState.selected,
              WidgetState.pressed,
            });
            final disabled = await resolve({WidgetState.disabled});
            final disabledSelectedPressed = await resolve({
              WidgetState.disabled,
              WidgetState.selected,
              WidgetState.pressed,
            });
            expect(
              _boxColor(selectedPressed.container),
              isNot(_boxColor(pressed.container)),
              reason:
                  '$brightness/$variant must keep an on-state while pressed.',
            );
            expect(
              _boxColor(disabledSelectedPressed.container),
              _boxColor(disabled.container),
              reason: 'Disabled must win over both press and selection.',
            );
          }
        }
      }
    });

    testWidgets('selected switches use appearance-aware high contrast thumbs', (
      tester,
    ) async {
      for (final variant in FortalSwitchVariant.values) {
        final highContrast = await _resolveFortalStyle(
          tester,
          (context) => fortalSwitchStyle(
            variant: variant,
            highContrast: true,
          ).build(context),
          brightness: .dark,
          states: {WidgetState.selected},
        );

        expect(
          _boxColor(highContrast.spec.thumb),
          variant == .surface
              ? ceu.dark.scale.step(1)
              : ceu.dark.scale.step(12),
          reason: '$variant must use its high-contrast content role.',
        );
      }
    });

    testWidgets('selected toggle variants resolve accent12 foregrounds', (
      tester,
    ) async {
      for (final variant in FortalToggleVariant.values) {
        final normal = await _resolveFortalStyle(
          tester,
          (context) => fortalToggleStyle(variant: variant).build(context),
          states: {WidgetState.selected},
        );
        final highContrast = await _resolveFortalStyle(
          tester,
          (context) => fortalToggleStyle(
            variant: variant,
            highContrast: true,
          ).build(context),
          states: {WidgetState.selected},
        );

        final expectedNormal = switch (variant) {
          .ghost => ceu.light.scale.step(11),
          .outline => ceu.light.scale.step(11),
        };
        expect(_textColor(normal.spec.label), expectedNormal);
        expect(_textColor(highContrast.spec.label), ceu.light.scale.step(12));
      }
    });

    testWidgets('select exposes high contrast through its direct styler', (
      tester,
    ) async {
      final hoveredNormal = await _resolveFortalStyle(
        tester,
        (context) => fortalSelectStyle().build(context),
        states: {WidgetState.hovered},
      );
      final hoveredHighContrast = await _resolveFortalStyle(
        tester,
        (context) => fortalSelectStyle(highContrast: true).build(context),
        states: {WidgetState.hovered},
      );
      expect(_textColor(hoveredNormal.spec.item.spec.text), ceu.light.contrast);
      expect(
        _textColor(hoveredHighContrast.spec.item.spec.text),
        ceu.light.scale.step(1),
      );
      expect(hoveredNormal.spec.item.spec.icon.spec.color, ceu.light.contrast);
      expect(
        hoveredHighContrast.spec.item.spec.icon.spec.color,
        ceu.light.scale.step(1),
      );
    });

    testWidgets('select item recipe exposes high contrast', (tester) async {
      final hoveredHighContrast = await _resolveFortalStyle(
        tester,
        (context) =>
            fortalSelectMenuItemStyle(highContrast: true).build(context),
        states: {WidgetState.hovered},
      );

      expect(
        _textColor(hoveredHighContrast.spec.text),
        ceu.light.scale.step(1),
      );
      expect(hoveredHighContrast.spec.icon.spec.color, ceu.light.scale.step(1));
    });

    testWidgets('slider variants resolve accent12 ranges', (tester) async {
      for (final variant in FortalSliderVariant.values) {
        final normal = await _resolveFortalStyle(
          tester,
          (context) => fortalSliderStyle(variant: variant).build(context),
        );
        final highContrast = await _resolveFortalStyle(
          tester,
          (context) => fortalSliderStyle(
            variant: variant,
            highContrast: true,
          ).build(context),
        );

        final expectedNormal = switch (variant) {
          .surface => ceu.light.indicator,
          .soft => ceu.light.scale.step(6),
        };
        expect(_boxColor(normal.spec.range), expectedNormal);
        final contrastGradient =
            highContrast.spec.rangeEffects!.behindContent!.gradients.last
                as LinearGradient;
        expect(contrastGradient.colors, everyElement(blackAlpha[8]));
      }
    });

    testWidgets('progress variants resolve accent12 indicators', (
      tester,
    ) async {
      for (final variant in FortalProgressVariant.values) {
        final normal = await _resolveFortalStyle(
          tester,
          (context) => fortalProgressStyle(variant: variant).build(context),
        );
        final highContrast = await _resolveFortalStyle(
          tester,
          (context) => fortalProgressStyle(
            variant: variant,
            highContrast: true,
          ).build(context),
        );

        final expectedNormal = switch (variant) {
          .surface => ceu.light.indicator,
          .soft => ceu.light.scale.step(8),
        };
        expect(_boxColor(normal.spec.indicator), expectedNormal);
        expect(
          _boxColor(highContrast.spec.indicator),
          ceu.light.scale.step(12),
        );
      }
    });

    testWidgets('progress variants respect the configured radius scale', (
      tester,
    ) async {
      for (final variant in FortalProgressVariant.values) {
        final style = await _resolveFortalStyle(
          tester,
          (context) => fortalProgressStyle(variant: variant).build(context),
          radius: .none,
        );

        expect(_boxBorderRadius(style.spec.indicator), BorderRadius.zero);
        expect(_boxBorderRadius(style.spec.container), BorderRadius.zero);
      }
    });

    testWidgets('selected tabs resolve an accent12 underline', (tester) async {
      final normal = await _resolveFortalStyle(
        tester,
        (context) => fortalTabStyle().build(context),
        states: {WidgetState.selected},
      );
      final highContrast = await _resolveFortalStyle(
        tester,
        (context) => fortalTabStyle(highContrast: true).build(context),
        states: {WidgetState.selected},
      );

      expect(_tabUnderlineColor(normal), ceu.light.scale.step(9));
      expect(_tabUnderlineColor(highContrast), ceu.light.scale.step(12));
    });
  });
}

Future<T> _resolveFortalStyle<T>(
  WidgetTester tester,
  T Function(BuildContext context) resolve, {
  FortalAccentColor accent = .ceu,
  Brightness brightness = .light,
  FortalRadius radius = .medium,
  Set<WidgetState> states = const {},
}) async {
  late T style;

  await tester.pumpWidget(
    FortalTheme(
      accent: accent,
      mode: brightness == Brightness.dark ? .dark : .light,
      radius: radius,
      child: WidgetsApp(
        color: const Color(0xFFFFFFFF),
        pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        ),
        home: WidgetStateProvider(
          states: states,
          child: Builder(
            builder: (context) {
              style = resolve(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    ),
  );

  return style;
}

Color? _boxColor(StyleSpec<BoxSpec> style) =>
    (style.spec.decoration as BoxDecoration?)?.color;

Color? _flexBoxColor(StyleSpec<FlexBoxSpec> style) =>
    (style.spec.box?.spec.decoration as BoxDecoration?)?.color;

BorderRadiusGeometry? _boxBorderRadius(StyleSpec<BoxSpec> style) =>
    switch (style.spec.decoration) {
      BoxDecoration(:final borderRadius) => borderRadius,
      ShapeDecoration(shape: RoundedRectangleBorder(:final borderRadius)) =>
        borderRadius,
      _ => null,
    };

double _contrastRatio(Color first, Color second) {
  final firstLuminance = first.computeLuminance();
  final secondLuminance = second.computeLuminance();
  final lighter = firstLuminance > secondLuminance
      ? firstLuminance
      : secondLuminance;
  final darker = firstLuminance > secondLuminance
      ? secondLuminance
      : firstLuminance;

  return (lighter + 0.05) / (darker + 0.05);
}

Color? _textColor(StyleSpec<TextSpec> style) => style.spec.style?.color;

Color? _tabUnderlineColor(StyleSpec<TabSpec> style) {
  final modifiers = style.widgetModifiers?.whereType<BoxModifier>().toList();
  final decoration = modifiers?.single.spec.decoration as BoxDecoration?;
  final border = decoration?.border;

  return border is Border ? border.bottom.color : null;
}
