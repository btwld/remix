part of 'icon_button.dart';

class RemixIconButtonSpec extends Spec<RemixIconButtonSpec>
    with Diagnosticable {
  final StyleSpec<BoxSpec> container;
  final StyleSpec<IconSpec> icon;
  final StyleSpec<RemixSpinnerSpec> spinner;

  const RemixIconButtonSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<IconSpec>? icon,
    StyleSpec<RemixSpinnerSpec>? spinner,
  })  : container = container ?? const StyleSpec(spec: BoxSpec()),
        icon = icon ?? const StyleSpec(spec: IconSpec()),
        spinner = spinner ?? const StyleSpec(spec: RemixSpinnerSpec());

  RemixIconButtonSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<IconSpec>? icon,
    StyleSpec<RemixSpinnerSpec>? spinner,
  }) {
    return RemixIconButtonSpec(
      container: container ?? this.container,
      icon: icon ?? this.icon,
      spinner: spinner ?? this.spinner,
    );
  }

  RemixIconButtonSpec lerp(RemixIconButtonSpec? other, double t) {
    if (other == null) return this;

    return RemixIconButtonSpec(
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
