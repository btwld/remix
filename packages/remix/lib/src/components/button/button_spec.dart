part of 'button.dart';

/// Defines the structure and styling properties for a button component.
///
/// RemixButtonSpec is the resolved specification that describes how a button
/// should be styled and structured. It follows the Spec pattern used
/// throughout the Remix framework, where:
///
/// 1. **Style classes** (like [RemixButtonStyle]) define styling APIs
/// 2. **Spec classes** (like [RemixButtonSpec]) hold resolved styling properties
/// 3. **Widget classes** (like [RemixButton]) consume specs to render UI
///
/// The RemixButtonSpec contains [StyleSpec] properties for each visual element
/// of the button: container layout, text label, icon, and loading spinner.
/// These properties are built by [RemixButtonStyle] and consumed by
/// [RemixButton] to create the final rendered widget.
///
/// ## Architecture Overview
///
/// ```
/// RemixButtonStyle -> RemixButtonSpec -> RemixButton Widget
/// (Define styles)    (Hold props)   (Render UI)
/// ```
///
/// ## Usage
///
/// Specs are typically not created directly by users. Instead, they are
/// built internally when applying styles:
///
/// ```dart
/// // Style creates and populates the spec
/// final style = RemixButtonStyle()
///   .labelColor(Colors.white)
///   .iconSize(20.0);
///
/// // Widget receives the resolved spec
/// RemixButton('Click me', style: style)
/// ```
///
/// ## Properties
///
/// Each [StyleSpec] property corresponds to a visual element:
/// - [container]: Layout and visual styling (flex, background, borders)
/// - [label]: Text styling for the button's label
/// - [icon]: Icon styling when an icon is present
/// - [spinner]: Loading spinner styling during async operations
///
/// See also:
/// - [RemixButtonStyle] for the styling API
/// - [RemixButton] for the widget implementation
/// - [Spec] for the base specification pattern
@MixableSpec()
class RemixButtonSpec extends Spec<RemixButtonSpec>
    with Diagnosticable, _$RemixButtonSpecMethods {
  /// Styling specification for the button's container.
  ///
  /// Controls the button's layout, background, borders, padding,
  /// and other visual container properties. Uses [FlexBoxSpec]
  /// to support flexible layout arrangements.
  @override
  final StyleSpec<FlexBoxSpec> container;

  /// Styling specification for the button's text label.
  ///
  /// Defines typography, color, and text-specific properties
  /// when the button displays text content.
  @override
  final StyleSpec<TextSpec> label;

  /// Styling specification for the button's icon.
  ///
  /// Controls icon size, color, and positioning when an icon
  /// is displayed alongside or instead of text.
  @override
  final StyleSpec<IconSpec> icon;

  /// Styling specification for the button's loading spinner.
  ///
  /// Defines the appearance of the spinner shown during
  /// asynchronous operations when the button is in loading state.
  @override
  final StyleSpec<RemixSpinnerSpec> spinner;

  /// The alignment of the icon relative to the label.
  ///
  /// When set to [IconAlignment.left], the icon appears before the label.
  /// When set to [IconAlignment.right], the icon appears after the label.
  /// Defaults to [IconAlignment.left].
  @override
  final IconAlignment iconAlignment;

  /// Creates a RemixButtonSpec with optional styling specifications.
  ///
  /// If any [StyleSpec] is not provided, a default specification
  /// with empty styling is used. This ensures all properties are
  /// always initialized and ready for use by the widget.
  ///
  /// Example:
  /// ```dart
  /// const spec = RemixButtonSpec(
  ///   container: StyleSpec(spec: FlexBoxSpec()),
  ///   label: StyleSpec(spec: TextSpec()),
  /// );
  /// ```
  const RemixButtonSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
    StyleSpec<RemixSpinnerSpec>? spinner,
    IconAlignment? iconAlignment,
  }) : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec()),
       spinner = spinner ?? const StyleSpec(spec: RemixSpinnerSpec()),
       iconAlignment = iconAlignment ?? IconAlignment.start;
}
