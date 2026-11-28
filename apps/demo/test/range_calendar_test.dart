import 'package:demo/components/range_calendar.dart';
import 'package:demo/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(
  WidgetTester tester, {
  Widget child = const RangeCalendarExample(),
  bool rtl = false,
  bool dark = false,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1000, 900);
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await tester.pumpWidget(
    MaterialApp(
      builder: (context, child) => FortalTheme(
        mode: dark ? FortalThemeMode.dark : FortalThemeMode.light,
        child: Directionality(
          textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        ),
      ),
      home: child,
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final dark in [false, true]) {
    for (final rtl in [false, true]) {
      testWidgets(
        '$dark $rtl the range is two accent discs over a tinted pill',
        (tester) async {
          await _pump(tester, dark: dark, rtl: rtl);
          final context = tester.element(find.byType(RangeCalendarExample));
          final fills = tester
              .widgetList<DecoratedBox>(
                find.descendant(
                  of: find.byType(AnimatedPositioned),
                  matching: find.byType(DecoratedBox),
                ),
              )
              .map((box) => (box.decoration as ShapeDecoration).color)
              .toList();
          final disc = FortalTokens.accent9.resolve(context);
          expect(fills.where((c) => c == disc), hasLength(2));
          expect(fills, contains(FortalTokens.accentSurface.resolve(context)));
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
