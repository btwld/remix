part of 'checkbox.dart';

/// Defines the structure and styling properties for a checkbox component.
///
/// CheckboxSpec is the resolved specification that describes how a checkbox
/// should be styled and structured. It follows the Spec pattern used
/// throughout the Remix framework, where:
///
/// 1. **Style classes** (like [RemixCheckboxStyle]) define styling APIs
/// 2. **Spec classes** (like [CheckboxSpec]) hold resolved styling properties
/// 3. **Widget classes** (like [RemixCheckbox]) consume specs to render UI
///
/// The CheckboxSpec contains [StyleSpec] properties for each visual element
/// of the checkbox: the overall container, the indicator container (checkbox box),
/// the indicator icon (checkmark), and the accompanying text label.
///
/// ## Architecture Overview
///
/// ```
/// RemixCheckboxStyle -> CheckboxSpec -> RemixCheckbox Widget
/// (Define styles)      (Hold props)    (Render UI)
/// ```
///
/// ## Visual Structure
///
/// A checkbox component consists of these styled elements:
/// ```
/// [container]
///   ├── [indicatorContainer] (the checkbox box)
///   │   └── [indicator] (checkmark icon)
///   └── [label] (accompanying text)
/// ```
///
/// ## Usage
///
/// Specs are typically not created directly by users. Instead, they are
/// built internally when applying styles:
///
/// ```dart
/// // Style creates and populates the spec
/// final style = RemixCheckboxStyle()
///   .indicatorColor(Colors.blue)
///   .labelColor(Colors.black)
///   .indicatorSize(20.0);
///
/// // Widget receives the resolved spec
/// RemixCheckbox('Accept terms', style: style)
/// ```
///
/// ## Properties
///
/// Each [StyleSpec] property corresponds to a visual element:
/// - [container]: Overall layout and spacing between indicator and label
/// - [indicatorContainer]: The checkbox box styling (background, border, size)
/// - [indicator]: The checkmark icon styling (color, size)
/// - [label]: Text styling for the checkbox label
///
/// See also:
/// - [RemixCheckboxStyle] for the styling API
/// - [RemixCheckbox] for the widget implementation
/// - [Spec] for the base specification pattern
class CheckboxSpec extends Spec<CheckboxSpec> with Diagnosticable {
  /// Styling specification for the checkbox's container.
  ///
  /// Controls the overall layout, spacing, and arrangement between
  /// the checkbox indicator and its label. Uses [FlexBoxSpec] to
  /// support flexible positioning and alignment.
  final StyleSpec<FlexBoxSpec> container;

  /// Styling specification for the checkbox indicator's container.
  ///
  /// Defines the appearance of the checkbox box itself, including
  /// background color, border, size, and shape. This is the visual
  /// element that users click to toggle the checkbox state.
  final StyleSpec<BoxSpec> indicatorContainer;

  /// Styling specification for the checkbox indicator icon.
  ///
  /// Controls the checkmark or other indicator symbol shown when
  /// the checkbox is in the checked state. Defines color, size,
  /// and other icon-specific properties.
  final StyleSpec<IconSpec> indicator;

  /// Styling specification for the checkbox's text label.
  ///
  /// Defines typography, color, and text-specific properties
  /// for the descriptive text displayed alongside the checkbox.
  final StyleSpec<TextSpec> label;

  /// Creates a CheckboxSpec with optional styling specifications.
  ///
  /// If any [StyleSpec] is not provided, a default specification
  /// with empty styling is used. This ensures all properties are
  /// always initialized and ready for use by the widget.
  ///
  /// The default specifications provide a foundation that can be
  /// extended through the styling system without requiring
  /// complete specification of every visual property.
  ///
  /// Example:
  /// ```dart
  /// const spec = CheckboxSpec(
  ///   indicatorContainer: StyleSpec(spec: BoxSpec()),
  ///   indicator: StyleSpec(spec: IconSpec()),
  ///   label: StyleSpec(spec: TextSpec()),
  /// );
  /// ```
  const CheckboxSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<BoxSpec>? indicatorContainer,
    StyleSpec<IconSpec>? indicator,
    StyleSpec<TextSpec>? label,
  })  : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
        indicatorContainer =
            indicatorContainer ?? const StyleSpec(spec: BoxSpec()),
        indicator = indicator ?? const StyleSpec(spec: IconSpec()),
        label = label ?? const StyleSpec(spec: TextSpec());

  /// Creates a copy of this CheckboxSpec with the given fields replaced.
  ///
  /// This method enables immutable updates to the specification,
  /// which is essential for the reactive styling system. Any parameter
  /// not provided will retain its current value from this instance.
  ///
  /// Example:
  /// ```dart
  /// final updatedSpec = originalSpec.copyWith(
  ///   indicator: StyleSpec(spec: IconSpec()),
  ///   label: StyleSpec(spec: TextSpec()),
  /// );
  /// ```
  CheckboxSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<BoxSpec>? indicatorContainer,
    StyleSpec<IconSpec>? indicator,
    StyleSpec<TextSpec>? label,
  }) {
    return CheckboxSpec(
      container: container ?? this.container,
      indicatorContainer: indicatorContainer ?? this.indicatorContainer,
      indicator: indicator ?? this.indicator,
      label: label ?? this.label,
    );
  }

  /// Linearly interpolates between this and another CheckboxSpec.
  ///
  /// Used by Flutter's animation system to create smooth transitions
  /// between different checkbox states or when animating between
  /// different checkbox styles. This is particularly useful for
  /// hover effects, focus states, and theme transitions.
  ///
  /// The [t] parameter represents the interpolation factor:
  /// - `0.0` returns this specification
  /// - `1.0` returns [other] specification
  /// - Values in between return interpolated specifications
  ///
  /// All [StyleSpec] properties are interpolated using [MixOps.lerp],
  /// which handles the complex interpolation of nested styling properties.
  ///
  /// Returns this specification unchanged if [other] is null.
  ///
  /// Example:
  /// ```dart
  /// final midpoint = spec1.lerp(spec2, 0.5); // 50% interpolation
  /// ```
  CheckboxSpec lerp(CheckboxSpec? other, double t) {
    if (other == null) return this;

    return CheckboxSpec(
      container: MixOps.lerp(container, other.container, t)!,
      indicatorContainer:
          MixOps.lerp(indicatorContainer, other.indicatorContainer, t)!,
      indicator: MixOps.lerp(indicator, other.indicator, t)!,
      label: MixOps.lerp(label, other.label, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('indicatorContainer', indicatorContainer))
      ..add(DiagnosticsProperty('indicator', indicator))
      ..add(DiagnosticsProperty('label', label));
  }

  @override
  List<Object?> get props => [container, indicatorContainer, indicator, label];
}
