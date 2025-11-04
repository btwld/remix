part of 'tooltip.dart';

class RemixTooltipSpec extends Spec<RemixTooltipSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;
  final StyleSpec<TextSpec> label;
  final Duration waitDuration;
  final Duration showDuration;

  const RemixTooltipSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? label,
    this.waitDuration = const Duration(milliseconds: 300),
    this.showDuration = const Duration(milliseconds: 1500),
  })  : container = container ?? const StyleSpec(spec: BoxSpec()),
        label = label ?? const StyleSpec(spec: TextSpec());

  RemixTooltipSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? label,
    Duration? waitDuration,
    Duration? showDuration,
  }) {
    return RemixTooltipSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      waitDuration: waitDuration ?? this.waitDuration,
      showDuration: showDuration ?? this.showDuration,
    );
  }

  RemixTooltipSpec lerp(RemixTooltipSpec? other, double t) {
    if (other == null) return this;

    return RemixTooltipSpec(
      container: MixOps.lerp(container, other.container, t)!,
      label: MixOps.lerp(label, other.label, t)!,
      waitDuration: t < 0.5 ? waitDuration : other.waitDuration,
      showDuration: t < 0.5 ? showDuration : other.showDuration,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('waitDuration', waitDuration))
      ..add(DiagnosticsProperty('showDuration', showDuration));
  }

  @override
  List<Object?> get props => [container, label, waitDuration, showDuration];
}
