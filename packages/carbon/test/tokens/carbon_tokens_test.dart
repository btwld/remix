import 'package:carbon/carbon.dart';
import 'package:carbon/src/foundation/carbon_theme.dart';
import 'package:carbon/src/tokens/generated/carbon_component_tokens.g.dart';
import 'package:carbon/src/tokens/generated/carbon_themes.g.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('Source manifest', () {
    test('records the pinned Carbon baseline', () {
      expect(CarbonSourceManifest.carbonCommit,
          'b288a66af010622bedc6de4d6d0b81ee3c9f5520');
      expect(CarbonSourceManifest.license, 'Apache-2.0');
      expect(CarbonSourceManifest.packageVersions['@carbon/themes'], '11.76.0');
    });

    test('inventory counts match the baseline', () {
      expect(CarbonSourceManifest.roleColorCount, 234);
      expect(CarbonSourceManifest.paletteColorCount, 246);
      expect(CarbonSourceManifest.componentTokenCount, 78);
    });
  });

  group('Fixed layout scale', () {
    test('spacing is the 13-step 2..160px scale', () {
      expect(carbonFixedSpacingPx,
          [2, 4, 8, 12, 16, 24, 32, 40, 48, 64, 80, 96, 160]);
    });

    test('breakpoints match Carbon widths and columns', () {
      final widths = {for (final b in carbonBreakpoints) b.name: b.width};
      expect(widths, {
        'sm': 320.0,
        'md': 672.0,
        'lg': 1056.0,
        'xlg': 1312.0,
        'max': 1584.0,
      });
      expect(carbonBreakpoints.firstWhere((b) => b.name == 'sm').columns, 4);
      expect(carbonBreakpoints.firstWhere((b) => b.name == 'lg').columns, 16);
    });

    test('control sizes span 24..80px', () {
      expect(carbonControlSizePx['xSmall'], 24);
      expect(carbonControlSizePx['xxLarge'], 80);
    });
  });

  group('Theme role resolution', () {
    Color colorOf(CarbonTheme theme, ColorToken token) =>
        buildCarbonTokenMap(theme)[token]! as Color;

    test('all four themes expose the same 234 role names', () {
      final white = carbonRoleColorsWhite().keys.toSet();
      expect(white.length, 234);
      for (final roles in [
        carbonRoleColorsG10(),
        carbonRoleColorsG90(),
        carbonRoleColorsG100(),
      ]) {
        expect(roles.keys.toSet(), white);
      }
    });

    test('background/text roles resolve per theme', () {
      expect(colorOf(CarbonTheme.white, CarbonTokens.background),
          const Color(0xFFFFFFFF));
      expect(colorOf(CarbonTheme.g100, CarbonTokens.background),
          const Color(0xFF161616));
      expect(colorOf(CarbonTheme.white, CarbonTokens.textPrimary),
          const Color(0xFF161616));
      expect(colorOf(CarbonTheme.g100, CarbonTokens.textPrimary),
          const Color(0xFFF4F4F4));
    });

    test('spacing, type, motion and weight tokens resolve', () {
      final map = buildCarbonTokenMap(CarbonTheme.white);
      expect(map[CarbonTokens.spacing01], 2.0);
      expect(map[CarbonTokens.spacing05], 16.0);
      expect(map[CarbonTokens.spacing13], 160.0);
      expect((map[CarbonTokens.body01]! as TextStyle).fontSize, 14.0);
      expect(map[CarbonTokens.durationFast01],
          const Duration(milliseconds: 70));
      expect(map[CarbonTokens.fontWeightRegular], FontWeight.w400);
    });

    test('typed overrides win without mutating generated maps', () {
      const override = Color(0xFF00FF00);
      final map = buildCarbonTokenMap(
        CarbonTheme.white,
        overrides: CarbonThemeOverrides(
          colors: {CarbonTokens.background: override},
        ),
      );
      expect(map[CarbonTokens.background], override);
      // Generated map is unchanged.
      expect(carbonRoleColorsWhite()[CarbonTokens.background],
          const Color(0xFFFFFFFF));
    });
  });

  group('Component tokens', () {
    test('button primary resolves', () {
      expect(carbonComponentColorsWhite()[CarbonComponentTokens.buttonPrimary],
          const Color(0xFF0F62FE));
    });

    test('partial-theme tokens are omitted, not fabricated', () {
      // notificationActionHover exists only for white + g10 upstream.
      expect(
        carbonComponentColorsWhite()
            .containsKey(CarbonComponentTokens.notificationActionHover),
        isTrue,
      );
      expect(
        carbonComponentColorsG100()
            .containsKey(CarbonComponentTokens.notificationActionHover),
        isFalse,
      );
    });

    test('component groups cover all 78 tokens', () {
      final grouped = carbonComponentTokenGroups.values
          .expand((tokens) => tokens)
          .toSet();
      expect(grouped.length, 78);
    });
  });
}
