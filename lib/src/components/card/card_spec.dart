part of 'card.dart';

class CardSpec extends Spec<CardSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;

  const CardSpec({StyleSpec<BoxSpec>? container})
      : container = container ?? const StyleSpec(spec: BoxSpec());

  CardSpec copyWith({StyleSpec<BoxSpec>? container}) {
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
