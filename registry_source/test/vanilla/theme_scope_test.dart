import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';

/// The root scope sets the page up: the theme's background, and a body text
/// run for bare [Text], whatever host the application runs in.
///
/// The review that started this spec found unstyled text inheriting the host
/// and vanishing in the dark theme. These pin the fix under the three hosts
/// an application actually has.
void main() {
  // A family the test can see, standing in for Geist.
  final light = const VanillaThemeData.light().copyWith(fontFamily: 'Body');
  final dark = const VanillaThemeData.dark().copyWith(fontFamily: 'Body');

  TextStyle runOf(WidgetTester tester) =>
      tester.widget<RichText>(find.byType(RichText).last).text.style!;

  void expectBodyRun(TextStyle style, VanillaThemeData theme) {
    expect(style.color, theme.foreground);
    expect(style.fontFamily, 'Body');
    expect(style.fontSize, 14);
    expect(style.height! * style.fontSize!, closeTo(20, 1e-9));
    expect(style.fontWeight, FontWeight.w400);
  }

  for (final (name, theme, hostBrightness) in [
    ('light', light, Brightness.dark),
    ('dark', dark, Brightness.light),
  ]) {
    testWidgets('$name text under a $hostBrightness Material host', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: hostBrightness),
          builder: (context, child) => VanillaThemeScope(
            theme: light,
            darkTheme: dark,
            mode: name == 'light' ? .light : .dark,
            child: child!,
          ),
          home: const Text('probe'),
        ),
      );

      expectBodyRun(runOf(tester), theme);
    });

    testWidgets('$name text under a WidgetsApp', (tester) async {
      await tester.pumpWidget(
        WidgetsApp(
          color: const Color(0xFF000000),
          builder: (context, _) => VanillaThemeScope(
            theme: light,
            darkTheme: dark,
            mode: name == 'light' ? .light : .dark,
            child: const Text('probe'),
          ),
        ),
      );

      expectBodyRun(runOf(tester), theme);
    });

    testWidgets('$name text with no host at all', (tester) async {
      await tester.pumpWidget(
        VanillaThemeScope(
          theme: light,
          darkTheme: dark,
          mode: name == 'light' ? .light : .dark,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: Text('probe'),
          ),
        ),
      );

      expectBodyRun(runOf(tester), theme);
    });

    testWidgets('the $name root paints its background', (tester) async {
      await tester.pumpWidget(
        VanillaThemeScope(
          theme: light,
          darkTheme: dark,
          mode: name == 'light' ? .light : .dark,
          child: const SizedBox.shrink(),
        ),
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is ColoredBox && widget.color == theme.background,
        ),
        findsOneWidget,
      );
    });
  }

  testWidgets('a nested scope re-scopes tokens and leaves the page alone', (
    tester,
  ) async {
    late Color innerForeground;

    await tester.pumpWidget(
      VanillaThemeScope(
        theme: light,
        darkTheme: dark,
        mode: .light,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: VanillaThemeScope(
            mode: .dark,
            child: Builder(
              builder: (context) {
                innerForeground = VanillaTokens.foreground.resolve(context);
                return const Text('probe');
              },
            ),
          ),
        ),
      ),
    );

    // The tokens follow the nested scope ...
    expect(innerForeground, dark.foreground);
    // ... but the text run and the background are the root's alone: a nested
    // scope that reinstalled them would repaint whatever surface it sits on.
    expectBodyRun(runOf(tester), light);
    expect(find.byType(ColoredBox), findsOneWidget);
  });

  testWidgets('a nearer DefaultTextStyle still wins', (tester) async {
    await tester.pumpWidget(
      VanillaThemeScope(
        theme: light,
        mode: .light,
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: DefaultTextStyle(
            style: TextStyle(fontSize: 30, color: Color(0xFF123456)),
            child: Text('probe'),
          ),
        ),
      ),
    );

    expect(runOf(tester).fontSize, 30);
    expect(runOf(tester).color, const Color(0xFF123456));
  });
}
