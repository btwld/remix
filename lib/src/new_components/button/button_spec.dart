part of 'button.dart';

class ButtonSpec extends Spec<ButtonSpec> with Diagnosticable {
  final BoxSpec container;
  final LabelSpec label;

  const ButtonSpec({BoxSpec? container, LabelSpec? label})
      : container = container ?? const BoxSpec(),
        label = label ?? const LabelSpec();

  /// Creates a default spinner widget for loading states.
  /// Uses the label's icon styling to determine spinner color and size.
  Widget spinner() {
    return SizedBox(
      width: label.icon.size ?? 16,
      height: label.icon.size ?? 16,
      child: RemixSpinner(
        style: SpinnerStyle(
          size: label.icon.size ?? 16,
          strokeWidth: 1.5,
          color: label.icon.color ?? Colors.white,
        ),
      ),
    );
  }

  @override
  ButtonSpec copyWith({BoxSpec? container, LabelSpec? label}) {
    return ButtonSpec(
      container: container ?? this.container,
      label: label ?? this.label,
    );
  }

  @override
  ButtonSpec lerp(ButtonSpec? other, double t) {
    if (other == null) return this;

    return ButtonSpec(
      container: MixOps.lerp(container, other.container, t)!,
      label: MixOps.lerp(label, other.label, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty('container', container, defaultValue: null));
    properties.add(DiagnosticsProperty('label', label, defaultValue: null));
  }

  @override
  List<Object?> get props => [container, label];
}
