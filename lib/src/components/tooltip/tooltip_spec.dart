part of 'tooltip.dart';

class TooltipSpec extends Spec<TooltipSpec> with Diagnosticable {
  final WidgetSpec<BoxSpec> container;
  final WidgetSpec<TextSpec> text;

  const TooltipSpec({WidgetSpec<BoxSpec>? container, WidgetSpec<TextSpec>? text})
      : container = container ?? const WidgetSpec(spec: BoxSpec()),
        text = text ?? const WidgetSpec(spec: TextSpec());

  TooltipSpec copyWith({WidgetSpec<BoxSpec>? container, WidgetSpec<TextSpec>? text}) {
    return TooltipSpec(
      container: container ?? this.container,
      text: text ?? this.text,
    );
  }

  TooltipSpec lerp(TooltipSpec? other, double t) {
    if (other == null) return this;

    return TooltipSpec(
      container: MixOps.lerp(container, other.container, t)!,
      text: MixOps.lerp(text, other.text, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('text', text));
  }

  @override
  List<Object?> get props => [container, text];
}
