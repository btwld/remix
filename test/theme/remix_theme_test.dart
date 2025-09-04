import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';

void main() {
  group('Remix Theme System Tests', () {
    testWidgets('MixScope provides light theme tokens correctly', (tester) async {
      late BuildContext capturedContext;
      
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(brightness: Brightness.light),
          home: createRemixScope(
            child: Builder(
              builder: (context) {
                capturedContext = context;
                return Container();
              },
            ),
          ),
        ),
      );

      // Test light theme color tokens
      expect(MixScope.tokenOf(RemixTokens.primary, capturedContext), const Color(0xFF2563EB));
      expect(MixScope.tokenOf(RemixTokens.background, capturedContext), Colors.white);
      expect(MixScope.tokenOf(RemixTokens.surface, capturedContext), const Color(0xFFF9FAFB));
      expect(MixScope.tokenOf(RemixTokens.textPrimary, capturedContext), const Color(0xFF111827));
      
      // Test spacing tokens
      expect(MixScope.tokenOf(RemixTokens.spaceXs, capturedContext), 4.0);
      expect(MixScope.tokenOf(RemixTokens.spaceSm, capturedContext), 8.0);
      expect(MixScope.tokenOf(RemixTokens.spaceMd, capturedContext), 12.0);
      expect(MixScope.tokenOf(RemixTokens.spaceLg, capturedContext), 16.0);
      
      // Test radius tokens
      expect(MixScope.tokenOf(RemixTokens.radiusSm, capturedContext), 4.0);
      expect(MixScope.tokenOf(RemixTokens.radiusMd, capturedContext), 6.0);
      expect(MixScope.tokenOf(RemixTokens.radiusLg, capturedContext), 8.0);
      expect(MixScope.tokenOf(RemixTokens.radiusXl, capturedContext), 12.0);
    });

    testWidgets('MixScope provides dark theme tokens correctly', (tester) async {
      late BuildContext capturedContext;
      
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(platformBrightness: Brightness.dark),
          child: MaterialApp(
            theme: ThemeData(brightness: Brightness.dark),
            home: createRemixScope(
              child: Builder(
                builder: (context) {
                  capturedContext = context;
                  return Container();
                },
              ),
            ),
          ),
        ),
      );

      // Test dark theme color tokens
      expect(MixScope.tokenOf(RemixTokens.primary, capturedContext), const Color(0xFF3B82F6));
      expect(MixScope.tokenOf(RemixTokens.background, capturedContext), const Color(0xFF111827));
      expect(MixScope.tokenOf(RemixTokens.surface, capturedContext), const Color(0xFF1F2937));
      expect(MixScope.tokenOf(RemixTokens.textPrimary, capturedContext), const Color(0xFFF9FAFB));
      
      // Test that spacing/radius tokens remain the same across themes
      expect(MixScope.tokenOf(RemixTokens.spaceXs, capturedContext), 4.0);
      expect(MixScope.tokenOf(RemixTokens.radiusLg, capturedContext), 8.0);
    });

    testWidgets('Theme switching updates token values correctly', (tester) async {
      late BuildContext capturedContext;
      
      Widget buildApp(Brightness brightness) {
        return MediaQuery(
          data: MediaQueryData(platformBrightness: brightness),
          child: MaterialApp(
            theme: ThemeData(brightness: brightness),
            home: createRemixScope(
              child: Builder(
                builder: (context) {
                  capturedContext = context;
                  return Container();
                },
              ),
            ),
          ),
        );
      }

      // Test light theme
      await tester.pumpWidget(buildApp(Brightness.light));
      expect(MixScope.tokenOf(RemixTokens.background, capturedContext), Colors.white);

      // Switch to dark theme
      await tester.pumpWidget(buildApp(Brightness.dark));
      await tester.pump();
      expect(MixScope.tokenOf(RemixTokens.background, capturedContext), const Color(0xFF111827));
    });
  });

  group('Refactored Component Token Integration Tests', () {
    testWidgets('Button component uses tokens correctly in light theme', (tester) async {
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

    testWidgets('Button component uses tokens correctly in dark theme', (tester) async {
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

    testWidgets('Card component uses tokens correctly in both themes', (tester) async {
      for (final brightness in [Brightness.light, Brightness.dark]) {
        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(platformBrightness: brightness),
            child: MaterialApp(
              theme: ThemeData(brightness: brightness),
              home: createRemixScope(
                child: const Scaffold(
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

    testWidgets('Badge component uses semantic tokens correctly', (tester) async {
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
                        style: RemixBadgeStyles.primary,
                        child: Text('Primary'),
                      ),
                      RemixBadge.raw(
                        style: RemixBadgeStyles.success,
                        child: Text('Success'),
                      ),
                      RemixBadge.raw(
                        style: RemixBadgeStyles.danger,
                        child: Text('Danger'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        
        // Verify all badge variants render correctly
        expect(find.text('Default'), findsOneWidget);
        expect(find.text('Primary'), findsOneWidget);
        expect(find.text('Success'), findsOneWidget);
        expect(find.text('Danger'), findsOneWidget);
      }
    });

    testWidgets('TextField component uses tokens correctly in both themes', (tester) async {
      for (final brightness in [Brightness.light, Brightness.dark]) {
        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(platformBrightness: brightness),
            child: MaterialApp(
              theme: ThemeData(brightness: brightness),
              home: createRemixScope(
                child: const Scaffold(
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
    testWidgets('Button states work consistently in both themes', (tester) async {
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
                      const RemixButton(
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