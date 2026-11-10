import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  group('CalendarStyler.call', () {
    test(
      'builds a calendar with the owning style and constructor defaults',
      () {
        final style = CalendarStyler().headerSpacing(12);
        final firstDate = DateTime(2024);
        final lastDate = DateTime(2025);

        final widget = style(
          value: null,
          firstDate: firstDate,
          lastDate: lastDate,
        );

        expect(widget, isA<RemixCalendar>());
        expect(widget.style, same(style));
        expect(widget.value, isNull);
        expect(widget.firstDate, same(firstDate));
        expect(widget.lastDate, same(lastDate));
        expect(widget.key, isNull);
        expect(widget.onChanged, isNull);
        expect(widget.currentDate, isNull);
        expect(widget.isDateUnavailable, isNull);
        expect(widget.firstDayOfWeek, DateTime.sunday);
        expect(widget.enabled, isTrue);
        expect(widget.semanticLabel, isNull);
        expect(widget.focusNode, isNull);
        expect(widget.autofocus, isFalse);
        expect(widget.labels, same(const RemixCalendarLabels()));
        expect(widget.headerBuilder, isNull);
        expect(widget.navigationStyle, same(const IconButtonStyler.create()));
        expect(widget.selectorStyle, same(const SelectStyler.create()));
        expect(widget.styleSpec, isNull);
      },
    );

    test('forwards every constructor argument', () {
      final style = CalendarStyler().rowSpacing(8);
      const key = ValueKey('calendar');
      final value = DateTime(2024, 2, 14);
      final firstDate = DateTime(2024);
      final lastDate = DateTime(2025);
      void onChanged(DateTime date) {}
      final currentDate = DateTime(2024, 2, 15);
      bool isDateUnavailable(DateTime date) =>
          date.weekday == DateTime.saturday;
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      const labels = RemixCalendarLabels(today: 'Current day');
      Widget headerBuilder(BuildContext context, NakedCalendarState state) =>
          const SizedBox.shrink();
      final navigationStyle = IconButtonStyler().size(32, 32);
      final selectorStyle = SelectStyler().trigger(
        SelectTriggerStyler().spacing(6),
      );

      final widget = style.call(
        key: key,
        value: value,
        firstDate: firstDate,
        lastDate: lastDate,
        onChanged: onChanged,
        currentDate: currentDate,
        isDateUnavailable: isDateUnavailable,
        firstDayOfWeek: DateTime.monday,
        enabled: false,
        semanticLabel: 'Appointment',
        focusNode: focusNode,
        autofocus: true,
        labels: labels,
        headerBuilder: headerBuilder,
        navigationStyle: navigationStyle,
        selectorStyle: selectorStyle,
      );

      expect(widget, isA<RemixCalendar>());
      expect(widget.style, same(style));
      expect(widget.key, same(key));
      expect(widget.value, same(value));
      expect(widget.firstDate, same(firstDate));
      expect(widget.lastDate, same(lastDate));
      expect(widget.onChanged, same(onChanged));
      expect(widget.currentDate, same(currentDate));
      expect(widget.isDateUnavailable, same(isDateUnavailable));
      expect(widget.firstDayOfWeek, DateTime.monday);
      expect(widget.enabled, isFalse);
      expect(widget.semanticLabel, 'Appointment');
      expect(widget.focusNode, same(focusNode));
      expect(widget.autofocus, isTrue);
      expect(widget.labels, same(labels));
      expect(widget.headerBuilder, same(headerBuilder));
      expect(widget.navigationStyle, same(navigationStyle));
      expect(widget.selectorStyle, same(selectorStyle));
      expect(widget.styleSpec, isNull);
    });
  });
}
