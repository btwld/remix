import 'package:flutter/material.dart' show MaterialApp;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui_example/registry.dart';
import 'package:naked_ui_example/src/example_app.dart';

// Every demo the kitchen sink can show now renders under `ExampleApp`, which
// is a `WidgetsApp`. Widgets that assert a Material ancestor -- `Scaffold`,
// `ListTile`, `SnackBar`, `Tooltip` -- throw there rather than degrading, so
// this is the test that keeps a Material host from creeping back in through a
// newly registered demo. `check_example_hosts.py` guards the source; this
// guards what the source actually builds.
void main() {
  for (final demo in DemoRegistry.demos) {
    testWidgets('${demo.id} renders with no Material ancestor', (tester) async {
      tester.view.physicalSize = const Size(1400, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ExampleApp(child: Builder(builder: demo.builder)),
      );
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(MaterialApp), findsNothing);
      expect(tester.takeException(), isNull, reason: demo.id);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
