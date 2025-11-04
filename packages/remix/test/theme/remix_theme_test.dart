import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/src/theme/remix_theme.dart';

void main() {
  group('resolveRemixBrightness', () {
    testWidgets('prefers media query platform brightness when available',
        (tester) async {
      late Brightness resolved;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(platformBrightness: Brightness.dark),
          child: Theme(
            data: ThemeData.from(colorScheme: const ColorScheme.light()),
            child: Builder(
              builder: (context) {
                resolved = resolveRemixBrightness(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(resolved, Brightness.dark);
    });

    testWidgets('respects explicit override before media query', (tester) async {
      late Brightness resolved;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(platformBrightness: Brightness.dark),
          child: Theme(
            data: ThemeData.from(colorScheme: const ColorScheme.dark()),
            child: Builder(
              builder: (context) {
                resolved = resolveRemixBrightness(
                  context,
                  brightnessOverride: Brightness.light,
                );
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(resolved, Brightness.light);
    });

  });

  group('resolveRemixBrightnessValues', () {
    test('falls back to theme brightness when media query is null', () {
      final result = resolveRemixBrightnessValues(
        mediaQuery: null,
        themeBrightness: Brightness.dark,
      );

      expect(result, Brightness.dark);
    });

    test('defaults to Brightness.light when nothing provided', () {
      final result = resolveRemixBrightnessValues();

      expect(result, Brightness.light);
    });
  });
}
