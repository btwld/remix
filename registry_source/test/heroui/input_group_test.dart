import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/input_group.dart';
import 'package:registry_source/src/heroui/components/textfield.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _prefix = 'https://';
const _suffix = '.com';
const _icon = IconData(0xe000, fontFamily: 'Ahem');
const _modes = ['light', 'dark'];

/// Upstream renders the full-width group 320px wide.
Widget _group({
  HeroUiTextFieldVariant variant = .primary,
  Widget? leading = const Text(_prefix),
  Widget? trailing = const Text(_suffix),
  bool error = false,
  bool enabled = true,
  ValueChanged<String>? onChanged,
  TextFieldStyler style = const TextFieldStyler.create(),
}) => SizedBox(
  width: 320,
  child: HeroUiInputGroup(
    variant: variant,
    error: error,
    enabled: enabled,
    style: style,
    leading: leading,
    trailing: trailing,
    hintText: 'example',
    onChanged: onChanged,
  ),
);

Future<TextFieldSpec> _pump(
  WidgetTester tester,
  Widget group, {
  String mode = 'light',
  int width = 1024,
}) async {
  await tester.pumpHeroUi(group, mode: mode, width: width.toDouble());
  await tester.pumpAndSettle();
  return _spec(tester);
}

TextFieldSpec _spec(WidgetTester tester) =>
    tester.resolvedSpecOf<TextFieldSpec>(find.byType(EditableText));

Color? _fill(TextFieldSpec spec) =>
    (spec.container.spec.decoration as BoxDecoration?)?.color;

/// Runs the 150ms state transition; the caret blink never lets
/// `pumpAndSettle` finish.
Future<void> _focus(WidgetTester tester) async {
  await tester.tap(find.byType(EditableText));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  for (final mode in _modes) {
    for (final width in [375, 1024]) {
      for (final variant in HeroUiTextFieldVariant.values) {
        testWidgets('${variant.name} matches upstream at $width px in $mode', (
          tester,
        ) async {
          final spec = await _pump(
            tester,
            _group(variant: variant),
            mode: mode,
            width: width,
          );
          final group = heroUiCase(
            'input-group-${variant.name}-full-input',
            mode: mode,
            width: width,
          );
          final prefix = heroUiCase(
            'input-group-${variant.name}-full-input-prefix',
            mode: mode,
            width: width,
          );
          final suffix = heroUiCase(
            'input-group-${variant.name}-full-input-suffix',
            mode: mode,
            width: width,
          );
          final box = tester.getRect(find.byType(HeroUiInputGroup));
          expect(box.width, group.size.width);
          expect(box.height, group.size.height);
          expect(
            (spec.container.spec.decoration as BoxDecoration).borderRadius,
            BorderRadius.circular(group.px('borderRadius')),
          );
          expect(
            spec.container.spec.constraints!.minHeight,
            group.px('minHeight'),
          );
          expectCssColor(
            _fill(spec)!,
            group.styles['backgroundColor']!,
            reason: 'fill',
          );
          expectShadows(
            behindShadows(spec.containerEffects),
            cssShadows(group.styles['boxShadow'] ?? ''),
          );

          // The prefix and suffix are `px-3` boxes beside an input with no
          // padding on their side.
          final leading = tester.getRect(find.text(_prefix));
          final input = tester.getRect(find.byType(EditableText));
          final trailing = tester.getRect(find.text(_suffix));
          expect(leading.left - box.left, prefix.px('paddingLeft'));
          expect(input.left - leading.right, prefix.px('paddingRight'));
          expect(trailing.left - input.right, suffix.px('paddingLeft'));
          expect(box.right - trailing.right, suffix.px('paddingRight'));
        });
      }
    }
  }

  for (final mode in _modes) {
    testWidgets('prefix text and icons take the placeholder color in $mode', (
      tester,
    ) async {
      await _pump(tester, _group(leading: const Icon(_icon)), mode: mode);
      final prefix = heroUiCase(
        'input-group-primary-full-input-prefix',
        mode: mode,
      );
      final text = tester.widget<DefaultTextStyle>(
        find
            .ancestor(
              of: find.text(_suffix),
              matching: find.byType(DefaultTextStyle),
            )
            .first,
      );
      expectCssColor(
        text.style.color!,
        prefix.styles['color']!,
        reason: 'text',
      );
      expect(text.style.fontSize, prefix.px('fontSize'));
      final context = tester.element(find.byIcon(_icon));
      expectCssColor(
        IconTheme.of(context).color!,
        prefix.styles['color']!,
        reason: 'icon',
      );
    });

    for (final variant in HeroUiTextFieldVariant.values) {
      testWidgets(
        'hover lightens the ${variant.name} group, and focus replaces it in '
        '$mode',
        (tester) async {
          await _pump(tester, _group(variant: variant), mode: mode);
          await tester.hoverCenter(find.byType(EditableText));
          // `.input-group:hover:not(:focus-within)`: `bg-field-hover`, or
          // `--input-group-bg-hover` (`default-hover`) when secondary.
          expect(
            _fill(_spec(tester)),
            heroUiToken(
              variant == .primary
                  ? HeroUiTokens.fieldHover
                  : HeroUiTokens.defaultHover,
              mode,
            ),
            reason: 'hover',
          );
          await _focus(tester);
          expect(
            _fill(_spec(tester)),
            heroUiToken(
              variant == .primary
                  ? HeroUiTokens.fieldFocus
                  : HeroUiTokens.defaultColor,
              mode,
            ),
            reason: 'focus',
          );
        },
        variant: desktopOnly,
      );

      testWidgets('focus and error ring the whole ${variant.name} group in '
          '$mode', (tester) async {
        var spec = await _pump(
          tester,
          _group(variant: variant, error: true),
          mode: mode,
        );
        final danger = heroUiToken(HeroUiTokens.danger, mode);
        // `invalid-field-ring`: a 1px danger outline, `ring-2` when focused.
        expect(spec.containerEffects!.outline.width, 1);
        expect(spec.containerEffects!.outline.color, danger);
        await _focus(tester);
        spec = _spec(tester);
        final focus = heroUiCase(
          'input-invalid-focus',
          mode: mode,
          state: true,
        );
        final ring = cssRemixShadows(focus.styles['boxShadow']!).singleWhere(
          (shadow) => shadow.blurRadius == 0 && shadow.spreadRadius > 0,
        );
        expect(spec.containerEffects!.outline.width, ring.spreadRadius);
        expect(spec.containerEffects!.outline.color, danger);
      });
    }

    // `.input-group[data-disabled]` is `status-disabled`; no case measures it.
    testWidgets('disabled dims the group and ignores typing in $mode', (
      tester,
    ) async {
      String? typed;
      await _pump(
        tester,
        _group(enabled: false, onChanged: (value) => typed = value),
        mode: mode,
      );
      expect(
        tester.opacityAbove(find.byType(EditableText)),
        HeroUiTokens.disabledOpacity,
      );
      await tester.enterText(find.byType(EditableText), 'abc');
      expect(typed, isNull);
    });
  }

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    final spec = await _pump(
      tester,
      _group(style: TextFieldStyler().color(override)),
    );
    expect(_fill(spec), override);
  });
}
