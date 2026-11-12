import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_chart/mix_chart.dart';

import '../lib/main.dart';
import '../lib/ui/ui.dart';

void main() {
  testWidgets('installed dashboard_demo renders and host theme action works', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const AcmeDashboardApp());
    await tester.pump();

    expect(find.text(r'$84,420'), findsOneWidget);
    expect(find.text('ORD-1048'), findsOneWidget);
    expect(find.byType(LineChart), findsOneWidget);
    expect(find.byType(PieChart), findsOneWidget);
    expect(find.byType(AcmeTable<AcmeDashboardRecord>), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('toggle-theme')));
    await tester.pump();
    expect(find.text('Light'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('installed dashboard_demo navigates to every destination', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const AcmeDashboardApp());
    await tester.pump();

    for (final (destination, text) in const [
      ('Chat', 'Agent chat'),
      ('Customers', 'Search customers…'),
      ('Orders', 'Refunded'),
      ('Settings', 'Danger zone'),
    ]) {
      await tester.tap(find.text(destination).first);
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text(text), findsWidgets, reason: destination);
    }
    expect(tester.takeException(), isNull);
  });
}
