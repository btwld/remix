import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/src/heroui/theme/theme.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

/// The `cubic-bezier(a, b, c, d)` of the CSS variable [name].
List<double> _cubic(String css, String name) {
  final match = RegExp('--$name: cubic-bezier\\(([^)]*)\\)').firstMatch(css)!;
  return [for (final part in match[1]!.split(',')) double.parse(part.trim())];
}

List<double> _points(Cubic curve) => [curve.a, curve.b, curve.c, curve.d];

void main() {
  test('the easing tokens are the pinned CSS cubic-beziers', () {
    final css = File(
      'reference/heroui_3_2_6/source/dist/themes/shared/theme.css',
    ).readAsStringSync();
    expect(_points(HeroUiTokens.easeOutQuart), _cubic(css, 'ease-out-quart'));
    expect(_points(HeroUiTokens.easeOutQuad), _cubic(css, 'ease-out-quad'));
    expect(_points(HeroUiTokens.easeOutFluid), _cubic(css, 'ease-out-fluid'));
    // Tailwind's `--ease-out` and the default `transition` timing function.
    expect(_points(HeroUiTokens.easeOut), [0, 0, .2, 1]);
    expect(_points(HeroUiTokens.easeDefault), [.4, 0, .2, 1]);
  });

  test('motion tokens are the transitions their CSS declares', () {
    const curves = {
      'ease-out': HeroUiTokens.easeOut,
      'ease-smooth': HeroUiTokens.easeSmooth,
      'ease-out-quart': HeroUiTokens.easeOutQuart,
    };
    for (final (motion, file, property) in [
      (HeroUiTokens.fillMotion, 'button', 'background-color'),
      (HeroUiTokens.smoothMotion, 'input', 'background-color'),
      (HeroUiTokens.selectionMotion, 'radio', 'background-color'),
      (HeroUiTokens.transformMotion, 'close-button', 'transform'),
    ]) {
      final css = File(
        'reference/heroui_3_2_6/source/dist/components/$file.css',
      ).readAsStringSync();
      final match = RegExp(
        '$property (\\d+)ms var\\(--([a-z-]+)\\)',
      ).firstMatch(css)!;
      expect(
        motion.duration,
        Duration(milliseconds: int.parse(match[1]!)),
        reason: '$file.css $property',
      );
      expect(motion.curve, curves[match[2]], reason: '$file.css $property');
    }
  });

  testWidgets('heroUiAlpha multiplies the token alpha in both modes', (
    tester,
  ) async {
    final half = heroUiAlpha(HeroUiTokens.accent, .5);
    final ofTranslucent = heroUiAlpha(HeroUiTokens.separatorTertiary, .5);
    for (final mode in ['light', 'dark']) {
      late BuildContext context;
      await tester.pumpHeroUi(
        Builder(
          builder: (c) {
            context = c;
            return const SizedBox();
          },
        ),
        mode: mode,
      );
      final accent = heroUiToken(HeroUiTokens.accent, mode);
      expect(half.resolve(context), accent.withValues(alpha: accent.a * .5));
      final tertiary = heroUiToken(HeroUiTokens.separatorTertiary, mode);
      expect(
        ofTranslucent.resolve(context).a,
        closeTo(tertiary.a * .5, 1e-9),
        reason: 'a translucent token keeps its own alpha: $mode',
      );
    }
  });

  testWidgets('heroUiRadius scales the token and caps it', (tester) async {
    final panel = heroUiRadius(HeroUiTokens.radiusLg, scale: 2.5, max: 32);
    final uncapped = heroUiRadius(HeroUiTokens.radiusLg, scale: 2.5);
    final plain = heroUiRadius(HeroUiTokens.radiusXl);
    for (final (radius, expected) in [(8.0, 20.0), (16.0, 32.0)]) {
      late BuildContext context;
      await tester.pumpHeroUi(
        Builder(
          builder: (c) {
            context = c;
            return const SizedBox();
          },
        ),
        theme: HeroUiThemeData.light(radius: radius),
      );
      expect(panel.resolve(context), Radius.circular(expected));
      expect(uncapped.resolve(context), Radius.circular(radius * 2.5));
      expect(plain.resolve(context), Radius.circular(radius * 1.5));
    }
  });
}
