part of 'button.dart';

class ButtonSpec extends Spec<ButtonSpec> with Diagnosticable {
  final StyleSpec<BoxSpec> container;
  final StyleSpec<LabelSpec> label;
  final StyleSpec<SpinnerSpec> spinner;

  const ButtonSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<LabelSpec>? label,
    StyleSpec<SpinnerSpec>? spinner,
  })  : container = container ?? const StyleSpec(spec: BoxSpec()),
        label = label ?? const StyleSpec(spec: LabelSpec()),
        spinner = spinner ?? const StyleSpec(spec: SpinnerSpec());

  ButtonSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<LabelSpec>? label,
    StyleSpec<SpinnerSpec>? spinner,
  }) {
    return ButtonSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      spinner: spinner ?? this.spinner,
    );
  }

  ButtonSpec lerp(ButtonSpec? other, double t) {
    if (other == null) return this;

    return ButtonSpec(
      container: MixOps.lerp(container, other.container, t)!,
      label: MixOps.lerp(label, other.label, t)!,
      spinner: MixOps.lerp(spinner, other.spinner, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('spinner', spinner));
  }

  @override
  List<Object?> get props => [container, label, spinner];
}
