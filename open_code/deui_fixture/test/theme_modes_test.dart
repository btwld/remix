import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_code_fixture/ui/ui.dart';
import 'package:remix/remix.dart';

void main() {
  Widget host(Widget child) => WidgetsApp(
    color: const Color(0xFFFFFFFF),
    builder: (context, _) => child,
  );
  late AcmeThemeData active;
  late Color background;
  late Color accent;
  late Color accentHover;
  final probe = Builder(
    builder: (context) {
      active = AcmeTheme.of(context);
      background = AcmeTokens.background.resolve(context);
      accent = AcmeTokens.accent.resolve(context);
      accentHover = AcmeTokens.accentHover.resolve(context);
      return const SizedBox.shrink();
    },
  );
  // The value recipes resolve: the theme's token table, not its raw colors.
  Color paint(AcmeThemeData theme, ColorToken token) =>
      theme.tokens[token]! as Color;
  Color backgroundOf(AcmeThemeData theme) =>
      paint(theme, AcmeTokens.background);

  testWidgets('the root follows live system changes above the app', (
    tester,
  ) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await tester.pumpWidget(host(AcmeTheme(child: probe)));
    expect(active.brightness, Brightness.light);
    expect(background, backgroundOf(const AcmeThemeData.light()));
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    await tester.pump();
    expect(active.brightness, Brightness.dark);
    expect(background, backgroundOf(const AcmeThemeData.dark()));
  });

  testWidgets('an explicit mode overrides the system and survives changes', (
    tester,
  ) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
    await tester.pumpWidget(host(AcmeTheme(mode: .light, child: probe)));
    expect(active.brightness, Brightness.light);
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    await tester.pump();
    expect(active.brightness, Brightness.light);
    expect(background, backgroundOf(const AcmeThemeData.light()));
  });

  testWidgets('a theme without a dark pair is used in both modes', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        AcmeTheme(
          theme: const AcmeThemeData.light(),
          mode: .dark,
          child: probe,
        ),
      ),
    );
    expect(active.brightness, Brightness.light);
    expect(background, backgroundOf(const AcmeThemeData.light()));
  });

  testWidgets('nested scopes inherit the selection and the configured pair', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        AcmeTheme(
          mode: .dark,
          child: MediaQuery(
            data: const MediaQueryData(platformBrightness: Brightness.light),
            child: AcmeTheme(child: probe),
          ),
        ),
      ),
    );
    expect(active.brightness, Brightness.dark);
    expect(background, backgroundOf(const AcmeThemeData.dark()));
  });

  testWidgets('a color override reaches the tokens derived from it', (
    tester,
  ) async {
    const custom = Color(0xFF9966CC);
    final theme = const AcmeThemeData.light().copyWith(
      colors: {AcmeTokens.accent: custom},
    );
    await tester.pumpWidget(host(AcmeTheme(theme: theme, child: probe)));
    expect(accent, custom);
    expect(
      accentHover,
      isNot(paint(const AcmeThemeData.light(), AcmeTokens.accentHover)),
    );
  });

  testWidgets('captured theme keeps its tokens in a new subtree', (
    tester,
  ) async {
    late Widget captured;
    await tester.pumpWidget(
      host(
        AcmeTheme(
          theme: const AcmeThemeData.light().copyWith(
            colors: {AcmeTokens.accent: const Color(0xFF9966CC)},
          ),
          mode: .light,
          child: Builder(
            builder: (context) {
              captured = InheritedTheme.captureAll(context, probe);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
    await tester.pumpWidget(host(captured));
    expect(active.brightness, Brightness.light);
    expect(accent, const Color(0xFF9966CC));
  });

  testWidgets('changing the mode updates an already-open dialog', (
    tester,
  ) async {
    var mode = AcmeThemeMode.light;
    late StateSetter update;
    late BuildContext pageContext;
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          update = setState;
          return WidgetsApp(
            color: const Color(0xFFFFFFFF),
            pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
              settings: settings,
              pageBuilder: (context, _, _) => builder(context),
            ),
            builder: (context, child) => AcmeTheme(mode: mode, child: child!),
            home: Builder(
              builder: (context) {
                pageContext = context;
                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
    showGeneralDialog<void>(
      context: pageContext,
      pageBuilder: (context, _, _) => probe,
    );
    await tester.pumpAndSettle();
    expect(active.brightness, Brightness.light);
    update(() => mode = AcmeThemeMode.dark);
    await tester.pumpAndSettle();
    expect(active.brightness, Brightness.dark);
    expect(background, backgroundOf(const AcmeThemeData.dark()));
    Navigator.of(pageContext).pop();
    await tester.pumpAndSettle();
  });
}
