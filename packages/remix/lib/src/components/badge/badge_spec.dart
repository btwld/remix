part of 'badge.dart';

class RemixBadgeSpec extends Spec<RemixBadgeSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;
  final StyleSpec<TextSpec> text;

  const RemixBadgeSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? text,
  })  : container = container ?? const StyleSpec(spec: BoxSpec()),
        text = text ?? const StyleSpec(spec: TextSpec());

  RemixBadgeSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? text,
  }) {
    return RemixBadgeSpec(
      container: container ?? this.container,
      text: text ?? this.text,
    );
  }

  RemixBadgeSpec lerp(RemixBadgeSpec? other, double t) {
    if (other == null) return this;

    return RemixBadgeSpec(
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
