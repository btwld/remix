import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'ui/ui.dart';

/// Run with `flutter run -t lib/calendar_reference.dart`.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) SemanticsBinding.instance.ensureSemantics();
  runApp(const CalendarReferenceApp());
}

/// A no-Material consumer of the shared calendar, using app-owned recipes.
class CalendarReferenceApp extends StatelessWidget {
  const CalendarReferenceApp({super.key});

  @override
  Widget build(BuildContext context) => WidgetsApp(
    title: 'Remix Calendar',
    color: const Color(0xFFFAFAFA),
    debugShowCheckedModeBanner: false,
    textStyle: const TextStyle(fontSize: 14, color: Color(0xFF171717)),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    ),
    builder: (context, child) => PlaygroundTheme(child: child!),
    home: const CalendarReferencePage(),
  );
}

class CalendarReferencePage extends StatefulWidget {
  const CalendarReferencePage({super.key});

  @override
  State<CalendarReferencePage> createState() => _CalendarReferencePageState();
}

enum _CalendarMode { picker, inline }

class _CalendarReferencePageState extends State<CalendarReferencePage> {
  DateTime? _selected = DateTime(2026, 11, 12);
  _CalendarMode _mode = _CalendarMode.picker;
  bool _enabled = true;
  bool _arabic = false;
  bool _largeText = false;

  @override
  Widget build(BuildContext context) {
    final labels = _arabic ? _arabicLabels : const RemixCalendarLabels();
    return Directionality(
      textDirection: _arabic ? TextDirection.rtl : TextDirection.ltr,
      child: MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(_largeText ? 2 : 1)),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 400;
            final padding = compact ? 4.0 : 32.0;
            final panelWidth = (constraints.maxWidth - padding * 2).clamp(
              0.0,
              380.0,
            );
            return Box(
              style: BoxStyler().color(PlaygroundTokens.background()),
              child: SingleChildScrollView(
                child: Center(
                  child: Box(
                    style: BoxStyler()
                        .maxWidth(1000)
                        .padding(.symmetric(horizontal: padding, vertical: 32)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StyledText(
                          'REMIX / CALENDAR',
                          style: TextStyler()
                              .fontSize(12)
                              .fontWeight(FontWeight.w600)
                              .letterSpacing(1.2)
                              .color(PlaygroundTokens.mutedForeground()),
                        ),
                        const SizedBox(height: 12),
                        StyledText(
                          _arabic ? 'اختر تاريخًا' : 'Choose a date',
                          style: TextStyler()
                              .fontSize(32)
                              .fontWeight(FontWeight.w600)
                              .color(PlaygroundTokens.foreground()),
                        ),
                        const SizedBox(height: 12),
                        StyledText(
                          _arabic
                              ? 'عطلة نهاية الأسبوع غير متاحة.'
                              : 'Choose an appointment. Weekends are unavailable.',
                          style: TextStyler()
                              .fontSize(14)
                              .color(PlaygroundTokens.mutedForeground()),
                        ),
                        const SizedBox(height: 24),
                        PlaygroundSegmentedControl<_CalendarMode>(
                          semanticLabel: _arabic
                              ? 'طريقة العرض'
                              : 'Calendar mode',
                          selectedValue: _mode,
                          onChanged: (mode) => setState(() => _mode = mode),
                          items: [
                            RemixSegmentedControlItem(
                              value: _CalendarMode.picker,
                              label: _arabic ? 'منتقي التاريخ' : 'Picker',
                            ),
                            RemixSegmentedControlItem(
                              value: _CalendarMode.inline,
                              label: _arabic ? 'تقويم مضمّن' : 'Inline',
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        if (_mode == _CalendarMode.picker)
                          PlaygroundDatePicker(
                            value: _selected,
                            firstDate: DateTime(2025),
                            lastDate: DateTime(2028, 12, 31),
                            currentDate: DateTime(2026, 11, 6),
                            semanticLabel: _arabic
                                ? 'تاريخ الموعد'
                                : 'Appointment date',
                            placeholder: _arabic
                                ? 'اختر تاريخًا'
                                : 'Select a date',
                            formatDate: (date) =>
                                '${labels.day(date)} ${labels.month(date.month)} '
                                '${labels.year(date.year)}',
                            calendarLabels: labels,
                            firstDayOfWeek: _arabic
                                ? DateTime.saturday
                                : DateTime.monday,
                            enabled: _enabled,
                            isDateUnavailable: _isWeekend,
                            onChanged: (date) =>
                                setState(() => _selected = date),
                          )
                        else
                          SizedBox(
                            width: panelWidth,
                            child: Box(
                              style: BoxStyler()
                                  .color(PlaygroundTokens.card())
                                  .border(
                                    .color(PlaygroundTokens.border()).width(1),
                                  )
                                  .borderRadius(.circular(12))
                                  .padding(.all(compact ? 0 : 12)),
                              child: PlaygroundCalendar(
                                value: _selected,
                                firstDate: DateTime(2025),
                                lastDate: DateTime(2028, 12, 31),
                                currentDate: DateTime(2026, 11, 6),
                                semanticLabel: _arabic
                                    ? 'تاريخ الموعد'
                                    : 'Appointment date',
                                isDateUnavailable: _isWeekend,
                                firstDayOfWeek: _arabic
                                    ? DateTime.saturday
                                    : DateTime.monday,
                                enabled: _enabled,
                                labels: labels,
                                onChanged: (date) =>
                                    setState(() => _selected = date),
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        StyledText(
                          _selected == null
                              ? (_arabic
                                    ? 'لم يتم اختيار تاريخ'
                                    : 'No date selected')
                              : labels.fullDate(_selected!),
                          style: TextStyler()
                              .fontSize(16)
                              .fontWeight(FontWeight.w600)
                              .color(PlaygroundTokens.foreground()),
                        ),
                        const SizedBox(height: 12),
                        StyledText(
                          _arabic
                              ? 'انتقل إلى التقويم بمفتاح Tab. استخدم الأسهم للتنقل '
                                    'ومفتاح Enter للاختيار. يغيّر PageUp وPageDown الشهر. '
                                    'مرّر داخل التقويم لرؤية التواريخ المخفية.'
                              : 'Tab into the calendar. Use arrows to browse and '
                                    'Enter to select. PageUp / PageDown changes months. '
                                    'Scroll within the calendar to reveal hidden dates.',
                          style: TextStyler()
                              .fontSize(13)
                              .color(PlaygroundTokens.mutedForeground()),
                        ),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _control(
                              _enabled
                                  ? 'Disable selection'
                                  : 'Enable selection',
                              () => setState(() => _enabled = !_enabled),
                            ),
                            _control(
                              _arabic ? 'English / LTR' : 'العربية / RTL',
                              () => setState(() => _arabic = !_arabic),
                            ),
                            _control(
                              _largeText ? '100% text' : '200% text',
                              () => setState(() => _largeText = !_largeText),
                            ),
                            _control(
                              'Clear selection',
                              () => setState(() => _selected = null),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _control(String label, VoidCallback onPressed) =>
      PlaygroundButton.outline(
        label: label,
        onPressed: onPressed,
        style: ButtonStyler().minHeight(44),
      );
}

bool _isWeekend(DateTime date) => date.weekday >= DateTime.saturday;

const _arabicMonths = [
  'يناير',
  'فبراير',
  'مارس',
  'أبريل',
  'مايو',
  'يونيو',
  'يوليو',
  'أغسطس',
  'سبتمبر',
  'أكتوبر',
  'نوفمبر',
  'ديسمبر',
];
const _arabicWeekdays = [
  'الاثنين',
  'الثلاثاء',
  'الأربعاء',
  'الخميس',
  'الجمعة',
  'السبت',
  'الأحد',
];

String _digits(int value) => '$value'.split('').map((character) {
  final digit = int.tryParse(character);
  return digit == null ? character : '٠١٢٣٤٥٦٧٨٩'[digit];
}).join();

final _arabicLabels = RemixCalendarLabels(
  previousMonth: 'الشهر السابق',
  nextMonth: 'الشهر التالي',
  chooseMonth: 'اختر الشهر',
  chooseYear: 'اختر السنة',
  today: 'اليوم',
  noDate: 'لم يتم اختيار تاريخ',
  month: (month) => _arabicMonths[month - 1],
  monthYear: (date) => '${_arabicMonths[date.month - 1]} ${_digits(date.year)}',
  fullDate: (date) =>
      '${_arabicWeekdays[date.weekday - 1]}، '
      '${_digits(date.day)} ${_arabicMonths[date.month - 1]} ${_digits(date.year)}',
  weekday: (day) => ['ن', 'ث', 'ر', 'خ', 'ج', 'س', 'ح'][day - 1],
  day: (date) => _digits(date.day),
  year: _digits,
);
