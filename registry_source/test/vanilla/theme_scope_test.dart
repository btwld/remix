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
  // A family the test can see, standing in for an application's font.
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

  testWidgets('a nested scope in the same theme leaves the page alone', (
    tester,
  ) async {
    await tester.pumpWidget(
      VanillaThemeScope(
        theme: light,
        darkTheme: dark,
        mode: .light,
        child: const Directionality(
          textDirection: TextDirection.ltr,
          child: VanillaThemeScope(child: Text('probe')),
        ),
      ),
    );

    expectBodyRun(runOf(tester), light);
    expect(find.byType(ColoredBox), findsOneWidget);
  });

  testWidgets('a nested scope in the other theme recolors text and icons', (
    tester,
  ) async {
    late Color innerForeground;
    late Color? iconColor;

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
                iconColor = IconTheme.of(context).color;
                return const Text('probe');
              },
            ),
          ),
        ),
      ),
    );

    // The tokens follow the nested scope, and so does the color of bare text
    // and icons, or they would vanish on the surfaces its recipes paint ...
    expect(innerForeground, dark.foreground);
    expect(iconColor, dark.foreground);
    final run = runOf(tester);
    expect(run.color, dark.foreground);
    // ... but the rest of the run and the background stay the root's: a
    // nested scope that reinstalled them would repaint whatever it sits on.
    expect(run.fontSize, 14);
    expect(run.fontFamily, 'Body');
    expect(find.byType(ColoredBox), findsOneWidget);
  });

  testWidgets('the root gives bare icons the foreground', (tester) async {
    late Color? iconColor;

    await tester.pumpWidget(
      VanillaThemeScope(
        theme: light,
        darkTheme: dark,
        mode: .dark,
        child: Builder(
          builder: (context) {
            iconColor = IconTheme.of(context).color;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(iconColor, dark.foreground);
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
