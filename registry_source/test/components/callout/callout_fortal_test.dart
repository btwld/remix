import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../../helpers/contrast.dart';

void main() {
  test('defaults to size2, surface and info', () {
    const callout = FortalCallout(child: Text('Heads up'));

    expect(callout.size, FortalCalloutSize.size2);
    expect(callout.variant, FortalCalloutVariant.surface);
    expect(callout.intent, FortalCalloutIntent.info);
  });

  group('Fortal Callout geometry', () {
    for (final (size, padding, gap, radius, title, text, icon) in const [
      (FortalCalloutSize.size1, 12.0, 8.0, 12.0, 12.0, 12.0, 16.0),
      (FortalCalloutSize.size2, 16.0, 12.0, 14.0, 13.0, 12.0, 18.0),
      (FortalCalloutSize.size3, 20.0, 12.0, 16.0, 15.0, 13.0, 20.0),
    ]) {
      testWidgets('${size.name} matches specified metrics', (tester) async {
        final spec = await _resolve(tester, fortalCalloutStyle(size: size));
        final flex = spec.container.spec;
        final box = flex.box!.spec;

        expect(box.padding, EdgeInsets.all(padding));
        expect(flex.flex!.spec.spacing, gap);
        expect(_radius(box), radius);
        expect(spec.title.spec.style!.fontSize, title);
        expect(spec.title.spec.style!.fontWeight, FontWeight.w500);
        expect(spec.text.spec.style!.fontSize, text);
        expect(spec.content.spec.flex!.spec.spacing, 4);
        expect(spec.icon.spec.size, icon);
        expect(flex.flex!.spec.crossAxisAlignment, CrossAxisAlignment.start);
      });
    }

    testWidgets('every variant keeps a 1px frame so content keeps its inset', (
      tester,
    ) async {
      for (final variant in FortalCalloutVariant.values) {
        final spec = await _resolve(
          tester,
          fortalCalloutStyle(variant: variant),
        );
        expect(_frame(spec).width, 1, reason: variant.name);
      }
    });
  });

  group('Fortal Callout variants', () {
    testWidgets('surface is a neutral resting card', (tester) async {
      final tokens = await _tokens(tester);
      final spec = await _resolve(tester, fortalCalloutStyle());
      final decoration = _decoration(spec)!;

      expect(decoration.color, tokens.surface);
      expect(_frame(spec).color, tokens.gray7);
      expect(decoration.boxShadow, isNotEmpty);
      expect(spec.title.spec.style!.color, tokens.gray12);
      expect(spec.text.spec.style!.color, tokens.gray11);
    });

    testWidgets('soft keeps the accent tint; outline a strong frame', (
      tester,
    ) async {
      final tokens = await _tokens(tester);
      final soft = await _resolve(tester, fortalCalloutStyle(variant: .soft));
      final outline = await _resolve(
        tester,
        fortalCalloutStyle(variant: .outline),
      );

      expect(_decoration(soft)!.color, tokens.accentA3);
      expect(_decoration(outline)!.color, isNull);
      expect(_frame(outline).color, tokens.gray8);
    });
  });

  group('Fortal Callout intent', () {
    testWidgets('each intent picks its icon color and glyph', (tester) async {
      final tokens = await _tokens(tester);
      for (final (intent, color, glyph) in [
        (
          FortalCalloutIntent.accent,
          tokens.accentContentAlpha,
          RemixIcons.info,
        ),
        (FortalCalloutIntent.info, tokens.info, RemixIcons.info),
        (FortalCalloutIntent.success, tokens.success, RemixIcons.check),
        (FortalCalloutIntent.warning, tokens.warning, RemixIcons.warning),
        (FortalCalloutIntent.error, tokens.error11, RemixIcons.closeCircle),
      ]) {
        final spec = await _resolve(tester, fortalCalloutStyle(intent: intent));
        expect(spec.icon.spec.color, color, reason: intent.name);
        expect(spec.icon.spec.icon, glyph, reason: intent.name);
      }
    });

    testWidgets('a callout draws its intent glyph without an icon argument', (
      tester,
    ) async {
      await tester.pumpWidget(
        FortalTheme(
          accent: .mar,
          mode: .light,
          child: WidgetsApp(
            color: Colors.black,
            builder: (context, _) => const Center(
              child: FortalCallout(
                intent: .success,
                title: 'Saved',
                text: 'All changes are live.',
              ),
            ),
          ),
        ),
      );

      expect(tester.widget<Icon>(find.byType(Icon)).icon, RemixIcons.check);
    });
  });

  group('Fortal Callout high contrast', () {
    for (final mode in FortalThemeMode.values) {
      testWidgets('lifts text to 4.5:1 and icon and frame to 3:1 '
          '(${mode.name})', (tester) async {
        final rest = await _resolve(tester, fortalCalloutStyle(), mode: mode);
        final theme = await _resolve(
          tester,
          fortalCalloutStyle(),
          mode: mode,
          themeHighContrast: true,
        );
        final flag = await _resolve(
          tester,
          fortalCalloutStyle(highContrast: true),
          mode: mode,
        );

        for (final spec in [theme, flag]) {
          final fill = _decoration(spec)!.color!;
          expect(
            contrastRatio(spec.text.spec.style!.color!, fill),
            greaterThanOrEqualTo(4.5),
          );
          expect(
            contrastRatio(spec.icon.spec.color!, fill),
            greaterThanOrEqualTo(3),
          );
          expect(
            contrastRatio(_frame(spec).color, fill),
            greaterThanOrEqualTo(3),
          );
        }
        expect(
          contrastRatio(_frame(rest).color, _decoration(rest)!.color!),
          lessThan(3),
          reason: 'the resting frame is the quiet border',
        );
      });
    }
  });

  testWidgets('the close button is a 28px circle around a 16px glyph', (
    tester,
  ) async {
    final spec = await _resolve(tester, fortalCalloutStyle());
    final button = await _resolveIn(
      tester,
      (context) => (spec.closeButton! as IconButtonStyler).build(context).spec,
    );
    final box = button.container.spec;

    expect(box.constraints!.minWidth, 28);
    expect(box.constraints!.minHeight, 28);
    expect(button.icon.spec.size, 16);
  });
}

Future<T> _resolveIn<T>(
  WidgetTester tester,
  T Function(BuildContext context) resolve, {
  FortalScaling scaling = .percent100,
  FortalThemeMode mode = .light,
  bool themeHighContrast = false,
}) async {
  late T result;
  await tester.pumpWidget(
    FortalTheme(
      accent: .mar,
      mode: mode,
      scaling: scaling,
      highContrast: themeHighContrast,
      child: WidgetsApp(
        color: Colors.black,
        builder: (context, child) {
          result = resolve(context);
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return result;
}

Future<CalloutSpec> _resolve(
  WidgetTester tester,
  CalloutStyler style, {
  FortalThemeMode mode = .light,
  bool themeHighContrast = false,
}) => _resolveIn(
  tester,
  (context) => style.build(context).spec,
  mode: mode,
  themeHighContrast: themeHighContrast,
);

typedef _Tokens = ({
  Color surface,
  Color gray7,
  Color gray8,
  Color gray11,
  Color gray12,
  Color accentA3,
  Color accentContentAlpha,
  Color info,
  Color success,
  Color warning,
  Color error11,
});

Future<_Tokens> _tokens(WidgetTester tester) => _resolveIn(tester, (context) {
  Color token(ColorToken value) => MixScope.tokenOf(value, context);
  return (
    surface: token(FortalTokens.colorSurface),
    gray7: token(FortalTokens.gray7),
    gray8: token(FortalTokens.gray8),
    gray11: token(FortalTokens.gray11),
    gray12: token(FortalTokens.gray12),
    accentA3: token(FortalTokens.accentA3),
    accentContentAlpha: token(FortalTokens.accentContentAlpha),
    info: token(FortalTokens.info),
    success: token(FortalTokens.success),
    warning: token(FortalTokens.warning),
    error11: token(FortalTokens.error11),
  );
});

BoxDecoration? _decoration(CalloutSpec spec) =>
    spec.container.spec.box?.spec.decoration as BoxDecoration?;

BorderSide _frame(CalloutSpec spec) =>
    (_decoration(spec)!.border! as Border).top;

double _radius(BoxSpec box) => (box.decoration as BoxDecoration).borderRadius!
    .resolve(TextDirection.ltr)
    .topLeft
    .x;
