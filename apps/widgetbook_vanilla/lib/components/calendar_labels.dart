import 'package:remix/remix.dart';

const _months = [
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
String _arabicNumber(int value) =>
    '$value'.split('').map((digit) => '٠١٢٣٤٥٦٧٨٩'[int.parse(digit)]).join();

String formatCalendarSceneDate(DateTime date, {bool rtl = false}) => rtl
    ? '${_arabicNumber(date.day)} ${_months[date.month - 1]} ${_arabicNumber(date.year)}'
    : '${date.month}/${date.day}/${date.year}';

String formatCalendarSceneRange(CivilDateRange range, {bool rtl = false}) {
  final start = formatCalendarSceneDate(range.start, rtl: rtl);
  return compareCivilDates(range.start, range.end) == 0
      ? start
      : '$start – ${formatCalendarSceneDate(range.end, rtl: rtl)}';
}

RemixCalendarLabels calendarSceneLabels(bool rtl) =>
    rtl ? _arabic : const RemixCalendarLabels();
final _arabic = RemixCalendarLabels(
  chooseMonth: 'الشهر',
  chooseYear: 'السنة',
  previousMonth: 'الشهر السابق',
  nextMonth: 'الشهر التالي',
  month: (month) => _months[month - 1],
  year: _arabicNumber,
  day: (date) => _arabicNumber(date.day),
  monthYear: (date) => '${_months[date.month - 1]} ${_arabicNumber(date.year)}',
  fullDate: (date) => formatCalendarSceneDate(date, rtl: true),
  weekday: (day) => ['اث', 'ثل', 'أر', 'خم', 'جم', 'سب', 'أح'][day - 1],
  noDate: 'لم يتم اختيار تاريخ',
);
