import 'package:registry_source/carbon.dart';
import 'package:registry_source/src/carbon/theme/generated/carbon_component_tokens.dart';
import 'package:registry_source/src/carbon/theme/generated/carbon_layout.dart';
import 'package:registry_source/src/carbon/theme/generated/carbon_themes.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  group('Source manifest', () {
    test('records the pinned Carbon baseline', () {
      expect(
        CarbideSourceManifest.carbonCommit,
        '188d23202ec1092322dee92cf0df9d9958224ae4',
      );
      expect(CarbideSourceManifest.license, 'Apache-2.0');
      expect(
        CarbideSourceManifest.packageVersions['@carbon/themes'],
        '11.79.0',
      );
    });

    test('inventory counts match the baseline', () {
      expect(CarbideSourceManifest.roleColorCount, 234);
      expect(CarbideSourceManifest.paletteColorCount, 246);
      expect(CarbideSourceManifest.componentTokenCount, 78);
    });
  });

  group('Fixed layout scale', () {
    test('breakpoints match Carbon widths and columns', () {
      final widths = {for (final b in carbideBreakpoints) b.name: b.width};
      expect(widths, {
        'sm': 320.0,
        'md': 672.0,
        'lg': 1056.0,
        'xlg': 1312.0,
        'max': 1584.0,
      });
      expect(carbideBreakpoints.firstWhere((b) => b.name == 'sm').columns, 4);
      expect(carbideBreakpoints.firstWhere((b) => b.name == 'lg').columns, 16);
    });

    test('control sizes span 24..80px and cover every CarbideSize', () {
      expect(carbideControlSizePx['xSmall'], 24);
      expect(carbideControlSizePx['xxLarge'], 80);
      // Guards the enum<->generated-map string bridge: an upstream key rename
      // must fail here, not at first widget build.
      for (final size in CarbideSize.values) {
        expect(size.height, isA<double>(), reason: 'size $size must resolve');
      }
    });
  });

  group('Theme role resolution', () {
    Color colorOf(CarbideTheme theme, ColorToken token) =>
        buildCarbideTokenMap(theme)[token]! as Color;

    test('all four themes expose the same 234 role names', () {
      final white = carbideRoleColorsWhite.keys.toSet();
      expect(white.length, 234);
      for (final roles in [
        carbideRoleColorsG10,
        carbideRoleColorsG90,
        carbideRoleColorsG100,
      ]) {
        expect(roles.keys.toSet(), white);
      }
    });

    test('background/text roles resolve per theme', () {
      expect(
        colorOf(CarbideTheme.white, CarbideTokens.background),
        const Color(0xFFFFFFFF),
      );
      expect(
        colorOf(CarbideTheme.g100, CarbideTokens.background),
        const Color(0xFF161616),
      );
      expect(
        colorOf(CarbideTheme.white, CarbideTokens.textPrimary),
        const Color(0xFF161616),
      );
      expect(
        colorOf(CarbideTheme.g100, CarbideTokens.textPrimary),
        const Color(0xFFF4F4F4),
      );
    });

    test('spacing, type, motion and weight tokens resolve', () {
      final map = buildCarbideTokenMap(CarbideTheme.white);
      expect(map[CarbideTokens.spacing01], 2.0);
      expect(map[CarbideTokens.spacing05], 16.0);
      expect(map[CarbideTokens.spacing13], 160.0);
      expect((map[CarbideTokens.body01]! as TextStyle).fontSize, 14.0);
      expect(
        map[CarbideTokens.durationFast01],
        const Duration(milliseconds: 70),
      );
      expect(map[CarbideTokens.fontWeightRegular], FontWeight.w400);
    });

    test('base maps are cached and unmodifiable', () {
      final a = buildCarbideTokenMap(CarbideTheme.g90);
      final b = buildCarbideTokenMap(CarbideTheme.g90);
      expect(
        identical(a, b),
        isTrue,
        reason: 'no-override builds must reuse the cached base map',
      );
      expect(
        () => a[CarbideTokens.background] = const Color(0x00000000),
        throwsUnsupportedError,
      );
    });

    test('typed overrides win without mutating generated maps', () {
      const override = Color(0xFF00FF00);
      final map = buildCarbideTokenMap(
        CarbideTheme.white,
        overrides: CarbideThemeOverrides(
          colors: {CarbideTokens.background: override},
        ),
      );
      expect(map[CarbideTokens.background], override);
      // Generated map is unchanged.
      expect(
        carbideRoleColorsWhite[CarbideTokens.background],
        const Color(0xFFFFFFFF),
      );
    });

    test('fontFamily override applies to every fixed text style', () {
      final map = buildCarbideTokenMap(
        CarbideTheme.white,
        overrides: const CarbideThemeOverrides(fontFamily: 'IBM Plex Sans'),
      );
      expect(
        (map[CarbideTokens.body01]! as TextStyle).fontFamily,
        'IBM Plex Sans',
      );
      expect(
        (map[CarbideTokens.heading07]! as TextStyle).fontFamily,
        'IBM Plex Sans',
      );
    });
  });

  group('Component tokens', () {
    test('button primary resolves', () {
      expect(
        carbideComponentColorsWhite[CarbideComponentTokens.buttonPrimary],
        const Color(0xFF0F62FE),
      );
    });

    test('partial-theme tokens are omitted, not fabricated', () {
      // notificationActionHover exists only for white + g10 upstream.
      expect(
        carbideComponentColorsWhite.containsKey(
          CarbideComponentTokens.notificationActionHover,
        ),
        isTrue,
      );
      expect(
        carbideComponentColorsG100.containsKey(
          CarbideComponentTokens.notificationActionHover,
        ),
        isFalse,
      );
    });
  });

  group('Indexed role families', () {
    test('CarbideContextualColor covers every generated family', () {
      // If a Carbon upgrade adds an indexed role family (e.g. layerBackground
      // appeared in v11), the alias enum must grow with it.
      final aliasNames = CarbideContextualColor.values
          .map((a) => a.name)
          .toSet();
      expect(aliasNames, carbideIndexedRoleFamilies.keys.toSet());
    });

    test('every alias resolves each of the three levels', () {
      for (final alias in CarbideContextualColor.values) {
        final family = carbideIndexedRoleFamilies[alias.name]!;
        for (var level = 1; level <= 3; level++) {
          expect(CarbideLayerData(level).color(alias), family[level - 1]);
        }
      }
    });
  });

  group('CarbideFontFamilies', () {
    test('exposes usable family names with separate fallbacks', () {
      expect(CarbideFontFamilies.sans, 'IBM Plex Sans');
      expect(CarbideFontFamilies.mono, 'IBM Plex Mono');
      expect(CarbideFontFamilies.sansFallback, contains('sans-serif'));
      // A family name must never be a raw CSS stack.
      expect(CarbideFontFamilies.sans.contains(','), isFalse);
    });
  });
}
