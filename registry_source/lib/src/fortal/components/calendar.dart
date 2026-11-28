import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_icons/remix_ui_icons.dart';

import '../motion/motion.dart';
import '../theme/theme.dart';
import 'select.dart';

/// The side of a day's touch slot at 100% text scaling in the default
/// header's month and year controls.
const fortalCalendarTarget = 44.0;

// These calendar dimensions have no matching spacing-scale step.

/// The width of the month and year selectors at 100% text scaling.
const fortalCalendarSelectorWidth = 146.0;

/// The width of the inline calendar at 100% text scaling: seven day slots.
const fortalCalendarWidth = 328.0;

/// The width of a day slot, scaled with the text, for a calendar [width]
/// wide.
double fortalCalendarDayWidth(
  BuildContext context, {
  double width = fortalCalendarWidth,
}) => MediaQuery.textScalerOf(context).scale(width / DateTime.daysPerWeek);

/// The calendar's text-scaled size: seven day slots across [width]. Each day
/// is a circle 4px narrower than its slot, and rows keep the same 4px gap.
CalendarStyler fortalCalendarGeometry(
  BuildContext context, {
  double width = fortalCalendarWidth,
}) {
  final slot = fortalCalendarDayWidth(context, width: width);

  return CalendarStyler()
      .maxWidth(slot * DateTime.daysPerWeek)
      .day(CalendarDayStyler().minWidth(slot).minHeight(slot - 4));
}

/// The previous and next month buttons: 32px pills in the secondary text
/// colour that fill gray 3 under the pointer and sink to 96% while held.
IconButtonStyler fortalCalendarNavigationStyle(BuildContext context) {
  final scaler = MediaQuery.textScalerOf(context);
  final button = scaler.scale(32);

  return IconButtonStyler()
      .size(button, button)
      .alignment(.center)
      .borderRadius(.all(FortalTokens.radiusFull()))
      .color(const Color(0x00000000))
      .icon(.size(scaler.scale(16)).color(FortalTokens.gray11()))
      .onHovered(
        IconButtonStyler()
            .color(FortalTokens.gray3())
            .icon(.color(FortalTokens.gray12())),
      )
      .onPressed(IconButtonStyler().scale(0.96))
      .onFocusVisible(IconButtonStyler().containerEffects(fortalFocusOutline()))
      .onDisabled(IconButtonStyler().wrap(.opacity(0.36)))
      .animate(
        AnimationConfig.curve(
          duration: FortalMotion.fast,
          curve: FortalMotion.easeStandard,
        ),
      );
}

/// The calendar's header gap, weekday row and day states: circles that fill
/// gray 3 under the pointer and sink to 94% while held, 13px tabular numbers,
/// medium today and selected numbers, and muted unavailable days. The
/// selected disc is painted by [fortalCalendarSelectionLayer]. Shared by the
/// inline calendar and the date picker.
CalendarStyler fortalCalendarStyle({
  CalendarStyler style = const CalendarStyler.create(),
}) => CalendarStyler()
    .headerSpacing(14)
    .weekdaySpacing(6)
    .rowSpacing(4)
    .fixedWeeks(true)
    .monthTransition(fortalCalendarMonthTransition)
    .selectionLayer(fortalCalendarSelectionLayer())
    .weekday(
      TextStyler()
          .style(FortalTokens.text1.mix())
          .fontWeight(FortalTokens.fontWeightMedium())
          .height(2)
          .color(FortalTokens.gray10()),
    )
    .onDisabled(CalendarStyler().wrap(.opacity(0.5)))
    .day(fortalCalendarDayStyle())
    .merge(style);

/// One day: a circle 2px in from each side of its slot with a 13px tabular
/// number.
CalendarDayStyler fortalCalendarDayStyle() => CalendarDayStyler()
    .margin(.symmetric(horizontal: 2))
    .borderRadius(.all(FortalTokens.radiusFull()))
    .label(
      TextStyler()
          .style(FortalTokens.text2.mix())
          .height(1)
          .fontFeatures(const [FontFeature.tabularFigures()])
          .color(FortalTokens.gray12()),
    )
    .containerEffects(RemixBoxEffectsMix())
    .onHovered(CalendarDayStyler().color(FortalTokens.gray3()))
    .onPressed(CalendarDayStyler().scale(0.94))
    .onToday(
      CalendarDayStyler().label(
        TextStyler().fontWeight(FortalTokens.fontWeightMedium()),
      ),
    )
    .onSelected(
      CalendarDayStyler()
          .color(const Color(0x00000000))
          .label(
            TextStyler()
                .color(fortalCalendarSwatchInk())
                .fontWeight(FortalTokens.fontWeightMedium()),
          ),
    )
    .onFocusVisible(CalendarDayStyler().containerEffects(fortalFocusOutline()))
    .onDisabled(CalendarDayStyler().label(TextStyler().color(_mutedDay())))
    .onUnavailable(
      CalendarDayStyler().label(
        TextStyler().color(_mutedDay()).decoration(TextDecoration.lineThrough),
      ),
    )
    .animate(
      AnimationConfig.curve(
        duration: FortalMotion.fast,
        curve: FortalMotion.easeStandard,
      ),
    );

/// The number on a selection disc: the accent's swatch ink, or black or
/// white, whichever reads better, for palettes whose swatch ink falls under
/// 4.5:1 on the disc.
final fortalCalendarSwatchInk = ContextToken<Color>((context) {
  final disc = FortalTokens.accent9.resolve(context);
  final ink = FortalTokens.accentSwatchContrast.resolve(context);
  double ratio(Color a, Color b) {
    final (x, y) = (a.computeLuminance(), b.computeLuminance());
    return (x > y ? x + 0.05 : y + 0.05) / (x > y ? y + 0.05 : x + 0.05);
  }

  if (ratio(ink, disc) >= 4.5) return ink;
  const black = Color(0xFF000000);
  const white = Color(0xFFFFFFFF);
  return ratio(black, disc) > ratio(white, disc) ? black : white;
});

/// Muted text at 42%, for days that cannot be chosen.
final _mutedDay = ContextToken<Color>(
  (context) => FortalTokens.gray10.resolve(context).withValues(alpha: 0.42),
);

/// The weeks slide a slot and 16px sideways on the smooth spring when the
/// month changes, and fade toward 40% as they leave.
final fortalCalendarMonthTransition = RemixMonthTransition(
  duration: FortalSpringCurve.smooth.duration,
  builder: (context, info, grid) {
    final sign = info.direction == RemixMonthDirection.forward ? 1.0 : -1.0;
    final t = FortalSpringCurve.smooth.transform(info.animation.value);
    final away = info.isIncoming ? 1 - t : t;

    return ClipRect(
      child: LayoutBuilder(
        builder: (context, constraints) => Transform.translate(
          offset: Offset(
            (info.isIncoming ? sign : -sign) *
                away *
                (constraints.maxWidth + 16),
            0,
          ),
          child: Opacity(opacity: 1 - 0.6 * away, child: grid),
        ),
      ),
    );
  },
);

/// The selection painted under the days: a disc in the accent on each end,
/// and for ranges a pill of the accent's subtle tint across each week. Discs
/// glide on the morph spring and grow from 70% when the selection arrives.
///
/// [inset] narrows each slot to the drawn disc and bar.
RemixCalendarSelectionLayerBuilder fortalCalendarSelectionLayer({
  double inset = 2,
}) => _layers.putIfAbsent(
  inset,
  () =>
      (context, selection) => _FortalSelectionLayer(
        selection: selection,
        inset: inset,
        disc: FortalTokens.accent9.resolve(context),
        band: FortalTokens.accentSurface.resolve(context),
      ),
);
final _layers = <double, RemixCalendarSelectionLayerBuilder>{};

Rect _narrow(Rect rect, double inset) =>
    Rect.fromLTRB(rect.left + inset, rect.top, rect.right - inset, rect.bottom);

class _FortalSelectionLayer extends StatelessWidget {
  const _FortalSelectionLayer({
    required this.selection,
    required this.inset,
    required this.disc,
    required this.band,
  });

  final RemixCalendarSelection selection;
  final double inset;
  final Color disc;
  final Color band;

  @override
  Widget build(BuildContext context) {
    final start = selection.start;
    final end = selection.end;
    final range = start != null && end != null && start != end;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (range)
          for (final segment in selection.segments)
            _Glide(
              key: ValueKey(('band', segment.row)),
              rect: _narrow(selection.segmentRect(segment), inset),
              color: band,
            ),
        if (start != null)
          _Glide(
            key: const ValueKey('start'),
            rect: _narrow(selection.cellRect(start), inset),
            color: disc,
          ),
        if (range)
          _Glide(
            key: const ValueKey('end'),
            rect: _narrow(selection.cellRect(end), inset),
            color: disc,
          ),
      ],
    );
  }
}

/// A pill that glides to [rect] on the morph spring, and grows from 70% and
/// fades in when it first appears. Reduced motion places it at once.
class _Glide extends StatelessWidget {
  const _Glide({super.key, required this.rect, required this.color});

  final Rect rect;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final still = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final glide = FortalSpringCurve.smooth;

    return AnimatedPositioned.fromRect(
      rect: rect,
      duration: still ? Duration.zero : glide.duration,
      curve: glide,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: still ? 1 : 0, end: 1),
        duration: still ? Duration.zero : FortalMotion.fast,
        curve: FortalMotion.easeEnter,
        builder: (context, t, child) => Opacity(
          opacity: t,
          child: Transform.scale(scale: 0.7 + 0.3 * t, child: child),
        ),
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: color,
            shape: const StadiumBorder(),
          ),
        ),
      ),
    );
  }
}

/// The header: the month and year on the left, previous and next month
/// buttons on the right.
class FortalCalendarHeader extends StatelessWidget {
  const FortalCalendarHeader({
    super.key,
    required this.month,
    this.onPrevious,
    this.onNext,
    this.labels = const RemixCalendarLabels(),
    this.navigationStyle = const IconButtonStyler.create(),
  });

  /// The displayed month.
  final DateTime month;

  /// Shows the previous month; null disables the button.
  final VoidCallback? onPrevious;

  /// Shows the next month; null disables the button.
  final VoidCallback? onNext;

  /// The month title and button names.
  final RemixCalendarLabels labels;

  /// Button styling merged over [fortalCalendarNavigationStyle].
  final IconButtonStyler navigationStyle;

  @override
  Widget build(BuildContext context) {
    final style = fortalCalendarNavigationStyle(context).merge(navigationStyle);

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 34),
      child: Row(
        children: [
          Expanded(
            child: StyledText(
              labels.monthYear(month),
              style: TextStyler()
                  .style(FortalTokens.text3.mix())
                  .fontWeight(FortalTokens.fontWeightMedium())
                  .fontFeatures(const [FontFeature.tabularFigures()])
                  .color(FortalTokens.gray12())
                  .maxLines(1),
            ),
          ),
          // The buttons' empty edge lines up with the last day's circle.
          Transform.translate(
            offset: Offset(
              Directionality.of(context) == TextDirection.ltr ? 6 : -6,
              0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 2,
              children: [
                RemixIconButton(
                  icon: RemixIcons.chevronLeft,
                  semanticLabel: labels.previousMonth,
                  onPressed: onPrevious,
                  style: style,
                ),
                RemixIconButton(
                  icon: RemixIcons.chevronRight,
                  semanticLabel: labels.nextMonth,
                  onPressed: onNext,
                  style: style,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The month and year selectors: select triggers sized to the calendar, whose
/// capped panels always show a scrollbar so overflow stays discoverable.
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

/// Fortal's Calendar composition.
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
    headerBuilder:
        headerBuilder ??
        (context, state) => FortalCalendarHeader(
          month: state.displayedMonth,
          onPrevious: state.showPreviousMonth,
          onNext: state.showNextMonth,
          labels: labels,
          navigationStyle: navigationStyle,
        ),
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

/// The keyboard focus ring color of a day: gray 11 in dark mode, focus 8 in
/// light mode.
final fortalCalendarFocusColor = ContextToken<Color>(
  (context) =>
      (FortalTheme.of(context).isDark
              ? FortalTokens.gray11
              : FortalTokens.focus8)
          .resolve(context),
);
