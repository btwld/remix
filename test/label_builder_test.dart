import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  group('RemixLabel builder tests', () {
    testWidgets('Regular usage still works', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RemixLabel('Hello World'),
          ),
        ),
      );

      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('Regular usage with icon at leading position', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RemixLabel(
              'Settings',
              icon: Icons.settings,
            ),
          ),
        ),
      );

      expect(find.text('Settings'), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    testWidgets('Regular usage with icon at trailing position', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RemixLabel(
              'Next',
              icon: Icons.arrow_forward,
              style: RemixLabelStyle(iconPosition: IconPosition.trailing),
            ),
          ),
        ),
      );

      expect(find.text('Next'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('Text builder works', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RemixLabel(
              'Test',
              textBuilder: (context, textSpec, text) {
                // Create a styled text widget from the spec
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(text, style: textSpec.style),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      color: MixColors.amber,
                      child: const Text('NEW', style: TextStyle(fontSize: 10)),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
      expect(find.text('NEW'), findsOneWidget);
    });

    testWidgets('Icon builder works with leading position', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RemixLabel(
              'Notifications',
              icon: Icons.notifications,
              iconBuilder: (context, iconSpec, icon, position) {
                // icon is guaranteed to be non-null here since we provide icon: Icons.notifications
                return Badge(
                  label: const Text('5'),
                  child: Icon(icon!, size: iconSpec.size, color: iconSpec.color),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.byIcon(Icons.notifications), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('Icon builder works with trailing position', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RemixLabel(
              'Next',
              icon: Icons.arrow_forward,
              style: RemixLabelStyle(iconPosition: IconPosition.trailing),
              iconBuilder: (context, iconSpec, icon, position) {
                // Position should be trailing
                expect(position, IconPosition.trailing);
                return Icon(icon!, size: iconSpec.size, color: iconSpec.color);
              },
            ),
          ),
        ),
      );

      expect(find.text('Next'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('Full builder works', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RemixLabel(
              'Dashboard',
              builder: (context, spec, text) {
                // Use spec directly to create the label
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.dashboard),
                    const SizedBox(height: 4),
                    spec.createWidget(text),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.byIcon(Icons.dashboard), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });
  });
}
