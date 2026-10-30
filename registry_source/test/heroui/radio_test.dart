import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/radio.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _modes = ['light', 'dark'];

/// Two radios in a group; `a` starts selected, as in the upstream fixture.
Widget _radios({
  HeroUiRadioVariant variant = .primary,
  bool invalid = false,
  bool enabled = true,
  String? groupValue = 'a',
  ValueChanged<String?>? onChanged,
  RadioStyler style = const RadioStyler.create(),
}) => RemixRadioGroup<String>(
  groupValue: groupValue,
  onChanged: onChanged ?? (_) {},
  child: Row(
    mainAxisSize: MainAxisSize.min,
    spacing: 16,
    children: [
      for (final value in ['a', 'b'])
        HeroUiRadio<String>(
          key: ValueKey(value),
          value: value,
          semanticLabel: value,
          variant: variant,
          invalid: invalid,
          enabled: enabled,
          style: style,
        ),
    ],
  ),
);

Future<void> _pump(
  WidgetTester tester,
  Widget radios, {
  String mode = 'light',
}) async {
  await tester.pumpHeroUi(radios, mode: mode);
  await tester.pumpAndSettle();
}

Finder _owner(String value) =>
    find.byType(HeroUiRadio<String>).at(value == 'a' ? 0 : 1);

/// The control's own box, which sits inside the radio's spec provider.
Finder _control(String value) => find
    .descendant(
      of: _owner(value),
      matching: find.byType(StyleSpecBuilder<BoxSpec>),
    )
    .first;

RadioSpec _spec(WidgetTester tester, String value) =>
    tester.resolvedSpecOf<RadioSpec>(_control(value));

Color? _fill(BoxSpec box) => (box.decoration as BoxDecoration?)?.color;

/// The unselected fill of a variant, and its hover fill (`radio.css`:
/// `bg-field-hover` on the dot; `--radio-control-bg-hover` when secondary).
ColorToken _restFill(HeroUiRadioVariant variant) => variant == .primary
    ? HeroUiTokens.fieldBackground
    : HeroUiTokens.defaultColor;

ColorToken _hoverFill(HeroUiRadioVariant variant) =>
    variant == .primary ? HeroUiTokens.fieldHover : HeroUiTokens.defaultHover;

void main() {
  test('variants follow HeroUI', () {
    expect(HeroUiRadioVariant.values, [
      HeroUiRadioVariant.primary,
      HeroUiRadioVariant.secondary,
    ]);
  });

  for (final mode in _modes) {
    for (final variant in HeroUiRadioVariant.values) {
      testWidgets('${variant.name} control matches upstream in $mode', (
        tester,
      ) async {
        await _pump(tester, _radios(variant: variant), mode: mode);
        final control = heroUiCase(
          'radio-${variant.name}-vertical-rest-a-control',
          mode: mode,
        );
        final selected = _spec(tester, 'a');
        final rest = _spec(tester, 'b');

        expect(
          selected.container.spec.constraints,
          BoxConstraints.tight(control.size),
        );
        expect(
          (selected.container.spec.decoration as BoxDecoration).borderRadius,
          BorderRadius.circular(control.px('borderRadius')),
        );
        expectCssColor(
          _fill(selected.container.spec)!,
          control.styles['backgroundColor']!,
          reason: 'selected fill',
        );
        expect(
          _fill(rest.container.spec),
          heroUiToken(_restFill(variant), mode),
        );
        // `.radio__indicator:empty::before` scales to 0.4286 once selected,
        // and only a selected radio draws it.
        expect(
          _fill(selected.indicator.spec),
          heroUiToken(HeroUiTokens.accentForeground, mode),
        );
        expect(
          selected.indicator.spec.constraints!.maxWidth,
          closeTo(control.size.width * 0.4286, .001),
        );
      });

      // `--field-shadow` is the surface shadow in light and transparent in
      // dark; the secondary variant has none (`shadow-none`).
      testWidgets('${variant.name} carries the upstream shadow in $mode', (
        tester,
      ) async {
        await _pump(tester, _radios(variant: variant), mode: mode);
        final control = heroUiCase(
          'radio-${variant.name}-vertical-rest-a-control',
          mode: mode,
        );
        expectShadows(
          behindShadows(_spec(tester, 'a').containerEffects),
          cssShadows(control.styles['boxShadow'] ?? ''),
        );
      });

      // Flutter shows hover on a `RawRadio` only in traditional highlight mode,
      // which desktop platforms start in.
      testWidgets(
        'hover fills an unselected ${variant.name} radio and leaves a '
        'selected one in $mode',
        (tester) async {
          await _pump(tester, _radios(variant: variant), mode: mode);
          final mouse = await tester.hoverCenter(_control('b'));
          expect(
            _fill(_spec(tester, 'b').container.spec),
            heroUiToken(_hoverFill(variant), mode),
          );

          // Selected stays `bg-accent` while hovered, as measured.
          final hovered = heroUiCase(
            'radio-primary-vertical-rest-a-hover',
            mode: mode,
            state: true,
          );
          await mouse.moveTo(tester.getCenter(_control('a')));
          await tester.pumpAndSettle();
          final fill = _fill(_spec(tester, 'a').container.spec)!;
          expect(fill, heroUiToken(HeroUiTokens.accent, mode));
          expectCssColor(fill, hovered.styles['backgroundColor']!);
        },
        variant: desktopOnly,
      );

      testWidgets('invalid keeps the accent fill and adds a 1px danger ring '
          'to ${variant.name} in $mode', (tester) async {
        await _pump(
          tester,
          _radios(variant: variant, invalid: true),
          mode: mode,
        );
        // Selected invalid keeps `bg-accent`, as at rest.
        final control = heroUiCase(
          'radio-${variant.name}-vertical-invalid-a-control',
          mode: mode,
        );
        expectCssColor(
          _fill(_spec(tester, 'a').container.spec)!,
          control.styles['backgroundColor']!,
          reason: 'selected fill',
        );
        expect(
          _fill(_spec(tester, 'b').container.spec),
          heroUiToken(_restFill(variant), mode),
        );
        for (final value in ['a', 'b']) {
          final effects = _spec(tester, value).containerEffects!;
          // `invalid-field-ring`: `outline-1 outline-danger`.
          expect(effects.outline.width, 1, reason: value);
          expect(
            effects.outline.color,
            heroUiToken(HeroUiTokens.danger, mode),
            reason: value,
          );
        }
      });
    }

    testWidgets('pressing scales the control and enlarges the dot in $mode', (
      tester,
    ) async {
      await _pump(tester, _radios(), mode: mode);
      final pressed = heroUiCase(
        'radio-primary-vertical-rest-a-pressed',
        mode: mode,
        state: true,
      );
      final rest = heroUiCase(
        'radio-primary-vertical-rest-a-control',
        mode: mode,
      );
      final press = await tester.pressCenter(_control('a'));
      final spec = _spec(tester, 'a');
      expect(
        spec.container.spec.transform!.entry(0, 0),
        closeTo(pressed.size.width / rest.size.width, .001),
      );
      expectCssColor(
        _fill(spec.container.spec)!,
        pressed.styles['backgroundColor']!,
        reason: 'pressed fill',
      );
      // `.radio__indicator:empty::before` scales to 0.5714 while pressed.
      expect(
        spec.indicator.spec.constraints!.maxWidth,
        closeTo(rest.size.width * 0.5714, .001),
      );
      await press.up();
    });

    // `radio-primary-vertical-rest-a-focus-control` is the measured ring. An
    // invalid radio has no capture: it is derived from the cascade (radio.yaml)
    // and keeps the accent ring.
    for (final invalid in [false, true]) {
      testWidgets('keyboard focus draws the measured ring without resizing, '
          '${invalid ? 'invalid' : 'valid'}, in $mode', (tester) async {
        await _pump(tester, _radios(invalid: invalid), mode: mode);
        final before = tester.getSize(_control('a'));
        await tester.focusWithTab();
        expectFocusRing(
          _spec(tester, 'a').containerEffects,
          heroUiCase(
            'radio-primary-vertical-rest-a-focus-control',
            mode: mode,
            state: true,
          ),
        );
        expect(tester.getSize(_control('a')), before);
      });
    }

    testWidgets('disabled dims the control and ignores taps in $mode', (
      tester,
    ) async {
      String? picked;
      await _pump(
        tester,
        _radios(enabled: false, onChanged: (v) => picked = v),
        mode: mode,
      );
      final disabled = heroUiCase(
        'radio-primary-vertical-disabled-a',
        mode: mode,
      );
      expect(
        tester.opacityAbove(_control('a')),
        double.parse(disabled.styles['opacity']!),
      );
      await tester.tap(_control('b'));
      expect(picked, isNull);
    });
  }

  testWidgets('selecting through Remix moves the selection', (tester) async {
    var value = 'a';
    await _pump(
      tester,
      StatefulBuilder(
        builder: (context, setState) => _radios(
          groupValue: value,
          onChanged: (v) => setState(() => value = v!),
        ),
      ),
    );
    await tester.tap(_control('b'));
    await tester.pumpAndSettle();
    expect(value, 'b');
    expect(
      _fill(_spec(tester, 'b').container.spec),
      heroUiToken(HeroUiTokens.accent),
    );
    expect(
      _fill(_spec(tester, 'a').container.spec),
      heroUiToken(HeroUiTokens.fieldBackground),
    );
  });

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    await _pump(tester, _radios(style: RadioStyler().color(override)));
    expect(_fill(_spec(tester, 'b').container.spec), override);
  });
}
