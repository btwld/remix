import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/src/fortal/theme/fortal_colors.dart'
    show fortalNeutral;
import 'package:registry_source/src/fortal/theme/computed.dart'
    show mixOklabPremultiplied;
import 'package:registry_source/src/fortal/theme/theme_data.dart'
    show buildFortalScopeTokens;

void main() {
  for (final dark in [false, true]) {
    test(
      '${dark ? 'dark' : 'light'} semantic layers and floating elevation',
      () {
        final data = dark
            ? const FortalThemeData.dark()
            : const FortalThemeData.light();
        final colors = resolveFortalTokens(data);
        final tokens = buildFortalScopeTokens(data);
        final neutral = dark ? fortalNeutral.dark : fortalNeutral.light;
        expect(colors.colorBackground, neutral.scale.step(1));
        expect(colors.colorSurface, neutral.scale.step(2));
        expect(
          colors.colorPanelSolid,
          dark ? const Color(0xff1f1f1f) : const Color(0xffffffff),
        );
        expect(colors.colorPanelSolid.a, 1);
        // The translucent panel is the raised surface at 88 percent.
        expect(colors.colorPanelTranslucent.a, closeTo(.88, .005));
        expect(
          colors.colorPanelTranslucent.toARGB32() & 0xffffff,
          colors.colorPanelSolid.toARGB32() & 0xffffff,
        );
        expect(colors.colorOverlay.a, inExclusiveRange(0, 1));
        expect(tokens[FortalTokens.colorPanel], colors.colorPanelSolid);
        expect(tokens[FortalTokens.panelBlur], 0);
        final translucent = buildFortalScopeTokens(
          data.copyWith(panelBackground: .translucent),
        );
        expect(
          translucent[FortalTokens.colorPanel],
          colors.colorPanelTranslucent,
        );
        expect(translucent[FortalTokens.panelBlur], greaterThan(0));
        var previousBlur = 0.0;
        var previousY = 0.0;
        for (final token in [
          FortalTokens.shadow1,
          FortalTokens.shadow2,
          FortalTokens.shadow3,
          FortalTokens.shadow4,
          FortalTokens.shadow5,
          FortalTokens.shadow6,
        ]) {
          final shadows = tokens[token]! as List<BoxShadow>;
          // Light shadows above the resting level carry a second, tighter
          // layer; dark shadows are one denser layer.
          expect(
            shadows,
            hasLength(dark || token == FortalTokens.shadow1 ? 1 : 2),
          );
          final shadow = shadows.first;
          expect(shadow.blurRadius, greaterThan(previousBlur));
          expect(shadow.offset.dy, greaterThan(previousY));
          for (final layer in shadows) {
            expect(layer.offset.dx, 0);
            expect(layer.color.a, inExclusiveRange(0, 1));
          }
          previousBlur = shadow.blurRadius;
          previousY = shadow.offset.dy;
        }
        final layers =
            tokens[FortalTokens.shadow1Layers]! as List<RemixBoxShadow>;
        expect(layers.every((layer) => layer.shapeInset == 0), isTrue);
        expect(
          tokens.keys.any((token) => token.name.contains('.classic.')),
          isFalse,
        );
      },
    );
  }

  test(
    'premultiplied OKLab blending preserves identity and handles transparent endpoints',
    () {
      const first = Color(0x80426180);
      const second = Color(0xFFFFCF50);
      Color closeColor(Color value) => Color.fromARGB(
        (value.a * 255).round(),
        (value.r * 255).round(),
        (value.g * 255).round(),
        (value.b * 255).round(),
      );
      expect(closeColor(mixOklabPremultiplied(first, second, 0)), first);
      expect(closeColor(mixOklabPremultiplied(first, second, 1)), second);
      expect(
        mixOklabPremultiplied(const Color(0), const Color(0), .5),
        const Color(0),
      );
      expect(
        mixOklabPremultiplied(first, second, .5).a,
        closeTo((first.a + 1) / 2, 1e-9),
      );
      for (final amount in [-.1, 1.1, double.nan]) {
        expect(
          () => mixOklabPremultiplied(first, second, amount),
          throwsArgumentError,
        );
      }
    },
  );
}
