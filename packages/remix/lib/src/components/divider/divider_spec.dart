part of 'divider.dart';

class RemixDividerSpec extends Spec<RemixDividerSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;

  const RemixDividerSpec({StyleSpec<BoxSpec>? container})
      : container = container ?? const StyleSpec(spec: BoxSpec());

  RemixDividerSpec copyWith({StyleSpec<BoxSpec>? container}) {
    return RemixDividerSpec(container: container ?? this.container);
  }

  RemixDividerSpec lerp(RemixDividerSpec? other, double t) {
    if (other == null) return this;

    return RemixDividerSpec(
      container: MixOps.lerp(container, other.container, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('container', container));
  }

  @override
  List<Object?> get props => [container];
}
