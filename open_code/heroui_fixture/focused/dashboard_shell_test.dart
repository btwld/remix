import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/main.dart';

void main() {
  testWidgets('installed shell navigates and retains page state', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const AcmeShellApp());
    await tester.tap(find.byKey(const ValueKey('increment')));
    await tester.pump();
    expect(find.text('Count 1'), findsOneWidget);

    await tester.tap(find.text('Reports'));
    await tester.pump();
    expect(find.text('Reports page'), findsOneWidget);

    await tester.tap(find.text('Overview').last);
    await tester.pump();
    expect(find.text('Count 1'), findsOneWidget);
    expect(find.byKey(const ValueKey('dashboard-search')), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('installed shell opens its compact sheet from the menu', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const AcmeShellApp());
    expect(find.text('Northstar'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('dashboard-menu')).first);
    await tester.pumpAndSettle();
    expect(find.text('Northstar'), findsOneWidget);

    await tester.tap(find.text('Reports'));
    await tester.pumpAndSettle();
    expect(find.text('Northstar'), findsNothing);
    expect(find.text('Reports page'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
