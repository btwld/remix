import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground/calendar_reference.dart';

void main() {
  testWidgets('inline reference selects and clears an appointment', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const CalendarReferenceApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('13'));
    await tester.pumpAndSettle();
    expect(find.text('Friday, November 13, 2026'), findsOneWidget);

    await tester.ensureVisible(find.text('Clear selection'));
    await tester.tap(find.text('Clear selection'));
    await tester.pumpAndSettle();
    expect(find.text('No date selected'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
