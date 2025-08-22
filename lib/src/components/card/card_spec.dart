part of 'card.dart';

class CardSpec extends WidgetSpec<CardSpec> {
  final WidgetContainerProperties container;

  const CardSpec({WidgetContainerProperties? container})
      : container = container ?? const WidgetContainerProperties();

  @override
  CardSpec copyWith({WidgetContainerProperties? container}) {
    return CardSpec(container: container ?? this.container);
  }

  @override
  CardSpec lerp(CardSpec? other, double t) {
    if (other == null) return this;

    return CardSpec(container: MixOps.lerp(container, other.container, t)!);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container));
  }

  @override
  List<Object?> get props => [container];
}
