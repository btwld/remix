part of 'divider.dart';

class DividerSpec extends WidgetSpec<DividerSpec> {
  final WidgetContainerProperties container;

  const DividerSpec({WidgetContainerProperties? container})
      : container = container ?? const WidgetContainerProperties();

  @override
  DividerSpec copyWith({WidgetContainerProperties? container}) {
    return DividerSpec(container: container ?? this.container);
  }

  @override
  DividerSpec lerp(DividerSpec? other, double t) {
    if (other == null) return this;

    return DividerSpec(
      container: MixOps.lerp(container, other.container, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container));
  }

  @override
  List<Object?> get props => [container];
}
