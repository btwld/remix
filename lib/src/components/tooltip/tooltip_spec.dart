part of 'tooltip.dart';

class TooltipSpec extends Spec<TooltipSpec> with Diagnosticable {
  final BoxSpec container;
  final TextSpec text;

  const TooltipSpec({
    BoxSpec? container,
    TextSpec? text
  })  : container = container ?? const BoxSpec(),
        text = text ?? const TextSpec();

  @override
  TooltipSpec copyWith({
    BoxSpec? container,
    TextSpec? text
  }) {
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
    properties.add(
      DiagnosticsProperty('container', container, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty('text', text, defaultValue: null)
    );
  }

  @override
  List<Object?> get props => [container, text];
}