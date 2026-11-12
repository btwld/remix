import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'calendar.dart';

/// The range calendar's padding, text and day states: today, the committed
/// range, the draft preview, hover, press and focus. Shared by the range
/// calendar and the date range picker.
CalendarStyler uiRangeCalendarStyle({
  CalendarStyler style = const CalendarStyler.create(),
}) => CalendarStyler()
    .padding(.all(UiTokens.space3()))
    .headerSpacing(UiTokens.space2())
    .weekdaySpacing(UiTokens.space1())
    .rowSpacing(UiTokens.space1())
    .weekday(TextStyler().style(UiTokens.text1.mix()).color(UiTokens.gray11()))
    .onDisabled(CalendarStyler().weekday(TextStyler().color(UiTokens.gray9())))
    .day(
      CalendarDayStyler()
          .label(TextStyler().style(UiTokens.text2.mix()))
          .border(BorderMix.all(BorderSideMix.none))
          .onToday(
            CalendarDayStyler()
                .border(
                  BorderMix.all(
                    BorderSideMix(
                      color: UiTokens.gray10(),
                      width: UiTokens.borderWidth1(),
                      style: .solid,
                    ),
                  ),
                )
                .borderRadius(
                  BorderRadiusDirectionalMix.all(UiTokens.radius3()),
                )
                .label(
                  TextStyler()
                      .color(UiTokens.gray12())
                      .fontWeight(UiTokens.fontWeightBold()),
                ),
          )
          .onSelected(
            CalendarDayStyler()
                .color(_quietCommitted())
                .borderRadius(BorderRadiusDirectionalMix.circular(0))
                .variant(
                  _committedStart,
                  CalendarDayStyler().borderRadius(
                    .only(
                      topStart: UiTokens.radius3(),
                      bottomStart: UiTokens.radius3(),
                      topEnd: Radius.zero,
                      bottomEnd: Radius.zero,
                    ),
                  ),
                )
                .variant(
                  _committedEnd,
                  CalendarDayStyler().borderRadius(
                    .only(
                      topEnd: UiTokens.radius3(),
                      bottomEnd: UiTokens.radius3(),
                      topStart: Radius.zero,
                      bottomStart: Radius.zero,
                    ),
                  ),
                )
                .variant(
                  _committedSingle,
                  CalendarDayStyler().borderRadius(
                    BorderRadiusDirectionalMix.all(UiTokens.radius3()),
                  ),
                )
                .label(TextStyler().color(UiTokens.gray11())),
          )
          .onDisabled(
            CalendarDayStyler().label(TextStyler().color(UiTokens.gray9())),
          )
          .onUnavailable(
            CalendarDayStyler().label(
              TextStyler().decoration(TextDecoration.lineThrough),
            ),
          )
          // Committed fills come from range roles. While drafting,
          // the old selection retains a quiet band and slightly stronger caps.
          .onRangeMiddle(
            CalendarDayStyler()
                .borderRadius(BorderRadiusDirectionalMix.circular(0))
                .color(UiTokens.accent4())
                .label(TextStyler().color(UiTokens.gray12()))
                .onDisabled(_mutedMiddle),
          )
          .onRangeStart(
            _endpoint.borderRadius(
              .only(
                topStart: UiTokens.radius3(),
                bottomStart: UiTokens.radius3(),
                topEnd: Radius.zero,
                bottomEnd: Radius.zero,
              ),
            ),
          )
          .onRangeEnd(
            _endpoint.borderRadius(
              .only(
                topEnd: UiTokens.radius3(),
                bottomEnd: UiTokens.radius3(),
                topStart: Radius.zero,
                bottomStart: Radius.zero,
              ),
            ),
          )
          .onRangeSingle(
            _endpoint.borderRadius(
              BorderRadiusDirectionalMix.all(UiTokens.radius3()),
            ),
          )
          // Preview follows the caps so the draft has its own treatment.
          .onRangePreview(
            CalendarDayStyler()
                .color(UiTokens.accent4())
                .border(
                  BorderMix(
                    top: _draftStroke,
                    bottom: _draftStroke,
                    left: _draftNone,
                    right: _draftNone,
                  ),
                )
                .label(TextStyler().color(UiTokens.accent12()))
                .onRangeStart(
                  CalendarDayStyler()
                      .color(UiTokens.accent5())
                      .border(.left(_draftStroke))
                      .onRtl(
                        CalendarDayStyler().border(
                          BorderMix(left: _draftNone, right: _draftStroke),
                        ),
                      ),
                )
                .onRangeEnd(
                  CalendarDayStyler()
                      .color(UiTokens.accent5())
                      .border(.right(_draftStroke))
                      .onRtl(
                        CalendarDayStyler().border(
                          BorderMix(left: _draftStroke, right: _draftNone),
                        ),
                      ),
                )
                .onRangeSingle(
                  CalendarDayStyler()
                      .color(UiTokens.accent5())
                      .border(BorderMix.all(_draftStroke)),
                )
                .onDisabled(
                  CalendarDayStyler()
                      .color(UiTokens.error3())
                      .label(TextStyler().color(UiTokens.error11())),
                ),
          )
          .onHovered(_pointer(pressed: false))
          .onPressed(_pointer(pressed: true))
          .onFocusVisible(
            CalendarDayStyler()
                .border(.all(_focusStroke))
                .onRangeMiddle(_focusEdges())
                .onRangeStart(_focusEdges(start: true))
                .onRangeEnd(_focusEdges(end: true)),
          ),
    )
    .merge(style);

/// A range's first and last day: the solid fill, muted when disabled.
final _endpoint = CalendarDayStyler()
    .color(UiTokens.accentSolid())
    .label(TextStyler().color(UiTokens.accentContrast()))
    .onDisabled(_mutedRange);

/// A disabled day in the middle of a range.
final _mutedMiddle = CalendarDayStyler()
    .color(UiTokens.gray3())
    .label(TextStyler().color(UiTokens.gray11()));

/// A disabled first or last day of a range.
final _mutedRange = CalendarDayStyler()
    .color(UiTokens.gray4())
    .label(TextStyler().color(UiTokens.gray11()));

// Physical borders support square middles in Flutter; mirror cap edges in RTL.
final _draftStroke = BorderSideMix(
  color: UiTokens.accent8(),
  width: 2,
  style: .solid,
);

final _draftNone = BorderSideMix(
  color: UiTokens.accent8(),
  width: 0,
  style: .none,
);

/// The fill under the pointer (or pressed), for each place a day can have in
/// the range.
CalendarDayStyler _pointer({required bool pressed}) => CalendarDayStyler()
    .color(pressed ? UiTokens.gray6() : UiTokens.gray4())
    .onSelected(
      CalendarDayStyler().color(pressed ? UiTokens.gray4() : UiTokens.gray3()),
    )
    .onRangeStart(
      CalendarDayStyler().color((pressed ? _capPressed : _capHover)()),
    )
    .onRangeEnd(
      CalendarDayStyler().color((pressed ? _capPressed : _capHover)()),
    )
    .onRangeSingle(
      CalendarDayStyler().color((pressed ? _capPressed : _capHover)()),
    )
    .onRangeMiddle(
      CalendarDayStyler().color(
        pressed ? UiTokens.accent6() : UiTokens.accent5(),
      ),
    )
    .onRangePreview(
      CalendarDayStyler().color(
        pressed ? UiTokens.accent5() : UiTokens.accent4(),
      ),
    );

/// A range cap's fill while hovered: the solid fill at 90%.
final _capHover = ContextToken<Color>(
  (context) => UiTokens.accentSolid.resolve(context).withValues(alpha: .9),
);

/// A range cap's fill while pressed: the solid fill at 80%.
final _capPressed = ContextToken<Color>(
  (context) => UiTokens.accentSolid.resolve(context).withValues(alpha: .8),
);

final _focusStroke = BorderSideMix(
  color: uiCalendarFocusColor(),
  width: 2,
  style: .solid,
);

CalendarDayStyler _focusEdges({bool start = false, bool end = false}) =>
    CalendarDayStyler()
        .border(
          BorderMix(
            top: _focusStroke,
            bottom: _focusStroke,
            left: start ? _focusStroke : _draftNone,
            right: end ? _focusStroke : _draftNone,
          ),
        )
        .onRtl(
          CalendarDayStyler().border(
            BorderMix(
              top: _focusStroke,
              bottom: _focusStroke,
              left: end ? _focusStroke : _draftNone,
              right: start ? _focusStroke : _draftNone,
            ),
          ),
        );

/// The committed range's fill. The live roles follow the draft, so this reads
/// the parent-owned value to keep the old range's geometry while drafting.
final _quietCommitted = ContextToken<Color>((context) {
  final value = NakedRangeCalendarState.maybeOf(context)?.value;
  final day = NakedCalendarDayState.maybeOf(context)?.date;
  final cap =
      value != null &&
      day != null &&
      (compareCivilDates(day, value.start) == 0 ||
          compareCivilDates(day, value.end) == 0);
  final dark = UiTheme.of(context).isDark;
  return (cap
          ? (dark ? _quietDarkCap : UiTokens.gray4)
          : (dark ? _quietDarkMiddle : UiTokens.gray3))
      .resolve(context);
});

/// Matches a day that has [position] in the committed range.
ContextVariant _committedRole(String name, NakedRangePosition position) =>
    ContextVariant('ui.calendar.committed-$name', (context) {
      final value = NakedRangeCalendarState.maybeOf(context)?.value;
      final day = NakedCalendarDayState.maybeOf(context)?.date;
      if (value == null || day == null || !value.contains(day)) return false;
      final start = compareCivilDates(day, value.start) == 0;
      final end = compareCivilDates(day, value.end) == 0;
      return (start && end
              ? NakedRangePosition.single
              : start
              ? NakedRangePosition.start
              : end
              ? NakedRangePosition.end
              : NakedRangePosition.middle) ==
          position;
    });

final _committedStart = _committedRole('start', .start);
final _committedEnd = _committedRole('end', .end);
final _committedSingle = _committedRole('single', .single);

/// Ui's RangeCalendar composition.
///
/// Remix owns civil-date selection, focus, keyboard navigation and semantics.
/// Multiple independent child styles require a hand-written facade; caller
/// overrides merge last and there is no generated adapter.
class UiRangeCalendar extends StatelessWidget {
  const UiRangeCalendar({
    super.key,
    required this.value,
    required this.firstDate,
    required this.lastDate,
    this.onChanged,
    this.currentDate,
    this.isDateUnavailable,
    this.firstDayOfWeek = DateTime.sunday,
    this.enabled = true,
    this.semanticLabel,
    this.focusNode,
    this.autofocus = false,
    this.labels = const RemixCalendarLabels(),
    this.rangeLabels = const RemixRangeCalendarLabels(),
    this.headerBuilder,
    this.navigationStyle = const IconButtonStyler.create(),
    this.selectorStyle = const SelectStyler.create(),
    this.style = const CalendarStyler.create(),
    this.styleSpec,
    this.summaryBuilder,
  });

  /// Parent-owned complete inclusive range, compared by civil fields.
  ///
  /// It is never clamped or corrected; an invalid value stays selected.
  final CivilDateRange? value;

  /// Inclusive earliest selectable date; time and UTC flag are ignored.
  final DateTime firstDate;

  /// Inclusive latest selectable date, on or after [firstDate].
  final DateTime lastDate;

  /// Requests one complete range. Null disables the calendar.
  ///
  /// The parent decides whether to accept it by updating [value].
  final ValueChanged<CivilDateRange>? onChanged;

  /// Today, for the `onToday` variant and fallback focus; defaults to now.
  final DateTime? currentDate;

  /// Marks in-range dates unavailable. A range cannot include them, even
  /// offscreen; they stay keyboard-focusable. Rebuild when results change.
  final bool Function(DateTime)? isDateUnavailable;

  /// First weekday column, from Monday=1 through Sunday=7.
  final int firstDayOfWeek;

  /// Whether navigation, focus and selection are enabled.
  final bool enabled;

  /// Accessible name of the calendar group.
  final String? semanticLabel;

  /// Focus entry point; requesting it focuses the current day.
  final FocusNode? focusNode;

  /// Whether to focus the current day on mount.
  final bool autofocus;

  /// Caller-owned date labels and formatters; English by default.
  final RemixCalendarLabels labels;

  /// Caller-owned range roles, instructions and joiners; English by default.
  final RemixRangeCalendarLabels rangeLabels;

  /// Replaces header visuals/navigation only. Day behavior remains owned.
  final Widget Function(BuildContext, NakedRangeCalendarState)? headerBuilder;

  /// Independent button styling, resolved in each navigation button state.
  final IconButtonStyler navigationStyle;

  /// Independent month/year selector styling.
  final SelectStyler selectorStyle;

  /// Calendar and day styling, including the range day variants.
  final CalendarStyler style;

  /// Raw resolved spec; bypasses [style] and inherited styles.
  ///
  /// A resolved spec carries no variants, so every day renders its `day` spec:
  /// selection, availability and range positions are not painted. Use [style]
  /// for state and range styling.
  final CalendarSpec? styleSpec;

  /// Paints the range summary: the selected range, the next instruction and
  /// any availability problem.
  ///
  /// By default the summary is not painted; it is a live region for assistive
  /// technology only. A builder makes it visible and keeps it live.
  final Widget Function(BuildContext context, String summary)? summaryBuilder;

  /// Creates a [CalendarStyler], for `RemixRangeCalendar.styleFrom(...)`.
  static const styleFrom = CalendarStyler.new;

  @override
  Widget build(BuildContext context) => RemixRangeCalendar(
    value: value,
    firstDate: firstDate,
    lastDate: lastDate,
    onChanged: onChanged,
    currentDate: currentDate,
    isDateUnavailable: isDateUnavailable,
    firstDayOfWeek: firstDayOfWeek,
    enabled: enabled,
    semanticLabel: semanticLabel,
    focusNode: focusNode,
    autofocus: autofocus,
    labels: labels,
    headerBuilder: headerBuilder,
    rangeLabels: rangeLabels,
    summaryBuilder: summaryBuilder,
    navigationStyle: uiCalendarNavigationStyle(context).merge(navigationStyle),
    selectorStyle: uiCalendarSelectorStyle(context).merge(selectorStyle),
    style: uiRangeCalendarStyle(
      style: uiCalendarGeometry(context).merge(style),
    ),
    styleSpec: styleSpec,
  );
}

// Keep the stale middle visible above the dark page without reaching its caps.
final _quietDarkMiddle = ContextToken<Color>(
  (context) => Color.lerp(
    UiTokens.gray2.resolve(context),
    UiTokens.gray3.resolve(context),
    .75,
  )!,
);

final _quietDarkCap = ContextToken<Color>(
  (context) => Color.lerp(
    UiTokens.gray3.resolve(context),
    UiTokens.gray4.resolve(context),
    .25,
  )!,
);
