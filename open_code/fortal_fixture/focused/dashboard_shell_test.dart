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
    expect(tester.takeException(), isNull);
  });
}
