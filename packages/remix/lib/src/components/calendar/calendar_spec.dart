part of 'calendar.dart';

/// Resolved calendar surface, typography and independently styled day anatomy.
// No target: the generator cannot resolve cross-generated constructor
// styler types for navigationStyle and selectorStyle in the same build.
@MixableSpec(extraStylerMixins: [RemixBoxStylerMixin])
class CalendarSpec with _$CalendarSpec {
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;
  @override
  final StyleSpec<TextSpec> heading;
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

  const CalendarSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? heading,
    StyleSpec<TextSpec>? weekday,
    StyleSpec<CalendarDaySpec>? day,
    this.headerSpacing,
    this.weekdaySpacing,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       heading = heading ?? const StyleSpec(spec: TextSpec()),
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
