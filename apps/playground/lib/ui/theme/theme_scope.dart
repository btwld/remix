import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'theme_data.dart';
import 'tokens.dart';

/// Installs a [PlaygroundThemeData] for a subtree.
///
/// Two things are installed together on purpose:
///
/// * [PlaygroundTheme], so application code can read the raw values through
///   [PlaygroundTheme.of];
/// * a `MixScope` carrying the same values keyed by `PlaygroundTokens`, so every Mix
///   styler resolved below this point sees them.
///
/// The outermost scope also sets the page up: it paints the theme's
/// `background` behind [child] and gives bare [Text] the theme's body run and
/// bare [Icon]s its `foreground`. A nested scope whose theme has a different
/// `foreground` recolors both for its subtree.
/// Place it below the application host so those defaults apply:
///
/// ```dart
/// WidgetsApp(
///   color: const Color(0xFFFFFFFF),
///   pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
///     settings: settings,
///     pageBuilder: (context, animation, secondaryAnimation) => builder(context),
///   ),
///   builder: (context, child) => PlaygroundThemeScope(child: child!),
///   home: const HomePage(),
/// )
/// ```
///
/// Each supplied theme replaces the values for its appearance. An empty nested
/// scope inherits the parent pair and selection; individual tokens do not merge.
class PlaygroundThemeScope extends StatelessWidget {
  /// A root follows the system and supplies both preset defaults.
  /// A custom theme without [darkTheme] is used in both modes.
  /// Nested scopes inherit the configured pair and active selection.
  const PlaygroundThemeScope({
    super.key,
    this.theme,
    this.darkTheme,
    this.mode,
    required this.child,
  });

  /// Values used for the light appearance, and for both when [darkTheme] is
  /// omitted.
  final PlaygroundThemeData? theme;

  /// Values used for the dark appearance.
  final PlaygroundThemeData? darkTheme;

  /// Appearance selection. A null mode inherits the ancestor's selection, or
  /// follows the system at the root.
  final PlaygroundThemeMode? mode;

  /// The subtree that resolves against the selected theme.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // `mode: system` needs a platform brightness. A scope mounted above any
    // MediaQuery still has to resolve, so supply one from the view.
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
        .dependOnInheritedWidgetOfExactType<PlaygroundTheme>();
    final base =
        theme ??
        inherited?.baseTheme ??
        inherited?.data ??
        const PlaygroundThemeData.light();
    final dark =
        darkTheme ??
        (theme != null
            ? theme!
            : inherited?.darkTheme ??
                  inherited?.data ??
                  const PlaygroundThemeData.dark());
    final useDark = mode == null && inherited != null
        ? inherited.usesDarkTheme
        : switch (mode ?? PlaygroundThemeMode.system) {
            PlaygroundThemeMode.light => false,
            PlaygroundThemeMode.dark => true,
            PlaygroundThemeMode.system =>
              (MediaQuery.maybePlatformBrightnessOf(context) ??
                      Brightness.light) ==
                  Brightness.dark,
          };
    final selected = useDark ? dark : base;
    final tokens = selected.tokens;
    Widget scoped = MixScope(tokens: tokens, child: child);
    // Only the outermost scope sets the page up. A nested scope must not
    // reinstall the root text run, which would silently replace whatever
    // `DefaultTextStyle` the subtree sits in, nor paint a second background
    // over a card or a panel. But a nested scope that switches to a theme with
    // a different `foreground` (a region shown in the other brightness, say)
    // recolors the run it inherits, so bare text and icons below it stay
    // readable on the surfaces its own recipes paint.
    if (inherited == null) {
      scoped = ColoredBox(
        color: selected.background,
        child: _rootTextStyle(tokens: tokens, child: scoped),
      );
    } else if (inherited.data.foreground != selected.foreground) {
      scoped = _recolored(selected.foreground, scoped);
    }

    return PlaygroundTheme(
      data: selected,
      baseTheme: base,
      darkTheme: dark,
      useDarkTheme: useDark,
      child: scoped,
    );
  }
}

/// The text run a bare [Text] below the root scope inherits.
///
/// The theme's font at `textSm`, in `foreground`, so a `Text` with no style of
/// its own reads as body copy in the theme's color in both brightnesses —
/// instead of inheriting whatever the host set up, which in a dark theme is
/// often dark text on a dark page.
///
/// Recipes still set their own sizes and colors; this is only the fallback,
/// and a nearer `DefaultTextStyle` wins through Flutter's normal inheritance.
/// Place the scope *below* a Material or Cupertino host (in its `builder`) so
/// the host's own text defaults do not sit between the two. A `Material`
/// below the scope (a `Scaffold`, a `Card`) sets its own text style from the
/// host's `ThemeData`, so give that `ThemeData` the scope's brightness.
///
/// A bare [Icon] takes `foreground` too, the color of the text beside it; its
/// size is left to the host.
Widget _rootTextStyle({
  required Map<MixToken<Object?>, Object> tokens,
  required Widget child,
}) {
  final body = tokens[PlaygroundTokens.textSm]! as TextStyle;
  final foreground = tokens[PlaygroundTokens.foreground]! as Color;

  return DefaultTextStyle(
    style: body.copyWith(color: foreground, fontWeight: FontWeight.w400),
    child: IconTheme.merge(
      data: IconThemeData(color: foreground),
      child: child,
    ),
  );
}

/// The inherited text run and icon theme, recolored to [foreground] and
/// otherwise untouched.
Widget _recolored(Color foreground, Widget child) => DefaultTextStyle.merge(
  style: TextStyle(color: foreground),
  child: IconTheme.merge(
    data: IconThemeData(color: foreground),
    child: child,
  ),
);

/// The inherited half of [PlaygroundThemeScope].
///
/// Prefer [PlaygroundThemeScope]; this is public because `PlaygroundTheme.of` is how widgets
/// read theme values that are not expressed as Mix styles, and because
/// `InheritedTheme.wrap` has to be able to rebuild it across a route
/// boundary.
class PlaygroundTheme extends InheritedTheme {
  /// Creates the inherited theme holding [data].
  const PlaygroundTheme({
    super.key,
    required this.data,
    this.baseTheme,
    this.darkTheme,
    this.useDarkTheme,
    required super.child,
  });

  /// The theme values available to [child].
  final PlaygroundThemeData data;

  /// The configured light values, carried so a nested scope can inherit them.
  final PlaygroundThemeData? baseTheme;

  /// The configured dark values, carried so a nested scope can inherit them.
  final PlaygroundThemeData? darkTheme;

  /// The active selection, carried so a nested scope can inherit it.
  final bool? useDarkTheme;

  /// Whether the dark half of the configured pair is currently selected.
  bool get usesDarkTheme => useDarkTheme ?? data.brightness == Brightness.dark;

  /// The closest [PlaygroundThemeData], or `null` when no scope is installed.
  static PlaygroundThemeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PlaygroundTheme>()?.data;

  /// The closest [PlaygroundThemeData].
  ///
  /// Throws when no [PlaygroundThemeScope] is installed above [context]; use
  /// [maybeOf] when absence is a valid state.
  static PlaygroundThemeData of(BuildContext context) {
    final data = maybeOf(context);
    if (data != null) return data;

    throw FlutterError.fromParts([
      ErrorSummary('No PlaygroundTheme found.'),
      ErrorDescription(
        '${context.widget.runtimeType} tried to read the UI theme, but no '
        'PlaygroundThemeScope was found above it.',
      ),
      context.describeElement('The context used was'),
    ]);
  }

  /// Rebuilds the theme *and* its Mix scope for a captured subtree.
  ///
  /// `InheritedTheme.capture` only carries `InheritedTheme`s across a route
  /// boundary. `MixScope` is a plain `InheritedModel`, so without rebuilding
  /// it here a captured subtree would keep the theme values and lose the
  /// token values that recipes actually resolve.
  @override
  Widget wrap(BuildContext context, Widget child) {
    return PlaygroundTheme(
      data: data,
      baseTheme: baseTheme,
      darkTheme: darkTheme,
      useDarkTheme: useDarkTheme,
      child: MixScope(tokens: data.tokens, child: child),
    );
  }

  @override
  bool updateShouldNotify(PlaygroundTheme oldWidget) =>
      data != oldWidget.data ||
      baseTheme != oldWidget.baseTheme ||
      darkTheme != oldWidget.darkTheme ||
      useDarkTheme != oldWidget.useDarkTheme;
}
