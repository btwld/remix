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
                .color(VanillaTokens.accent())
                .label(
                  .color(
                    VanillaTokens.accentForeground(),
                  ).fontWeight(FontWeight.w600),
                ),
          )
          .onHovered(
            CalendarDayStyler()
                .color(_hover())
                .label(.color(VanillaTokens.accentForeground())),
          )
          .onPressed(
            CalendarDayStyler()
                .color(_pressed())
                .label(.color(VanillaTokens.foreground())),
          )
          .onSelected(
            CalendarDayStyler()
                .color(VanillaTokens.primary())
                .label(.color(VanillaTokens.primaryForeground())),
          )
          .onDisabled(
            CalendarDayStyler()
                .label(.color(VanillaTokens.mutedForeground()))
                .wrap(.opacity(VanillaTokens.disabledOpacity)),
          )
          .onUnavailable(
            CalendarDayStyler().label(.decoration(TextDecoration.lineThrough)),
          )
          .onFocusVisible(
            CalendarDayStyler().foregroundDecoration(
              BoxDecorationMix(
                border: BorderMix.all(
                  BorderSideMix(
                    color: _ring(),
                    width: VanillaTokens.strokeRing,
                  ),
                ),
                borderRadius: BorderRadiusMix.all(VanillaTokens.radiusSm()),
              ),
            ),
          ),
    )
    .merge(style);

final _clear = vanillaTint(VanillaTokens.foreground, 0);
final _pressed = vanillaTint(VanillaTokens.primary, 0.15, dark: 0.25);
final _ring = vanillaTint(VanillaTokens.ring, 0.5);

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
          .merge(navigationStyle),
    ),
    selectorStyle: vanillaSelectStyle(
      style: SelectStyler()
          .trigger(
            SelectTriggerStyler().width(
              MediaQuery.textScalerOf(
                context,
              ).scale(VanillaTokens.s16 * 2 + VanillaTokens.s6),
            ),
          )
          .merge(selectorStyle),
    ),
    style: vanillaCalendarStyle(style: style),
    styleSpec: styleSpec,
  );
}

final _hover = vanillaTint(VanillaTokens.accent, 1, dark: 0.5);
