part of 'button.dart';

class ButtonSpec extends Spec<ButtonSpec> with Diagnosticable {
  final WidgetSpec<BoxSpec> container;
  final WidgetSpec<LabelSpec> label;
  final WidgetSpec<SpinnerSpec> spinner;

  const ButtonSpec({
    WidgetSpec<BoxSpec>? container,
    WidgetSpec<LabelSpec>? label,
    WidgetSpec<SpinnerSpec>? spinner,
  })  : container = container ?? const WidgetSpec(spec: BoxSpec()),
        label = label ?? const WidgetSpec(spec: LabelSpec()),
        spinner = spinner ?? const WidgetSpec(spec: SpinnerSpec());

  ButtonSpec copyWith({
    WidgetSpec<BoxSpec>? container,
    WidgetSpec<LabelSpec>? label,
    WidgetSpec<SpinnerSpec>? spinner,
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
