part of 'tooltip.dart';

class TooltipSpec extends Spec<TooltipSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;
  final StyleSpec<TextSpec> label;

  const TooltipSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? label,
  })  : container = container ?? const StyleSpec(spec: BoxSpec()),
        label = label ?? const StyleSpec(spec: TextSpec());

  TooltipSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? label,
  }) {
    return TooltipSpec(
      container: container ?? this.container,
      label: label ?? this.label,
    );
  }

  TooltipSpec lerp(TooltipSpec? other, double t) {
    if (other == null) return this;

    return TooltipSpec(
      container: MixOps.lerp(container, other.container, t)!,
      label: MixOps.lerp(label, other.label, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('label', label));
  }

  @override
  List<Object?> get props => [container, label];
}
