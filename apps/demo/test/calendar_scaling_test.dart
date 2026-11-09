import 'package:demo/components/calendar.dart';
import 'package:demo/components/date_picker.dart';
import 'package:demo/components/range_calendar.dart';
import 'package:demo/components/date_range_picker.dart';
import 'package:demo/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  for (final (name, example, picker) in <(String, Widget, Type?)>[
    ('calendar', const CalendarExample(), null),
    ('range calendar', const RangeCalendarExample(), null),
    ('picker', const DatePickerExample(), RemixDatePicker),
    ('range picker', const DateRangePickerExample(), RemixDateRangePicker),
  ]) {
    testWidgets(
      '$name keeps captions and weekdays on one line at 200 percent',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(1000, 900);
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });
        await tester.pumpWidget(
          MaterialApp(
            builder: (context, child) => FortalTheme(
              child: MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: TextScaler.linear(2)),
                child: child!,
              ),
            ),
            home: example,
          ),
        );
        await tester.pumpAndSettle();
        if (picker != null) {
          await tester.tap(
            find
                .descendant(
                  of: find.byType(picker),
                  matching: find.byType(RemixButton),
                )
                .first,
          );
          await tester.pumpAndSettle();
        }
        for (final label in [
          'November',
          '2026',
          'Mo',
          'Tu',
          'We',
          'Th',
          'Fr',
          'Sa',
          'Su',
        ]) {
          final paragraph = tester.renderObject<RenderParagraph>(
            find.descendant(
              of: find.text(label),
              matching: find.byType(RichText),
            ),
          );
          expect(
            paragraph.size.height,
            lessThanOrEqualTo(paragraph.preferredLineHeight + 0.1),
            reason: label,
          );
          expect(paragraph.didExceedMaxLines, isFalse, reason: label);
        }
        expect(tester.takeException(), isNull);
      },
    );
  }
}
