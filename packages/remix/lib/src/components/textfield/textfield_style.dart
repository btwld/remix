part of 'textfield.dart';

class RemixTextFieldStyle
    extends RemixFlexContainerStyle<RemixTextFieldSpec, RemixTextFieldStyle>
    with LabelStyleMixin<RemixTextFieldStyle> {
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
  }) : $text = text,
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
    List<VariantStyle<RemixTextFieldSpec>>? variants,
    WidgetModifierConfig? modifier,
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
    return merge(
      RemixTextFieldStyle(
        text: TextStyler(style: TextStyleMix(color: value)),
      ),
    );
  }

  /// Sets background color
  RemixTextFieldStyle backgroundColor(Color value) {
    return merge(
      RemixTextFieldStyle(
        container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets container that wraps editable text area
  RemixTextFieldStyle container(FlexBoxStyler value) {
    return merge(RemixTextFieldStyle(container: value));
  }

  /// Sets border radius
  RemixTextFieldStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixTextFieldStyle(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  /// Sets padding
  RemixTextFieldStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixTextFieldStyle(container: FlexBoxStyler(padding: value)));
  }

  /// Sets border
  RemixTextFieldStyle border(BoxBorderMix value) {
    return merge(
      RemixTextFieldStyle(
        container: FlexBoxStyler(decoration: BoxDecorationMix(border: value)),
      ),
    );
  }

  /// Sets width
  RemixTextFieldStyle width(double value) {
    return merge(
      RemixTextFieldStyle(
        container: FlexBoxStyler(
          constraints: BoxConstraintsMix(minWidth: value, maxWidth: value),
        ),
      ),
    );
  }

  /// Sets height
  RemixTextFieldStyle height(double value) {
    return merge(
      RemixTextFieldStyle(
        container: FlexBoxStyler(
          constraints: BoxConstraintsMix(minHeight: value, maxHeight: value),
        ),
      ),
    );
  }

  /// Sets cursor color
  RemixTextFieldStyle cursorColor(Color value) {
    return merge(RemixTextFieldStyle(cursorColor: value));
  }

  /// Sets hint text color
  RemixTextFieldStyle hintColor(Color value) {
    return merge(
      RemixTextFieldStyle(
        hintText: TextStyler(style: TextStyleMix(color: value)),
      ),
    );
  }

  /// Sets hint text color
  RemixTextFieldStyle hintText(TextStyler value) {
    return merge(RemixTextFieldStyle(hintText: value));
  }

  // Additional convenience methods that delegate to container

  /// Sets margin
  RemixTextFieldStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixTextFieldStyle(container: FlexBoxStyler(margin: value)));
  }

  /// Sets flex spacing
  RemixTextFieldStyle spacing(double value) {
    return merge(RemixTextFieldStyle(container: FlexBoxStyler(spacing: value)));
  }

  /// Sets decoration
  RemixTextFieldStyle decoration(DecorationMix value) {
    return merge(
      RemixTextFieldStyle(container: FlexBoxStyler(decoration: value)),
    );
  }

  /// Sets container alignment
  RemixTextFieldStyle alignment(Alignment value) {
    return merge(
      RemixTextFieldStyle(container: FlexBoxStyler(alignment: value)),
    );
  }

  /// Sets constraints
  RemixTextFieldStyle constraints(BoxConstraintsMix value) {
    return merge(
      RemixTextFieldStyle(container: FlexBoxStyler(constraints: value)),
    );
  }

  /// Sets text alignment
  RemixTextFieldStyle textAlign(TextAlign value) {
    return merge(RemixTextFieldStyle(textAlign: value));
  }

  /// Sets helper text
  RemixTextFieldStyle helperText(TextStyler value) {
    return merge(RemixTextFieldStyle(helperText: value));
  }

  /// Sets label text
  @override
  RemixTextFieldStyle label(TextStyler value) {
    return merge(RemixTextFieldStyle(label: value));
  }

  /// Sets animation
  @override
  RemixTextFieldStyle animate(AnimationConfig animation) {
    return merge(RemixTextFieldStyle(animation: animation));
  }

  @override
  RemixTextFieldStyle variants(List<VariantStyle<RemixTextFieldSpec>> value) {
    return merge(RemixTextFieldStyle(variants: value));
  }

  @override
  RemixTextFieldStyle wrap(WidgetModifierConfig value) {
    return merge(RemixTextFieldStyle(modifier: value));
  }

  // Abstract method implementations for mixins

  @override
  RemixTextFieldStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixTextFieldStyle(
        container: FlexBoxStyler(foregroundDecoration: value),
      ),
    );
  }

  @override
  RemixTextFieldStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixTextFieldStyle(
        container: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  @override
  StyleSpec<RemixTextFieldSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixTextFieldSpec(
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
      cursorOpacityAnimates: MixOps.merge(
        $cursorOpacityAnimates,
        other.$cursorOpacityAnimates,
      ),
      selectionHeightStyle: MixOps.merge(
        $selectionHeightStyle,
        other.$selectionHeightStyle,
      ),
      selectionWidthStyle: MixOps.merge(
        $selectionWidthStyle,
        other.$selectionWidthStyle,
      ),
      scrollPadding: MixOps.merge($scrollPadding, other.$scrollPadding),
      keyboardAppearance: MixOps.merge(
        $keyboardAppearance,
        other.$keyboardAppearance,
      ),
      spacing: MixOps.merge($spacing, other.$spacing),
      container: MixOps.merge($container, other.$container),
      helperText: MixOps.merge($helperText, other.$helperText),
      label: MixOps.merge($label, other.$label),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  // FlexStyleMixin implementation
  @override
  RemixTextFieldStyle flex(FlexStyler value) {
    return merge(RemixTextFieldStyle(container: FlexBoxStyler().flex(value)));
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
    $label,
    $helperText,
    $variants,
    $animation,
    $modifier,
  ];
}
