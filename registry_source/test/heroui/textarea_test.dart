import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/components/textarea.dart';
import 'package:registry_source/src/heroui/components/textfield.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _modes = ['light', 'dark'];

/// Upstream renders the text area 320px wide.
Widget _area({
  HeroUiTextFieldVariant variant = .primary,
  bool error = false,
  bool enabled = true,
  ValueChanged<String>? onChanged,
  TextFieldStyler style = const TextFieldStyler.create(),
}) => SizedBox(
  width: 320,
  child: HeroUiTextArea(
    variant: variant,
    error: error,
    enabled: enabled,
    style: style,
    hintText: 'Tell us more',
    onChanged: onChanged,
  ),
);

Future<TextFieldSpec> _pump(
  WidgetTester tester,
  Widget area, {
  String mode = 'light',
  int width = 1024,
}) async {
  await tester.pumpHeroUi(area, mode: mode, width: width.toDouble());
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
            _area(variant: variant),
            mode: mode,
            width: width,
          );
          final area = heroUiCase(
            'textarea-${variant.name}-full-rest',
            mode: mode,
            width: width,
          );
          expect(tester.getSize(find.byType(HeroUiTextArea)), area.size);

          final box = spec.container.spec;
          expect(box.constraints!.minHeight, area.px('minHeight'));
          expect(
            box.padding,
            EdgeInsets.fromLTRB(
              area.px('paddingLeft'),
              area.px('paddingTop'),
              area.px('paddingRight'),
              area.px('paddingBottom'),
            ),
          );
          expect(
            (box.decoration as BoxDecoration).borderRadius,
            BorderRadius.circular(area.px('borderRadius')),
          );
          expectCssColor(
            _fill(spec)!,
            area.styles['backgroundColor']!,
            reason: 'fill',
          );
          expect(spec.text.spec.style!.fontSize, area.px('fontSize'));
          expectShadows(
            behindShadows(spec.containerEffects),
            cssShadows(area.styles['boxShadow'] ?? ''),
          );
        });
      }
    }
  }

  // A worksheet choice: only `.input-group:has(textarea)` top-aligns upstream.
  testWidgets('the content starts at the top of the area', (tester) async {
    final spec = await _pump(tester, _area());
    expect(spec.crossAxisAlignment, CrossAxisAlignment.start);
  });

  testWidgets('more lines than the minimum grow the area', (tester) async {
    await _pump(tester, _area());
    final rest = heroUiCase('textarea-primary-full-rest');
    await tester.enterText(find.byType(EditableText), 'one\ntwo\nthree');
    await tester.pumpAndSettle();
    expect(
      tester.getSize(find.byType(HeroUiTextArea)).height,
      rest.size.height + rest.px('lineHeight'),
    );
  });

  for (final mode in _modes) {
    for (final variant in HeroUiTextFieldVariant.values) {
      testWidgets(
        'hover lightens the ${variant.name} fill, and focus replaces it in $mode',
        (tester) async {
          await _pump(tester, _area(variant: variant), mode: mode);
          await tester.hoverCenter(find.byType(EditableText));
          // `--textarea-bg-hover` is `default-hover`; primary is `field-hover`.
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

      testWidgets(
        'error and focus use the ${variant.name} text field rings in $mode',
        (tester) async {
          var spec = await _pump(
            tester,
            _area(variant: variant, error: true),
            mode: mode,
          );
          final invalid = heroUiCase(
            'textarea-${variant.name}-full-invalid',
            mode: mode,
          );
          final danger = heroUiToken(HeroUiTokens.danger, mode);
          expectCssColor(
            _fill(spec)!,
            invalid.styles['backgroundColor']!,
            reason: 'fill',
          );
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
        },
      );
    }

    testWidgets('disabled dims the area in $mode', (tester) async {
      await _pump(tester, _area(enabled: false), mode: mode);
      final disabled = heroUiCase('textarea-primary-full-disabled', mode: mode);
      expect(
        tester.opacityAbove(find.byType(EditableText)),
        double.parse(disabled.styles['opacity']!),
      );
    });
  }

  testWidgets('a caller style wins over the recipe', (tester) async {
    const override = Color(0xFF00FF00);
    final spec = await _pump(
      tester,
      _area(style: TextFieldStyler().color(override)),
    );
    expect(_fill(spec), override);
  });

  testWidgets('typing reaches onChanged through Remix', (tester) async {
    String? value;
    await _pump(tester, _area(onChanged: (next) => value = next));
    await tester.enterText(find.byType(EditableText), 'a\nb');
    expect(value, 'a\nb');
  });
}
