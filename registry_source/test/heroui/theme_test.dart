import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';
import 'package:registry_source/src/heroui/theme/color.dart';
import 'package:remix/remix.dart';

import '../helpers/heroui.dart';

const _brand = ColorToken('app.brand');

class _BrandedTheme extends HeroUiThemeData {
  const _BrandedTheme(this.brandColor) : super.light();

  final Color brandColor;

  @override
  Color color(ColorToken token) =>
      token == _brand ? brandColor : super.color(token);

  @override
  bool operator ==(Object other) =>
      other is _BrandedTheme &&
      super == other &&
      brandColor == other.brandColor;

  @override
  int get hashCode => Object.hash(super.hashCode, brandColor);
}

/// Browser-resolved colors from the pinned HeroUI CSS, by variable name.
Map<String, dynamic> _upstreamColors(String mode) {
  final tokens =
      jsonDecode(
            File(
              'reference/heroui_3_2_6/chromium/tokens.json',
            ).readAsStringSync(),
          )
          as Map<String, dynamic>;
  return {
    for (final entry in (tokens[mode] as Map<String, dynamic>).entries)
      if ((entry.value as Map).containsKey('rgbaFloat')) entry.key: entry.value,
  };
}

/// The color variables the token inventory declares.
Set<String> _inventoryColors() {
  final inventory =
      jsonDecode(File('specs/heroui/tokens.json').readAsStringSync())
          as Map<String, dynamic>;
  return {
    for (final entry in (inventory['tokens'] as Map<String, dynamic>).entries)
      if ((entry.value as Map)['runtime'] == 'color') entry.key,
  };
}

Color _composite(Color color, Color background) =>
    Color.alphaBlend(color, background);

void main() {
  for (final mode in ['light', 'dark']) {
    test('$mode colors match the browser-resolved upstream values', () {
      final theme = mode == 'light'
          ? const HeroUiThemeData.light()
          : const HeroUiThemeData.dark();
      final tokens = theme.tokens;
      final upstream = _upstreamColors(mode);
      final names = _inventoryColors();
      expect(upstream.keys.toSet(), containsAll(names));

      for (final name in names) {
        final actual = tokens[ColorToken('heroUi.color.$name')]! as Color;
        final rgba = (upstream[name]['rgbaFloat'] as List).cast<num>();
        final expected = Color.from(
          alpha: rgba[3].toDouble(),
          red: rgba[0].toDouble(),
          green: rgba[1].toDouble(),
          blue: rgba[2].toDouble(),
        );
        // Canvas readback is 8-bit; translucent channels are compared after
        // compositing, where readback noise is bounded.
        expect(actual.a, closeTo(expected.a, 1 / 255), reason: name);
        for (final background in const [Color(0xFFFFFFFF), Color(0xFF000000)]) {
          final a = _composite(actual, background);
          final e = _composite(expected, background);
          for (final (channel, x, y) in [
            ('r', a.r, e.r),
            ('g', a.g, e.g),
            ('b', a.b, e.b),
          ]) {
            expect(x, closeTo(y, 1.5 / 255), reason: '$name.$channel');
          }
        }
      }
    });
  }

  test('measured browser colors decode to the theme tokens', () {
    for (final mode in ['light', 'dark']) {
      for (final (id, style, token) in [
        ('button-primary-md', 'backgroundColor', HeroUiTokens.accent),
        ('button-primary-md', 'color', HeroUiTokens.accentForeground),
        ('button-danger-md', 'backgroundColor', HeroUiTokens.danger),
        ('close-button', 'backgroundColor', HeroUiTokens.defaultColor),
        ('close-button', 'color', HeroUiTokens.muted),
        ('card-default', 'backgroundColor', HeroUiTokens.surface),
      ]) {
        expectCssColor(
          heroUiToken(token, mode),
          heroUiCase(id, mode: mode).styles[style]!,
          reason: '$id $style in $mode',
        );
      }
    }
  });

  test('color-mix uses OKLab with premultiplied transparency', () {
    const red = Color(0xFFFF0000);
    const blue = Color(0xFF0000FF);
    // Chrome: color-mix(in oklab, red 50%, blue).
    final mix = heroUiMixOklab(red, blue, .5, .5);
    expect(mix.r, closeTo(.550441, .00001));
    expect(mix.g, closeTo(.325621, .00001));
    expect(mix.b, closeTo(.636501, .00001));
    // Weights below 100% scale alpha, as in CSS.
    expect(heroUiMixOklab(red, blue, .9, .02).a, closeTo(.92, .000001));
  });

  test('overriding a color recomputes the colors derived from it', () {
    const accent = Color(0xFF8000FF);
    final theme = const HeroUiThemeData.light().copyWith(
      colors: {HeroUiTokens.accent: accent},
    );
    expect(
      theme.color(HeroUiTokens.accentHover),
      heroUiMixOklab(
        accent,
        theme.color(HeroUiTokens.accentForeground),
        .9,
        .1,
      ),
    );
    final soft = theme.color(HeroUiTokens.accentSoft);
    expect(soft.a, closeTo(.15, .000001));
    expect(soft.r, closeTo(accent.r, .000001));
    expect(
      theme.color(HeroUiTokens.focus),
      accent,
      reason: '--focus is var(--accent)',
    );
  });

  test('the radius scale derives from --radius; panel radius caps at 32', () {
    final theme = const HeroUiThemeData.light().copyWith(radius: 10);
    expect(theme.tokens[HeroUiTokens.radiusLg], const Radius.circular(10));
    expect(theme.tokens[HeroUiTokens.radiusField], const Radius.circular(15));
    expect(theme.tokens[HeroUiTokens.radiusPanel], const Radius.circular(30));
    expect(
      theme.copyWith(radius: 100).tokens[HeroUiTokens.radiusPanel],
      const Radius.circular(32),
    );
  });

  test('theme data has value equality and immutable tokens', () {
    const theme = HeroUiThemeData.dark();
    expect(theme.copyWith(), theme);
    expect(theme.copyWith().hashCode, theme.hashCode);
    expect(
      theme.copyWith(colors: {HeroUiTokens.accent: const Color(0xFF00FF00)}),
      isNot(theme),
    );
    expect(() => theme.tokens.clear(), throwsUnsupportedError);
    expect(
      () => theme.color(const ColorToken('heroUi.color.unknown')),
      throwsArgumentError,
    );
  });

  test('legacy constructors retain their const colors argument', () {
    const themes = [
      HeroUiThemeData(brightness: Brightness.light, colors: {}),
      HeroUiThemeData.light(colors: {}),
      HeroUiThemeData.dark(colors: {}),
    ];
    for (final theme in themes) {
      expect(theme.colors, isEmpty);
    }
  });

  for (final updatesInactiveDark in [false, true]) {
    testWidgets(
      updatesInactiveDark
          ? 'an inactive dark theme update reaches a nested dark scope'
          : 'an active theme update reaches its dependents',
      (tester) async {
        const originalAccent = Color(0xFF8000FF);
        const updatedAccent = Color(0xFF00FF00);
        final colors = {HeroUiTokens.accent: originalAccent};
        final theme = updatesInactiveDark
            ? HeroUiThemeData.dark(colors: colors)
            : HeroUiThemeData.light(colors: colors);
        final seenAccents = <Color>[];
        final dependent = Builder(
          builder: (context) {
            seenAccents.add(HeroUiTheme.of(context).color(HeroUiTokens.accent));
            return const SizedBox();
          },
        );
        final child = updatesInactiveDark
            ? HeroUiTheme(mode: HeroUiThemeMode.dark, child: dependent)
            : dependent;

        Future<void> pumpTheme() => tester.pumpWidget(
          HeroUiTheme(
            mode: HeroUiThemeMode.light,
            theme: updatesInactiveDark ? null : theme,
            darkTheme: updatesInactiveDark ? theme : null,
            child: child,
          ),
        );

        await pumpTheme();
        expect(seenAccents, [originalAccent]);

        await pumpTheme();
        expect(seenAccents, [originalAccent]);

        theme.colors[HeroUiTokens.accent] = updatedAccent;
        expect(colors[HeroUiTokens.accent], updatedAccent);
        await pumpTheme();
        expect(seenAccents, [originalAccent, updatedAccent]);
      },
    );
  }

  testWidgets('replacing a value-equal map key does not notify dependents', (
    tester,
  ) async {
    const accent = HeroUiTokens.accent;
    const color = Color(0xFF8000FF);
    var builds = 0;
    final child = Builder(
      builder: (context) {
        expect(HeroUiTheme.of(context).color(accent), color);
        builds++;
        return const SizedBox();
      },
    );
    final colors = {accent: color};
    final theme = HeroUiThemeData.light(colors: colors);

    await tester.pumpWidget(HeroUiTheme(theme: theme, child: child));
    expect(builds, 1);

    colors[ColorToken(accent.name)] = colors.remove(accent)!;
    await tester.pumpWidget(HeroUiTheme(theme: theme, child: child));
    expect(builds, 1);
  });

  testWidgets('subclass equality determines whether a theme change notifies', (
    tester,
  ) async {
    const original = Color(0xFF8000FF);
    const updated = Color(0xFF00FF00);
    final seenColors = <Color>[];
    final child = Builder(
      builder: (context) {
        seenColors.add(HeroUiTheme.of(context).color(_brand));
        return const SizedBox();
      },
    );

    Future<void> pumpTheme(HeroUiThemeData theme) =>
        tester.pumpWidget(HeroUiTheme(theme: theme, child: child));

    await pumpTheme(const _BrandedTheme(original));
    expect(seenColors, [original]);
    await pumpTheme(_BrandedTheme(original));
    expect(seenColors, [original]);
    await pumpTheme(const _BrandedTheme(updated));
    expect(seenColors, [original, updated]);
  });

  testWidgets('of throws without a scope; maybeOf returns null', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      Builder(
        builder: (c) {
          context = c;
          return const SizedBox();
        },
      ),
    );
    expect(HeroUiTheme.maybeOf(context), isNull);
    expect(() => HeroUiTheme.of(context), throwsFlutterError);
  });

  testWidgets('mode selects between the light and dark themes', (tester) async {
    for (final (mode, brightness) in [
      ('light', Brightness.light),
      ('dark', Brightness.dark),
    ]) {
      late HeroUiThemeData data;
      await tester.pumpHeroUi(
        Builder(
          builder: (context) {
            data = HeroUiTheme.of(context);
            return const SizedBox();
          },
        ),
        mode: mode,
      );
      expect(data.brightness, brightness);
    }

    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    late HeroUiThemeData system;
    await tester.pumpHeroUi(
      Builder(
        builder: (context) {
          system = HeroUiTheme.of(context);
          return const SizedBox();
        },
      ),
      mode: 'system',
    );
    expect(system.brightness, Brightness.dark);
  });

  testWidgets('the root scope paints the background and sets the text run', (
    tester,
  ) async {
    await tester.pumpHeroUi(const Text('Body'), mode: 'dark');
    const dark = HeroUiThemeData.dark();
    final box = tester.widget<ColoredBox>(find.byType(ColoredBox).first);
    expect(box.color, dark.tokens[HeroUiTokens.background]);
    final style = tester.widget<RichText>(find.byType(RichText)).text.style!;
    expect(style.color, dark.tokens[HeroUiTokens.foreground]);
    expect(style.fontSize, 16);
  });

  testWidgets('a nested scope carries its tokens into the root overlay', (
    tester,
  ) async {
    const green = Color(0xFF00FF00);
    late Color fromOverlay;
    await tester.pumpHeroUi(
      HeroUiTheme(
        theme: const HeroUiThemeData.light().copyWith(
          colors: {HeroUiTokens.accent: green},
        ),
        child: Builder(
          builder: (context) => GestureDetector(
            onTap: () {
              final themes = InheritedTheme.capture(from: context, to: null);
              Overlay.of(context, rootOverlay: true).insert(
                OverlayEntry(
                  builder: (_) => themes.wrap(
                    Builder(
                      builder: (context) {
                        fromOverlay = MixScope.tokenOf(
                          HeroUiTokens.accent,
                          context,
                        );
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pump();
    expect(fromOverlay, green);
  });

  testWidgets(
    'the scope rebuilds for brightness, not other MediaQuery fields',
    (tester) async {
      var scopeBuilds = 0;
      debugOnRebuildDirtyWidget = (element, _) {
        if (element.widget is HeroUiTheme) scopeBuilds++;
      };
      addTearDown(() => debugOnRebuildDirtyWidget = null);
      const scope = HeroUiTheme(child: SizedBox());
      Widget host(MediaQueryData data) => MediaQuery(
        data: data,
        child: const Directionality(textDirection: .ltr, child: scope),
      );

      await tester.pumpWidget(host(const MediaQueryData()));
      scopeBuilds = 0;
      await tester.pumpWidget(
        host(const MediaQueryData(viewInsets: EdgeInsets.only(bottom: 300))),
      );
      expect(scopeBuilds, 0, reason: 'keyboard insets');

      await tester.pumpWidget(
        host(const MediaQueryData(platformBrightness: .dark)),
      );
      expect(scopeBuilds, 1, reason: 'system mode follows brightness');
    },
  );
}
