part of 'button.dart';

class ButtonSpec extends WidgetSpec<ButtonSpec> {
  final ContainerSpec container;
  final LabelSpec label;
  final SpinnerSpec spinner;

  const ButtonSpec({
    ContainerSpec? container,
    LabelSpec? label,
    SpinnerSpec? spinner,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  })  : container = container ?? const ContainerSpec(),
        label = label ?? const LabelSpec(),
        spinner = spinner ?? const SpinnerSpec(),
        super(animation: animation, widgetModifiers: widgetModifiers, inherit: inherit);

  @override
  ButtonSpec copyWith({
    ContainerSpec? container,
    LabelSpec? label,
    SpinnerSpec? spinner,
    AnimationConfig? animation,
    List<Modifier>? widgetModifiers,
    bool? inherit,
  }) {
    return ButtonSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      spinner: spinner ?? this.spinner,
      animation: animation ?? this.animation,
      widgetModifiers: widgetModifiers ?? this.widgetModifiers,
      inherit: inherit ?? this.inherit,
    );
  }

  @override
  ButtonSpec lerp(ButtonSpec? other, double t) {
    if (other == null) return this;

    return ButtonSpec(
      container: MixOps.lerp(container, other.container, t)!,
      label: MixOps.lerp(label, other.label, t)!,
      spinner: MixOps.lerp(spinner, other.spinner, t)!,
      animation: MixOps.lerp(animation, other.animation, t),
      widgetModifiers: MixOps.lerp(widgetModifiers, other.widgetModifiers, t),
      inherit: MixOps.lerp(inherit, other.inherit, t),
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
  List<Object?> get props => [...super.props, container, label, spinner];
}
