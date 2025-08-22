part of 'tooltip.dart';

class TooltipSpec extends WidgetSpec<TooltipSpec> {
  final WidgetContainerProperties container;
  final TextSpec text;

  const TooltipSpec({WidgetContainerProperties? container, TextSpec? text})
      : container = container ?? const WidgetContainerProperties(),
        text = text ?? const TextSpec();

  @override
  TooltipSpec copyWith({WidgetContainerProperties? container, TextSpec? text}) {
    return TooltipSpec(
      container: container ?? this.container,
      text: text ?? this.text,
    );
  }

  @override
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
