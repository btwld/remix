import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../theme/theme.dart';
import 'select.dart';

// calendar.css w-63 / seven columns; scales square tiles with text.
const heroUiCalendarTarget = 36.0;
double heroUiCalendarDayWidth(BuildContext context) =>
    MediaQuery.textScalerOf(context).scale(heroUiCalendarTarget);
CalendarStyler heroUiCalendarGeometry(BuildContext context) => CalendarStyler()
    .minWidth(heroUiCalendarDayWidth(context) * DateTime.daysPerWeek + 24)
    .day(
      CalendarDayStyler()
          .minWidth(heroUiCalendarDayWidth(context))
          .minHeight(heroUiCalendarDayWidth(context)),
    );
IconButtonStyler heroUiCalendarNavigationStyle(BuildContext context) =>
    IconButtonStyler()
        .size(
          MediaQuery.textScalerOf(context).scale(24),
          MediaQuery.textScalerOf(context).scale(24),
        )
        .padding(.all(0))
        .alignment(.center)
        .borderRadius(.all(HeroUiTokens.radius2xl()))
        .icon(
          .size(
            MediaQuery.textScalerOf(context).scale(16),
          ).color(HeroUiTokens.accentSoftForeground()),
        )
        .onHovered(IconButtonStyler().color(HeroUiTokens.defaultColor()))
        .onPressed(IconButtonStyler().scale(.95))
        .onFocusVisible(IconButtonStyler().containerEffects(heroUiFocusRing()))
        .onDisabled(
          IconButtonStyler().wrap(.opacity(HeroUiTokens.disabledOpacity)),
        );
SelectStyler heroUiCalendarSelectorStyle(BuildContext context) =>
    heroUiSelectStyle(variant: .secondary)
        .trigger(
          SelectTriggerStyler()
              .minHeight(24)
              .padding(.horizontal(8))
              .width(MediaQuery.textScalerOf(context).scale(118))
              .indicator(.size(MediaQuery.textScalerOf(context).scale(11))),
        )
        .content(
          SelectContentStyler()
              // Four complete day rows plus their gap below the selector.
              .maxHeight(38 + MediaQuery.textScalerOf(context).scale(160))
              .maxWidth(remixAnchorWidth())
              .wrap(
                WidgetModifierConfig.modifier(const _CalendarScrollCueMix()),
              ),
        )
        // Keep full month names on one line at the trigger's narrow width.
        .menuContainer(FlexBoxStyler().padding(.all(4)).spacing(4))
        .item(
          SelectMenuItemStyler()
              .padding(.horizontal(4))
              .spacing(4)
              .icon(.size(12))
              .onFocusVisible(
                SelectMenuItemStyler().containerEffects(heroUiInsetFocusRing),
              ),
        );

/// The application's Calendar style recipe.
///
/// Remix owns rendering, selection, navigation, focus and date semantics.
/// This supplies theme typography, transparent resting days and the visual
/// states. The inset focus band uses the shared ring tint and stroke without
/// changing layout; a calendar's scrolling grid clips an outside ring.
CalendarStyler heroUiCalendarStyle({
  CalendarStyler style = const CalendarStyler.create(),
}) => CalendarStyler()
    .padding(.all(12.0))
    .headerSpacing(16.0)
    .weekdaySpacing(12.0)
    .rowSpacing(4.0)
    .selectorSpacing(4.0)
    .weekday(.style(HeroUiTokens.textXs.mix()).color(HeroUiTokens.muted()))
    .day(
      CalendarDayStyler()
          .minWidth(36.0)
          .minHeight(36.0)
          .alignment(.center)
          .color(_clear())
          .border(.color(_clear()).width(1.0))
          .borderRadius(
            .only(
              topStart: HeroUiTokens.radius3xl(),
              topEnd: HeroUiTokens.radius3xl(),
              bottomStart: HeroUiTokens.radius3xl(),
              bottomEnd: HeroUiTokens.radius3xl(),
            ),
          )
          .label(
            .style(
              HeroUiTokens.textSm.mix(),
            ).fontWeight(FontWeight.w500).color(HeroUiTokens.foreground()),
          )
          .onToday(
            CalendarDayStyler()
                .color(HeroUiTokens.accentSoft())
                .border(.color(HeroUiTokens.accentSoftForeground()))
                .label(
                  .fontWeight(
                    FontWeight.w600,
                  ).color(HeroUiTokens.accentSoftForeground()),
                ),
          )
          .onSelected(
            CalendarDayStyler()
                .color(HeroUiTokens.accent())
                .label(.color(HeroUiTokens.accentForeground())),
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
                .color(HeroUiTokens.defaultColor())
                .label(.color(HeroUiTokens.foreground()))
                .onSelected(_solidPointer(_primaryHover))
                .onRangeMiddle(
                  CalendarDayStyler()
                      .color(_middleHover())
                      .label(.color(HeroUiTokens.foreground())),
                )
                .onRangePreview(
                  CalendarDayStyler()
                      .color(_draftHover())
                      .label(.color(HeroUiTokens.foreground())),
                ),
          )
          .onPressed(
            CalendarDayStyler()
                .color(_pressed())
                .label(.color(HeroUiTokens.foreground()))
                .onSelected(_solidPointer(_primaryPressed))
                .onRangeMiddle(
                  CalendarDayStyler()
                      .color(_middlePressed())
                      .label(.color(HeroUiTokens.foreground())),
                )
                .onRangePreview(
                  CalendarDayStyler()
                      .color(_draftPressed())
                      .label(.color(HeroUiTokens.foreground())),
                ),
          )
          .onFocusVisible(
            CalendarDayStyler()
                .border(.all(.color(_clear()).width(0).style(BorderStyle.none)))
                .containerEffects(
                  RemixBoxEffectsMix(
                    outline: BorderSideMix(color: _focusContour(), width: 2.0),
                    outlineOffset: -2.0,
                  ),
                ),
          )
          .onDisabled(
            CalendarDayStyler()
                .label(.color(HeroUiTokens.muted()))
                .wrap(.opacity(HeroUiTokens.disabledOpacity))
                .onSelected(
                  CalendarDayStyler()
                      .color(_quietSelected())
                      .label(.color(HeroUiTokens.muted()))
                      .wrap(.opacity(1)),
                ),
          )
          .onUnavailable(
            CalendarDayStyler()
                .label(
                  .color(
                    HeroUiTokens.muted(),
                  ).decoration(TextDecoration.lineThrough),
                )
                .wrap(.opacity(1))
                .variant(
                  _calendarDisabled,
                  CalendarDayStyler().wrap(
                    .opacity(HeroUiTokens.disabledOpacity),
                  ),
                ),
          ),
    )
    .variant(
      _calendarDisabled,
      CalendarStyler().weekday(
        .color(
          HeroUiTokens.muted(),
        ).wrap(.opacity(HeroUiTokens.disabledOpacity)),
      ),
    )
    .merge(style);

final _clear = heroUiAlpha(HeroUiTokens.foreground, 0);
final _pressed = ContextToken<Color>(
  (c) => HeroUiTokens.defaultHover.resolve(c),
);
// One inset outline follows the resolved day or range-cap shape.
final _focusContour = ContextToken<Color>(
  (context) => HeroUiTokens.foreground.resolve(context),
);

final _calendarDisabled = ContextVariant(
  'heroUi.calendar.disabled',
  (context) =>
      (NakedCalendarState.maybeOf(context)?.states ??
              NakedRangeCalendarState.maybeOf(context)?.states ??
              const <WidgetState>{})
          .contains(WidgetState.disabled),
);
CalendarDayStyler _solidPointer(ContextToken<Color> fill) => CalendarDayStyler()
    .color(fill())
    .label(.color(HeroUiTokens.accentForeground()));
final _primaryHover = ContextToken<Color>(
  (c) => HeroUiTokens.accent.resolve(c),
);
final _primaryPressed = ContextToken<Color>(
  (c) => HeroUiTokens.accentHover.resolve(c),
);
final _middleHover = ContextToken<Color>(
  (c) => HeroUiTokens.accentSoftHover.resolve(c),
);
final _middlePressed = ContextToken<Color>(
  (c) => HeroUiTokens.accentSoftHover.resolve(c),
);
final _draftHover = ContextToken<Color>(
  (c) => HeroUiTokens.accentSoft.resolve(c),
);
final _draftPressed = ContextToken<Color>(
  (c) => HeroUiTokens.accentSoftHover.resolve(c),
);
final _quietSelected = ContextToken<Color>((context) {
  final value = NakedRangeCalendarState.maybeOf(context)?.value;
  final day = NakedCalendarDayState.maybeOf(context)?.date;
  final cap =
      value != null &&
      day != null &&
      (compareCivilDates(day, value.start) == 0 ||
          compareCivilDates(day, value.end) == 0);
  return (cap ? HeroUiTokens.surfaceTertiary : HeroUiTokens.surfaceSecondary)
      .resolve(context);
});

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
    thumbColor: HeroUiTokens.muted.resolve(context),
    thickness: 4.0,
    child: child,
  );
}

/// HeroUI's three-letter English weekday headings; callers can localize labels.
const heroUiCalendarLabels = RemixCalendarLabels(weekday: _heroUiWeekday);
String _heroUiWeekday(int day) =>
    const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day - 1];

/// HeroUI reference Calendar composition.
///
/// Remix owns civil-date selection, focus, keyboard navigation and semantics.
/// Multiple independent child styles require a hand-written facade; caller
/// overrides merge last and there is no generated adapter.
class HeroUiCalendar extends StatelessWidget {
  const HeroUiCalendar({
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
    this.labels = heroUiCalendarLabels,
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
    navigationStyle: heroUiCalendarNavigationStyle(
      context,
    ).merge(navigationStyle),
    selectorStyle: heroUiCalendarSelectorStyle(context).merge(selectorStyle),
    style: heroUiCalendarStyle(
      style: heroUiCalendarGeometry(context).merge(style),
    ),
    styleSpec: styleSpec,
  );
}
