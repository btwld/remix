part of 'progress.dart';

/// Resolved visual values for a [RemixProgress].
@MixableSpec()
class RemixProgressSpec with _$RemixProgressSpec {
  @override
  final StyleSpec<BoxSpec> container;
  @override
  final StyleSpec<BoxSpec> track;
  @override
  final StyleSpec<BoxSpec> indicator;
  @override
  final StyleSpec<BoxSpec> trackContainer;

  const RemixProgressSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? track,
    StyleSpec<BoxSpec>? indicator,
    StyleSpec<BoxSpec>? trackContainer,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       track = track ?? const StyleSpec(spec: BoxSpec()),
       indicator = indicator ?? const StyleSpec(spec: BoxSpec()),
       trackContainer = trackContainer ?? const StyleSpec(spec: BoxSpec());
}
