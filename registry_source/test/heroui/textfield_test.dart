import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/textfield.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _label = 'Email';
const _description = 'We will never share it.';
const _modes = ['light', 'dark'];

/// Upstream renders the text field 280px wide.
Widget _field({
  HeroUiTextFieldVariant variant = .primary,
  bool error = false,
  bool enabled = true,
  bool withText = true,
  ValueChanged<String>? onChanged,
  TextFieldStyler style = const TextFieldStyler.create(),
}) => SizedBox(
  width: 280,
  child: HeroUiTextField(
    variant: variant,
    error: error,
    enabled: enabled,
    style: style,
    label: withText ? _label : null,
    helperText: withText ? _description : null,
    hintText: 'you@example.com',
    onChanged: onChanged,
  ),
);

Future<TextFieldSpec> _pump(
  WidgetTester tester,
  Widget field, {
  String mode = 'light',
  int width = 1024,
  HeroUiThemeData? theme,
}) async {
  await tester.pumpHeroUi(
    field,
    mode: mode,
    width: width.toDouble(),
    theme: theme,
  );
  await tester.pumpAndSettle();
  return _spec(tester);
}

TextFieldSpec _spec(WidgetTester tester) =>
    tester.resolvedSpecOf<TextFieldSpec>(find.byType(EditableText));

Color? _fill(TextFieldSpec spec) =>
    (spec.container.spec.decoration as BoxDecoration?)?.color;

/// The fill a variant takes while hovered (`input.css`, `--input-bg-hover`).
ColorToken _hoverFill(HeroUiTextFieldVariant variant) =>
    variant == .primary ? HeroUiTokens.fieldHover : HeroUiTokens.defaultHover;

/// The fill a variant takes while focused or invalid (`--field-focus`,
/// `--input-bg-focus`).
ColorToken _focusFill(HeroUiTextFieldVariant variant) =>
    variant == .primary ? HeroUiTokens.fieldFocus : HeroUiTokens.defaultColor;

/// The ring of `input-invalid-focus`: `ring-2` as a solid spread. The focus
/// ring of a plain field is the same `ring-2` (`focus-field-ring`).
RemixBoxShadow _measuredRing(String mode) => cssRemixShadows(
  heroUiCase(
    'input-invalid-focus',
    mode: mode,
    state: true,
  ).styles['boxShadow']!,
).singleWhere((shadow) => shadow.blurRadius == 0 && shadow.spreadRadius > 0);

Future<void> _focus(WidgetTester tester) async {
  await tester.tap(find.byType(EditableText));
  await _settle(tester);
}

/// Runs the 150ms state transition; the caret blink never lets
/// `pumpAndSettle` finish.
Future<void> _settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  test('variants follow HeroUI', () {
    expect(HeroUiTextFieldVariant.values, [
      HeroUiTextFieldVariant.primary,
      HeroUiTextFieldVariant.secondary,
    ]);
  });

  for (final mode in _modes) {
    for (final width in [375, 1024]) {
      for (final variant in HeroUiTextFieldVariant.values) {
        testWidgets('${variant.name} matches upstream at $width px in $mode', (
          tester,
        ) async {
          final spec = await _pump(
            tester,
            _field(variant: variant),
            mode: mode,
            width: width,
          );
          final root = heroUiCase(
            'textfield-${variant.name}-rest',
            mode: mode,
            width: width,
          );
          expect(tester.getSize(find.byType(HeroUiTextField)), root.size);

          final input = heroUiCase(
            'input-${variant.name}-rest',
            mode: mode,
            width: width,
          );
          expect(
            tester.getSize(find.byType(EditableText)),
            Size(
              input.size.width -
                  input.px('paddingLeft') -
                  input.px('paddingRight'),
              input.size.height -
                  input.px('paddingTop') -
                  input.px('paddingBottom'),
            ),
          );
          final box = spec.container.spec;
          expect(
            box.padding,
            EdgeInsets.fromLTRB(
              input.px('paddingLeft'),
              input.px('paddingTop'),
              input.px('paddingRight'),
              input.px('paddingBottom'),
            ),
          );
          expect(
            (box.decoration as BoxDecoration).borderRadius,
            BorderRadius.circular(input.px('borderRadius')),
          );
          expectCssColor(
            _fill(spec)!,
            input.styles['backgroundColor']!,
            reason: 'fill',
          );
          final text = spec.text.spec.style!;
          expect(text.fontSize, input.px('fontSize'));
          expect(text.fontSize! * text.height!, input.px('lineHeight'));
          expectCssColor(text.color!, input.styles['color']!, reason: 'text');
          expect(
            spec.hintText.spec.style!.color,
            heroUiToken(HeroUiTokens.fieldPlaceholder, mode),
          );
        });
      }
    }
  }

  testWidgets('the input alone is as tall as upstream at both sizes', (
    tester,
  ) async {
    for (final width in [375, 1024]) {
      await _pump(tester, _field(withText: false), width: width);
      final input = heroUiCase('input-primary-rest', width: width);
      expect(tester.getSize(find.byType(HeroUiTextField)), input.size);
    }
  });

  for (final mode in _modes) {
    testWidgets(
      'the label and description follow label.css and description.css in $mode',
      (tester) async {
        final spec = await _pump(tester, _field(), mode: mode);
        final label = spec.label.spec.style!;
        expect(label.fontSize, 14);
        expect(label.fontSize! * label.height!, 20);
        expect(label.fontWeight, FontWeight.w500);
        expect(label.color, heroUiToken(HeroUiTokens.foreground, mode));
        final helper = spec.helperText.spec.style!;
        expect(helper.fontSize, 12);
        expect(helper.fontSize! * helper.height!, 16);
        expect(helper.color, heroUiToken(HeroUiTokens.muted, mode));
      },
    );

    // A browser draws the caret in the text color (worksheet approximation).
    testWidgets('the caret takes the text color in $mode', (tester) async {
      final spec = await _pump(tester, _field(), mode: mode);
      expect(spec.cursorColor, heroUiToken(HeroUiTokens.fieldForeground, mode));
    });

    for (final variant in HeroUiTextFieldVariant.values) {
      // `--field-shadow` is the surface shadow in light and transparent in
      // dark; the secondary variant has none (`shadow-none`).
      testWidgets('${variant.name} carries the upstream shadow in $mode', (
        tester,
      ) async {
        final spec = await _pump(tester, _field(variant: variant), mode: mode);
        final input = heroUiCase('input-${variant.name}-rest', mode: mode);
        expectShadows(
          behindShadows(spec.containerEffects),
          cssShadows(input.styles['boxShadow'] ?? ''),
        );
      });

      testWidgets(
        'hover lightens the ${variant.name} fill, and focus replaces it in $mode',
        (tester) async {
          await _pump(tester, _field(variant: variant), mode: mode);
          await tester.hoverCenter(find.byType(EditableText));
          expect(
            _fill(_spec(tester)),
            heroUiToken(_hoverFill(variant), mode),
            reason: 'hover',
          );
          await _focus(tester);
          expect(
            _fill(_spec(tester)),
            heroUiToken(_focusFill(variant), mode),
            reason: 'focus',
          );
        },
        variant: desktopOnly,
      );

      testWidgets(
        'error rings the ${variant.name} field with danger, 2px on focus, in $mode',
        (tester) async {
          var spec = await _pump(
            tester,
            _field(variant: variant, error: true),
            mode: mode,
          );
          final invalid = heroUiCase(
            'input-${variant.name}-invalid',
            mode: mode,
          );
          final fieldError = heroUiCase(
            'search-primary-intrinsic-invalid-error',
            mode: mode,
          );
          final danger = heroUiToken(HeroUiTokens.danger, mode);
          expect(
            tester.getSize(find.byType(HeroUiTextField)).width,
            invalid.size.width,
          );
          // `invalid-field-ring`: `outline-1 outline-danger`.
          expect(spec.containerEffects!.outline.width, 1);
          expect(spec.containerEffects!.outline.color, danger);
          expectCssColor(
            spec.label.spec.style!.color!,
            fieldError.styles['color']!,
            reason: 'label',
          );
          expectCssColor(
            spec.helperText.spec.style!.color!,
            fieldError.styles['color']!,
            reason: 'message',
          );
          expectCssColor(
            _fill(spec)!,
            invalid.styles['backgroundColor']!,
            reason: 'fill',
          );

          await _focus(tester);
          spec = _spec(tester);
          final ring = _measuredRing(mode);
          expect(spec.containerEffects!.outline.width, ring.spreadRadius);
          expect(spec.containerEffects!.outline.color, danger);
          expect(spec.containerEffects!.outlineOffset, 0);
        },
      );

      testWidgets(
        'hovering an invalid ${variant.name} field keeps the hover fill in $mode',
        (tester) async {
          await _pump(
            tester,
            _field(variant: variant, error: true),
            mode: mode,
          );
          await tester.hoverCenter(find.byType(EditableText));
          expect(_fill(_spec(tester)), heroUiToken(_hoverFill(variant), mode));
        },
        variant: desktopOnly,
      );
    }
  }

  testWidgets('focus draws the 2px ring against the field without resizing', (
    tester,
  ) async {
    for (final mode in _modes) {
      await _pump(tester, _field(), mode: mode);
      final before = tester.getSize(find.byType(HeroUiTextField));
      expect(_spec(tester).containerEffects!.outline.width, 0);
      await _focus(tester);
      final effects = _spec(tester).containerEffects!;
      expect(effects.outline.width, _measuredRing(mode).spreadRadius);
      expect(effects.outline.color, heroUiToken(HeroUiTokens.focus, mode));
      // `focus-field-ring`: `ring-offset-0`.
      expect(effects.outlineOffset, 0);
      expect(tester.getSize(find.byType(HeroUiTextField)), before);
    }
  });

  testWidgets('an error fills with field-focus, not the rest fill', (
    tester,
  ) async {
    // The default theme makes `field-focus` the same color as
    // `field-background`; splitting them shows which one an error takes
    // (`input.css`: `.input[data-invalid]` sets `bg-field-focus`).
    final theme = const HeroUiThemeData.light().copyWith(
      colors: {HeroUiTokens.fieldFocus: const Color(0xFFFFE0B2)},
    );
    Color colorOf(ColorToken token) => theme.tokens[token]! as Color;

    var spec = await _pump(tester, _field(), theme: theme);
    expect(_fill(spec), colorOf(HeroUiTokens.fieldBackground));
    spec = await _pump(tester, _field(error: true), theme: theme);
    expect(_fill(spec), colorOf(HeroUiTokens.fieldFocus));

    // `.input--secondary` sets `--input-bg-focus` to `default`.
    spec = await _pump(
      tester,
      _field(variant: .secondary, error: true),
      theme: theme,
    );
    expect(_fill(spec), colorOf(HeroUiTokens.defaultColor));
  });

  testWidgets('an error message gets the field-error inset', (tester) async {
    await _pump(tester, _field(error: true));
    // `.field-error` is `px-1`.
    final error = heroUiCase('search-primary-intrinsic-invalid-error');
    final insets = tester
        .widgetList<Padding>(
          find.ancestor(
            of: find.text(_description),
            matching: find.byType(Padding),
          ),
        )
        .map((padding) => padding.padding);
    expect(
      insets,
      contains(EdgeInsets.symmetric(horizontal: error.px('paddingLeft'))),
    );
  });

  for (final mode in _modes) {
    testWidgets('disabled dims the input and label but not the description in '
        '$mode', (tester) async {
      await _pump(tester, _field(enabled: false), mode: mode);
      final disabled = heroUiCase('input-primary-disabled', mode: mode);
      expect(
        tester.opacityAbove(find.byType(EditableText)),
        double.parse(disabled.styles['opacity']!),
      );
      expect(
        tester.opacityAbove(find.text(_label)),
        HeroUiTokens.disabledOpacity,
      );
      expect(tester.opacityAbove(find.text(_description)), 1);
    });
  }

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    final spec = await _pump(
      tester,
      _field(style: TextFieldStyler().color(override)),
    );
    expect(_fill(spec), override);
  });

  testWidgets('typing reaches onChanged through Remix', (tester) async {
    String? value;
    await _pump(tester, _field(onChanged: (next) => value = next));
    await tester.enterText(find.byType(EditableText), 'a@b.c');
    expect(value, 'a@b.c');
  });
}
