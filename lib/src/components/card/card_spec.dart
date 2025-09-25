part of 'card.dart';

class RemixCardSpec extends Spec<RemixCardSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;

  const RemixCardSpec({StyleSpec<BoxSpec>? container})
      : container = container ?? const StyleSpec(spec: BoxSpec());

  RemixCardSpec copyWith({StyleSpec<BoxSpec>? container}) {
    return RemixCardSpec(container: container ?? this.container);
  }

  RemixCardSpec lerp(RemixCardSpec? other, double t) {
    if (other == null) return this;

    return RemixCardSpec(container: MixOps.lerp(container, other.container, t)!);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('container', container));
  }

  @override
  List<Object?> get props => [container];
}
