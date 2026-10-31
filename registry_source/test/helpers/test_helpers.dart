import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/fortal.dart';

/// Fortal's counterpart to `packages/remix/test/helpers/test_helpers.dart`.
///
/// Dart `package:` imports only reach `lib/`, so test helpers cannot be shared
/// across packages. This copy differs in exactly one way that matters: it wraps
/// every pump in [FortalTheme], because Fortal recipes resolve Fortal tokens.
extension WidgetTesterHelpers on WidgetTester {
  /// Pumps a Fortal widget in a `WidgetsApp` test harness with a `Navigator`
  /// and `Overlay`.
  ///
  /// Host-contract tests that verify minimal host requirements should provide
  /// only the capability under test, such as `Overlay.wrap` or a caller-owned
  /// `Navigator`.
  Future<void> pumpRemixApp(
    Widget widget, {
    TextDirection textDirection = TextDirection.ltr,
    FortalAccentColor? accent,
    FortalColorTheme? accentPalette,
    FortalThemeConfig? theme,
    FortalThemeConfig? darkTheme,
    FortalThemeMode? mode,
  }) async {
    await pumpWidget(
      FortalTheme(
        accent: accent,
        accentPalette: accentPalette,
        theme: theme,
        darkTheme: darkTheme,
        mode: mode,
        child: WidgetsApp(
          color: const Color(0xFFFFFFFF),
          pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (context, _, _) => builder(context),
          ),
          home: Directionality(
            textDirection: textDirection,
            child: Center(child: widget),
          ),
        ),
      ),
    );
  }

  /// Returns the resolved Mix spec for [finder].
  S resolvedSpecOf<S extends Spec<S>>(Finder finder) {
    final context = element(finder);
    final provider = context
        .getInheritedWidgetOfExactType<StyleSpecProvider<S>>();
    expect(provider, isNotNull, reason: 'No StyleSpecProvider<$S> found');
    return provider!.spec.spec;
  }
}

/// Resolves a value inside [FortalTheme], optionally selecting appearance,
/// theme configuration, and widget states. Defaults retain the neutral preset.
Future<T> resolveInFortalTheme<T>(
  WidgetTester tester,
  T Function(BuildContext context) resolve, {
  FortalAccentColor? accent,
  FortalColorTheme? accentPalette,
  FortalThemeConfig? theme,
  FortalThemeConfig? darkTheme,
  FortalThemeMode? mode,
  Set<WidgetState> states = const {},
}) async {
  late T result;
  await tester.pumpRemixApp(
    WidgetStateProvider(
      states: states,
      child: Builder(
        builder: (context) {
          result = resolve(context);
          return const SizedBox.shrink();
        },
      ),
    ),
    accent: accent,
    accentPalette: accentPalette,
    theme: theme,
    darkTheme: darkTheme,
    mode: mode,
  );

  return result;
}
