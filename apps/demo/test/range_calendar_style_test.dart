import 'package:demo/components/range_calendar.dart';
import 'package:demo/ui/ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  testWidgets('available range days have no resting tile', (tester) async {
    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xFFFFFFFF),
        builder: (context, _) =>
            FortalTheme(child: const RangeCalendarExample()),
      ),
    );
    final day = find
        .ancestor(of: find.text('20'), matching: find.byType(Box))
        .first;
    final box = tester.widget<Box>(day);
    final decoration = box.styleSpec!.spec.decoration as BoxDecoration?;
    expect(decoration?.color?.a ?? 0, 0);
    expect((decoration?.border as Border?)?.top.color.a ?? 0, 0);
  });
}
