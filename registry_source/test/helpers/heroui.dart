import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/heroui.dart';
import 'package:remix/remix.dart';

/// A color of the default light or dark theme; [mode] is `light` or `dark`.
Color heroUiToken(ColorToken token, [String mode = 'light']) =>
    (_theme(mode).tokens[token]! as Color);

HeroUiThemeData _theme(String mode) => mode == 'light'
    ? const HeroUiThemeData.light()
    : const HeroUiThemeData.dark();

/// Runs a widget test on desktop only, where Naked controls react to hover.
final desktopOnly = TargetPlatformVariant.only(TargetPlatform.macOS);

extension HeroUiTester on WidgetTester {
  /// Pumps [widget] in a `WidgetsApp` whose builder installs [HeroUiTheme], the
  /// placement `HeroUiTheme` documents. [mode] is `light`, `dark`, or
  /// `system`; a [theme] replaces the default theme for both.
  Future<void> pumpHeroUi(
    Widget widget, {
    String mode = 'light',
    double width = 1024,
    HeroUiThemeData? theme,
  }) async {
    view
      ..physicalSize = Size(width, 768)
      ..devicePixelRatio = 1;
    addTearDown(view.reset);
    // `home` is built once per route; a fresh app per pump shows [widget].
    await pumpWidget(
      WidgetsApp(
        key: UniqueKey(),
        color: const Color(0xFFFFFFFF),
        pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        ),
        builder: (context, navigator) => HeroUiTheme(
          theme: theme,
          mode: HeroUiThemeMode.values.byName(mode),
          child: navigator!,
        ),
        home: Center(child: widget),
      ),
    );
  }

  /// The resolved Mix spec provided below [finder].
  S resolvedSpecOf<S extends Spec<S>>(Finder finder) {
    final provider = element(
      finder,
    ).getInheritedWidgetOfExactType<StyleSpecProvider<S>>();
    expect(provider, isNotNull, reason: 'No StyleSpecProvider<$S> found');
    return provider!.spec.spec;
  }

  /// Moves a mouse to the center of [finder] and settles. The pointer is
  /// removed when the test ends; the caller may move or remove it sooner.
  Future<TestGesture> hoverCenter(Finder finder) async {
    final mouse = await createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(getCenter(finder));
    await pumpAndSettle();
    return mouse;
  }

  /// Presses the center of [finder] and holds it: the press registers after
  /// `kPressTimeout`, then the style animates. Release with `gesture.up()`.
  Future<TestGesture> pressCenter(
    Finder finder, {
    PointerDeviceKind kind = PointerDeviceKind.touch,
  }) async {
    final press = await startGesture(getCenter(finder), kind: kind);
    await pump(kPressTimeout);
    await pump(const Duration(milliseconds: 400));
    return press;
  }

  /// Moves keyboard focus to the next control, as the Tab key does.
  Future<void> focusWithTab() async {
    await sendKeyEvent(LogicalKeyboardKey.tab);
    await pumpAndSettle();
  }

  /// The product of every `Opacity` above [of].
  double opacityAbove(Finder of) => widgetList<Opacity>(
    find.ancestor(of: of, matching: find.byType(Opacity)),
  ).fold(1.0, (product, widget) => product * widget.opacity);
}

final _measurements =
    jsonDecode(
          File('reference/heroui_3_2_6/measurements.json').readAsStringSync(),
        )
        as Map<String, dynamic>;

/// One upstream measurement from HeroUI 3.2.6 in Chromium.
///
/// Expected values in recipe tests come from here, never from the recipes.
class HeroUiCase {
  HeroUiCase._(this.id, Map<String, dynamic> json)
    : rect = Rect.fromLTWH(
        (json['rect']['x'] as num?)?.toDouble() ?? 0,
        (json['rect']['y'] as num?)?.toDouble() ?? 0,
        (json['rect']['width'] as num).toDouble(),
        (json['rect']['height'] as num).toDouble(),
      ),
      styles = {
        for (final entry
            in ((json['styles'] as Map<String, dynamic>?) ?? {}).entries)
          entry.key: entry.value as String,
      };

  final String id;

  /// The measured box. `x` and `y` are kept for modal, toast, and tooltip
  /// only: viewport coordinates for the first two, an offset from the
  /// trigger's corner for the tooltip; zero elsewhere.
  final Rect rect;
  final Map<String, String> styles;

  Size get size => rect.size;

  /// A pixel style such as `fontSize`; CSS initial values were omitted, so a
  /// missing key is 0.
  double px(String key) =>
      double.parse((styles[key] ?? '0px').replaceAll('px', ''));

  /// The browser-resolved color style [key], such as `backgroundColor`.
  Color color(String key) => cssColor(styles[key]!);
}

/// The case [id] in [mode] at [width]. Viewport 375 lists only cases that
/// differ from 1024; [state] reads the hover/pressed/focus captures.
HeroUiCase heroUiCase(
  String id, {
  String mode = 'light',
  int width = 1024,
  bool state = false,
}) {
  final groups = _measurements['modes'][mode] as Map<String, dynamic>;
  final json = state
      ? groups['states'][id]
      : (width == 375 ? groups['375'][id] : null) ?? groups['1024'][id];
  if (json == null) throw ArgumentError.value(id, 'id', 'No upstream case');
  return HeroUiCase._(id, json as Map<String, dynamic>);
}

/// The box half of a flex container spec, where Mix keeps decoration and size.
extension FlexBoxSpecBox on FlexBoxSpec {
  BoxSpec get boxSpec => box!.spec;
}

/// The fill of a box spec.
Color? boxFill(StyleSpec<BoxSpec> box) =>
    (box.spec.decoration as BoxDecoration?)?.color;

/// A browser-resolved CSS color: `rgb(a)`, `oklch(L C h [/ a])`,
/// `oklab(L a b [/ a])`, or `color(srgb r g b [/ a])`.
Color cssColor(String css) {
  final match = RegExp(r'^(\w+)\((.*)\)$').firstMatch(css.trim());
  if (match == null) throw FormatException('Not a CSS color', css);
  final parts = match[2]!.split('/');
  final alpha = parts.length > 1 ? double.parse(parts[1].trim()) : null;
  final values = parts[0]
      .replaceAll(',', ' ')
      .replaceFirst(RegExp(r'^srgb\s+'), '')
      .trim()
      .split(RegExp(r'\s+'));
  final numbers = [
    for (final value in values)
      double.tryParse(value.replaceAll('deg', '')) ?? 0,
  ];
  switch (match[1]) {
    case 'rgb' || 'rgba':
      return Color.from(
        alpha: alpha ?? (numbers.length > 3 ? numbers[3] : 1),
        red: numbers[0] / 255,
        green: numbers[1] / 255,
        blue: numbers[2] / 255,
      );
    case 'color':
      return Color.from(
        alpha: alpha ?? 1,
        red: numbers[0],
        green: numbers[1],
        blue: numbers[2],
      );
    case 'oklch':
      final hue = numbers[2] * math.pi / 180;
      return _oklab(
        numbers[0],
        numbers[1] * math.cos(hue),
        numbers[1] * math.sin(hue),
        alpha ?? 1,
      );
    case 'oklab':
      return _oklab(numbers[0], numbers[1], numbers[2], alpha ?? 1);
  }
  throw FormatException('Unsupported CSS color', css);
}

Color _oklab(double l, double a, double b, double alpha) {
  final lp = math.pow(l + .3963377774 * a + .2158037573 * b, 3).toDouble();
  final mp = math.pow(l - .1055613458 * a - .0638541728 * b, 3).toDouble();
  final sp = math.pow(l - .0894841775 * a - 1.291485548 * b, 3).toDouble();
  double encode(double x) =>
      (x <= .0031308 ? 12.92 * x : 1.055 * math.pow(x, 1 / 2.4) - .055)
          .clamp(0.0, 1.0)
          .toDouble();
  return Color.from(
    alpha: alpha,
    red: encode(4.0767416621 * lp - 3.3077115913 * mp + .2309699292 * sp),
    green: encode(-1.2684380046 * lp + 2.6097574011 * mp - .3413193965 * sp),
    blue: encode(-.0041960863 * lp - .7034186147 * mp + 1.707614701 * sp),
  );
}

/// Expects [actual] to be [expected] within 8-bit readback noise.
void expectColorNear(Color actual, Color expected, {String? reason}) {
  const tolerance = 1.5 / 255;
  expect(actual.a, closeTo(expected.a, tolerance), reason: '$reason alpha');
  expect(actual.r, closeTo(expected.r, tolerance), reason: '$reason red');
  expect(actual.g, closeTo(expected.g, tolerance), reason: '$reason green');
  expect(actual.b, closeTo(expected.b, tolerance), reason: '$reason blue');
}

/// Expects [actual] to be the browser color [css], within 8-bit readback noise.
void expectCssColor(Color actual, String css, {String? reason}) =>
    expectColorNear(actual, cssColor(css), reason: '$reason ($css)');

/// Expects [actual] to be the case's `backgroundColor`; upstream omits the
/// property when the fill is transparent.
void expectFill(Color? actual, HeroUiCase upstream, {String? reason}) {
  final css = upstream.styles['backgroundColor'];
  if (css == null) {
    expect(actual, HeroUiTokens.transparent, reason: reason);
  } else {
    expectCssColor(actual!, css, reason: reason);
  }
}

/// Expects the recipe's focus ring to match a measured one: `focus-ring` is
/// two solid spreads, a background gap then the 2px ring beyond it, drawn as
/// an outline offset by the gap with a background-coloured shadow under it.
///
/// An [inset] ring is `ring-inset`: the measured ring's width drawn inside the
/// part, at offset minus that width, with no background gap.
void expectFocusRing(
  RemixBoxEffectsSpec? effects,
  HeroUiCase measured, {
  bool inset = false,
}) {
  final [gap, ring] = [
    for (final shadow in cssRemixShadows(measured.styles['boxShadow']!))
      if (shadow.blurRadius == 0 && shadow.spreadRadius > 0) shadow,
  ];
  final width = ring.spreadRadius - gap.spreadRadius;
  expect(effects, isNotNull, reason: measured.id);
  expect(effects!.outline.width, width, reason: measured.id);
  expect(
    effects.outlineOffset,
    inset ? -width : gap.spreadRadius,
    reason: measured.id,
  );
  expectColorNear(effects.outline.color, ring.color, reason: 'ring');
  final over = effects.overContent?.shadows ?? const [];
  if (inset) {
    expect(over, isEmpty, reason: measured.id);
    return;
  }
  expect(over, hasLength(1), reason: measured.id);
  expect(over.single.spreadRadius, gap.spreadRadius, reason: measured.id);
  expectColorNear(over.single.color, gap.color, reason: 'gap');
}

/// The alpha of a CSS color such as `oklab(... / 0.8)`.
double cssAlpha(String css) => cssColor(css).a;

/// The visible layers of a computed CSS `box-shadow` as Remix shadows,
/// including a trailing `inset`.
List<RemixBoxShadow> cssRemixShadows(String value) => [
  for (final match in RegExp(
    r'(rgba?\([\d., ]+\)|oklch\([^)]*\)|oklab\([^)]*\)) '
    r'(-?[\d.]+)px (-?[\d.]+)px ([\d.]+)px (-?[\d.]+)px( inset)?',
  ).allMatches(value))
    if (cssColor(match[1]!).a > 0)
      RemixBoxShadow(
        kind: match[6] == null
            ? RemixBoxShadowKind.outer
            : RemixBoxShadowKind.inset,
        color: cssColor(match[1]!),
        offset: Offset(double.parse(match[2]!), double.parse(match[3]!)),
        blurRadius: double.parse(match[4]!),
        spreadRadius: double.parse(match[5]!),
      ),
];

/// The visible outer layers of a computed CSS `box-shadow` as Flutter shadows.
List<BoxShadow> cssShadows(String value) => [
  for (final shadow in cssRemixShadows(value))
    if (shadow.kind == RemixBoxShadowKind.outer)
      BoxShadow(
        color: shadow.color,
        offset: shadow.offset,
        blurRadius: shadow.blurRadius,
        spreadRadius: shadow.spreadRadius,
      ),
];

/// `--overlay-shadow` as measured on the open popover; popover, dropdown,
/// tooltip, modal, and toast all use it.
List<RemixBoxShadow> upstreamOverlayShadow(String mode) => cssRemixShadows(
  heroUiCase('popover-open', mode: mode, state: true).styles['boxShadow']!,
);

/// `--surface-shadow` as measured on the primary tab indicator; empty in dark.
List<RemixBoxShadow> upstreamSurfaceShadow(String mode) => cssRemixShadows(
  heroUiCase(
        'tabs-primary-rest-tabs-indicator',
        mode: mode,
      ).styles['boxShadow'] ??
      '',
);

/// The shadows painted behind the content of [effects].
List<RemixBoxShadow> behindShadows(RemixBoxEffectsSpec? effects) =>
    effects?.behindContent?.shadows ?? const [];

/// Expects Remix shadows to equal Flutter shadows layer by layer.
void expectShadows(List<RemixBoxShadow> actual, List<BoxShadow> expected) {
  expect(actual.length, expected.length);
  for (var i = 0; i < expected.length; i++) {
    expect(actual[i].color, expected[i].color, reason: 'color $i');
    expect(actual[i].offset, expected[i].offset, reason: 'offset $i');
    expect(actual[i].blurRadius, expected[i].blurRadius, reason: 'blur $i');
    expect(
      actual[i].spreadRadius,
      expected[i].spreadRadius,
      reason: 'spread $i',
    );
  }
}
