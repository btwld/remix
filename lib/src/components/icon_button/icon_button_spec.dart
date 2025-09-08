part of 'icon_button.dart';

class IconButtonSpec extends Spec<IconButtonSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;
  final StyleSpec<IconSpec> icon;
  final StyleSpec<SpinnerSpec> spinner;

  const IconButtonSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<IconSpec>? icon,
    StyleSpec<SpinnerSpec>? spinner,
  })  : container = container ?? const StyleSpec(spec: BoxSpec()),
        icon = icon ?? const StyleSpec(spec: IconSpec()),
        spinner = spinner ?? const StyleSpec(spec: SpinnerSpec());

  IconButtonSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<IconSpec>? icon,
    StyleSpec<SpinnerSpec>? spinner,
  }) {
    return IconButtonSpec(
      container: container ?? this.container,
      icon: icon ?? this.icon,
      spinner: spinner ?? this.spinner,
    );
  }

  IconButtonSpec lerp(IconButtonSpec? other, double t) {
    if (other == null) return this;

    return IconButtonSpec(
      container: MixOps.lerp(container, other.container, t)!,
      icon: MixOps.lerp(icon, other.icon, t)!,
      spinner: MixOps.lerp(spinner, other.spinner, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('icon', icon))
      ..add(DiagnosticsProperty('spinner', spinner));
  }

  @override
  List<Object?> get props => [container, icon, spinner];
}