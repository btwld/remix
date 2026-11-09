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
CalendarStyler vanillaCalendarStyle({
  CalendarStyler style = const CalendarStyler.create(),
}) => CalendarStyler()
    .padding(.all(VanillaTokens.s3))
    .selectorSpacing(VanillaTokens.s2)
    .selectorRunSpacing(VanillaTokens.s1)
    .heading(
      .style(
        VanillaTokens.textSm.mix(),
      ).fontWeight(FontWeight.w600).color(VanillaTokens.foreground()),
    )
    .weekday(
      .style(VanillaTokens.textXs.mix()).color(VanillaTokens.mutedForeground()),
    )
    .day(
      CalendarDayStyler()
          .minWidth(VanillaTokens.s12)
          .minHeight(VanillaTokens.s12)
          .alignment(.center)
          .color(_clear())
          .border(.color(_clear()).width(VanillaTokens.strokeHairline))
          .borderRadius(
            .only(
              topStart: VanillaTokens.radiusSm(),
              topEnd: VanillaTokens.radiusSm(),
              bottomStart: VanillaTokens.radiusSm(),
              bottomEnd: VanillaTokens.radiusSm(),
            ),
          )
          .label(
            .style(
              VanillaTokens.textSm.mix(),
            ).color(VanillaTokens.foreground()),
          )
          .onToday(
            CalendarDayStyler()
                .border(.color(VanillaTokens.input()))
                .label(.fontWeight(FontWeight.w600)),
          )
          .onSelected(
            CalendarDayStyler()
                .color(VanillaTokens.primary())
                .label(.color(VanillaTokens.primaryForeground())),
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
                .color(VanillaTokens.accent())
                .label(.color(VanillaTokens.accentForeground())),
          )
          .onPressed(
            CalendarDayStyler()
                .color(_pressed())
                .label(.color(VanillaTokens.foreground())),
          )
          .onFocusVisible(
            CalendarDayStyler()
                .border(
                  .all(
                    .width(
                      VanillaTokens.strokeHairline,
                    ).style(BorderStyle.solid),
                  ),
                )
                .border(vanillaFocusBorder())
                .containerEffects(
                  vanillaFocusRing(inset: true).overContent(
                    .shadows([
                      RemixBoxShadowMix(
                        kind: .inset,
                        color: _focusContour(),
                        spreadRadius: VanillaTokens.strokeHairline,
                        shapeInset: VanillaTokens.strokeRing,
                      ),
                    ]),
                  ),
                ),
          )
          .onDisabled(
            CalendarDayStyler()
                .label(.color(VanillaTokens.mutedForeground()))
                .wrap(.opacity(VanillaTokens.disabledOpacity))
                .onSelected(CalendarDayStyler().color(VanillaTokens.muted())),
          )
          .onUnavailable(
            CalendarDayStyler()
                .label(
                  .color(
                    VanillaTokens.mutedForeground(),
                  ).decoration(TextDecoration.lineThrough),
                )
                .wrap(.opacity(1))
                .variant(
                  _calendarDisabled,
                  CalendarDayStyler().wrap(
                    .opacity(VanillaTokens.disabledOpacity),
                  ),
                ),
          ),
    )
    .variant(
      _calendarDisabled,
      CalendarStyler()
          .heading(.color(VanillaTokens.mutedForeground()))
          .weekday(
            .color(
              VanillaTokens.mutedForeground(),
            ).wrap(.opacity(VanillaTokens.disabledOpacity)),
          ),
    )
    .merge(style);

final _clear = vanillaTint(VanillaTokens.foreground, 0);
final _pressed = vanillaTint(VanillaTokens.primary, 0.22, dark: 0.32);
// A thin inner keyline supplies calendar-local contrast where the shared
// half-strength ring is too faint. Keep the token border and band unchanged.
final _focusContour = ContextToken<Color>((context) {
  final day = NakedCalendarDayState.maybeOf(context);
  final range = NakedRangeCalendarState.maybeOf(context);
  final states = day?.states ?? const <WidgetState>{};
  final solid =
      states.contains(WidgetState.selected) &&
      !states.contains(WidgetState.hovered) &&
      !states.contains(WidgetState.pressed) &&
      !states.contains(WidgetState.disabled) &&
      (range == null ||
          (range.preview == null &&
              day?.rangePosition != NakedRangePosition.middle));
  return (solid ? VanillaTokens.primaryForeground : VanillaTokens.foreground)
      .resolve(context)
      .withValues(alpha: 0.65);
});

/// The application's Calendar recipe.
///
/// Remix owns rendering, civil-date selection, keyboard navigation, focus and
/// semantics. This recipe supplies the day states, typography, Vanilla icon
/// navigation and Select selectors. Selectors retain intrinsic text height.
///
/// CalendarSpec has no generator target, so this facade composes the child
/// recipes by hand and deliberately has no generated part.
class VanillaCalendar extends StatelessWidget {
  const VanillaCalendar({
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
    navigationStyle: vanillaIconButtonStyle(
      variant: .ghost,
      style: IconButtonStyler()
          .size(VanillaTokens.s12, VanillaTokens.s12)
          .margin(.symmetric(vertical: VanillaTokens.s1))
          .icon(
            .size(MediaQuery.textScalerOf(context).scale(VanillaTokens.icon)),
          )
          .merge(navigationStyle),
    ),
    selectorStyle: vanillaSelectStyle(
      style: SelectStyler()
          .trigger(
            SelectTriggerStyler()
                .indicator(
                  .size(
                    MediaQuery.textScalerOf(context).scale(VanillaTokens.s2_5),
                  ),
                )
                .minHeight(
                  MediaQuery.textScalerOf(
                    context,
                  ).scale(VanillaTokens.controlMd),
                )
                .maxWidth(double.infinity)
                .minWidth(
                  MediaQuery.textScalerOf(
                    context,
                  ).scale(VanillaTokens.s16 + VanillaTokens.s12),
                ),
          )
          .merge(selectorStyle),
    ),
    style: vanillaCalendarStyle(
      style: CalendarStyler()
          .day(
            CalendarDayStyler().minWidth(
              MediaQuery.textScalerOf(context).scale(VanillaTokens.s12),
            ),
          )
          .merge(style),
    ),
    styleSpec: styleSpec,
  );
}

final _calendarDisabled = ContextVariant(
  'vanilla.calendar.disabled',
  (context) =>
      (NakedCalendarState.maybeOf(context)?.states ??
              NakedRangeCalendarState.maybeOf(context)?.states ??
              const <WidgetState>{})
          .contains(WidgetState.disabled),
);
