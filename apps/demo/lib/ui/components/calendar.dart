import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'icon_button.dart';
import 'select.dart';

// Reviewed calendar geometry has no matching spacing-scale step.
const fortalCalendarTarget = 44.0;
const fortalCalendarSelectorWidth = 146.0;

double fortalCalendarDayWidth(BuildContext context) =>
    MediaQuery.textScalerOf(context).scale(fortalCalendarTarget);

CalendarStyler fortalCalendarGeometry(BuildContext context) => CalendarStyler()
    .minWidth(
      fortalCalendarDayWidth(context) * DateTime.daysPerWeek +
          FortalTokens.space3.resolve(context) * 2,
    )
    .day(
      CalendarDayStyler()
          .minWidth(fortalCalendarDayWidth(context))
          .minHeight(fortalCalendarDayWidth(context)),
    );

IconButtonStyler fortalCalendarNavigationStyle(BuildContext context) =>
    fortalIconButtonStyle(variant: .ghost)
        .size(
          MediaQuery.textScalerOf(context)
              .scale(FortalTokens.space5.resolve(context))
              .clamp(fortalCalendarTarget, double.infinity),
          MediaQuery.textScalerOf(context)
              .scale(FortalTokens.space5.resolve(context))
              .clamp(fortalCalendarTarget, double.infinity),
        )
        // Keep ghost padding from overriding the requested vector size.
        .padding(.all(0))
        .margin(.all(0))
        .alignment(.center)
        .icon(
          .size(
            MediaQuery.textScalerOf(
              context,
            ).scale(FortalTokens.space5.resolve(context)),
          ),
        );

/// Shared geometry and day states for the inline and picker stories.
CalendarStyler fortalCalendarStyle({
  CalendarStyler style = const CalendarStyler.create(),
}) => CalendarStyler()
    .padding(.all(FortalTokens.space3()))
    .headerSpacing(FortalTokens.space2())
    .weekdaySpacing(FortalTokens.space1())
    .rowSpacing(FortalTokens.space1())
    .onDisabled(
      CalendarStyler().weekday(TextStyler().color(FortalTokens.gray9())),
    )
    .weekday(
      TextStyler().style(FortalTokens.text1.mix()).color(FortalTokens.gray11()),
    )
    .day(
      CalendarDayStyler()
          .minWidth(fortalCalendarTarget)
          .minHeight(fortalCalendarTarget)
          .borderRadius(.all(FortalTokens.radius3()))
          .label(TextStyler().style(FortalTokens.text2.mix()))
          .onToday(
            CalendarDayStyler()
                .border(
                  .color(
                    FortalTokens.gray9(),
                  ).width(FortalTokens.borderWidth1()),
                )
                .label(
                  TextStyler()
                      .color(FortalTokens.gray12())
                      .fontWeight(FontWeight.w700),
                ),
          )
          .onSelected(
            CalendarDayStyler()
                .color(FortalTokens.accentSolid())
                .label(TextStyler().color(FortalTokens.accentContrast())),
          )
          .onHovered(
            CalendarDayStyler()
                .color(FortalTokens.gray4())
                .onSelected(CalendarDayStyler().color(_selectedHover())),
          )
          .onPressed(
            CalendarDayStyler()
                .color(FortalTokens.gray6())
                .onSelected(CalendarDayStyler().color(_selectedPressed())),
          )
          .onFocusVisible(
            CalendarDayStyler().border(
              .color(
                fortalCalendarFocusColor(),
              ).width(FortalTokens.focusRingWidth()),
            ),
          )
          .onDisabled(
            CalendarDayStyler().label(TextStyler().color(FortalTokens.gray9())),
          )
          .onUnavailable(
            CalendarDayStyler().label(
              TextStyler().decoration(TextDecoration.lineThrough),
            ),
          ),
    )
    .merge(style);

final _selectedHover = ContextToken<Color>(
  (context) => FortalTokens.accentSolid.resolve(context).withValues(alpha: .9),
);
final _selectedPressed = ContextToken<Color>(
  (context) => FortalTokens.accentSolid.resolve(context).withValues(alpha: .8),
);

/// Keep overflow discoverable in the capped month and year panels.
SelectStyler fortalCalendarSelectorStyle(
  BuildContext context,
) => fortalSelectStyle()
    .trigger(
      SelectTriggerStyler()
          .padding(.horizontal(FortalTokens.space2()))
          .indicator(.size(MediaQuery.textScalerOf(context).scale(9)))
          .height(FortalTokens.touchTargetMin())
          .width(
            MediaQuery.textScalerOf(context).scale(fortalCalendarSelectorWidth),
          ),
    )
    .content(
      SelectContentStyler()
          // Half an extra item plus the panel borders puts the bottom
          // in a calendar row gap rather than through the day labels.
          .maxHeight(
            MediaQuery.textScalerOf(
              context,
            ).scale(FortalTokens.touchTargetMin.resolve(context) * 6.5 + 2),
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
    thumbColor: FortalTokens.gray9.resolve(context),
    thickness: FortalTokens.space1.resolve(context),
    child: child,
  );
}

/// Fortal's reviewed Calendar composition.
///
/// Remix owns civil-date selection, focus, keyboard navigation and semantics.
/// Multiple independent child styles require a hand-written facade; caller
/// overrides merge last and there is no generated adapter.
class FortalCalendar extends StatelessWidget {
  const FortalCalendar({
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
    navigationStyle: fortalCalendarNavigationStyle(
      context,
    ).merge(navigationStyle),
    selectorStyle: fortalCalendarSelectorStyle(context).merge(selectorStyle),
    style: fortalCalendarStyle(
      style: fortalCalendarGeometry(context).merge(style),
    ),
    styleSpec: styleSpec,
  );
}

// A brighter neutral step separates keyboard focus from the dark draft edge.
final fortalCalendarFocusColor = ContextToken<Color>(
  (context) =>
      (FortalTheme.of(context).isDark
              ? FortalTokens.gray11
              : FortalTokens.focus8)
          .resolve(context),
);
