import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_vanilla/ui/ui.dart';

@widgetbook.UseCase(name: 'Appointment date', type: VanillaDatePicker)
Widget buildVanillaDatePickerUseCase(BuildContext context) {
  final inWidgetbook = WidgetbookState.maybeOf(context) != null;
  final enabled =
      !inWidgetbook ||
      context.knobs.boolean(label: 'Enabled', initialValue: true);
  final rtl = inWidgetbook && context.knobs.boolean(label: 'RTL at 200% text');
  DateTime? value = DateTime(2026, 11, 12);
  return Directionality(
    textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
    child: MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(rtl ? 2 : 1)),
      child: Center(
        child: SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setState) => VanillaDatePicker(
              value: value,
              firstDate: DateTime(2026, 11, 5),
              lastDate: DateTime(2027),
              currentDate: DateTime(2026, 11, 6),
              enabled: enabled,
              firstDayOfWeek: DateTime.monday,
              semanticLabel: 'Appointment date',
              isDateUnavailable: (date) =>
                  date.year == 2026 && date.month == 11 && date.day == 18,
              onChanged: (next) => setState(() => value = next),
              formatDate: (date) => '${date.month}/${date.day}/${date.year}',
            ),
          ),
        ),
      ),
    ),
  );
}
