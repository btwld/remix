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
  }) async {
    await pumpWidget(
      FortalTheme(
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

/// Resolves a value against a `BuildContext` inside a default [FortalTheme].
///
/// Use this for assertions on token or style resolution that need no scope
/// configuration. Suites that vary the accent, brightness, radius, or widget
/// states keep their own richer local resolver.
Future<T> resolveInFortalTheme<T>(
  WidgetTester tester,
  T Function(BuildContext context) resolve,
) async {
  late T result;
  await tester.pumpRemixApp(
    Builder(
      builder: (context) {
        result = resolve(context);

        return const SizedBox.shrink();
      },
    ),
  );

  return result;
}
