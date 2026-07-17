import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  group('Fortal semantic tokens', () {
    testWidgets('resolve to the Radix light and dark semantic colors', (
      tester,
    ) async {
      final light = await _captureFortalTokens(tester, Brightness.light);
      final dark = await _captureFortalTokens(tester, Brightness.dark);

      expect(light.semanticColors, const {
        'background': Color(0xFFFFFFFF),
        'panelSolid': Color(0xFFFFFFFF),
        'panelTranslucent': Color(0xB3FFFFFF),
        'surface': Color(0xD9FFFFFF),
        'overlay': Color(0x66000000),
      });
      expect(dark.semanticColors, const {
        'background': Color(0xFF111113),
        'panelSolid': Color(0xFF18191B),
        'panelTranslucent': Color(0x09D8F4F6),
        'surface': Color(0x40000000),
        'overlay': Color(0x99000000),
      });

      for (final entry in light.semanticColors.entries) {
        expect(
          entry.value,
          isNot(dark.semanticColors[entry.key]),
          reason: '${entry.key} must differ between light and dark modes.',
        );
      }
    });

    testWidgets('bind mode-specific shadow strokes into shadow recipes', (
      tester,
    ) async {
      final light = await _captureFortalTokens(tester, Brightness.light);
      final dark = await _captureFortalTokens(tester, Brightness.dark);

      final expectedLightStroke = Color.lerp(
        slate.light.scale.alphaStep(3),
        slate.light.scale.step(3),
        0.25,
      )!;
      final expectedDarkStroke = Color.lerp(
        slate.dark.scale.alphaStep(6),
        slate.dark.scale.step(6),
        0.25,
      )!;

      expect(light.shadowStroke, expectedLightStroke);
      expect(dark.shadowStroke, expectedDarkStroke);
      expect(light.shadowStroke, isNot(dark.shadowStroke));

      for (final tokens in [light, dark]) {
        expect(
          tokenFromReferenceValue<Color>(tokens.shadow2.first.color),
          FortalTokens.shadowStroke,
        );
        expect(
          tokenFromReferenceValue<Color>(tokens.shadow6.first.color),
          FortalTokens.shadowStroke,
        );
        expect(tokens.shadow2FirstLayerColor, tokens.shadowStroke);
        expect(tokens.shadow6FirstLayerColor, tokens.shadowStroke);
      }

      expect(
        _shadowGeometry(light.shadow3),
        isNot(_shadowGeometry(dark.shadow3)),
      );
      expect(_shadowGeometry(light.shadow3), const [
        (offset: Offset(0, 0), blurRadius: 0.0, spreadRadius: 1.0),
        (offset: Offset(0, 2), blurRadius: 3.0, spreadRadius: -2.0),
        (offset: Offset(0, 3), blurRadius: 12.0, spreadRadius: -4.0),
        (offset: Offset(0, 4), blurRadius: 16.0, spreadRadius: -8.0),
      ]);
      expect(_shadowGeometry(dark.shadow3), const [
        (offset: Offset(0, 0), blurRadius: 0.0, spreadRadius: 1.0),
        (offset: Offset(0, 2), blurRadius: 3.0, spreadRadius: -2.0),
        (offset: Offset(0, 3), blurRadius: 8.0, spreadRadius: -2.0),
        (offset: Offset(0, 4), blurRadius: 12.0, spreadRadius: -4.0),
      ]);
    });
  });
}

Future<_FortalTokenSnapshot> _captureFortalTokens(
  WidgetTester tester,
  Brightness brightness,
) async {
  late _FortalTokenSnapshot snapshot;

  await tester.pumpWidget(
    MaterialApp(
      home: FortalScope(
        brightness: brightness,
        child: Builder(
          builder: (context) {
            final shadow2 = List<BoxShadow>.unmodifiable(
              MixScope.tokenOf(FortalTokens.shadow2, context),
            );
            final shadow3 = List<BoxShadow>.unmodifiable(
              MixScope.tokenOf(FortalTokens.shadow3, context),
            );
            final shadow6 = List<BoxShadow>.unmodifiable(
              MixScope.tokenOf(FortalTokens.shadow6, context),
            );

            snapshot = _FortalTokenSnapshot(
              background: MixScope.tokenOf(
                FortalTokens.colorBackground,
                context,
              ),
              panelSolid: MixScope.tokenOf(
                FortalTokens.colorPanelSolid,
                context,
              ),
              panelTranslucent: MixScope.tokenOf(
                FortalTokens.colorPanelTranslucent,
                context,
              ),
              surface: MixScope.tokenOf(FortalTokens.colorSurface, context),
              overlay: MixScope.tokenOf(FortalTokens.colorOverlay, context),
              shadowStroke: MixScope.tokenOf(
                FortalTokens.shadowStroke,
                context,
              ),
              shadow2: shadow2,
              shadow3: shadow3,
              shadow6: shadow6,
              shadow2FirstLayerColor: _resolveColorReference(
                context,
                shadow2.first.color,
              ),
              shadow6FirstLayerColor: _resolveColorReference(
                context,
                shadow6.first.color,
              ),
            );

            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );

  return snapshot;
}

Color _resolveColorReference(BuildContext context, Color color) {
  final token = tokenFromReferenceValue<Color>(color);

  return token == null ? color : MixScope.tokenOf(token, context);
}

List<({Offset offset, double blurRadius, double spreadRadius})> _shadowGeometry(
  List<BoxShadow> shadows,
) {
  return [
    for (final shadow in shadows)
      (
        offset: shadow.offset,
        blurRadius: shadow.blurRadius,
        spreadRadius: shadow.spreadRadius,
      ),
  ];
}

class _FortalTokenSnapshot {
  const _FortalTokenSnapshot({
    required this.background,
    required this.panelSolid,
    required this.panelTranslucent,
    required this.surface,
    required this.overlay,
    required this.shadowStroke,
    required this.shadow2,
    required this.shadow3,
    required this.shadow6,
    required this.shadow2FirstLayerColor,
    required this.shadow6FirstLayerColor,
  });

  final Color background;
  final Color panelSolid;
  final Color panelTranslucent;
  final Color surface;
  final Color overlay;
  final Color shadowStroke;
  final List<BoxShadow> shadow2;
  final List<BoxShadow> shadow3;
  final List<BoxShadow> shadow6;
  final Color shadow2FirstLayerColor;
  final Color shadow6FirstLayerColor;

  Map<String, Color> get semanticColors => {
    'background': background,
    'panelSolid': panelSolid,
    'panelTranslucent': panelTranslucent,
    'surface': surface,
    'overlay': overlay,
  };
}
