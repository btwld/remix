import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'theme_data.dart';
import 'tokens.dart';

/// Establishes a courtesy default text run for bare [Text] descendants.
///
/// `.radix-themes` is not only a token carrier upstream: `color.css` sets
/// `color: var(--gray-12)` in the same rule as the `data-has-background` fill,
/// and `typography.css` pins the root to `--default-font-size`
/// (`--font-size-3`), `--default-line-height`, `--default-letter-spacing`, and
/// `--default-font-weight`. Those resolve to exactly [UiTokens.text3] plus
/// [UiTokens.gray12] at regular weight.
///
/// Ui text recipes resolve and pin their own runs. This fallback keeps
/// deliberately bare [Text] descendants aligned with Radix's root typography
/// and neutral foreground. A nearer descendant `DefaultTextStyle` still wins
/// through Flutter's normal inheritance.
///
/// Only the outermost [UiTheme] installs this. A nested scope re-scopes
/// tokens for its subtree and nothing more: upstream, `.radix-themes` inside
/// another `.radix-themes` still inherits `color` and the font properties from
/// its parent chain, and a nested scope that reinstalled the root run here
/// would silently replace whatever `DefaultTextStyle` the subtree sits in.
///
/// The font family is deliberately left unset. Radix's `--default-font-family`
/// is the platform system stack, and a null family is Flutter's equivalent;
/// naming a concrete family here would pin every consumer to one typeface.
Widget _uiRootTextStyle({
  required Map<MixToken<Object?>, Object> tokens,
  required Widget child,
}) {
  final root = tokens[UiTokens.text3]! as TextStyle;
  final foreground = tokens[UiTokens.gray12]! as Color;

  return DefaultTextStyle(
    style: root.copyWith(
      color: foreground,
      fontWeight: tokens[UiTokens.fontWeightRegular]! as FontWeight,
    ),
    child: IconTheme.merge(
      data: IconThemeData(color: foreground),
      child: child,
    ),
  );
}

Widget _uiRecolored(Color foreground, Widget child) => DefaultTextStyle.merge(
  style: TextStyle(color: foreground),
  child: IconTheme.merge(
    data: IconThemeData(color: foreground),
    child: child,
  ),
);

/// Widget that provides Ui design tokens to its subtree via [MixScope].
///
/// Place [UiTheme] below the application host so its text defaults apply.
/// For a routed app, wrap the navigator in the host's builder. This also keeps
/// [UiTokens] available to routes and dialogs.
///
/// ```dart
/// WidgetsApp(
///   color: const Color(0xFFF8FAFC),
///   pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
///     settings: settings,
///     pageBuilder: (context, animation, secondaryAnimation) => builder(context),
///   ),
///   builder: (_, child) => UiTheme(child: child!),
///   home: const HomePage(),
/// )
/// ```
class UiTheme extends StatelessWidget {
  const UiTheme({
    super.key,
    this.theme,
    this.darkTheme,
    this.mode,
    this.accent,
    this.gray,
    this.panelBackground,
    this.radius,
    this.scaling,
    this.hasBackground,
    this.orderOfModifiers,
    required this.child,
  });

  /// Base appearance. Without either theme, the preset provides both defaults.
  /// If only [theme] is supplied, it is also the dark-mode fallback.
  final UiThemeConfig? theme;
  final UiThemeConfig? darkTheme;

  /// Omitted at a root follows the system; omitted below a scope inherits it.
  final UiThemeMode? mode;

  final UiAccentColor? accent;
  final UiGrayColor? gray;
  final UiPanelBackground? panelBackground;
  final UiRadius? radius;
  final UiScaling? scaling;
  final bool? hasBackground;
  final List<Type>? orderOfModifiers;
  final Widget child;

  /// Returns the closest resolved Ui theme.
  static UiThemeData of(BuildContext context) {
    final data = maybeOf(context);
    if (data != null) return data;
    throw FlutterError.fromParts([
      ErrorSummary('No UiTheme found.'),
      ErrorDescription(
        '${context.widget.runtimeType} tried to read the Ui theme, but no UiTheme was found above it.',
      ),
      context.describeElement('The context used was'),
    ]);
  }

  /// Returns the closest resolved Ui theme, if one is available.
  static UiThemeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_UiInheritedTheme>()?.data;

  @override
  Widget build(BuildContext context) {
    final view = View.maybeOf(context);
    if (MediaQuery.maybeOf(context) == null && view != null) {
      return MediaQuery.fromView(
        view: view,
        child: Builder(builder: _build),
      );
    }
    return _build(context);
  }

  Widget _build(BuildContext context) {
    final inherited = context
        .dependOnInheritedWidgetOfExactType<_UiInheritedTheme>();
    final parent = inherited?.data;
    final baseParent = inherited?.baseTheme ?? parent;
    final darkParent = inherited?.darkTheme ?? parent;
    UiThemeData resolve(
      UiThemeConfig? supplied,
      UiThemeData? ancestor,
      Brightness fallback,
    ) {
      final config = supplied ?? const UiThemeConfig();
      return _resolveUiTheme(
        UiThemeConfig(
          accent: accent ?? config.accent,
          gray: gray ?? config.gray,
          brightness: config.brightness ?? ancestor?.brightness ?? fallback,
          panelBackground: panelBackground ?? config.panelBackground,
          radius: radius ?? config.radius,
          scaling: scaling ?? config.scaling,
          hasBackground: hasBackground ?? config.hasBackground,
        ),
        parent: ancestor,
      );
    }

    final base = resolve(theme, baseParent, Brightness.light);
    final dark = darkTheme == null && theme != null
        ? base
        : resolve(darkTheme, darkParent, Brightness.dark);
    final useDark = mode == null && inherited != null
        ? inherited.usesDarkTheme
        : switch (mode ?? UiThemeMode.system) {
            UiThemeMode.light => false,
            UiThemeMode.dark => true,
            UiThemeMode.system =>
              (MediaQuery.maybePlatformBrightnessOf(context) ??
                      Brightness.light) ==
                  Brightness.dark,
          };
    final data = useDark ? dark : base;
    final tokens = buildUiScopeTokens(data);
    final foreground = tokens[UiTokens.gray12]! as Color;
    Widget scoped = child;
    if (parent == null) {
      scoped = _uiRootTextStyle(tokens: tokens, child: scoped);
    } else if (parent.brightness != data.brightness ||
        parent.gray != data.gray) {
      scoped = _uiRecolored(foreground, scoped);
    }
    Widget result = MixScope(
      tokens: tokens,
      orderOfModifiers: orderOfModifiers,
      // Theme-root identity, not `hasBackground`, decides who owns the text
      // run: a scope nested for its accent or scaling must leave the current
      // run alone, while a root scope with `hasBackground: false` still
      // establishes it.
      child: scoped,
    );
    if (data.hasBackground) {
      result = ColoredBox(
        color: tokens[UiTokens.colorBackground]! as Color,
        child: result,
      );
    }

    return _UiInheritedTheme(
      data: data,
      baseTheme: base,
      darkTheme: dark,
      useDarkTheme: useDark,
      orderOfModifiers: orderOfModifiers,
      child: result,
    );
  }
}

UiThemeData _resolveUiTheme(UiThemeConfig config, {UiThemeData? parent}) {
  final accent = config.accent ?? parent?.accent ?? UiAccentColor.indigo;

  return UiThemeData(
    accent: accent,
    gray: config.gray ?? parent?.gray ?? UiGrayColor.slate,
    brightness: config.brightness ?? parent?.brightness ?? Brightness.light,
    panelBackground:
        config.panelBackground ??
        parent?.panelBackground ??
        UiPanelBackground.translucent,
    radius: config.radius ?? parent?.radius ?? UiRadius.medium,
    scaling: config.scaling ?? parent?.scaling ?? UiScaling.percent100,
    hasBackground: config.hasBackground ?? parent == null,
  );
}

/// The inherited half of [UiTheme].
class _UiInheritedTheme extends InheritedTheme {
  const _UiInheritedTheme({
    required this.data,
    this.baseTheme,
    this.darkTheme,
    this.useDarkTheme,
    this.orderOfModifiers,
    required super.child,
  });

  final UiThemeData data;
  final UiThemeData? baseTheme;
  final UiThemeData? darkTheme;
  final bool? useDarkTheme;
  bool get usesDarkTheme => useDarkTheme ?? data.isDark;
  final List<Type>? orderOfModifiers;

  /// Rebuilds only the theme and its Mix tokens.
  ///
  /// The captured subtree's text run is *not* synthesized here.
  /// `DefaultTextStyle` is itself an [InheritedTheme], so
  /// `InheritedTheme.capture` already carries the actual nearest ambient run
  /// across to the new route; installing the Radix root run alongside it would
  /// overwrite that capture with a value the source context never had.
  @override
  Widget wrap(BuildContext context, Widget child) => _UiInheritedTheme(
    data: data,
    baseTheme: baseTheme,
    darkTheme: darkTheme,
    useDarkTheme: useDarkTheme,
    orderOfModifiers: orderOfModifiers,
    child: MixScope(
      tokens: buildUiScopeTokens(data),
      orderOfModifiers: orderOfModifiers,
      child: child,
    ),
  );

  @override
  bool updateShouldNotify(_UiInheritedTheme oldWidget) =>
      data != oldWidget.data ||
      baseTheme != oldWidget.baseTheme ||
      darkTheme != oldWidget.darkTheme ||
      useDarkTheme != oldWidget.useDarkTheme;
}
