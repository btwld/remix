part of 'progress.dart';

@MixableSpec()
class RemixProgressSpec extends Spec<RemixProgressSpec>
    with Diagnosticable, _$RemixProgressSpecMethods {
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
