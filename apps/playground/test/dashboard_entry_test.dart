import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground/preview_shell/controls_bar.dart';
import 'package:playground/registry/component_registry.dart';
import 'package:playground/ui/ui.dart';

void main() {
  testWidgets(
    'dashboard starter is discoverable and rendered with sample data',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      expect(components, contains('dashboard'));
      await tester.pumpWidget(
        MaterialApp(home: Builder(builder: components['dashboard']!)),
      );

      expect(find.byType(PlaygroundDashboardDemo), findsOneWidget);
      expect(find.text('Revenue'), findsOneWidget);
      expect(find.text('Recent orders'), findsOneWidget);
      expect(find.text('ORD-1048'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'dashboard preview viewport and brightness controls stay active',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1100);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(home: Builder(builder: components['dashboard']!)),
      );

      final control = find.descendant(
        of: find.byType(ControlsBar),
        matching: find.byType(PlaygroundSegmentedControl<Brightness>),
      );
      tester.widget<PlaygroundSegmentedControl<Brightness>>(control).onChanged!(
        Brightness.dark,
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        tester
            .widget<PlaygroundSegmentedControl<Brightness>>(control)
            .selectedValue,
        Brightness.dark,
      );

      await tester.tap(
        find.descendant(
          of: find.byType(ControlsBar),
          matching: find.text('Mobile'),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byKey(const ValueKey('dashboard-menu')), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );
}
