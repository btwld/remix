part of 'textfield.dart';

class RemixTextFieldStyle extends Style<TextFieldSpec>
    with
        StyleModifierMixin<RemixTextFieldStyle, TextFieldSpec>,
        StyleVariantMixin<RemixTextFieldStyle, TextFieldSpec> {
  final Prop<TextSpec>? $text;
  final Prop<TextSpec>? $hintText;
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
  final Prop<TextSpec>? $label;

  const RemixTextFieldStyle.create({
    Prop<TextSpec>? text,
    Prop<TextSpec>? hintText,
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
    Prop<TextSpec>? label,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $text = text,
        $hintText = hintText,
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
        $helperText = helperText,
        $label = label;

  RemixTextFieldStyle({
    TextMix? text,
    TextMix? hintText,
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
    TextMix? label,
    AnimationConfig? animation,
    List<VariantStyle<TextFieldSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          text: text != null ? Prop.mix(text) : null,
          hintText: hintText != null ? Prop.mix(hintText) : null,
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
          label: label != null ? Prop.mix(label) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  // Factory methods for common properties

  /// Factory for text color
  factory RemixTextFieldStyle.color(Color value) {
    return RemixTextFieldStyle(text: TextMix(style: TextStyleMix(color: value)));
  }

  /// Factory for background color
  factory RemixTextFieldStyle.backgroundColor(Color value) {
    return RemixTextFieldStyle(container: FlexBoxMix.color(value));
  }

  /// Factory for border radius
  factory RemixTextFieldStyle.borderRadius(double radius) {
    return RemixTextFieldStyle(
      container: FlexBoxMix.borderRadius(BorderRadiusMix.circular(radius)),
    );
  }

  /// Factory for padding
  factory RemixTextFieldStyle.padding(double value) {
    return RemixTextFieldStyle(
      container: FlexBoxMix.padding(EdgeInsetsMix.all(value)),
    );
  }

  /// Factory for border
  factory RemixTextFieldStyle.border(BoxBorderMix value) {
    return RemixTextFieldStyle(container: FlexBoxMix.border(value));
  }

  /// Factory for width
  factory RemixTextFieldStyle.width(double value) {
    return RemixTextFieldStyle(container: FlexBoxMix.width(value));
  }

  /// Factory for height
  factory RemixTextFieldStyle.height(double value) {
    return RemixTextFieldStyle(container: FlexBoxMix.height(value));
  }

  /// Factory for cursor color
  factory RemixTextFieldStyle.cursorColor(Color value) {
    return RemixTextFieldStyle(cursorColor: value);
  }

  /// Factory for hint text color
  factory RemixTextFieldStyle.hintColor(Color value) {
    return RemixTextFieldStyle(hintText: TextMix(style: TextStyleMix(color: value)));
  }

  // Instance methods (chainable)

  /// Sets text color
  RemixTextFieldStyle color(Color value) {
    return merge(RemixTextFieldStyle.color(value));
  }

  /// Sets background color
  RemixTextFieldStyle backgroundColor(Color value) {
    return merge(RemixTextFieldStyle.backgroundColor(value));
  }

  /// Sets border radius
  RemixTextFieldStyle borderRadius(double radius) {
    return merge(RemixTextFieldStyle.borderRadius(radius));
  }

  /// Sets padding
  RemixTextFieldStyle padding(double value) {
    return merge(RemixTextFieldStyle.padding(value));
  }

  /// Sets border
  RemixTextFieldStyle border(BoxBorderMix value) {
    return merge(RemixTextFieldStyle.border(value));
  }

  /// Sets width
  RemixTextFieldStyle width(double value) {
    return merge(RemixTextFieldStyle.width(value));
  }

  /// Sets height
  RemixTextFieldStyle height(double value) {
    return merge(RemixTextFieldStyle.height(value));
  }

  /// Sets cursor color
  RemixTextFieldStyle cursorColor(Color value) {
    return merge(RemixTextFieldStyle.cursorColor(value));
  }

  /// Sets hint text color
  RemixTextFieldStyle hintColor(Color value) {
    return merge(RemixTextFieldStyle.hintColor(value));
  }

  /// Sets animation
  RemixTextFieldStyle animate(AnimationConfig animation) {
    return merge(RemixTextFieldStyle(animation: animation));
  }

  /// Sets variant
  @override
  RemixTextFieldStyle variant(Variant variant, RemixTextFieldStyle style) {
    return merge(RemixTextFieldStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  RemixTextFieldStyle variants(List<VariantStyle<TextFieldSpec>> value) {
    return merge(RemixTextFieldStyle(variants: value));
  }

  @override
  RemixTextFieldStyle wrap(ModifierConfig value) {
    return merge(RemixTextFieldStyle(modifier: value));
  }

  @override
  TextFieldSpec resolve(BuildContext context) {
    return TextFieldSpec(
      text: MixOps.resolve(context, $text),
      hintText: MixOps.resolve(context, $hintText),
      textAlign: MixOps.resolve(context, $textAlign),
      cursorWidth: MixOps.resolve(context, $cursorWidth),
      cursorHeight: MixOps.resolve(context, $cursorHeight),
      cursorRadius: MixOps.resolve(context, $cursorRadius),
      cursorColor: MixOps.resolve(context, $cursorColor),
      cursorOffset: MixOps.resolve(context, $cursorOffset),
      selectionHeightStyle: MixOps.resolve(context, $selectionHeightStyle),
      selectionWidthStyle: MixOps.resolve(context, $selectionWidthStyle),
      scrollPadding: MixOps.resolve(context, $scrollPadding),
      keyboardAppearance: MixOps.resolve(context, $keyboardAppearance),
      cursorOpacityAnimates: MixOps.resolve(context, $cursorOpacityAnimates),
      spacing: MixOps.resolve(context, $spacing),
      container: MixOps.resolve(context, $container),
      helperText: MixOps.resolve(context, $helperText),
      label: MixOps.resolve(context, $label),
    );
  }

  @override
  RemixTextFieldStyle merge(RemixTextFieldStyle? other) {
    if (other == null) return this;

    return RemixTextFieldStyle.create(
      text: MixOps.merge($text, other.$text),
      hintText: MixOps.merge($hintText, other.$hintText),
      textAlign: MixOps.merge($textAlign, other.$textAlign),
      cursorWidth: MixOps.merge($cursorWidth, other.$cursorWidth),
      cursorHeight: MixOps.merge($cursorHeight, other.$cursorHeight),
      cursorRadius: MixOps.merge($cursorRadius, other.$cursorRadius),
      cursorColor: MixOps.merge($cursorColor, other.$cursorColor),
      cursorOffset: MixOps.merge($cursorOffset, other.$cursorOffset),
      cursorOpacityAnimates:
          MixOps.merge($cursorOpacityAnimates, other.$cursorOpacityAnimates),
      selectionHeightStyle:
          MixOps.merge($selectionHeightStyle, other.$selectionHeightStyle),
      selectionWidthStyle:
          MixOps.merge($selectionWidthStyle, other.$selectionWidthStyle),
      scrollPadding: MixOps.merge($scrollPadding, other.$scrollPadding),
      keyboardAppearance:
          MixOps.merge($keyboardAppearance, other.$keyboardAppearance),
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
        $text,
        $hintText,
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
final DefaultRemixTextFieldStyle = RemixTextFieldStyle(
  text: TextMix(style: TextStyleMix(color: Colors.black87, fontSize: 14)),
  hintText: TextMix(style: TextStyleMix(color: Colors.grey.shade400)),
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
      padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecorationMix(
        border: BoxBorderMix.all(
          BorderSideMix(color: Colors.grey.shade300, width: 1),
        ),
        borderRadius: BorderRadiusMix.circular(6),
      ),
    ),
    flex: FlexMix(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
    ),
  ),
  helperText: TextMix(
    style: TextStyleMix(color: Colors.grey.shade600, fontSize: 12),
  ),
);

// Focus style
final RemixTextFieldFocusStyle = RemixTextFieldStyle(
  container: FlexBoxMix(
    box: BoxMix(
      decoration: BoxDecorationMix(
        border: BoxBorderMix.all(
          BorderSideMix(color: Colors.blue, width: 2),
        ),
      ),
    ),
  ),
);

// Error style
final RemixTextFieldErrorStyle = RemixTextFieldStyle(
  container: FlexBoxMix(
    box: BoxMix(
      decoration: BoxDecorationMix(
        border: BoxBorderMix.all(BorderSideMix(color: Colors.red, width: 1)),
      ),
    ),
  ),
  helperText: TextMix(style: TextStyleMix(color: Colors.red)),
);

// Disabled style
final RemixTextFieldDisabledStyle = RemixTextFieldStyle(
  text: TextMix(style: TextStyleMix(color: Colors.grey.shade500)),
  container: FlexBoxMix(
    box: BoxMix(
      decoration: BoxDecorationMix(
        border: BoxBorderMix.all(
          BorderSideMix(color: Colors.grey.shade300, width: 1),
        ),
        color: Colors.grey.shade100,
      ),
    ),
  ),
);

extension RemixTextFieldVariants on RemixTextFieldStyle {
  /// Primary text field variant with blue accents
  static RemixTextFieldStyle get primary => RemixTextFieldStyle(
        text: TextMix(style: TextStyleMix(color: Colors.black87, fontSize: 14)),
        hintText: TextMix(style: TextStyleMix(color: Colors.grey.shade400)),
        textAlign: TextAlign.start,
        cursorWidth: 2.0,
        cursorColor: Colors.blue[500],
        cursorOffset: Offset.zero,
        selectionHeightStyle: BoxHeightStyle.tight,
        selectionWidthStyle: BoxWidthStyle.tight,
        scrollPadding: const EdgeInsets.all(20.0),
        spacing: 4,
        container: FlexBoxMix(
          box: BoxMix(
            padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecorationMix(
              border: BoxBorderMix.all(
                BorderSideMix(color: Colors.blue[500]!, width: 1),
              ),
              borderRadius: BorderRadiusMix.circular(6),
              color: Colors.blue[25],
            ),
          ),
          flex: FlexMix(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
        helperText: TextMix(
          style: TextStyleMix(color: Colors.blue.shade600, fontSize: 12),
        ),
      );

  /// Outlined text field variant with prominent border
  static RemixTextFieldStyle get outlined => RemixTextFieldStyle(
        text: TextMix(style: TextStyleMix(color: Colors.black87, fontSize: 14)),
        hintText: TextMix(style: TextStyleMix(color: Colors.grey.shade400)),
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
            padding: EdgeInsetsMix.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecorationMix(
              border: BoxBorderMix.all(
                BorderSideMix(color: Colors.grey.shade400, width: 2),
              ),
              borderRadius: BorderRadiusMix.circular(6),
              color: Colors.transparent,
            ),
          ),
          flex: FlexMix(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
        helperText: TextMix(
          style: TextStyleMix(color: Colors.grey.shade600, fontSize: 12),
        ),
      );

  /// Filled text field variant with background color
  static RemixTextFieldStyle get filled => RemixTextFieldStyle(
        text: TextMix(style: TextStyleMix(color: Colors.black87, fontSize: 14)),
        hintText: TextMix(style: TextStyleMix(color: Colors.grey.shade500)),
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
            padding: EdgeInsetsMix.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecorationMix(
              border: BoxBorderMix.all(
                BorderSideMix(color: Colors.transparent, width: 1),
              ),
              borderRadius: BorderRadiusMix.circular(8),
              color: Colors.grey.shade100,
            ),
          ),
          flex: FlexMix(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
        helperText: TextMix(
          style: TextStyleMix(color: Colors.grey.shade600, fontSize: 12),
        ),
      );
}
