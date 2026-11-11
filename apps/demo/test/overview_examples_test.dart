import 'package:flutter/material.dart' show MaterialApp;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../../packages/remix/example/main.dart' as remix_example;
import '../../../registry_source/example/main.dart' as preset_example;

void main() {
  for (final (name, start) in [
    ('Remix overview', remix_example.main),
    ('Fortal overview', preset_example.main),
  ]) {
    testWidgets('$name runs and updates its controlled toggle', (tester) async {
      tester.view.physicalSize = const Size(1024, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      start();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(find.byType(WidgetsApp), findsOneWidget);
      expect(find.byType(MaterialApp), findsNothing);
      expect(tester.takeException(), isNull);
      final toggle = find.byType(RemixToggle);
      expect(tester.widget<RemixToggle>(toggle).selected, isTrue);
      await tester.tap(toggle);
      await tester.pump(const Duration(milliseconds: 350));
      expect(tester.widget<RemixToggle>(toggle).selected, isFalse);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
