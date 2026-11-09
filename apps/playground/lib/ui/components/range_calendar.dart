import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';
import '../theme/effects.dart';
import 'icon_button.dart';
import 'select.dart';
import 'calendar.dart';

/// The application's RangeCalendar style recipe.
///
/// Remix owns the complete range, local draft and range roles. This recipe
/// paints committed endpoints in primary, interiors in a distinct tint, and the draft
/// with a tinted fill and primary outline. While drafting, the old committed
/// value keeps only its quiet selected treatment. Unavailable draft days use
/// the full-strength destructive text role and remain struck through.
CalendarStyler playgroundRangeCalendarStyle({
  CalendarStyler style = const CalendarStyler.create(),
}) => playgroundCalendarStyle()
    .day(
      CalendarDayStyler()
          .onSelected(
            _muted()
                .variant(_committedStart, _shape(start: true))
                .variant(_committedMiddle, _shape())
                .variant(_committedEnd, _shape(end: true))
                .variant(_committedSingle, _shape(start: true, end: true)),
          )
          .onRangeMiddle(
            _shape()
                .color(_middle())
                .label(.color(PlaygroundTokens.foreground())),
          )
          .onRangeStart(_endpoint().merge(_shape(start: true)))
          .onRangeEnd(_endpoint().merge(_shape(end: true)))
          .onRangeSingle(_endpoint().merge(_shape(start: true, end: true)))
          .onRangePreview(
            CalendarDayStyler()
                .color(_draft())
                .border(
                  BorderMix(
                    top: _draftStroke,
                    bottom: _draftStroke,
                    left: _none,
                    right: _none,
                  ),
                )
                .label(.color(PlaygroundTokens.foreground()))
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
    .color(_blocked())
    .label(.color(PlaygroundTokens.destructive()))
    .wrap(.opacity(1));

CalendarDayStyler _muted() => CalendarDayStyler()
    .color(PlaygroundTokens.muted())
    .label(.color(PlaygroundTokens.mutedForeground()));

CalendarDayStyler _endpoint() => CalendarDayStyler()
    .color(PlaygroundTokens.primary())
    .label(.color(PlaygroundTokens.primaryForeground()));

CalendarDayStyler _shape({bool start = false, bool end = false}) {
  final radius = BorderRadiusGeometryMix.only(
    topStart: start ? PlaygroundTokens.radiusSm() : Radius.zero,
    bottomStart: start ? PlaygroundTokens.radiusSm() : Radius.zero,
    topEnd: end ? PlaygroundTokens.radiusSm() : Radius.zero,
    bottomEnd: end ? PlaygroundTokens.radiusSm() : Radius.zero,
  );
  return CalendarDayStyler().borderRadius(radius);
}

// The headless role tracks the draft while drafting. Read the committed
// snapshot only for the old selection's geometry, reusing the same shapes.
ContextVariant _committedRole(String name, NakedRangePosition position) =>
    ContextVariant('playground.calendar.committed-$name', (context) {
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
// Rank the directional override with the draft role it refines; plain
// context variants run before widget-state-ranked range variants in Mix.
final _rtlDraftStart = _RtlDraftEdge(NakedRangePosition.start);
final _rtlDraftEnd = _RtlDraftEdge(NakedRangePosition.end);

final class _RtlDraftEdge extends ContextVariant {
  _RtlDraftEdge(NakedRangePosition role)
    : super(
        'playground.calendar.rtl-draft-${role.name}',
        (context) =>
            Directionality.of(context) == TextDirection.rtl &&
            NakedCalendarDayState.maybeOf(context)?.rangePosition == role,
      );
  @override
  Set<WidgetState> get widgetStateDependencies => const {WidgetState.selected};
}

final _middle = playgroundTint(PlaygroundTokens.primary, 0.09, dark: 0.24);
final _draft = playgroundTint(PlaygroundTokens.primary, 0.12, dark: 0.2);
final _draftBorder = playgroundTint(PlaygroundTokens.primary, 0.6);
final _blocked = playgroundTint(PlaygroundTokens.destructive, 0, dark: 0);
final _draftStroke = BorderSideMix(
  color: _draftBorder(),
  width: PlaygroundTokens.strokeHairline,
  style: BorderStyle.solid,
);
final _none = BorderSideMix(
  color: _draftBorder(),
  width: 0,
  style: BorderStyle.none,
);

/// The application's RangeCalendar recipe.
///
/// Remix owns rendering, civil-date selection, keyboard navigation, focus and
/// semantics. This recipe supplies the day states, typography, Playground icon
/// navigation and Select selectors. Selectors retain intrinsic text height.
///
/// CalendarSpec has no generator target, so this facade composes the child
/// recipes by hand and deliberately has no generated part.
class PlaygroundRangeCalendar extends StatelessWidget {
  const PlaygroundRangeCalendar({
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
    navigationStyle: playgroundIconButtonStyle(
      variant: .ghost,
      style: IconButtonStyler()
          .size(PlaygroundTokens.s12, PlaygroundTokens.s12)
          .margin(.symmetric(vertical: PlaygroundTokens.s1))
          .icon(
            .size(
              MediaQuery.textScalerOf(context).scale(PlaygroundTokens.icon),
            ),
          )
          .merge(navigationStyle),
    ),
    selectorStyle: playgroundSelectStyle(
      style: SelectStyler()
          .trigger(
            SelectTriggerStyler()
                .indicator(
                  .size(
                    MediaQuery.textScalerOf(
                      context,
                    ).scale(PlaygroundTokens.s2_5),
                  ),
                )
                .minHeight(
                  MediaQuery.textScalerOf(
                    context,
                  ).scale(PlaygroundTokens.controlMd),
                )
                .maxWidth(double.infinity)
                .minWidth(
                  MediaQuery.textScalerOf(
                    context,
                  ).scale(PlaygroundTokens.s16 + PlaygroundTokens.s12),
                ),
          )
          .merge(selectorStyle),
    ),
    style: playgroundRangeCalendarStyle(
      style: CalendarStyler()
          .day(
            CalendarDayStyler().minWidth(playgroundCalendarDayWidth(context)),
          )
          .merge(style),
    ),
    styleSpec: styleSpec,
    summaryBuilder: summaryBuilder,
  );
}
