import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/toggle_button.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _label = 'Toggle';
const _icon = IconData(0xe000, fontFamily: 'Ahem');
const _modes = ['light', 'dark'];

Widget _toggle({
  HeroUiToggleButtonVariant variant = .defaultToggle,
  HeroUiToggleButtonSize size = .md,
  bool iconOnly = false,
  bool selected = false,
  bool enabled = true,
  ValueChanged<bool>? onChanged,
  ToggleStyler style = const ToggleStyler.create(),
}) => HeroUiToggleButton(
  variant: variant,
  size: size,
  iconOnly: iconOnly,
  selected: selected,
  enabled: enabled,
  label: iconOnly ? null : _label,
  icon: iconOnly ? _icon : null,
  semanticLabel: _label,
  onChanged: onChanged ?? (_) {},
  style: style,
);

Future<ToggleSpec> _pump(
  WidgetTester tester,
  Widget toggle, {
  String mode = 'light',
  int width = 1024,
  bool iconOnly = false,
}) async {
  await tester.pumpHeroUi(toggle, mode: mode, width: width.toDouble());
  await tester.pumpAndSettle();
  return _spec(tester, iconOnly: iconOnly);
}

ToggleSpec _spec(WidgetTester tester, {bool iconOnly = false}) =>
    tester.resolvedSpecOf<ToggleSpec>(
      iconOnly ? find.byIcon(_icon) : find.text(_label),
    );

BoxDecoration _decoration(ToggleSpec spec) =>
    spec.container.spec.boxSpec.decoration! as BoxDecoration;

Color? _fill(ToggleSpec spec) =>
    (spec.container.spec.boxSpec.decoration as BoxDecoration?)?.color;

String _id(HeroUiToggleButtonVariant variant) =>
    variant == .defaultToggle ? 'default' : 'ghost';

/// The fill and foreground tokens of each variant at rest, per `--toggle-button-*`.
(ColorToken?, ColorToken) _rest(HeroUiToggleButtonVariant variant) =>
    switch (variant) {
      .defaultToggle => (HeroUiTokens.defaultColor, HeroUiTokens.foreground),
      .ghost => (null, HeroUiTokens.defaultForeground),
    };

void main() {
  test('variants and sizes follow HeroUI', () {
    expect(HeroUiToggleButtonVariant.values, [
      HeroUiToggleButtonVariant.defaultToggle,
      HeroUiToggleButtonVariant.ghost,
    ]);
    expect(HeroUiToggleButtonSize.values, [
      HeroUiToggleButtonSize.sm,
      HeroUiToggleButtonSize.md,
      HeroUiToggleButtonSize.lg,
    ]);
  });

  for (final mode in _modes) {
    for (final width in [375, 1024]) {
      for (final variant in HeroUiToggleButtonVariant.values) {
        for (final size in HeroUiToggleButtonSize.values) {
          for (final iconOnly in [false, true]) {
            for (final selected in [false, true]) {
              final kind = iconOnly ? 'icon' : 'label';
              final state = selected ? 'selected' : 'rest';
              final id = 'toggle-${_id(variant)}-${size.name}-$kind-$state';
              testWidgets('$id matches upstream at $width px in $mode', (
                tester,
              ) async {
                final spec = await _pump(
                  tester,
                  _toggle(
                    variant: variant,
                    size: size,
                    iconOnly: iconOnly,
                    selected: selected,
                  ),
                  mode: mode,
                  width: width,
                  iconOnly: iconOnly,
                );
                final upstream = heroUiCase(id, mode: mode, width: width);
                final box = tester.getSize(find.byType(HeroUiToggleButton));

                expect(box.height, upstream.size.height);
                if (iconOnly) {
                  expect(box.width, upstream.size.width);
                } else {
                  final text = tester.getSize(find.text(_label)).width;
                  expect(
                    box.width - text,
                    upstream.px('paddingLeft') + upstream.px('paddingRight'),
                  );
                  final label = spec.label.spec.style!;
                  expect(label.fontSize, upstream.px('fontSize'));
                  expect(
                    label.fontSize! * label.height!,
                    upstream.px('lineHeight'),
                  );
                  expect(label.fontWeight, FontWeight.w500);
                  expect(
                    spec.container.spec.flex!.spec.spacing,
                    upstream.px('gap'),
                  );
                }
                expect(
                  (spec.container.spec.boxSpec.decoration as BoxDecoration)
                      .borderRadius,
                  BorderRadius.circular(upstream.px('borderRadius')),
                );

                // A transparent fill is a browser `rgba(0, 0, 0, 0)`.
                final (fill, foreground) = _rest(variant);
                expect(
                  _fill(spec),
                  selected
                      ? heroUiToken(HeroUiTokens.accentSoft, mode)
                      : fill == null
                      ? HeroUiTokens.transparent
                      : heroUiToken(fill, mode),
                );
                final content = selected
                    ? heroUiToken(HeroUiTokens.accentSoftForeground, mode)
                    : heroUiToken(foreground, mode);
                if (iconOnly) {
                  expect(spec.icon.spec.color, content);
                  // `size-5 sm:size-4`, and `size-4` on small buttons.
                  expect(
                    spec.icon.spec.size,
                    size == .sm || width >= 640 ? 16 : 20,
                  );
                } else {
                  expect(spec.label.spec.style!.color, content);
                }
              });
            }
          }
        }
      }
    }
  }

  testWidgets('heights step down at the md breakpoint, icons at sm', (
    tester,
  ) async {
    for (final (width, height, icon) in [
      (639, 40.0, 20.0),
      (640, 40.0, 16.0),
      (767, 40.0, 16.0),
      (768, 36.0, 16.0),
    ]) {
      final spec = await _pump(
        tester,
        _toggle(iconOnly: true),
        width: width,
        iconOnly: true,
      );
      expect(
        tester.getSize(find.byType(HeroUiToggleButton)).height,
        height,
        reason: '$width',
      );
      expect(spec.icon.spec.size, icon, reason: '$width');
    }
  });

  // `--toggle-button-bg-hover`: `default-hover` for the default variant,
  // `default` for ghost; a selected button takes `accent-soft-hover`.
  for (final mode in _modes) {
    for (final (variant, selected, hover) in [
      (
        HeroUiToggleButtonVariant.defaultToggle,
        false,
        HeroUiTokens.defaultHover,
      ),
      (HeroUiToggleButtonVariant.ghost, false, HeroUiTokens.defaultColor),
      (
        HeroUiToggleButtonVariant.defaultToggle,
        true,
        HeroUiTokens.accentSoftHover,
      ),
      (HeroUiToggleButtonVariant.ghost, true, HeroUiTokens.accentSoftHover),
    ]) {
      final name = '${variant.name} ${selected ? 'selected' : 'rest'} in $mode';
      testWidgets('hover takes the variant color: $name', (tester) async {
        await _pump(
          tester,
          _toggle(variant: variant, selected: selected),
          mode: mode,
        );
        await tester.hoverCenter(find.byType(HeroUiToggleButton));
        expect(_fill(_spec(tester)), heroUiToken(hover, mode));
      }, variant: desktopOnly);

      testWidgets('press takes the variant color: $name', (tester) async {
        await _pump(
          tester,
          _toggle(variant: variant, selected: selected),
          mode: mode,
        );
        final press = await tester.pressCenter(find.byType(HeroUiToggleButton));
        expect(_fill(_spec(tester)), heroUiToken(hover, mode));
        await press.up();
      });
    }

    // `toggle-button.css` applies `status-focused`, the utility the close
    // button's capture shows.
    testWidgets('keyboard focus draws the measured ring without resizing in '
        '$mode', (tester) async {
      final rest = await _pump(tester, _toggle(), mode: mode);
      expect(rest.containerEffects?.isEmpty ?? true, isTrue);
      expect(_decoration(rest).border, isNull);
      final before = tester.getSize(find.byType(HeroUiToggleButton));
      final label = tester.getRect(find.text(_label));

      await tester.focusWithTab();
      final focused = _spec(tester);
      expectFocusRing(
        focused.containerEffects,
        heroUiCase('close-button-focus', mode: mode, state: true),
      );
      expect(_decoration(focused).border, isNull);
      expect(tester.getSize(find.byType(HeroUiToggleButton)), before);
      expect(tester.getRect(find.text(_label)), label);
    });

    for (final selected in [false, true]) {
      testWidgets('disabled dims the ${selected ? 'selected ' : ''}button in '
          '$mode', (tester) async {
        await _pump(
          tester,
          _toggle(enabled: false, selected: selected),
          mode: mode,
        );
        final disabled = heroUiCase(
          'toggle-default-md-label-${selected ? 'disabled-selected' : 'disabled'}',
          mode: mode,
        );
        expect(
          tester.opacityAbove(find.text(_label)),
          double.parse(disabled.styles['opacity']!),
        );
      });
    }
  }

  testWidgets('pressing scales each size by its own factor', (tester) async {
    // `scale(0.98)`, `0.97`, and `0.96` in `.toggle-button--sm`, base, and `--lg`.
    for (final (size, scale) in [
      (HeroUiToggleButtonSize.sm, 0.98),
      (HeroUiToggleButtonSize.md, 0.97),
      (HeroUiToggleButtonSize.lg, 0.96),
    ]) {
      await _pump(tester, _toggle(size: size));
      final press = await tester.pressCenter(find.byType(HeroUiToggleButton));
      expect(
        _spec(tester).container.spec.boxSpec.transform!.entry(0, 0),
        closeTo(scale, .001),
        reason: size.name,
      );
      await press.up();
    }
  });

  testWidgets('tapping toggles through Remix', (tester) async {
    bool? value;
    await _pump(tester, _toggle(onChanged: (next) => value = next));
    await tester.tap(find.text(_label));
    expect(value, isTrue);
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    final spec = await _pump(
      tester,
      _toggle(style: ToggleStyler().color(override)),
    );
    expect(_fill(spec), override);
  });
}
