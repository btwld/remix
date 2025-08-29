part of 'divider.dart';

class DividerSpec extends Spec<DividerSpec> with Diagnosticable {
  final WidgetSpec<BoxSpec> container;

  const DividerSpec({WidgetSpec<BoxSpec>? container})
      : container = container ?? const WidgetSpec(spec: BoxSpec());

  DividerSpec copyWith({WidgetSpec<BoxSpec>? container}) {
    return DividerSpec(container: container ?? this.container);
  }

  DividerSpec lerp(DividerSpec? other, double t) {
    if (other == null) return this;

    return DividerSpec(
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
