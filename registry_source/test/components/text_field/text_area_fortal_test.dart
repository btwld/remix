import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix/remix.dart';

void main() {
  for (final (size, minHeight) in const [
    (FortalTextAreaSize.size1, 88.0),
    (FortalTextAreaSize.size2, 110.0),
    (FortalTextAreaSize.size3, 121.0),
  ]) {
    testWidgets('text area ${size.name} is $minHeight tall at the least', (
      tester,
    ) async {
      final look = await _resolve(
        tester,
        (_) => fortalTextAreaStyle(size: size),
      );
      final container = look.spec.container.spec;

      expect(container.constraints?.minHeight, closeTo(minHeight, 1e-9));
      expect(container.padding, const EdgeInsets.all(13));
      expect(
        (container.decoration! as BoxDecoration).borderRadius,
        BorderRadius.circular(14),
      );
      expect(look.spec.text.spec.style?.fontSize, 14);
      expect(look.spec.crossAxisAlignment, CrossAxisAlignment.start);
    });
  }

  testWidgets('text area sizes scale with the theme', (tester) async {
    final look = await _resolve(
      tester,
      (_) => fortalTextAreaStyle(),
      scaling: .percent110,
    );
    final container = look.spec.container.spec;

    expect(container.constraints?.minHeight, closeTo(121, 1e-9));
    // 12px scaled, plus the 1px frame, which does not scale.
    expect(
      container.padding!.resolve(TextDirection.ltr).left,
      closeTo(14.2, 1e-9),
    );
  });

  for (final (name, style, opacity) in [
    ('field', fortalTextFieldStyle, 0.5),
    ('area', fortalTextAreaStyle, 0.6),
  ]) {
    for (final mode in FortalThemeMode.values) {
      testWidgets('$name ${mode.name}: surface frame darkens on hover and '
          'focus, with no ring', (tester) async {
        for (final (states, frame) in [
          (<WidgetState>{}, FortalTokens.controlBorder),
          ({WidgetState.hovered}, FortalTokens.gray12),
          ({WidgetState.focused}, FortalTokens.gray12),
        ]) {
          final look = await _resolve(
            tester,
            (_) => _style(style),
            mode: mode,
            states: states,
          );
          expect(look.frame, look.token(frame), reason: '$states');
          expect(look.fill, look.token(FortalTokens.gray2), reason: '$states');
          final ring = look.spec.containerEffects!.outline;
          expect(
            ring.style == BorderStyle.none || ring.color.a == 0,
            isTrue,
            reason: '$states',
          );
        }
      });

      testWidgets('$name ${mode.name}: error holds its frame through hover '
          'and focus and keeps the label', (tester) async {
        final look = await _resolve(
          tester,
          (_) => _style(style),
          mode: mode,
          states: {WidgetState.error, WidgetState.hovered, WidgetState.focused},
        );

        expect(look.frame, look.token(FortalTokens.error8));
        expect(
          look.spec.label.spec.style?.color,
          look.token(FortalTokens.gray12),
        );
        expect(
          look.spec.errorText.spec.style?.color,
          look.token(FortalTokens.error11),
        );
        expect(look.spec.cursorColor, look.token(FortalTokens.error9));
      });

      testWidgets('$name ${mode.name}: disabled fades the box over the muted '
          'fill and keeps the resting frame', (tester) async {
        final look = await _resolve(
          tester,
          (_) => _style(style),
          mode: mode,
          states: {WidgetState.disabled, WidgetState.hovered},
        );

        expect(look.frame, look.token(FortalTokens.controlBorder));
        expect(look.fill, look.token(FortalTokens.gray3));
        expect(
          look.spec.container.widgetModifiers!
              .whereType<OpacityModifier>()
              .single
              .opacity,
          opacity,
        );
        expect(
          look.spec.label.spec.style?.color,
          look.token(FortalTokens.gray12),
        );
      });
    }

    testWidgets('$name soft shows no frame at rest and the strong one under '
        'high contrast', (tester) async {
      final rest = await _resolve(tester, (_) => _style(style, soft: true));
      final focused = await _resolve(
        tester,
        (_) => _style(style, soft: true),
        states: {WidgetState.focused},
      );
      final contrast = await _resolve(
        tester,
        (_) => _style(style, soft: true),
        highContrast: true,
      );

      expect(rest.fill, rest.token(FortalTokens.gray3));
      expect(rest.frame!.a, 0);
      expect(focused.frame, focused.token(FortalTokens.gray12));
      expect(contrast.frame, contrast.token(FortalTokens.controlBorder));
    });

    testWidgets('$name rings on focus and lifts muted content only under the '
        'theme high contrast switch', (tester) async {
      final normal = await _resolve(
        tester,
        (_) => _style(style),
        states: {WidgetState.focused},
      );
      final contrast = await _resolve(
        tester,
        (_) => _style(style),
        states: {WidgetState.focused},
        highContrast: true,
      );

      expect(
        normal.spec.hintText.spec.style?.color,
        normal.token(FortalTokens.gray10),
      );
      expect(
        normal.spec.helperText.spec.style?.color,
        normal.token(FortalTokens.gray10),
      );
      expect(
        contrast.spec.containerEffects!.outline.color,
        contrast.token(FortalTokens.focus8),
      );
      expect(contrast.spec.containerEffects!.outline.width, 2);
      expect(
        contrast.spec.hintText.spec.style?.color,
        contrast.token(FortalTokens.gray11),
      );
    });

    testWidgets('$name labels and message rows carry their own 8px gaps', (
      tester,
    ) async {
      final look = await _resolve(tester, (_) => _style(style));

      expect(look.spec.layout.spec.flex?.spec.spacing, 0);
      expect(look.spec.label.spec.style?.fontSize, 13);
      expect(look.spec.label.spec.style?.fontWeight, FontWeight.w500);
      expect(look.spec.helperText.spec.style?.fontSize, 12);
      expect(look.spec.errorText.spec.style?.fontSize, 12);
      for (final (slot, padding) in [
        (look.spec.label, const EdgeInsets.only(bottom: 8)),
        (look.spec.helperText, const EdgeInsets.only(top: 8)),
        (look.spec.errorText, const EdgeInsets.only(top: 8)),
      ]) {
        expect(
          slot.widgetModifiers!.whereType<PaddingModifier>().single.padding,
          padding,
        );
      }
    });
  }

  testWidgets('a new message row opens on the spring and an old one closes '
      'faster', (tester) async {
    final error = ValueNotifier<String?>(null);
    await tester.pumpWidget(
      FortalTheme(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 240,
              child: ValueListenableBuilder(
                valueListenable: error,
                builder: (context, text, _) =>
                    FortalTextField(label: 'Email', errorText: text),
              ),
            ),
          ),
        ),
      ),
    );
    final closed = tester.getSize(find.byType(FortalTextField)).height;

    error.value = 'Enter a valid email';
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final opening =
        tester.getSize(find.byType(FortalTextField)).height - closed;
    await tester.pumpAndSettle();
    final open = tester.getSize(find.byType(FortalTextField)).height - closed;

    // 8px gap plus the 12px row at 1.4 line height, rounded by the engine.
    expect(open, closeTo(25, 0.5));
    // The critically damped smooth spring is at 0.52 of its travel at 100ms.
    expect(opening / open, closeTo(0.52, 0.06));

    error.value = null;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final closing =
        tester.getSize(find.byType(FortalTextField)).height - closed;
    expect(closing / open, closeTo(0.48, 0.06));
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(FortalTextField)).height, closed);
  });
}

TextFieldStyler _style(
  TextFieldStyler Function({
    FortalTextFieldVariant variant,
    TextFieldStyler style,
  })
  recipe, {
  bool soft = false,
}) => recipe(variant: soft ? .soft : .surface);

typedef _Look = ({
  TextFieldSpec spec,
  Color Function(MixToken<Color> token) token,
  Color? frame,
  Color? fill,
});

Future<_Look> _resolve(
  WidgetTester tester,
  TextFieldStyler Function(BuildContext context) style, {
  FortalThemeMode mode = .light,
  FortalScaling scaling = .percent100,
  bool highContrast = false,
  Set<WidgetState> states = const {},
}) async {
  late _Look look;
  await tester.pumpWidget(
    FortalTheme(
      mode: mode,
      scaling: scaling,
      highContrast: highContrast,
      child: WidgetStateProvider(
        states: states,
        child: Builder(
          builder: (context) {
            final spec = style(context).build(context).spec;
            final shadows = spec.containerEffects?.overContent?.shadows;
            look = (
              spec: spec,
              token: (token) => MixScope.tokenOf(token, context),
              frame: shadows == null || shadows.isEmpty
                  ? null
                  : shadows.single.color,
              fill: (spec.container.spec.decoration as BoxDecoration?)?.color,
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
  return look;
}
