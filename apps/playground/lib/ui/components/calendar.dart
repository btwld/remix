import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';
import '../theme/effects.dart';
import 'icon_button.dart';
import 'select.dart';

/// The application's Calendar style recipe.
///
/// Remix owns rendering, selection, navigation, focus and date semantics.
/// This supplies theme typography, transparent resting days and the visual
/// states. The inset focus band uses the shared ring tint and stroke without
/// changing layout; a calendar's scrolling grid clips an outside ring.
CalendarStyler playgroundCalendarStyle({
  CalendarStyler style = const CalendarStyler.create(),
}) => CalendarStyler()
    .padding(.all(PlaygroundTokens.s3))
    .headerSpacing(PlaygroundTokens.s2)
    .weekdaySpacing(PlaygroundTokens.s1)
    .rowSpacing(PlaygroundTokens.s0_5)
    .selectorSpacing(PlaygroundTokens.s2)
    .selectorRunSpacing(PlaygroundTokens.s1)
    .heading(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).fontWeight(FontWeight.w600).color(PlaygroundTokens.foreground()),
    )
    .weekday(
      .style(
        PlaygroundTokens.textXs.mix(),
      ).color(PlaygroundTokens.mutedForeground()),
    )
    .day(
      CalendarDayStyler()
          .minWidth(PlaygroundTokens.s12)
          .minHeight(PlaygroundTokens.s12)
          .alignment(.center)
          .color(_clear())
          .border(.color(_clear()).width(PlaygroundTokens.strokeHairline))
          .borderRadius(
            .only(
              topStart: PlaygroundTokens.radiusSm(),
              topEnd: PlaygroundTokens.radiusSm(),
              bottomStart: PlaygroundTokens.radiusSm(),
              bottomEnd: PlaygroundTokens.radiusSm(),
            ),
          )
          .label(
            .style(
              PlaygroundTokens.textSm.mix(),
            ).color(PlaygroundTokens.foreground()),
          )
          .onToday(
            CalendarDayStyler()
                .border(.color(PlaygroundTokens.mutedForeground()))
                .label(.fontWeight(FontWeight.w600)),
          )
          .onSelected(
            CalendarDayStyler()
                .color(PlaygroundTokens.primary())
                .label(.color(PlaygroundTokens.primaryForeground())),
          )
          // Reserve range keys before pointer states: Mix keeps a key's first
          // position when the range recipe supplies its role fragments.
          .onRangeStart(CalendarDayStyler())
          .onRangeMiddle(CalendarDayStyler())
          .onRangeEnd(CalendarDayStyler())
          .onRangeSingle(CalendarDayStyler())
          .onRangePreview(CalendarDayStyler())
          .onHovered(
            CalendarDayStyler()
                .color(PlaygroundTokens.accent())
                .label(.color(PlaygroundTokens.accentForeground()))
                .onSelected(_solidPointer(_primaryHover))
                .onRangeMiddle(
                  CalendarDayStyler()
                      .color(_middleHover())
                      .label(.color(PlaygroundTokens.foreground())),
                )
                .onRangePreview(
                  CalendarDayStyler()
                      .color(_draftHover())
                      .label(.color(PlaygroundTokens.foreground())),
                ),
          )
          .onPressed(
            CalendarDayStyler()
                .color(_pressed())
                .label(.color(PlaygroundTokens.foreground()))
                .onSelected(_solidPointer(_primaryPressed))
                .onRangeMiddle(
                  CalendarDayStyler()
                      .color(_middlePressed())
                      .label(.color(PlaygroundTokens.foreground())),
                )
                .onRangePreview(
                  CalendarDayStyler()
                      .color(_draftPressed())
                      .label(.color(PlaygroundTokens.foreground())),
                ),
          )
          .onFocusVisible(
            CalendarDayStyler()
                .border(.all(.color(_clear()).width(0).style(BorderStyle.none)))
                .containerEffects(
                  RemixBoxEffectsMix(
                    outline: BorderSideMix(
                      color: _focusContour(),
                      width: PlaygroundTokens.strokeIndicator,
                    ),
                    outlineOffset: -PlaygroundTokens.strokeIndicator,
                  ),
                ),
          )
          .onDisabled(
            CalendarDayStyler()
                .label(.color(PlaygroundTokens.mutedForeground()))
                .wrap(.opacity(PlaygroundTokens.disabledOpacity))
                .onSelected(
                  CalendarDayStyler()
                      .color(_quietSelected())
                      .label(.color(PlaygroundTokens.mutedForeground()))
                      .wrap(.opacity(1)),
                ),
          )
          .onUnavailable(
            CalendarDayStyler()
                .label(
                  .color(
                    PlaygroundTokens.mutedForeground(),
                  ).decoration(TextDecoration.lineThrough),
                )
                .wrap(.opacity(1))
                .variant(
                  _calendarDisabled,
                  CalendarDayStyler().wrap(
                    .opacity(PlaygroundTokens.disabledOpacity),
                  ),
                ),
          ),
    )
    .variant(
      _calendarDisabled,
      CalendarStyler()
          .heading(.color(PlaygroundTokens.mutedForeground()))
          .weekday(
            .color(
              PlaygroundTokens.mutedForeground(),
            ).wrap(.opacity(PlaygroundTokens.disabledOpacity)),
          ),
    )
    .merge(style);

final _clear = playgroundTint(PlaygroundTokens.foreground, 0);
final _pressed = playgroundTint(PlaygroundTokens.primary, 0.22, dark: 0.32);
// One inset outline follows the resolved day or range-cap shape.
final _focusContour = ContextToken<Color>((context) {
  final day = NakedCalendarDayState.maybeOf(context);
  final range = NakedRangeCalendarState.maybeOf(context);
  final states = day?.states ?? const <WidgetState>{};
  final solid =
      states.contains(WidgetState.selected) &&
      !states.contains(WidgetState.disabled) &&
      (range == null ||
          (range.preview == null &&
              day?.rangePosition != NakedRangePosition.middle));
  return (solid
          ? PlaygroundTokens.primaryForeground
          : PlaygroundTokens.foreground)
      .resolve(context)
      .withValues(alpha: 0.65);
});

/// Scales the grid when space allows, retaining compact targets in narrow views.
/// Header labels can wrap there; growing the entire grid would hide columns
/// from a vertical-only pointer scroll after initial focus moves the viewport.
double playgroundCalendarDayWidth(BuildContext context) {
  final available =
      MediaQuery.sizeOf(context).width -
      PlaygroundTokens.s3 * 2 -
      PlaygroundTokens.s1 * 2 -
      PlaygroundTokens.strokeHairline * 2 -
      PlaygroundTokens.s2 * 2;
  return math.max(
    PlaygroundTokens.s12,
    math.min(
      MediaQuery.textScalerOf(context).scale(PlaygroundTokens.s12),
      available / DateTime.daysPerWeek,
    ),
  );
}

/// The application's Calendar recipe.
///
/// Remix owns rendering, civil-date selection, keyboard navigation, focus and
/// semantics. This recipe supplies the day states, typography, Playground icon
/// navigation and Select selectors. Selectors retain intrinsic text height.
///
/// CalendarSpec has no generator target, so this facade composes the child
/// recipes by hand and deliberately has no generated part.
class PlaygroundCalendar extends StatelessWidget {
  const PlaygroundCalendar({
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
    this.headerBuilder,
    this.navigationStyle = const IconButtonStyler.create(),
    this.selectorStyle = const SelectStyler.create(),
    this.style = const CalendarStyler.create(),
    this.styleSpec,
  });

  /// Parent-owned selected date, compared by year/month/day fields.
  final DateTime? value;

  /// Inclusive earliest selectable date; time and UTC flag are ignored.
  final DateTime firstDate;

  /// Inclusive latest selectable date, on or after [firstDate].
  final DateTime lastDate;

  /// Requests a selected date. Null disables the calendar.
  ///
  /// The parent decides whether to accept it by updating [value].
  final ValueChanged<DateTime>? onChanged;

  /// Today, for the `onToday` variant and fallback focus; defaults to now.
  final DateTime? currentDate;

  /// Marks in-range dates unselectable; they stay keyboard-focusable.
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

  /// Caller-owned labels and date formatters; English by default.
  final RemixCalendarLabels labels;

  /// Replaces header visuals/navigation only. Day behavior remains owned.
  final Widget Function(BuildContext, NakedCalendarState)? headerBuilder;

  /// Independent button styling, resolved in each navigation button state.
  final IconButtonStyler navigationStyle;

  /// Independent month/year selector styling.
  final SelectStyler selectorStyle;

  /// Calendar and day styling, resolved in each part's own state.
  final CalendarStyler style;

  /// Raw resolved spec; bypasses [style] and inherited styles.
  final CalendarSpec? styleSpec;

  /// Creates a [CalendarStyler], for `RemixCalendar.styleFrom(...)`.
  static const styleFrom = CalendarStyler.new;

  @override
  Widget build(BuildContext context) => RemixCalendar(
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
    navigationStyle: playgroundIconButtonStyle(
      variant: .ghost,
      style: IconButtonStyler()
          .size(
            playgroundCalendarDayWidth(context),
            playgroundCalendarDayWidth(context),
          )
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
    style: playgroundCalendarStyle(
      style: CalendarStyler()
          .day(
            CalendarDayStyler()
                .minWidth(playgroundCalendarDayWidth(context))
                .minHeight(playgroundCalendarDayWidth(context)),
          )
          .merge(style),
    ),
    styleSpec: styleSpec,
  );
}

final _calendarDisabled = ContextVariant(
  'playground.calendar.disabled',
  (context) =>
      (NakedCalendarState.maybeOf(context)?.states ??
              NakedRangeCalendarState.maybeOf(context)?.states ??
              const <WidgetState>{})
          .contains(WidgetState.disabled),
);

CalendarDayStyler _solidPointer(ContextToken<Color> fill) => CalendarDayStyler()
    .color(fill())
    .label(.color(PlaygroundTokens.primaryForeground()));
final _primaryHover = playgroundTint(PlaygroundTokens.primary, .9);
final _primaryPressed = playgroundTint(PlaygroundTokens.primary, .8);
final _middleHover = playgroundTint(PlaygroundTokens.primary, .15, dark: .32);
final _middlePressed = playgroundTint(PlaygroundTokens.primary, .22, dark: .4);
final _draftHover = playgroundTint(PlaygroundTokens.primary, .18, dark: .28);
final _draftPressed = playgroundTint(PlaygroundTokens.primary, .24, dark: .36);
final _quietSelected = ContextToken<Color>((context) {
  final value = NakedRangeCalendarState.maybeOf(context)?.value;
  if (value == null) return _quietSingle.resolve(context);
  final day = NakedCalendarDayState.maybeOf(context)?.date;
  final cap =
      day != null &&
      (compareCivilDates(day, value.start) == 0 ||
          compareCivilDates(day, value.end) == 0);
  return (cap ? _quietCap : _quietMiddle).resolve(context);
});
final _quietSingle = playgroundTint(PlaygroundTokens.primary, .12, dark: .2);
final _quietCap = playgroundTint(PlaygroundTokens.primary, .09, dark: .16);
final _quietMiddle = playgroundTint(PlaygroundTokens.primary, .07, dark: .12);
