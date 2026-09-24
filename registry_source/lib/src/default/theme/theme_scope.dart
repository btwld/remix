import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'theme_data.dart';

/// Installs a [VanillaThemeData] for a subtree.
///
/// Two things are installed together on purpose:
///
/// * [VanillaTheme], so application code can read the raw values through
///   [VanillaTheme.of];
/// * a `MixScope` carrying the same values keyed by `VanillaTokens`, so every Mix
///   styler resolved below this point sees them.
///
/// Each supplied theme replaces the values for its appearance. An empty nested
/// scope inherits the parent pair and selection; individual tokens do not merge.
class VanillaThemeScope extends StatelessWidget {
  /// A root follows the system and supplies both preset defaults.
  /// A custom theme without [darkTheme] is used in both modes.
  /// Nested scopes inherit the configured pair and active selection.
  const VanillaThemeScope({
    super.key,
    this.theme,
    this.darkTheme,
    this.mode,
    required this.child,
  });

  /// Values used for the light appearance, and for both when [darkTheme] is
  /// omitted.
  final VanillaThemeData? theme;

  /// Values used for the dark appearance.
  final VanillaThemeData? darkTheme;

  /// Appearance selection. A null mode inherits the ancestor's selection, or
  /// follows the system at the root.
  final VanillaThemeMode? mode;

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
        .dependOnInheritedWidgetOfExactType<VanillaTheme>();
    final base =
        theme ??
        inherited?.baseTheme ??
        inherited?.data ??
        const VanillaThemeData.light();
    final dark =
        darkTheme ??
        (theme != null
            ? theme!
            : inherited?.darkTheme ??
                  inherited?.data ??
                  const VanillaThemeData.dark());
    final useDark = mode == null && inherited != null
        ? inherited.usesDarkTheme
        : switch (mode ?? VanillaThemeMode.system) {
            VanillaThemeMode.light => false,
            VanillaThemeMode.dark => true,
            VanillaThemeMode.system =>
              (MediaQuery.maybePlatformBrightnessOf(context) ??
                      Brightness.light) ==
                  Brightness.dark,
          };
    final selected = useDark ? dark : base;

    return VanillaTheme(
      data: selected,
      baseTheme: base,
      darkTheme: dark,
      useDarkTheme: useDark,
      child: MixScope(tokens: selected.tokens, child: child),
    );
  }
}

/// The inherited half of [VanillaThemeScope].
///
/// Prefer [VanillaThemeScope]; this is public because `VanillaTheme.of` is how widgets
/// read theme values that are not expressed as Mix styles, and because
/// `InheritedTheme.wrap` has to be able to rebuild it across a route
/// boundary.
class VanillaTheme extends InheritedTheme {
  /// Creates the inherited theme holding [data].
  const VanillaTheme({
    super.key,
    required this.data,
    this.baseTheme,
    this.darkTheme,
    this.useDarkTheme,
    required super.child,
  });

  /// The theme values available to [child].
  final VanillaThemeData data;

  /// The configured light values, carried so a nested scope can inherit them.
  final VanillaThemeData? baseTheme;

  /// The configured dark values, carried so a nested scope can inherit them.
  final VanillaThemeData? darkTheme;

  /// The active selection, carried so a nested scope can inherit it.
  final bool? useDarkTheme;

  /// Whether the dark half of the configured pair is currently selected.
  bool get usesDarkTheme => useDarkTheme ?? data.brightness == Brightness.dark;

  /// The closest [VanillaThemeData], or `null` when no scope is installed.
  static VanillaThemeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<VanillaTheme>()?.data;

  /// The closest [VanillaThemeData].
  ///
  /// Throws when no [VanillaThemeScope] is installed above [context]; use
  /// [maybeOf] when absence is a valid state.
  static VanillaThemeData of(BuildContext context) {
    final data = maybeOf(context);
    if (data != null) return data;

    throw FlutterError.fromParts([
      ErrorSummary('No VanillaTheme found.'),
      ErrorDescription(
        '${context.widget.runtimeType} tried to read the UI theme, but no '
        'VanillaThemeScope was found above it.',
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
    return VanillaTheme(
      data: data,
      baseTheme: baseTheme,
      darkTheme: darkTheme,
      useDarkTheme: useDarkTheme,
      child: MixScope(tokens: data.tokens, child: child),
    );
  }

  @override
  bool updateShouldNotify(VanillaTheme oldWidget) =>
      data != oldWidget.data ||
      baseTheme != oldWidget.baseTheme ||
      darkTheme != oldWidget.darkTheme ||
      useDarkTheme != oldWidget.useDarkTheme;
}
