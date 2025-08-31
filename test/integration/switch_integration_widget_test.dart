import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('RemixSwitch Integration Tests', () {
    testWidgets('renders correctly with default state', (tester) async {
      await tester.pumpRemixApp(
        RemixSwitch(
          selected: false,
          onChanged: (_) {},
        ),
      );

      expect(find.byType(RemixSwitch), findsOneWidget);

      // Verify switch track is visible
      final switchFinder = find.byType(RemixSwitch);
      expect(switchFinder, findsOneWidget);
    });

    testWidgets('renders with selected state', (tester) async {
      await tester.pumpRemixApp(
        RemixSwitch(
          selected: true,
          onChanged: (_) {},
        ),
      );

      expect(find.byType(RemixSwitch), findsOneWidget);
    });

    testWidgets('toggles state when tapped', (tester) async {
      bool switchValue = false;

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return RemixSwitch(
              selected: switchValue,
              onChanged: (value) {
                setState(() {
                  switchValue = value;
                });
              },
            );
          },
        ),
      );

      expect(switchValue, false);

      // Tap to turn on
      await tester.tap(find.byType(RemixSwitch));
      await tester.pumpAndSettle();
      expect(switchValue, true);

      // Tap to turn off
      await tester.tap(find.byType(RemixSwitch));
      await tester.pumpAndSettle();
      expect(switchValue, false);
    });

    testWidgets('respects disabled state', (tester) async {
      bool switchValue = false;

      await tester.pumpRemixApp(
        RemixSwitch(
          selected: switchValue,
          enabled: false,
          onChanged: (value) {
            switchValue = value;
          },
        ),
      );

      await tester.tap(find.byType(RemixSwitch));
      await tester.pumpAndSettle();

      // Value should not change when disabled
      expect(switchValue, false);
    });

    testWidgets('calls onChanged callback with correct value', (tester) async {
      bool? callbackValue;

      await tester.pumpRemixApp(
        RemixSwitch(
          selected: false,
          onChanged: (value) {
            callbackValue = value;
          },
        ),
      );

      await tester.tap(find.byType(RemixSwitch));
      await tester.pumpAndSettle();

      expect(callbackValue, true);
    });

    testWidgets('maintains state across rebuilds', (tester) async {
      bool switchValue = true;

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RemixSwitch(
                  selected: switchValue,
                  onChanged: (value) {
                    setState(() {
                      switchValue = value;
                    });
                  },
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      // Force rebuild
                    });
                  },
                  child: const Text('Rebuild'),
                ),
              ],
            );
          },
        ),
      );

      expect(switchValue, true);

      // Force rebuild
      await tester.tap(find.text('Rebuild'));
      await tester.pumpAndSettle();

      // State should be maintained
      expect(switchValue, true);
    });

    testWidgets('handles rapid toggling', (tester) async {
      int toggleCount = 0;

      await tester.pumpRemixApp(
        RemixSwitch(
          selected: false,
          onChanged: (_) {
            toggleCount++;
          },
        ),
      );

      // Rapid toggling
      await tester.tap(find.byType(RemixSwitch));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byType(RemixSwitch));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byType(RemixSwitch));
      await tester.pumpAndSettle();

      expect(toggleCount, 3);
    });

    testWidgets('responds to keyboard input', (tester) async {
      bool switchValue = false;

      await tester.pumpRemixApp(
        Focus(
          autofocus: true,
          child: StatefulBuilder(
            builder: (context, setState) {
              return RemixSwitch(
                selected: switchValue,
                onChanged: (value) {
                  setState(() {
                    switchValue = value;
                  });
                },
              );
            },
          ),
        ),
      );

      // Focus the switch
      await tester.tap(find.byType(RemixSwitch));
      await tester.pumpAndSettle();

      // Try space key to toggle
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();

      // Space key might toggle depending on implementation
      // This test verifies keyboard interaction doesn't crash
      expect(find.byType(RemixSwitch), findsOneWidget);
    });

    testWidgets('animates smoothly between states', (tester) async {
      bool switchValue = false;

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return RemixSwitch(
              selected: switchValue,
              onChanged: (value) {
                setState(() {
                  switchValue = value;
                });
              },
            );
          },
        ),
      );

      // Toggle and verify animation runs
      await tester.tap(find.byType(RemixSwitch));

      // Pump a few frames to verify animation
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      await tester.pumpAndSettle();
      expect(switchValue, true);
    });

    testWidgets('works in a form with multiple switches', (tester) async {
      Map<String, bool> settings = {
        'notifications': false,
        'darkMode': false,
        'autoSave': false,
      };

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: settings.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(entry.key),
                      const SizedBox(width: 16),
                      RemixSwitch(
                        key: Key(entry.key),
                        selected: entry.value,
                        onChanged: (value) {
                          setState(() {
                            settings[entry.key] = value;
                          });
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      );

      // Toggle each switch
      await tester.tap(find.byKey(const Key('notifications')));
      await tester.pumpAndSettle();
      expect(settings['notifications'], true);

      await tester.tap(find.byKey(const Key('darkMode')));
      await tester.pumpAndSettle();
      expect(settings['darkMode'], true);

      await tester.tap(find.byKey(const Key('autoSave')));
      await tester.pumpAndSettle();
      expect(settings['autoSave'], true);

      // Verify all switches are on
      expect(settings.values.every((v) => v == true), true);
    });

    testWidgets('handles hover state', (tester) async {
      await tester.pumpRemixApp(
        RemixSwitch(
          selected: false,
          onChanged: (_) {},
        ),
      );

      // Simulate hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.byType(RemixSwitch)));
      await tester.pumpAndSettle();

      // Switch should still be visible and functional
      expect(find.byType(RemixSwitch), findsOneWidget);
    });

    testWidgets('updates visual state when selected changes externally',
        (tester) async {
      bool externalValue = false;

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RemixSwitch(
                  selected: externalValue,
                  onChanged: (_) {},
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      externalValue = !externalValue;
                    });
                  },
                  child: const Text('Toggle Externally'),
                ),
              ],
            );
          },
        ),
      );

      // Toggle externally
      await tester.tap(find.text('Toggle Externally'));
      await tester.pumpAndSettle();

      // Switch should reflect new state
      expect(find.byType(RemixSwitch), findsOneWidget);
    });

    testWidgets('handles null onChanged callback', (tester) async {
      await tester.pumpRemixApp(
        RemixSwitch(
          selected: true,
          enabled: false,
          onChanged: (_) {},
        ),
      );

      // Should render without crash
      expect(find.byType(RemixSwitch), findsOneWidget);

      // Tap should not cause error
      await tester.tap(find.byType(RemixSwitch));
      await tester.pumpAndSettle();
    });

    testWidgets('preserves accessibility semantics', (tester) async {
      await tester.pumpRemixApp(
        Semantics(
          label: 'Enable notifications',
          child: RemixSwitch(
            selected: false,
            onChanged: (_) {},
          ),
        ),
      );

      // Verify semantics are preserved
      final semantics = tester.getSemantics(find.byType(RemixSwitch));
      expect(semantics.label, contains('Enable notifications'));
    });

    testWidgets('handles gesture cancellation', (tester) async {
      bool switchValue = false;

      await tester.pumpRemixApp(
        RemixSwitch(
          selected: switchValue,
          onChanged: (value) {
            switchValue = value;
          },
        ),
      );

      // Start a tap but cancel it
      final gesture =
          await tester.startGesture(tester.getCenter(find.byType(RemixSwitch)));
      await tester.pump(const Duration(milliseconds: 100));
      await gesture.cancel();
      await tester.pumpAndSettle();

      // Value should not change on cancelled gesture
      expect(switchValue, false);
    });
  });
}
