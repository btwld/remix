import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground/main.dart' as playground;
import 'package:playground/ui/ui.dart';

void main() {
  // Both entry shapes: `avatar` resolves its theme scope above PreviewShell,
  // `skeleton` and `dashboard_shell` resolve it inside. The inside shape is the
  // interesting one for host neutrality — nothing above the shell supplies
  // tokens, so the app host and the shell chrome have to stand on their own.
  //
  // Entries are chosen for a clean render at the default mobile preset, since
  // `takeException` below is deliberately strict. Several other examples
  // overflow at that width on `main` already; that is a layout question for
  // those examples, not a host question for this test.
  for (final component in ['avatar', 'skeleton', 'dashboard_shell']) {
    testWidgets('$component comparison works under WidgetsApp', (tester) async {
      tester.view.physicalSize = const Size(2400, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      tester.binding.resetEpoch();
      playground.main();
      await tester.pump();
      await tester.tap(find.text(component));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(find.byType(WidgetsApp), findsWidgets);
      expect(find.byType(MaterialApp), findsNothing);
      expect(tester.takeException(), isNull);

      final control = find.byType(PlaygroundSegmentedControl<Brightness>);
      expect(
        tester
            .widget<PlaygroundSegmentedControl<Brightness>>(control)
            .selectedValue,
        Brightness.light,
      );
      await tester.tap(find.text('Dark'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(
        tester
            .widget<PlaygroundSegmentedControl<Brightness>>(control)
            .selectedValue,
        Brightness.dark,
      );
      expect(find.byType(MaterialApp), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
