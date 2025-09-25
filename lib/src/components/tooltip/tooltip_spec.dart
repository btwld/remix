part of 'tooltip.dart';

class RemixTooltipSpec extends Spec<RemixTooltipSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;
  final StyleSpec<TextSpec> label;

  const RemixTooltipSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? label,
  })  : container = container ?? const StyleSpec(spec: BoxSpec()),
        label = label ?? const StyleSpec(spec: TextSpec());

  RemixTooltipSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? label,
  }) {
    return RemixTooltipSpec(
      container: container ?? this.container,
      label: label ?? this.label,
    );
  }

  RemixTooltipSpec lerp(RemixTooltipSpec? other, double t) {
    if (other == null) return this;

    return RemixTooltipSpec(
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
