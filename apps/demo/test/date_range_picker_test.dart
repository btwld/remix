import 'package:demo/components/date_range_picker.dart';
import 'package:demo/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

Future<void> _pump(WidgetTester tester) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1000, 900);
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await tester.pumpWidget(
    MaterialApp(
      builder: (context, child) => FortalTheme(child: child!),
      home: const DateRangePickerExample(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('range demo uses a compact same-month label', (tester) async {
    await _pump(tester);
    expect(find.text('Nov 10–13, 2026'), findsOneWidget);
  });
  testWidgets('range demo prints a single day once and keeps its field width', (
    tester,
  ) async {
    await _pump(tester);
    final width = tester.getSize(find.byType(RemixButton).first).width;
    await tester.tap(find.byType(RemixButton).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('24'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('24'));
    await tester.pumpAndSettle();
    expect(find.text('Nov 24, 2026'), findsOneWidget);
    expect(tester.getSize(find.byType(RemixButton).first).width, width);
    expect(tester.takeException(), isNull);
  });
}
