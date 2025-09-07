part of 'textfield.dart';

// Private per-component constants (sizes only)

const _kFontSizeSm = 12.0;
const _kFontSizeMd = 14.0;

class RemixTextFieldStyle extends Style<TextFieldSpec>
    with
        StyleModifierMixin<RemixTextFieldStyle, TextFieldSpec>,
        StyleVariantMixin<RemixTextFieldStyle, TextFieldSpec>,
        ModifierStyleMixin<RemixTextFieldStyle, TextFieldSpec>,
        BorderStyleMixin<RemixTextFieldStyle>,
        BorderRadiusStyleMixin<RemixTextFieldStyle>,
        ShadowStyleMixin<RemixTextFieldStyle>,
        DecorationStyleMixin<RemixTextFieldStyle>,
        SpacingStyleMixin<RemixTextFieldStyle>,
        TransformStyleMixin<RemixTextFieldStyle>,
        ConstraintStyleMixin<RemixTextFieldStyle>,
        AnimationStyleMixin<TextFieldSpec, RemixTextFieldStyle> {
  final Prop<StyleSpec<TextSpec>>? $text;
  final Prop<StyleSpec<TextSpec>>? $hintText;
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
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $helperText;
  final Prop<StyleSpec<TextSpec>>? $label;

  const RemixTextFieldStyle.create({
    Prop<StyleSpec<TextSpec>>? text,
    Prop<StyleSpec<TextSpec>>? hintText,
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
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? helperText,
    Prop<StyleSpec<TextSpec>>? label,
    super.variants,
    super.animation,
    super.modifier,
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
    TextStyler? text,
    TextStyler? hintText,
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
    FlexBoxStyler? container,
    TextStyler? helperText,
    TextStyler? label,
    AnimationConfig? animation,
    List<VariantStyle<TextFieldSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          text: Prop.maybeMix(text),
          hintText: Prop.maybeMix(hintText),
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
          container: Prop.maybeMix(container),
          helperText: Prop.maybeMix(helperText),
          label: Prop.maybeMix(label),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  // Instance methods (chainable)

  /// Sets text color
  RemixTextFieldStyle color(Color value) {
    return merge(RemixTextFieldStyle(
      text: TextStyler(style: TextStyleMix(color: value)),
    ));
  }

  /// Sets background color
  RemixTextFieldStyle backgroundColor(Color value) {
    return merge(RemixTextFieldStyle(
      container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets border radius
  RemixTextFieldStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixTextFieldStyle(
      container: FlexBoxStyler(
        decoration: BoxDecorationMix(borderRadius: radius),
      ),
    ));
  }

  /// Sets padding
  RemixTextFieldStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixTextFieldStyle(
      container: FlexBoxStyler(padding: value),
    ));
  }

  /// Sets border
  RemixTextFieldStyle border(BoxBorderMix value) {
    return merge(RemixTextFieldStyle(
      container: FlexBoxStyler(decoration: BoxDecorationMix(border: value)),
    ));
  }

  /// Sets width
  RemixTextFieldStyle width(double value) {
    return merge(RemixTextFieldStyle(
      container: FlexBoxStyler(
        constraints: BoxConstraintsMix(minWidth: value, maxWidth: value),
      ),
    ));
  }

  /// Sets height
  RemixTextFieldStyle height(double value) {
    return merge(RemixTextFieldStyle(
      container: FlexBoxStyler(
        constraints: BoxConstraintsMix(minHeight: value, maxHeight: value),
      ),
    ));
  }

  /// Sets cursor color
  RemixTextFieldStyle cursorColor(Color value) {
    return merge(RemixTextFieldStyle(cursorColor: value));
  }

  /// Sets hint text color
  RemixTextFieldStyle hintColor(Color value) {
    return merge(RemixTextFieldStyle(
      hintText: TextStyler(style: TextStyleMix(color: value)),
    ));
  }

  // Additional convenience methods that delegate to container

  /// Sets margin
  RemixTextFieldStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixTextFieldStyle(
      container: FlexBoxStyler(margin: value),
    ));
  }

  /// Sets flex spacing
  RemixTextFieldStyle spacing(double value) {
    return merge(RemixTextFieldStyle(
      container: FlexBoxStyler(spacing: value),
    ));
  }

  /// Sets decoration
  RemixTextFieldStyle decoration(DecorationMix value) {
    return merge(RemixTextFieldStyle(
      container: FlexBoxStyler(decoration: value),
    ));
  }

  /// Sets constraints
  RemixTextFieldStyle constraints(BoxConstraintsMix value) {
    return merge(RemixTextFieldStyle(
      container: FlexBoxStyler(constraints: value),
    ));
  }

  /// Sets text alignment
  RemixTextFieldStyle textAlign(TextAlign value) {
    return merge(RemixTextFieldStyle(textAlign: value));
  }

  /// Sets label text
  RemixTextFieldStyle label(TextStyler value) {
    return merge(RemixTextFieldStyle(label: value));
  }

  /// Sets helper text
  RemixTextFieldStyle helperText(TextStyler value) {
    return merge(RemixTextFieldStyle(helperText: value));
  }

  /// Sets animation
  @override
  RemixTextFieldStyle animate(AnimationConfig animation) {
    return merge(RemixTextFieldStyle(animation: animation));
  }

  @override
  RemixTextFieldStyle variants(List<VariantStyle<TextFieldSpec>> value) {
    return merge(RemixTextFieldStyle(variants: value));
  }

  @override
  RemixTextFieldStyle wrap(ModifierConfig value) {
    return merge(RemixTextFieldStyle(modifier: value));
  }

  // Abstract method implementations for mixins

  @override
  RemixTextFieldStyle foregroundDecoration(DecorationMix value) {
    return merge(RemixTextFieldStyle(
      container: FlexBoxStyler(foregroundDecoration: value),
    ));
  }

  @override
  RemixTextFieldStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixTextFieldStyle(
      container: FlexBoxStyler(alignment: alignment, transform: value),
    ));
  }

  @override
  StyleSpec<TextFieldSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: TextFieldSpec(
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
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
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
      label: MixOps.merge($label, other.$label),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
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
      ];
}

// Default style is provided by RemixTextFieldStyles.defaultStyle

// Focus style
final RemixTextFieldFocusStyle = RemixTextFieldStyle(
  container: FlexBoxStyler(
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(
        BorderSideMix(color: RemixTokens.primary(), width: 2),
      ),
    ),
  ),
);

// Error style
final RemixTextFieldErrorStyle = RemixTextFieldStyle(
  container: FlexBoxStyler(
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(
        BorderSideMix(color: RemixTokens.primary(), width: 1),
      ),
    ),
  ),
  helperText: TextStyler(style: TextStyleMix(color: RemixTokens.primary())),
);

// Disabled style
final RemixTextFieldDisabledStyle = RemixTextFieldStyle(
  text: TextStyler(
    style: TextStyleMix(
      color: RemixTokens.primary().withValues(alpha: 0.40),
    ),
  ),
  container: FlexBoxStyler(
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(
        BorderSideMix(
          color: RemixTokens.primary().withValues(alpha: 0.06),
          width: 1,
        ),
      ),
      color: RemixTokens.primary().withValues(alpha: 0.03),
    ),
  ),
);

// Variants are exposed via RemixTextFieldStyles

/// Canonical access to default and common state styles
class RemixTextFieldStyles {
  /// Default text field style
  static RemixTextFieldStyle get defaultStyle => RemixTextFieldStyle(
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.primary(),
            fontSize: _kFontSizeMd,
          ),
        ),
        hintText: TextStyler(
          style:
              TextStyleMix(color: RemixTokens.primary().withValues(alpha: 0.5)),
        ),
        textAlign: TextAlign.start,
        cursorWidth: 2.0,
        cursorColor: RemixTokens.primary(),
        cursorOffset: Offset.zero,
        selectionHeightStyle: BoxHeightStyle.tight,
        selectionWidthStyle: BoxWidthStyle.tight,
        scrollPadding: EdgeInsets.all(RemixTokens.spaceLg()),
        spacing: RemixTokens.spaceXs(),
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(
                color: RemixTokens.primary().withValues(alpha: 0.20),
                width: 1,
              ),
            ),
            borderRadius: BorderRadiusMix.circular(SpaceTokens.radius()),
            color: RemixTokens.onPrimary(),
          ),
          padding: EdgeInsetsGeometryMix.symmetric(
            vertical: RemixTokens.spaceSm(),
            horizontal: RemixTokens.spaceMd(),
          ),
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        helperText: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.secondary().withValues(alpha: 0.6),
            fontSize: _kFontSizeSm,
          ),
        ),
      );

  /// Focused state style
  static RemixTextFieldStyle get focused => RemixTextFieldFocusStyle;

  /// Error state style
  static RemixTextFieldStyle get error => RemixTextFieldErrorStyle;

  /// Disabled state style
  static RemixTextFieldStyle get disabled => RemixTextFieldDisabledStyle;

  /// Solid variant (default-like variant)
  static RemixTextFieldStyle get solid => RemixTextFieldStyle(
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.primary(),
            fontSize: _kFontSizeMd,
          ),
        ),
        hintText: TextStyler(
          style:
              TextStyleMix(color: RemixTokens.primary().withValues(alpha: 0.5)),
        ),
        textAlign: TextAlign.start,
        cursorWidth: 2.0,
        cursorColor: RemixTokens.primary(),
        cursorOffset: Offset.zero,
        selectionHeightStyle: BoxHeightStyle.tight,
        selectionWidthStyle: BoxWidthStyle.tight,
        scrollPadding: EdgeInsets.all(RemixTokens.spaceLg()),
        spacing: RemixTokens.spaceXs(),
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(
                color: RemixTokens.primary().withValues(alpha: 0.20),
                width: 1,
              ),
            ),
            borderRadius: BorderRadiusMix.circular(SpaceTokens.radius()),
            color: RemixTokens.onPrimary(),
          ),
          padding: EdgeInsetsGeometryMix.symmetric(
            vertical: RemixTokens.spaceSm(),
            horizontal: RemixTokens.spaceMd(),
          ),
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        helperText: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.secondary().withValues(alpha: 0.6),
            fontSize: _kFontSizeSm,
          ),
        ),
      );

  /// Outline variant - transparent background with emphasized border
  static RemixTextFieldStyle get outline => RemixTextFieldStyle(
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.primary(),
            fontSize: _kFontSizeMd,
          ),
        ),
        hintText: TextStyler(
          style:
              TextStyleMix(color: RemixTokens.primary().withValues(alpha: 0.5)),
        ),
        textAlign: TextAlign.start,
        cursorWidth: 2.0,
        cursorColor: RemixTokens.primary(),
        cursorOffset: Offset.zero,
        selectionHeightStyle: BoxHeightStyle.tight,
        selectionWidthStyle: BoxWidthStyle.tight,
        scrollPadding: EdgeInsets.all(RemixTokens.spaceLg()),
        spacing: RemixTokens.spaceXs(),
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RemixTokens.primary(), width: 2),
            ),
            borderRadius: BorderRadiusMix.circular(SpaceTokens.radius()),
            color: RemixTokens.onPrimary().withValues(alpha: 0.0),
          ),
          padding: EdgeInsetsGeometryMix.symmetric(
            vertical: RemixTokens.spaceSm(),
            horizontal: RemixTokens.spaceMd(),
          ),
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        helperText: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.secondary().withValues(alpha: 0.6),
            fontSize: _kFontSizeSm,
          ),
        ),
      );
}
