import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'icon_button.dart';
import 'select.dart';

/// The side of a day cell and of a navigation button: 44px at 100% text
/// scaling.
const uiCalendarTarget = 44.0;

// These calendar dimensions have no matching spacing-scale step.

/// The width of the month and year selectors at 100% text scaling.
const uiCalendarSelectorWidth = 146.0;

/// The width of a day cell, scaled with the text.
double uiCalendarDayWidth(BuildContext context) =>
    MediaQuery.textScalerOf(context).scale(uiCalendarTarget);

/// The calendar's text-scaled size: seven day columns plus the padding.
CalendarStyler uiCalendarGeometry(BuildContext context) => CalendarStyler()
    .minWidth(
      uiCalendarDayWidth(context) * DateTime.daysPerWeek +
          UiTokens.space3.resolve(context) * 2,
    )
    .day(
      CalendarDayStyler()
          .minWidth(uiCalendarDayWidth(context))
          .minHeight(uiCalendarDayWidth(context)),
    );

/// The previous and next month buttons: ghost icon buttons that grow with the
/// text and never go below the 44px touch target.
IconButtonStyler uiCalendarNavigationStyle(BuildContext context) {
  final icon = MediaQuery.textScalerOf(
    context,
  ).scale(UiTokens.space5.resolve(context));
  final button = icon.clamp(uiCalendarTarget, double.infinity);

  return uiIconButtonStyle(variant: .ghost)
      .size(button, button)
      // Keep ghost padding from overriding the requested vector size.
      .padding(.all(0))
      .margin(.all(0))
      .alignment(.center)
      .icon(.size(icon));
}

/// The calendar's padding, text and day states: today, selected, hover,
/// press, focus, disabled and unavailable. Shared by the inline calendar and
/// the pickers.
CalendarStyler uiCalendarStyle({
  CalendarStyler style = const CalendarStyler.create(),
}) => CalendarStyler()
    .padding(.all(UiTokens.space3()))
    .headerSpacing(UiTokens.space2())
    .weekdaySpacing(UiTokens.space1())
    .rowSpacing(UiTokens.space1())
    .onDisabled(CalendarStyler().weekday(TextStyler().color(UiTokens.gray9())))
    .weekday(TextStyler().style(UiTokens.text1.mix()).color(UiTokens.gray11()))
    .day(
      CalendarDayStyler()
          .minWidth(uiCalendarTarget)
          .minHeight(uiCalendarTarget)
          .borderRadius(.all(UiTokens.radius3()))
          .label(TextStyler().style(UiTokens.text2.mix()))
          .onToday(
            CalendarDayStyler()
                .border(.color(UiTokens.gray9()).width(UiTokens.borderWidth1()))
                .label(
                  TextStyler()
                      .color(UiTokens.gray12())
                      .fontWeight(UiTokens.fontWeightBold()),
                ),
          )
          .onSelected(
            CalendarDayStyler()
                .color(UiTokens.accentSolid())
                .label(TextStyler().color(UiTokens.accentContrast())),
          )
          .onHovered(
            CalendarDayStyler()
                .color(UiTokens.gray4())
                .onSelected(CalendarDayStyler().color(_selectedHover())),
          )
          .onPressed(
            CalendarDayStyler()
                .color(UiTokens.gray6())
                .onSelected(CalendarDayStyler().color(_selectedPressed())),
          )
          .onFocusVisible(
            CalendarDayStyler().border(
              .color(uiCalendarFocusColor()).width(UiTokens.focusRingWidth()),
            ),
          )
          .onDisabled(
            CalendarDayStyler().label(TextStyler().color(UiTokens.gray9())),
          )
          .onUnavailable(
            CalendarDayStyler().label(
              TextStyler().decoration(TextDecoration.lineThrough),
            ),
          ),
    )
    .merge(style);

/// The selected day's fill while hovered: the solid fill at 90%.
final _selectedHover = ContextToken<Color>(
  (context) => UiTokens.accentSolid.resolve(context).withValues(alpha: .9),
);

/// The selected day's fill while pressed: the solid fill at 80%.
final _selectedPressed = ContextToken<Color>(
  (context) => UiTokens.accentSolid.resolve(context).withValues(alpha: .8),
);

/// The month and year selectors: select triggers sized to the calendar, whose
/// capped panels always show a scrollbar so overflow stays discoverable.
SelectStyler uiCalendarSelectorStyle(BuildContext context) => uiSelectStyle()
    .trigger(
      SelectTriggerStyler()
          .padding(.horizontal(UiTokens.space2()))
          .indicator(.size(MediaQuery.textScalerOf(context).scale(9)))
          .height(UiTokens.touchTargetMin())
          .width(
            MediaQuery.textScalerOf(context).scale(uiCalendarSelectorWidth),
          ),
    )
    .content(
      SelectContentStyler()
          // Half an extra item plus the panel borders puts the bottom
          // in a calendar row gap rather than through the day labels.
          .maxHeight(
            MediaQuery.textScalerOf(
              context,
            ).scale(UiTokens.touchTargetMin.resolve(context) * 6.5 + 2),
          )
          .wrap(WidgetModifierConfig.modifier(const _CalendarScrollCueMix())),
    );

final class _CalendarScrollCueMix extends ModifierMix<_CalendarScrollCue> {
  const _CalendarScrollCueMix();

  @override
  _CalendarScrollCue resolve(BuildContext context) =>
      const _CalendarScrollCue();

  @override
  _CalendarScrollCueMix merge(_CalendarScrollCueMix? other) => other ?? this;

  @override
  List<Object?> get props => const [];
}

final class _CalendarScrollCue extends WidgetModifier<_CalendarScrollCue> {
  const _CalendarScrollCue();

  @override
  Widget build(Widget child) => ScrollConfiguration(
    behavior: const _CalendarScrollBehavior(),
    child: child,
  );

  @override
  _CalendarScrollCue copyWith() => this;

  @override
  _CalendarScrollCue lerp(_CalendarScrollCue? other, double t) => this;

  @override
  List<Object?> get props => const [];
}

class _CalendarScrollBehavior extends ScrollBehavior {
  const _CalendarScrollBehavior();
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => RawScrollbar(
    controller: details.controller,
    thumbVisibility: true,
    thumbColor: UiTokens.gray9.resolve(context),
    thickness: UiTokens.space1.resolve(context),
    child: child,
  );
}

/// Ui's Calendar composition.
///
/// Remix owns civil-date selection, focus, keyboard navigation and semantics.
/// Multiple independent child styles require a hand-written facade; caller
/// overrides merge last and there is no generated adapter.
class UiCalendar extends StatelessWidget {
  const UiCalendar({
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
    navigationStyle: uiCalendarNavigationStyle(context).merge(navigationStyle),
    selectorStyle: uiCalendarSelectorStyle(context).merge(selectorStyle),
    style: uiCalendarStyle(style: uiCalendarGeometry(context).merge(style)),
    styleSpec: styleSpec,
  );
}

/// The keyboard focus ring color of a day: gray 11 in dark mode, focus 8 in
/// light mode.
final uiCalendarFocusColor = ContextToken<Color>(
  (context) => (UiTheme.of(context).isDark ? UiTokens.gray11 : UiTokens.focus8)
      .resolve(context),
);
