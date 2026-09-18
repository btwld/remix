import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground/registry/component_registry.dart';

void main() {
  testWidgets(
    'base dashboard preview supports search, navigation, and themes',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(builder: components['dashboard_shell']!),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Workspace overview'), findsOneWidget);
      expect(find.text('Website refresh'), findsOneWidget);

      await tester.enterText(find.byType(EditableText).last, 'Customer');
      await tester.pumpAndSettle();
      expect(find.text('Customer portal'), findsOneWidget);
      expect(find.text('Website refresh'), findsNothing);

      await tester.tap(find.text('Projects').first);
      await tester.pumpAndSettle();
      expect(find.text('Your projects'), findsOneWidget);

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();
      expect(find.text('Customer portal'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Mobile'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}
