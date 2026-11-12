import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';
import '../theme/effects.dart';
import 'icon_button.dart';
import 'select.dart';
import 'calendar.dart';

/// The application's RangeCalendar style recipe.
///
/// Committed endpoints are `primary`, interiors a tint, and the draft a tinted
/// fill with a `primary` outline. While drafting, the old committed value keeps
/// only a quiet selected look. Unavailable draft days are struck through in
/// full-strength `destructive`.
CalendarStyler vanillaRangeCalendarStyle({
  CalendarStyler style = const CalendarStyler.create(),
}) => vanillaCalendarStyle()
    .day(
      CalendarDayStyler()
          .onSelected(
            _muted()
                .variant(_committedStart, _quietCap(start: true))
                .variant(_committedMiddle, _shape())
                .variant(_committedEnd, _quietCap(end: true))
                .variant(_committedSingle, _quietCap(start: true, end: true)),
          )
          .onRangeMiddle(
            _shape()
                .color(vanillaTint(VanillaTokens.primary, 0.09, dark: 0.24)())
                .label(.color(VanillaTokens.foreground())),
          )
          .onRangeStart(_endpoint().merge(_shape(start: true)))
          .onRangeEnd(_endpoint().merge(_shape(end: true)))
          .onRangeSingle(_endpoint().merge(_shape(start: true, end: true)))
          .onRangePreview(
            CalendarDayStyler()
                .color(vanillaTint(VanillaTokens.primary, 0.12, dark: 0.28)())
                .border(
                  BorderMix(
                    top: _draftStroke,
                    bottom: _draftStroke,
                    left: _none,
                    right: _none,
                  ),
                )
                .label(.color(VanillaTokens.foreground()))
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

CalendarDayStyler _blockedPreview() => CalendarDayStyler()
    .color(vanillaTint(VanillaTokens.destructive, 0, dark: 0)())
    .label(.color(VanillaTokens.destructive()))
    .wrap(.opacity(1));

CalendarDayStyler _muted() => CalendarDayStyler()
    .color(vanillaTint(VanillaTokens.primary, .07, dark: .12)())
    .label(.color(VanillaTokens.mutedForeground()));

CalendarDayStyler _endpoint() => CalendarDayStyler()
    .color(VanillaTokens.primary())
    .label(.color(VanillaTokens.primaryForeground()));

/// A committed endpoint while a draft is in progress: the quiet cap tint.
CalendarDayStyler _quietCap({bool start = false, bool end = false}) => _shape(
  start: start,
  end: end,
).color(vanillaTint(VanillaTokens.primary, .09, dark: .16)());

/// Rounds the corners at the ends of a range and squares the rest.
CalendarDayStyler _shape({bool start = false, bool end = false}) {
  final radius = BorderRadiusGeometryMix.only(
    topStart: start ? VanillaTokens.radiusSm() : Radius.zero,
    bottomStart: start ? VanillaTokens.radiusSm() : Radius.zero,
    topEnd: end ? VanillaTokens.radiusSm() : Radius.zero,
    bottomEnd: end ? VanillaTokens.radiusSm() : Radius.zero,
  );
  return CalendarDayStyler().borderRadius(radius);
}

// The headless role tracks the draft while drafting, so these read the
// committed snapshot, only for the old selection's geometry.
ContextVariant _committedRole(String name, NakedRangePosition position) =>
    ContextVariant('vanilla.calendar.committed-$name', (context) {
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
// Ranked with the draft role they refine: Mix runs plain context variants
// before widget-state-ranked range variants.
final _rtlDraftStart = _RtlDraftEdge(NakedRangePosition.start);
final _rtlDraftEnd = _RtlDraftEdge(NakedRangePosition.end);

final class _RtlDraftEdge extends ContextVariant {
  _RtlDraftEdge(NakedRangePosition role)
    : super(
        'vanilla.calendar.rtl-draft-${role.name}',
        (context) =>
            Directionality.of(context) == TextDirection.rtl &&
            NakedCalendarDayState.maybeOf(context)?.rangePosition == role,
      );
  @override
  Set<WidgetState> get widgetStateDependencies => const {WidgetState.selected};
}

/// The draft's `primary` outline at 60%, and the same color with no width for
/// the edges that draw none.
final _draftStroke = BorderSideMix(
  color: vanillaTint(VanillaTokens.primary, 0.6)(),
  width: VanillaTokens.strokeHairline,
  style: BorderStyle.solid,
);
final _none = BorderSideMix(
  color: vanillaTint(VanillaTokens.primary, 0.6)(),
  width: 0,
  style: BorderStyle.none,
);

/// The application's RangeCalendar recipe, wiring [vanillaRangeCalendarStyle],
/// the ghost icon button and the Select recipe.
///
/// `CalendarSpec` has no generator target, so this facade composes the child
/// recipes by hand and has no generated part.
class VanillaRangeCalendar extends StatelessWidget {
  const VanillaRangeCalendar({
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
    rangeLabels: rangeLabels,
    headerBuilder: headerBuilder,
    navigationStyle: vanillaIconButtonStyle(
      variant: .ghost,
      style: IconButtonStyler()
          .size(
            vanillaCalendarDayWidth(context),
            vanillaCalendarDayWidth(context),
          )
          .icon(
            .size(MediaQuery.textScalerOf(context).scale(VanillaTokens.icon)),
          )
          .merge(navigationStyle),
    ),
    selectorStyle: vanillaSelectStyle(
      style: SelectStyler()
          .content(vanillaCalendarSelectorContentStyle())
          .trigger(
            SelectTriggerStyler()
                .indicator(
                  .size(
                    MediaQuery.textScalerOf(context).scale(VanillaTokens.s2_5),
                  ),
                )
                .minHeight(vanillaCalendarDayWidth(context))
                .maxWidth(double.infinity)
                .minWidth(
                  MediaQuery.textScalerOf(
                    context,
                  ).scale(VanillaTokens.s16 + VanillaTokens.s12),
                ),
          )
          .merge(selectorStyle),
    ),
    style: vanillaRangeCalendarStyle(
      style: CalendarStyler()
          .day(
            CalendarDayStyler()
                .minWidth(vanillaCalendarDayWidth(context))
                .minHeight(vanillaCalendarDayWidth(context)),
          )
          .merge(style),
    ),
    styleSpec: styleSpec,
    summaryBuilder: summaryBuilder,
  );
}
