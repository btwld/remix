import 'package:carbon/carbon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/pump.dart';

void main() {
  group('CarbonButton', () {
    testWidgets('renders its label', (tester) async {
      await tester.pumpCarbonApp(
        CarbonButton(label: 'Save', onPressed: () {}),
      );
      await tester.pumpAndSettle();
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('fires onPressed when tapped', (tester) async {
      var pressed = 0;
      await tester.pumpCarbonApp(
        CarbonButton(label: 'Submit', onPressed: () => pressed++),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Submit'));
      expect(pressed, 1);
    });

    testWidgets('is disabled when onPressed is null', (tester) async {
      await tester.pumpCarbonApp(
        const CarbonButton(label: 'Disabled', onPressed: null),
      );
      await tester.pumpAndSettle();
      expect(find.text('Disabled'), findsOneWidget);
      // Tapping a disabled button must not throw and has no callback to fire.
      await tester.tap(find.text('Disabled'), warnIfMissed: false);
      await tester.pumpAndSettle();
    });

    testWidgets('renders a trailing icon', (tester) async {
      await tester.pumpCarbonApp(
        CarbonButton(
          label: 'Add',
          icon: Icons.add,
          onPressed: () {},
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Add'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('every kind builds across all four themes', (tester) async {
      for (final theme in CarbonTheme.values) {
        for (final kind in CarbonButtonKind.values) {
          await tester.pumpCarbonApp(
            CarbonButton(label: 'Go', kind: kind, onPressed: () {}),
            theme: theme,
          );
          await tester.pumpAndSettle();
          expect(find.text('Go'), findsOneWidget,
              reason: 'kind=$kind theme=$theme');
        }
      }
    });

    testWidgets('respects an explicit size', (tester) async {
      await tester.pumpCarbonApp(
        CarbonButton(
          label: 'Large',
          size: CarbonSize.xl,
          onPressed: () {},
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Large'), findsOneWidget);
    });
  });
}
