part of 'calendar.dart';

/// Resolved calendar surface, typography and independently styled day anatomy.
///
/// Range days are styled with day variants such as
/// `CalendarDayStyler.onRangeStart`, resolved in each day's own state.
// No target: the generator cannot resolve cross-generated constructor
// styler types for navigationStyle and selectorStyle in the same build.
@MixableSpec(extraStylerMixins: [RemixBoxStylerMixin])
class CalendarSpec with _$CalendarSpec {
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;
  @override
  final StyleSpec<TextSpec> weekday;
  @override
  final StyleSpec<CalendarDaySpec> day;

  /// Gap below the header, before the weekday labels.
  @override
  final double? headerSpacing;

  /// Gap below the weekday labels, before the first week.
  @override
  final double? weekdaySpacing;

  /// Horizontal gap between the month and year selectors.
  @override
  final double? selectorSpacing;

  /// Vertical gap when the month and year selectors wrap onto two lines.
  @override
  final double? selectorRunSpacing;

  /// Vertical gap between week rows; columns remain connected.
  @override
  final double? rowSpacing;

  const CalendarSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? weekday,
    StyleSpec<CalendarDaySpec>? day,
    this.rowSpacing,
    this.headerSpacing,
    this.weekdaySpacing,
    this.selectorSpacing,
    this.selectorRunSpacing,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       weekday = weekday ?? const StyleSpec(spec: TextSpec()),
       day = day ?? const StyleSpec(spec: CalendarDaySpec());
}

/// Day surface and numeric label, resolved in that day's interaction state.
@MixableSpec(extraStylerMixins: [RemixBoxStylerMixin])
class CalendarDaySpec with _$CalendarDaySpec {
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;
  @override
  final StyleSpec<TextSpec> label;

  /// Box effects painted with the day's resolved radius, without layout space.
  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? containerEffects;

  const CalendarDaySpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? label,
    this.containerEffects,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec());

  @override
  CalendarDaySpec lerp(CalendarDaySpec? other, double t) {
    final generated = super.lerp(other, t);
    if (other == null) return generated;
    return generated.copyWith(
      containerEffects: RemixBoxEffectsSpec.lerpNullable(
        containerEffects,
        other.containerEffects,
        t,
      ),
    );
  }
}
