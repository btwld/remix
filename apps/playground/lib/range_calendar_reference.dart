import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'ui/ui.dart';

/// Run with `flutter run -t lib/range_calendar_reference.dart`.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) SemanticsBinding.instance.ensureSemantics();
  runApp(const RangeCalendarReferenceApp());
}

/// Material-free, app-owned reference for inclusive range selection.
class RangeCalendarReferenceApp extends StatelessWidget {
  const RangeCalendarReferenceApp({super.key, this.usePicker = false});

  final bool usePicker;

  @override
  Widget build(BuildContext context) => WidgetsApp(
    title: usePicker ? 'Remix Date Range Picker' : 'Remix Range Calendar',
    color: const Color(0xFFFAFAFA),
    debugShowCheckedModeBanner: false,
    textStyle: const TextStyle(fontSize: 14, color: Color(0xFF171717)),
    pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    ),
    builder: (context, child) => PlaygroundTheme(child: child!),
    // The initial route cannot dismiss itself. Supply its fallback below the
    // route's disabled dismissal action; nearer menu actions still win.
    home: Actions(
      actions: {
        DismissIntent: CallbackAction<DismissIntent>(onInvoke: (_) => null),
      },
      child: RangeCalendarReferencePage(usePicker: usePicker),
    ),
  );
}

class RangeCalendarReferencePage extends StatefulWidget {
  const RangeCalendarReferencePage({super.key, this.usePicker = false});

  final bool usePicker;

  @override
  State<RangeCalendarReferencePage> createState() =>
      _RangeCalendarReferencePageState();
}

class _RangeCalendarReferencePageState
    extends State<RangeCalendarReferencePage> {
  CivilDateRange? _value = CivilDateRange(
    start: DateTime(2026, 11, 10),
    end: DateTime(2026, 11, 13),
  );
  bool _enabled = true;
  bool _arabic = false;
  bool _largeText = false;
  bool _reject = false;
  String? _message;

  @override
  Widget build(BuildContext context) {
    final labels = _arabic ? _arabicLabels : const RemixCalendarLabels();
    String formatRange(CivilDateRange range) =>
        '${labels.day(range.start)} ${labels.month(range.start.month)} – ${labels.day(range.end)} ${labels.month(range.end.month)} ${labels.year(range.end.year)}';
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
            return Box(
              style: BoxStyler().color(PlaygroundTokens.background()),
              child: SingleChildScrollView(
                child: Center(
                  child: Box(
                    style: BoxStyler()
                        .maxWidth(1000)
                        .padding(.symmetric(horizontal: padding, vertical: 24)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StyledText(
                          widget.usePicker
                              ? 'REMIX / DATE RANGE PICKER'
                              : 'REMIX / RANGE CALENDAR',
                          style: TextStyler()
                              .fontSize(12)
                              .fontWeight(FontWeight.w600)
                              .letterSpacing(1.2)
                              .color(PlaygroundTokens.mutedForeground()),
                        ),
                        const SizedBox(height: 12),
                        StyledText(
                          _arabic ? 'اختر فترة' : 'Choose a period',
                          style: TextStyler()
                              .fontSize(30)
                              .fontWeight(FontWeight.w600)
                              .color(PlaygroundTokens.foreground()),
                        ),
                        const SizedBox(height: 8),
                        StyledText(
                          _arabic
                              ? 'اختر بداية الفترة ونهايتها. ١٨ نوفمبر غير متاح.'
                              : 'Choose a start and end date. November 18 is unavailable.',
                          style: TextStyler()
                              .fontSize(14)
                              .color(PlaygroundTokens.mutedForeground()),
                        ),
                        const SizedBox(height: 20),
                        if (widget.usePicker)
                          PlaygroundDateRangePicker(
                            value: _value,
                            firstDate: DateTime(2025),
                            lastDate: DateTime(2028, 12, 31),
                            currentDate: DateTime(2026, 11, 6),
                            semanticLabel: _arabic
                                ? 'فترة التقرير'
                                : 'Reporting period',
                            placeholder: _arabic
                                ? 'اختر فترة'
                                : 'Select a period',
                            formatRange: formatRange,
                            firstDayOfWeek: _arabic
                                ? DateTime.saturday
                                : DateTime.monday,
                            isDateUnavailable: _isUnavailable,
                            enabled: _enabled,
                            calendarLabels: labels,
                            rangeLabels: _arabic
                                ? _arabicRangeLabels
                                : const RemixRangeCalendarLabels(),
                            onChanged: _select,
                          )
                        else
                          SizedBox(
                            width: (constraints.maxWidth - padding * 2).clamp(
                              0.0,
                              380.0,
                            ),
                            child: Box(
                              style: BoxStyler()
                                  .color(PlaygroundTokens.card())
                                  .border(
                                    .color(PlaygroundTokens.border()).width(1),
                                  )
                                  .borderRadius(.circular(12))
                                  .padding(.all(compact ? 0 : 12)),
                              child: PlaygroundRangeCalendar(
                                value: _value,
                                firstDate: DateTime(2025),
                                lastDate: DateTime(2028, 12, 31),
                                currentDate: DateTime(2026, 11, 6),
                                semanticLabel: _arabic
                                    ? 'فترة التقرير'
                                    : 'Reporting period',
                                firstDayOfWeek: _arabic
                                    ? DateTime.saturday
                                    : DateTime.monday,
                                isDateUnavailable: _isUnavailable,
                                enabled: _enabled,
                                labels: labels,
                                rangeLabels: _arabic
                                    ? _arabicRangeLabels
                                    : const RemixRangeCalendarLabels(),
                                onChanged: _select,
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        StyledText(
                          _value == null
                              ? (_arabic
                                    ? 'لم تُحدد فترة'
                                    : 'No period selected')
                              : formatRange(_value!),
                          style: TextStyler()
                              .fontSize(16)
                              .fontWeight(FontWeight.w600)
                              .color(PlaygroundTokens.foreground()),
                        ),
                        if (_message != null) ...[
                          const SizedBox(height: 8),
                          StyledText(
                            _message!,
                            style: TextStyler()
                                .fontSize(14)
                                .color(PlaygroundTokens.foreground()),
                          ),
                        ],
                        const SizedBox(height: 12),
                        StyledText(
                          _arabic
                              ? 'استخدم الأسهم للتنقل وEnter للاختيار وEscape لإلغاء المسودة.'
                              : 'Use arrows to browse, Enter to choose, and Escape to cancel a draft.',
                          style: TextStyler()
                              .fontSize(13)
                              .color(PlaygroundTokens.mutedForeground()),
                        ),
                        const SizedBox(height: 20),
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
                              _reject ? 'Accept requests' : 'Reject requests',
                              () => setState(() => _reject = !_reject),
                            ),
                            _control(
                              'Clear selection',
                              () => setState(() {
                                _value = null;
                                _message = null;
                              }),
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

  bool _isUnavailable(DateTime date) =>
      date.year == 2026 && date.month == 11 && date.day == 18;

  void _select(CivilDateRange next) => setState(() {
    if (_reject) {
      _message = _arabic
          ? 'لم تُقبل الفترة الجديدة. بقيت الفترة السابقة.'
          : 'Request rejected. The previous period is unchanged.';
    } else {
      _value = next;
      _message = null;
    }
  });

  Widget _control(String label, VoidCallback onPressed) =>
      PlaygroundButton.outline(
        label: label,
        onPressed: onPressed,
        style: ButtonStyler().minHeight(44),
      );
}

final _arabicRangeLabels = RemixRangeCalendarLabels(
  noRange: 'لم يتم اختيار فترة',
  rangeValue: (s, e) => 'من $s إلى $e',
  start: 'بداية الفترة',
  end: 'نهاية الفترة',
  draftStart: 'بداية المسودة',
  draftEnd: 'نهاية المسودة',
  draftRange: 'ضمن المسودة',
  chooseStart: 'اختر بداية الفترة',
  chooseEnd: 'اختر نهاية الفترة',
  unavailableRange: 'تحتوي الفترة على يوم غير متاح',
  invalidRange: 'الفترة المحددة غير متاحة',
  selectedRange: (start, end) => 'الفترة المحددة: $start – $end',
);

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
  month: (month) => _arabicMonths[month - 1],
  monthYear: (date) => '${_arabicMonths[date.month - 1]} ${_digits(date.year)}',
  fullDate: (date) =>
      '${_arabicWeekdays[date.weekday - 1]}، '
      '${_digits(date.day)} ${_arabicMonths[date.month - 1]} ${_digits(date.year)}',
  weekday: (day) => ['ن', 'ث', 'ر', 'خ', 'ج', 'س', 'ح'][day - 1],
  day: (date) => _digits(date.day),
  year: _digits,
);
