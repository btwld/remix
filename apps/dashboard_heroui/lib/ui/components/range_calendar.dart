import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'calendar.dart';

/// The application's RangeCalendar style recipe.
///
/// Remix owns the complete range, local draft and range roles. This recipe
/// paints committed endpoints in primary, interiors in a distinct tint, and
/// the draft with a tinted fill and primary outline. While drafting, the old committed
/// value keeps only its quiet selected treatment. Unavailable draft days use
/// the full-strength destructive text role and remain struck through.
CalendarStyler uiRangeCalendarStyle({
  CalendarStyler style = const CalendarStyler.create(),
}) => uiCalendarStyle()
    .day(
      CalendarDayStyler()
          .onSelected(
            _muted()
                .variant(
                  _committedStart,
                  _shape(start: true).color(UiTokens.surfaceTertiary()),
                )
                .variant(_committedMiddle, _shape())
                .variant(
                  _committedEnd,
                  _shape(end: true).color(UiTokens.surfaceTertiary()),
                )
                .variant(
                  _committedSingle,
                  _shape(
                    start: true,
                    end: true,
                  ).color(UiTokens.surfaceTertiary()),
                ),
          )
          .onRangeMiddle(
            _shape()
                .color(UiTokens.accentSoft())
                .label(.color(UiTokens.foreground())),
          )
          .onRangeStart(_endpoint().merge(_shape(start: true)))
          .onRangeEnd(_endpoint().merge(_shape(end: true)))
          .onRangeSingle(_endpoint().merge(_shape(start: true, end: true)))
          .onRangePreview(
            CalendarDayStyler()
                .color(UiTokens.accentSoft())
                .border(
                  BorderMix(
                    top: _draftStroke,
                    bottom: _draftStroke,
                    left: _none,
                    right: _none,
                  ),
                )
                .label(.color(UiTokens.foreground()))
                .onRangeStart(
                  CalendarDayStyler()
                      .border(.left(_draftStroke))
                      .variant(
                        _rtlDraftStart,
                        CalendarDayStyler().border(
                          BorderMix(left: _none, right: _draftStroke),
                        ),
                      ),
                )
                .onRangeEnd(
                  CalendarDayStyler()
                      .border(.right(_draftStroke))
                      .variant(
                        _rtlDraftEnd,
                        CalendarDayStyler().border(
                          BorderMix(left: _draftStroke, right: _none),
                        ),
                      ),
                )
                .onRangeSingle(CalendarDayStyler().border(.all(_draftStroke))),
          )
          .onDisabled(CalendarDayStyler().onRangePreview(_blockedPreview()))
          .onUnavailable(CalendarDayStyler().onRangePreview(_blockedPreview())),
    )
    .merge(style);

/// A draft that cannot be completed: full-strength `danger` text, no fill.
CalendarDayStyler _blockedPreview() => CalendarDayStyler()
    .color(_blocked())
    .label(.color(UiTokens.danger()))
    .wrap(.opacity(1));

/// The committed range while a new draft is in progress.
CalendarDayStyler _muted() => CalendarDayStyler()
    .color(_quietCommitted())
    .label(.color(UiTokens.muted()));

/// A range endpoint: the solid `accent` fill.
CalendarDayStyler _endpoint() => CalendarDayStyler()
    .color(UiTokens.accent())
    .label(.color(UiTokens.accentForeground()));

/// Rounds the corners at the start and the end of a range; interior days stay
/// square.
CalendarDayStyler _shape({bool start = false, bool end = false}) {
  final radius = BorderRadiusGeometryMix.only(
    topStart: start ? UiTokens.radius3xl() : Radius.zero,
    bottomStart: start ? UiTokens.radius3xl() : Radius.zero,
    topEnd: end ? UiTokens.radius3xl() : Radius.zero,
    bottomEnd: end ? UiTokens.radius3xl() : Radius.zero,
  );
  return CalendarDayStyler().borderRadius(radius);
}

/// Matches a day in the committed range at [position].
///
/// The headless role tracks the draft while drafting, so this reads the
/// committed value instead, for the old selection's geometry.
ContextVariant _committedRole(String name, NakedRangePosition position) =>
    ContextVariant('ui.calendar.committed-$name', (context) {
      final value = NakedRangeCalendarState.maybeOf(context)?.value;
      final day = NakedCalendarDayState.maybeOf(context)?.date;
      if (value == null || day == null || !value.contains(day)) return false;
      final start = compareCivilDates(day, value.start) == 0;
      final end = compareCivilDates(day, value.end) == 0;
      final role = start && end
          ? NakedRangePosition.single
          : start
          ? NakedRangePosition.start
          : end
          ? NakedRangePosition.end
          : NakedRangePosition.middle;
      return role == position;
    });

final _committedStart = _committedRole('start', .start);
final _committedMiddle = _committedRole('middle', .middle);
final _committedEnd = _committedRole('end', .end);
final _committedSingle = _committedRole('single', .single);

final _rtlDraftStart = _RtlDraftEdge(NakedRangePosition.start);
final _rtlDraftEnd = _RtlDraftEdge(NakedRangePosition.end);

/// Matches the draft endpoint at [role] in right-to-left text, where the open
/// edge is on the other side.
///
/// It depends on the selected widget state so Mix ranks it with the draft role
/// it refines; plain context variants run before widget-state-ranked range
/// variants.
final class _RtlDraftEdge extends ContextVariant {
  _RtlDraftEdge(NakedRangePosition role)
    : super(
        'ui.calendar.rtl-draft-${role.name}',
        (context) =>
            Directionality.of(context) == TextDirection.rtl &&
            NakedCalendarDayState.maybeOf(context)?.rangePosition == role,
      );
  @override
  Set<WidgetState> get widgetStateDependencies => const {WidgetState.selected};
}

final _blocked = uiAlpha(UiTokens.danger, 0);

/// The 1px outline of a draft day, on the edges that face outside the draft.
final _draftStroke = BorderSideMix(
  color: UiTokens.accentSoftForeground(),
  width: 1.0,
  style: BorderStyle.solid,
);

/// No outline, on the edges that face the rest of the draft.
final _none = BorderSideMix(
  color: UiTokens.accentSoftForeground(),
  width: 0,
  style: BorderStyle.none,
);

/// The fill of a committed day while a draft is in progress:
/// `surface-tertiary` on the endpoints, `surface-secondary` between them.
final _quietCommitted = ContextToken<Color>((context) {
  final value = NakedRangeCalendarState.maybeOf(context)?.value;
  final day = NakedCalendarDayState.maybeOf(context)?.date;
  final cap =
      value != null &&
      day != null &&
      (compareCivilDates(day, value.start) == 0 ||
          compareCivilDates(day, value.end) == 0);

  return (cap ? UiTokens.surfaceTertiary : UiTokens.surfaceSecondary).resolve(
    context,
  );
});

/// HeroUI reference RangeCalendar composition.
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
    this.labels = uiCalendarLabels,
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
