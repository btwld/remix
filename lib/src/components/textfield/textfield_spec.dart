part of 'textfield.dart';

/// Defines the structure and styling properties for a text field component.
///
/// TextFieldSpec is the resolved specification that describes how a text field
/// should be styled, structured, and behave. It follows the Spec pattern used
/// throughout the Remix framework, where:
///
/// 1. **Style classes** (like [RemixTextFieldStyle]) define styling APIs
/// 2. **Spec classes** (like [TextFieldSpec]) hold resolved styling properties
/// 3. **Widget classes** (like [RemixTextField]) consume specs to render UI
///
/// The TextFieldSpec contains both styling properties ([StyleSpec] instances)
/// for visual elements and configuration properties for text field behavior
/// such as cursor appearance, text alignment, and selection handling.
///
/// ## Architecture Overview
///
/// ```
/// RemixTextFieldStyle -> TextFieldSpec -> RemixTextField Widget
/// (Define styles)       (Hold props)     (Render UI)
/// ```
///
/// ## Property Categories
///
/// **Visual Styling**: [text], [hintText], [container], [helperText], [label]
/// **Text Behavior**: [textAlign], [spacing]
/// **Cursor Configuration**: [cursorWidth], [cursorHeight], [cursorRadius], [cursorColor], [cursorOffset], [cursorOpacityAnimates]
/// **Selection Styling**: [selectionHeightStyle], [selectionWidthStyle]
/// **Input Configuration**: [scrollPadding], [keyboardAppearance]
///
/// ## Usage
///
/// Specs are typically not created directly by users. Instead, they are
/// built internally when applying styles:
///
/// ```dart
/// // Style creates and populates the spec
/// final style = RemixTextFieldStyle()
///   .textColor(Colors.black)
///   .cursorColor(Colors.blue)
///   .spacing(8.0);
///
/// // Widget receives the resolved spec
/// RemixTextField(style: style)
/// ```
///
/// See also:
/// - [RemixTextFieldStyle] for the styling API
/// - [RemixTextField] for the widget implementation
/// - [Spec] for the base specification pattern
class TextFieldSpec extends Spec<TextFieldSpec> with Diagnosticable {
  /// Styling specification for the input text.
  ///
  /// Controls typography, color, and text-specific properties
  /// for the actual text content entered by the user.
  final StyleSpec<TextSpec> text;

  /// Styling specification for the hint/placeholder text.
  ///
  /// Defines the appearance of placeholder text shown when
  /// the text field is empty. Typically styled with muted colors.
  final StyleSpec<TextSpec> hintText;

  /// Horizontal alignment of the text within the input field.
  ///
  /// Determines how text is aligned when it doesn't fill the
  /// entire width of the text field.
  final TextAlign textAlign;

  /// Width of the text cursor in logical pixels.
  ///
  /// Controls how thick the blinking cursor appears when
  /// the text field has focus.
  final double cursorWidth;

  /// Height of the text cursor in logical pixels.
  ///
  /// If null, the cursor height will match the text line height.
  /// When specified, creates a cursor of fixed height.
  final double? cursorHeight;

  /// Border radius of the text cursor.
  ///
  /// If null, the cursor will have sharp rectangular corners.
  /// When specified, creates a cursor with rounded corners.
  final Radius? cursorRadius;

  /// Color of the text cursor.
  ///
  /// If null, the cursor will use the theme's default cursor color.
  /// When specified, overrides the default cursor appearance.
  final Color? cursorColor;

  /// Offset of the cursor from its default position.
  ///
  /// Allows fine-tuning of cursor positioning relative to the text.
  /// Defaults to [Offset.zero] for standard positioning.
  final Offset cursorOffset;

  /// Whether the cursor opacity should animate.
  ///
  /// When true, the cursor will fade in and out with a blinking animation.
  /// When false, the cursor remains at constant opacity.
  /// If null, uses the platform default behavior.
  final bool? cursorOpacityAnimates;

  /// How tall the selection highlight should be.
  ///
  /// Controls the vertical sizing behavior of text selection highlights.
  final BoxHeightStyle selectionHeightStyle;

  /// How wide the selection highlight should be.
  ///
  /// Controls the horizontal sizing behavior of text selection highlights.
  final BoxWidthStyle selectionWidthStyle;

  /// Padding around the scrollable area of the text field.
  ///
  /// Ensures content remains visible when the software keyboard
  /// or other UI elements might otherwise obscure the text field.
  final EdgeInsets scrollPadding;

  /// Appearance of the keyboard for this text field.
  ///
  /// Controls whether the keyboard should use light or dark appearance.
  /// If null, uses the system default appearance.
  final Brightness? keyboardAppearance;

  /// Vertical spacing between text field elements.
  ///
  /// Controls the gap between label, input, helper text, and other
  /// text field components when they are stacked vertically.
  final double spacing;

  /// Styling specification for the text field's container.
  ///
  /// Controls the text field's layout, background, borders, padding,
  /// and other visual container properties. Uses [FlexBoxSpec]
  /// to support flexible layout arrangements.
  final StyleSpec<FlexBoxSpec> container;

  /// Styling specification for helper text.
  ///
  /// Defines typography and color for supplementary text shown
  /// below the input field to provide additional context or validation feedback.
  final StyleSpec<TextSpec> helperText;

  /// Styling specification for the text field's label.
  ///
  /// Controls the appearance of the label text that describes
  /// the purpose or expected content of the text field.
  final StyleSpec<TextSpec> label;

  /// Creates a TextFieldSpec with optional styling and configuration.
  ///
  /// Provides sensible defaults for all properties to ensure the text field
  /// is functional even when minimal configuration is provided:
  ///
  /// - Text alignment defaults to [TextAlign.start]
  /// - Cursor width defaults to 2.0 logical pixels
  /// - Cursor offset defaults to [Offset.zero]
  /// - Selection styles default to tight sizing
  /// - Scroll padding defaults to 20.0 on all sides
  /// - Spacing defaults to 4.0 logical pixels
  /// - All [StyleSpec] properties default to empty specifications
  ///
  /// Example:
  /// ```dart
  /// const spec = TextFieldSpec(
  ///   textAlign: TextAlign.center,
  ///   cursorWidth: 3.0,
  ///   cursorColor: Colors.blue,
  ///   spacing: 8.0,
  /// );
  /// ```
  const TextFieldSpec({
    StyleSpec<TextSpec>? text,
    StyleSpec<TextSpec>? hintText,
    TextAlign? textAlign,
    double? cursorWidth,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    Offset? cursorOffset,
    BoxHeightStyle? selectionHeightStyle,
    BoxWidthStyle? selectionWidthStyle,
    EdgeInsets? scrollPadding,
    this.keyboardAppearance,
    this.cursorOpacityAnimates,
    double? spacing,
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? helperText,
    StyleSpec<TextSpec>? label,
  })  : text = text ?? const StyleSpec(spec: TextSpec()),
        hintText = hintText ?? const StyleSpec(spec: TextSpec()),
        textAlign = textAlign ?? TextAlign.start,
        cursorWidth = cursorWidth ?? 2.0,
        cursorOffset = cursorOffset ?? Offset.zero,
        selectionHeightStyle = selectionHeightStyle ?? BoxHeightStyle.tight,
        selectionWidthStyle = selectionWidthStyle ?? BoxWidthStyle.tight,
        scrollPadding = scrollPadding ?? const EdgeInsets.all(20.0),
        helperText = helperText ?? const StyleSpec(spec: TextSpec()),
        label = label ?? const StyleSpec(spec: TextSpec()),
        container = container ?? const StyleSpec(spec: FlexBoxSpec()),
        spacing = spacing ?? 4;

  /// Creates a copy of this TextFieldSpec with the given fields replaced.
  ///
  /// This method enables immutable updates to the specification,
  /// which is essential for the reactive styling system. Any parameter
  /// not provided will retain its current value.
  ///
  /// Example:
  /// ```dart
  /// final updatedSpec = originalSpec.copyWith(
  ///   cursorColor: Colors.red,
  ///   spacing: 12.0,
  ///   textAlign: TextAlign.center,
  /// );
  /// ```
  TextFieldSpec copyWith({
    StyleSpec<TextSpec>? text,
    StyleSpec<TextSpec>? hintText,
    TextAlign? textAlign,
    double? cursorWidth,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Offset? cursorOffset,
    bool? cursorOpacityAnimates,
    BoxHeightStyle? selectionHeightStyle,
    BoxWidthStyle? selectionWidthStyle,
    EdgeInsets? scrollPadding,
    Brightness? keyboardAppearance,
    double? spacing,
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? helperText,
    StyleSpec<TextSpec>? label,
  }) {
    return TextFieldSpec(
      text: text ?? this.text,
      hintText: hintText ?? this.hintText,
      textAlign: textAlign ?? this.textAlign,
      cursorWidth: cursorWidth ?? this.cursorWidth,
      cursorHeight: cursorHeight ?? this.cursorHeight,
      cursorRadius: cursorRadius ?? this.cursorRadius,
      cursorColor: cursorColor ?? this.cursorColor,
      cursorOffset: cursorOffset ?? this.cursorOffset,
      selectionHeightStyle: selectionHeightStyle ?? this.selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle ?? this.selectionWidthStyle,
      scrollPadding: scrollPadding ?? this.scrollPadding,
      keyboardAppearance: keyboardAppearance ?? this.keyboardAppearance,
      cursorOpacityAnimates:
          cursorOpacityAnimates ?? this.cursorOpacityAnimates,
      spacing: spacing ?? this.spacing,
      container: container ?? this.container,
      helperText: helperText ?? this.helperText,
      label: label ?? this.label,
    );
  }

  /// Linearly interpolates between this and another TextFieldSpec.
  ///
  /// Used by Flutter's animation system to create smooth transitions
  /// between different text field states or when animating between
  /// different text field styles.
  ///
  /// The [t] parameter represents the interpolation factor:
  /// - `0.0` returns this specification
  /// - `1.0` returns [other] specification
  /// - Values in between return interpolated specifications
  ///
  /// For discrete properties (like [textAlign] and [keyboardAppearance]),
  /// the interpolation uses a threshold at `t < 0.5` to determine
  /// which value to use.
  ///
  /// Returns this specification unchanged if [other] is null.
  ///
  /// Example:
  /// ```dart
  /// final midpoint = spec1.lerp(spec2, 0.5); // 50% interpolation
  /// ```
  TextFieldSpec lerp(TextFieldSpec? other, double t) {
    if (other == null) return this;

    return TextFieldSpec(
      text: MixOps.lerp(text, other.text, t)!,
      hintText: MixOps.lerp(hintText, other.hintText, t)!,
      textAlign: t < 0.5 ? textAlign : other.textAlign,
      cursorWidth: lerpDouble(cursorWidth, other.cursorWidth, t),
      cursorHeight: lerpDouble(cursorHeight, other.cursorHeight, t),
      cursorRadius: Radius.lerp(cursorRadius, other.cursorRadius, t),
      cursorColor: Color.lerp(cursorColor, other.cursorColor, t),
      cursorOffset: Offset.lerp(cursorOffset, other.cursorOffset, t),
      selectionHeightStyle:
          t < 0.5 ? selectionHeightStyle : other.selectionHeightStyle,
      selectionWidthStyle:
          t < 0.5 ? selectionWidthStyle : other.selectionWidthStyle,
      scrollPadding: EdgeInsets.lerp(scrollPadding, other.scrollPadding, t),
      keyboardAppearance:
          t < 0.5 ? keyboardAppearance : other.keyboardAppearance,
      cursorOpacityAnimates:
          t < 0.5 ? cursorOpacityAnimates : other.cursorOpacityAnimates,
      spacing: lerpDouble(spacing, other.spacing, t),
      container: MixOps.lerp(container, other.container, t)!,
      helperText: MixOps.lerp(helperText, other.helperText, t)!,
      label: MixOps.lerp(label, other.label, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('hintText', hintText))
      ..add(EnumProperty<TextAlign>('textAlign', textAlign))
      ..add(DoubleProperty('cursorWidth', cursorWidth))
      ..add(DoubleProperty('cursorHeight', cursorHeight))
      ..add(DiagnosticsProperty('cursorRadius', cursorRadius))
      ..add(ColorProperty('cursorColor', cursorColor))
      ..add(DiagnosticsProperty('cursorOffset', cursorOffset))
      ..add(DiagnosticsProperty('cursorOpacityAnimates', cursorOpacityAnimates))
      ..add(EnumProperty<BoxHeightStyle>(
        'selectionHeightStyle',
        selectionHeightStyle,
      ))
      ..add(EnumProperty<BoxWidthStyle>(
        'selectionWidthStyle',
        selectionWidthStyle,
      ))
      ..add(DiagnosticsProperty('scrollPadding', scrollPadding))
      ..add(EnumProperty<Brightness>('keyboardAppearance', keyboardAppearance))
      ..add(DoubleProperty('spacing', spacing))
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('helperText', helperText))
      ..add(DiagnosticsProperty('label', label));
  }

  @override
  List<Object?> get props => [
        text,
        hintText,
        textAlign,
        cursorWidth,
        cursorHeight,
        cursorRadius,
        cursorColor,
        cursorOffset,
        cursorOpacityAnimates,
        selectionHeightStyle,
        selectionWidthStyle,
        scrollPadding,
        keyboardAppearance,
        spacing,
        container,
        helperText,
        label,
      ];
}
