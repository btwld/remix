part of 'switch.dart';

class RemixSwitchSpec extends Spec<RemixSwitchSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;
  final StyleSpec<BoxSpec> thumb;

  const RemixSwitchSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? thumb,
  })  : container = container ?? const StyleSpec(spec: BoxSpec()),
        thumb = thumb ?? const StyleSpec(spec: BoxSpec());

  RemixSwitchSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? thumb,
  }) {
    return RemixSwitchSpec(
      container: container ?? this.container,
      thumb: thumb ?? this.thumb,
    );
  }

  RemixSwitchSpec lerp(RemixSwitchSpec? other, double t) {
    if (other == null) return this;

    return RemixSwitchSpec(
      container: MixOps.lerp(container, other.container, t)!,
      thumb: MixOps.lerp(thumb, other.thumb, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('thumb', thumb));
  }

  @override
  List<Object?> get props => [container, thumb];
}
