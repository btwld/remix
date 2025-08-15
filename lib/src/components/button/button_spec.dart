part of 'button.dart';

class ButtonSpec extends Spec<ButtonSpec> with Diagnosticable {
  final BoxSpec container;
  final LabelSpec label;
  final SpinnerSpec spinner;

  const ButtonSpec({BoxSpec? container, LabelSpec? label, SpinnerSpec? spinner})
      : container = container ?? const BoxSpec(),
        label = label ?? const LabelSpec(),
        spinner = spinner ?? const SpinnerSpec();

  @override
  ButtonSpec copyWith({BoxSpec? container, LabelSpec? label, SpinnerSpec? spinner}) {
    return ButtonSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      spinner: spinner ?? this.spinner,
    );
  }

  @override
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
        .add(DiagnosticsProperty('container', container, defaultValue: null));
    properties.add(DiagnosticsProperty('label', label, defaultValue: null));
    properties.add(DiagnosticsProperty('spinner', spinner, defaultValue: null));
  }

  @override
  List<Object?> get props => [container, label, spinner];
}
