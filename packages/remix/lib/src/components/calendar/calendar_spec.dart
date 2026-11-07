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

  const CalendarSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? heading,
    StyleSpec<TextSpec>? weekday,
    StyleSpec<CalendarDaySpec>? day,
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

  const CalendarDaySpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? label,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec());
}
