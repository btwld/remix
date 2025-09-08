part of 'badge.dart';

class BadgeSpec extends Spec<BadgeSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;
  final StyleSpec<TextSpec> text;

  const BadgeSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? text,
  })  : container = container ?? const StyleSpec(spec: BoxSpec()),
        text = text ?? const StyleSpec(spec: TextSpec());

  BadgeSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? text,
  }) {
    return BadgeSpec(
      container: container ?? this.container,
      text: text ?? this.text,
    );
  }

  BadgeSpec lerp(BadgeSpec? other, double t) {
    if (other == null) return this;

    return BadgeSpec(
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
