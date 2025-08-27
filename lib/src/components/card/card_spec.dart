part of 'card.dart';

class CardSpec extends Spec<CardSpec> with Diagnosticable {
  final BoxSpec container;

  const CardSpec({BoxSpec? container})
      : container = container ?? const BoxSpec();

  CardSpec copyWith({BoxSpec? container}) {
    return CardSpec(container: container ?? this.container);
  }

  CardSpec lerp(CardSpec? other, double t) {
    if (other == null) return this;

    return CardSpec(container: MixOps.lerp(container, other.container, t)!);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('container', container));
  }

  @override
  List<Object?> get props => [container];
}
