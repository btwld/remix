part of 'textfield.dart';

class TextFieldStyle extends Style<TextFieldSpec> with StyleModifierMixin<TextFieldStyle, TextFieldSpec>, StyleVariantMixin<TextFieldStyle, TextFieldSpec> {
  final Prop<TextStyle>? $style;
  final Prop<Color>? $hintTextColor;
  final Prop<TextAlign>? $textAlign;
  
  final Prop<double>? $cursorWidth;
  final Prop<double>? $cursorHeight;
  final Prop<Radius>? $cursorRadius;
  final Prop<Color>? $cursorColor;
  final Prop<Offset>? $cursorOffset;
  final Prop<bool>? $cursorOpacityAnimates;
  
  final Prop<BoxHeightStyle>? $selectionHeightStyle;
  final Prop<BoxWidthStyle>? $selectionWidthStyle;
  
  final Prop<EdgeInsets>? $scrollPadding;
  final Prop<Brightness>? $keyboardAppearance;
  final Prop<double>? $spacing;
  final Prop<FlexBoxSpec>? $container;
  final Prop<TextSpec>? $helperText;

  const TextFieldStyle.create({
    Prop<TextStyle>? style,
    Prop<Color>? hintTextColor,
    Prop<TextAlign>? textAlign,
    Prop<double>? cursorWidth,
    Prop<double>? cursorHeight,
    Prop<Radius>? cursorRadius,
    Prop<Color>? cursorColor,
    Prop<Offset>? cursorOffset,
    Prop<bool>? cursorOpacityAnimates,
    Prop<BoxHeightStyle>? selectionHeightStyle,
    Prop<BoxWidthStyle>? selectionWidthStyle,
    Prop<EdgeInsets>? scrollPadding,
    Prop<Brightness>? keyboardAppearance,
    Prop<double>? spacing,
    Prop<FlexBoxSpec>? container,
    Prop<TextSpec>? helperText,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $style = style,
        $hintTextColor = hintTextColor,
        $textAlign = textAlign,
        $cursorWidth = cursorWidth,
        $cursorHeight = cursorHeight,
        $cursorRadius = cursorRadius,
        $cursorColor = cursorColor,
        $cursorOffset = cursorOffset,
        $cursorOpacityAnimates = cursorOpacityAnimates,
        $selectionHeightStyle = selectionHeightStyle,
        $selectionWidthStyle = selectionWidthStyle,
        $scrollPadding = scrollPadding,
        $keyboardAppearance = keyboardAppearance,
        $spacing = spacing,
        $container = container,
        $helperText = helperText;

  TextFieldStyle({
    TextStyle? style,
    Color? hintTextColor,
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
    FlexBoxMix? container,
    TextMix? helperText,
    AnimationConfig? animation,
    List<VariantStyle<TextFieldSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          style: Prop.maybe(style),
          hintTextColor: Prop.maybe(hintTextColor),
          textAlign: Prop.maybe(textAlign),
          cursorWidth: Prop.maybe(cursorWidth),
          cursorHeight: Prop.maybe(cursorHeight),
          cursorRadius: Prop.maybe(cursorRadius),
          cursorColor: Prop.maybe(cursorColor),
          cursorOffset: Prop.maybe(cursorOffset),
          cursorOpacityAnimates: Prop.maybe(cursorOpacityAnimates),
          selectionHeightStyle: Prop.maybe(selectionHeightStyle),
          selectionWidthStyle: Prop.maybe(selectionWidthStyle),
          scrollPadding: Prop.maybe(scrollPadding),
          keyboardAppearance: Prop.maybe(keyboardAppearance),
          spacing: Prop.maybe(spacing),
          container: container != null ? Prop.mix(container) : null,
          helperText: helperText != null ? Prop.mix(helperText) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  // Factory methods for common properties
  
  /// Factory for text color
  factory TextFieldStyle.color(Color value) {
    return TextFieldStyle(style: TextStyle(color: value));
  }
  
  /// Factory for background color
  factory TextFieldStyle.backgroundColor(Color value) {
    return TextFieldStyle(container: FlexBoxMix.color(value));
  }
  
  /// Factory for border radius
  factory TextFieldStyle.borderRadius(double radius) {
    return TextFieldStyle(container: FlexBoxMix.borderRadius(BorderRadiusMix.circular(radius)));
  }
  
  /// Factory for padding
  factory TextFieldStyle.padding(double value) {
    return TextFieldStyle(container: FlexBoxMix.padding(EdgeInsetsMix.all(value)));
  }
  
  /// Factory for border
  factory TextFieldStyle.border(BoxBorderMix value) {
    return TextFieldStyle(container: FlexBoxMix.border(value));
  }
  
  /// Factory for width
  factory TextFieldStyle.width(double value) {
    return TextFieldStyle(container: FlexBoxMix.width(value));
  }
  
  /// Factory for height
  factory TextFieldStyle.height(double value) {
    return TextFieldStyle(container: FlexBoxMix.height(value));
  }
  
  /// Factory for cursor color
  factory TextFieldStyle.cursorColor(Color value) {
    return TextFieldStyle(cursorColor: value);
  }
  
  /// Factory for hint text color
  factory TextFieldStyle.hintColor(Color value) {
    return TextFieldStyle(hintTextColor: value);
  }

  // Instance methods (chainable)
  
  /// Sets text color
  TextFieldStyle color(Color value) {
    return merge(TextFieldStyle.color(value));
  }
  
  /// Sets background color
  TextFieldStyle backgroundColor(Color value) {
    return merge(TextFieldStyle.backgroundColor(value));
  }
  
  /// Sets border radius
  TextFieldStyle borderRadius(double radius) {
    return merge(TextFieldStyle.borderRadius(radius));
  }
  
  /// Sets padding
  TextFieldStyle padding(double value) {
    return merge(TextFieldStyle.padding(value));
  }
  
  /// Sets border
  TextFieldStyle border(BoxBorderMix value) {
    return merge(TextFieldStyle.border(value));
  }
  
  /// Sets width
  TextFieldStyle width(double value) {
    return merge(TextFieldStyle.width(value));
  }
  
  /// Sets height
  TextFieldStyle height(double value) {
    return merge(TextFieldStyle.height(value));
  }
  
  /// Sets cursor color
  TextFieldStyle cursorColor(Color value) {
    return merge(TextFieldStyle.cursorColor(value));
  }
  
  /// Sets hint text color
  TextFieldStyle hintColor(Color value) {
    return merge(TextFieldStyle.hintColor(value));
  }
  
  /// Sets animation
  TextFieldStyle animate(AnimationConfig animation) {
    return merge(TextFieldStyle(animation: animation));
  }
  
  /// Sets variant
  @override
  TextFieldStyle variant(Variant variant, TextFieldStyle style) {
    return merge(TextFieldStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  TextFieldStyle variants(List<VariantStyle<TextFieldSpec>> value) {
    return merge(TextFieldStyle(variants: value));
  }

  @override
  TextFieldStyle wrap(ModifierConfig value) {
    return merge(TextFieldStyle(modifier: value));
  }

  @override
  TextFieldSpec resolve(BuildContext context) {
    return TextFieldSpec(
      style: MixOps.resolve(context, $style),
      hintTextColor: MixOps.resolve(context, $hintTextColor),
      textAlign: MixOps.resolve(context, $textAlign),
      cursorWidth: MixOps.resolve(context, $cursorWidth),
      cursorHeight: MixOps.resolve(context, $cursorHeight),
      cursorRadius: MixOps.resolve(context, $cursorRadius),
      cursorColor: MixOps.resolve(context, $cursorColor),
      cursorOffset: MixOps.resolve(context, $cursorOffset),
      cursorOpacityAnimates: MixOps.resolve(context, $cursorOpacityAnimates),
      selectionHeightStyle: MixOps.resolve(context, $selectionHeightStyle),
      selectionWidthStyle: MixOps.resolve(context, $selectionWidthStyle),
      scrollPadding: MixOps.resolve(context, $scrollPadding),
      keyboardAppearance: MixOps.resolve(context, $keyboardAppearance),
      spacing: MixOps.resolve(context, $spacing),
      container: MixOps.resolve(context, $container),
      helperText: MixOps.resolve(context, $helperText),
    );
  }

  @override
  TextFieldStyle merge(TextFieldStyle? other) {
    if (other == null) return this;

    return TextFieldStyle.create(
      style: MixOps.merge($style, other.$style),
      hintTextColor: MixOps.merge($hintTextColor, other.$hintTextColor),
      textAlign: MixOps.merge($textAlign, other.$textAlign),
      cursorWidth: MixOps.merge($cursorWidth, other.$cursorWidth),
      cursorHeight: MixOps.merge($cursorHeight, other.$cursorHeight),
      cursorRadius: MixOps.merge($cursorRadius, other.$cursorRadius),
      cursorColor: MixOps.merge($cursorColor, other.$cursorColor),
      cursorOffset: MixOps.merge($cursorOffset, other.$cursorOffset),
      cursorOpacityAnimates: MixOps.merge($cursorOpacityAnimates, other.$cursorOpacityAnimates),
      selectionHeightStyle: MixOps.merge($selectionHeightStyle, other.$selectionHeightStyle),
      selectionWidthStyle: MixOps.merge($selectionWidthStyle, other.$selectionWidthStyle),
      scrollPadding: MixOps.merge($scrollPadding, other.$scrollPadding),
      keyboardAppearance: MixOps.merge($keyboardAppearance, other.$keyboardAppearance),
      spacing: MixOps.merge($spacing, other.$spacing),
      container: MixOps.merge($container, other.$container),
      helperText: MixOps.merge($helperText, other.$helperText),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  List<Object?> get props => [
        $style,
        $hintTextColor,
        $textAlign,
        $cursorWidth,
        $cursorHeight,
        $cursorRadius,
        $cursorColor,
        $cursorOffset,
        $cursorOpacityAnimates,
        $selectionHeightStyle,
        $selectionWidthStyle,
        $scrollPadding,
        $keyboardAppearance,
        $spacing,
        $container,
        $helperText,
        $variants,
        $animation,
        $modifier,
        $inherit,
      ];
}

// Default style
final DefaultTextFieldStyle = TextFieldStyle(
  style: TextStyle(
    fontSize: 14,
    color: Colors.black87,
  ),
  hintTextColor: Colors.grey.shade400,
  textAlign: TextAlign.start,
  cursorWidth: 2.0,
  cursorColor: Colors.blue,
  cursorOffset: Offset.zero,
  selectionHeightStyle: BoxHeightStyle.tight,
  selectionWidthStyle: BoxWidthStyle.tight,
  scrollPadding: const EdgeInsets.all(20.0),
  spacing: 4,
  container: FlexBoxMix(
    box: BoxMix(
      padding: EdgeInsetsMix.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecorationMix(
        borderRadius: BorderRadiusMix.circular(6),
        border: BoxBorderMix.all(
          BorderSideMix(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
    ),
    flex: FlexMix(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
    ),
  ),
  helperText: TextMix(
    style: TextStyleMix(
      fontSize: 12,
      color: Colors.grey.shade600,
    ),
  ),
);

// Focus style
final TextFieldFocusStyle = TextFieldStyle(
  container: FlexBoxMix(
    box: BoxMix(
      decoration: BoxDecorationMix(
        border: BoxBorderMix.all(
          BorderSideMix(
            color: Colors.blue,
            width: 2,
          ),
        ),
      ),
    ),
  ),
);

// Error style
final TextFieldErrorStyle = TextFieldStyle(
  container: FlexBoxMix(
    box: BoxMix(
      decoration: BoxDecorationMix(
        border: BoxBorderMix.all(
          BorderSideMix(
            color: Colors.red,
            width: 1,
          ),
        ),
      ),
    ),
  ),
  helperText: TextMix(
    style: TextStyleMix(
      color: Colors.red,
    ),
  ),
);

// Disabled style
final TextFieldDisabledStyle = TextFieldStyle(
  style: TextStyle(
    color: Colors.grey.shade500,
  ),
  container: FlexBoxMix(
    box: BoxMix(
      decoration: BoxDecorationMix(
        color: Colors.grey.shade100,
        border: BoxBorderMix.all(
          BorderSideMix(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
    ),
  ),
);