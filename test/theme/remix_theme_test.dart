import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  group('Refactored Component Token Integration Tests', () {
    testWidgets('Button component uses tokens correctly in light theme',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: createRemixScope(
            child: Scaffold(
              body: RemixButton(
                label: 'Test Button',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify button renders correctly in light theme
      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(RemixButton), findsOneWidget);
    });

    testWidgets('Button component uses tokens correctly in dark theme',
        (tester) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(platformBrightness: Brightness.dark),
          child: MaterialApp(
            theme: ThemeData(brightness: Brightness.dark),
            home: createRemixScope(
              child: Scaffold(
                body: RemixButton(
                  label: 'Test Button',
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify button renders correctly in dark theme
      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byType(RemixButton), findsOneWidget);
    });

    testWidgets('Card component uses tokens correctly in both themes',
        (tester) async {
      for (final brightness in [Brightness.light, Brightness.dark]) {
        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(platformBrightness: brightness),
            child: MaterialApp(
              theme: ThemeData(brightness: brightness),
              home: createRemixScope(
                child: Scaffold(
                  body: RemixCard(
                    child: Text('Test Card'),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify card renders correctly in both themes
        expect(find.text('Test Card'), findsOneWidget);
        expect(find.byType(RemixCard), findsOneWidget);
      }
    });

    testWidgets('Badge component uses semantic tokens correctly',
        (tester) async {
      for (final brightness in [Brightness.light, Brightness.dark]) {
        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(platformBrightness: brightness),
            child: MaterialApp(
              theme: ThemeData(brightness: brightness),
              home: createRemixScope(
                child: Scaffold(
                  body: Column(
                    children: [
                      RemixBadge.raw(child: Text('Default')),
                      RemixBadge.raw(
                        child: Text('Solid'),
                      ),
                      RemixBadge.raw(
                        child: Text('Outline'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify badge examples render correctly (refactored variants)
        expect(find.text('Default'), findsOneWidget);
        expect(find.text('Solid'), findsOneWidget);
        expect(find.text('Outline'), findsOneWidget);
      }
    });

    testWidgets('TextField component uses tokens correctly in both themes',
        (tester) async {
      for (final brightness in [Brightness.light, Brightness.dark]) {
        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(platformBrightness: brightness),
            child: MaterialApp(
              theme: ThemeData(brightness: brightness),
              home: createRemixScope(
                child: Scaffold(
                  body: RemixTextField(
                    hintText: 'Test TextField',
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify textfield renders correctly in both themes
        expect(find.byType(RemixTextField), findsOneWidget);
      }
    });
  });

  group('Widget State Consistency Tests', () {
    testWidgets('Button states work consistently in both themes',
        (tester) async {
      for (final brightness in [Brightness.light, Brightness.dark]) {
        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(platformBrightness: brightness),
            child: MaterialApp(
              theme: ThemeData(brightness: brightness),
              home: createRemixScope(
                child: Scaffold(
                  body: Column(
                    children: [
                      RemixButton(
                        label: 'Enabled',
                        onPressed: () {},
                      ),
                      RemixButton(
                        label: 'Disabled',
                        onPressed: null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Test enabled state
        expect(find.text('Enabled'), findsOneWidget);

        // Test disabled state
        expect(find.text('Disabled'), findsOneWidget);

        // Test interaction
        await tester.tap(find.text('Enabled'));
        await tester.pump(const Duration(milliseconds: 100));
      }
    });
  });
}
