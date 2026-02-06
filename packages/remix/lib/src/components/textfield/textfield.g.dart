// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'textfield.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixTextFieldSpecMethods on Spec<RemixTextFieldSpec>, Diagnosticable {
  StyleSpec<TextSpec>? get text;
  StyleSpec<TextSpec>? get hintText;
  TextAlign? get textAlign;
  double? get cursorWidth;
  double? get cursorHeight;
  Radius? get cursorRadius;
  Color? get cursorColor;
  Offset? get cursorOffset;
  BoxHeightStyle? get selectionHeightStyle;
  BoxWidthStyle? get selectionWidthStyle;
  EdgeInsets? get scrollPadding;
  Brightness? get keyboardAppearance;
  bool? get cursorOpacityAnimates;
  double? get spacing;
  StyleSpec<FlexBoxSpec>? get container;
  StyleSpec<TextSpec>? get helperText;
  StyleSpec<TextSpec>? get label;

  @override
  RemixTextFieldSpec copyWith({
    StyleSpec<TextSpec>? text,
    StyleSpec<TextSpec>? hintText,
    TextAlign? textAlign,
    double? cursorWidth,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Offset? cursorOffset,
    BoxHeightStyle? selectionHeightStyle,
    BoxWidthStyle? selectionWidthStyle,
    EdgeInsets? scrollPadding,
    Brightness? keyboardAppearance,
    bool? cursorOpacityAnimates,
    double? spacing,
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? helperText,
    StyleSpec<TextSpec>? label,
  }) {
    return RemixTextFieldSpec(
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

  @override
  RemixTextFieldSpec lerp(RemixTextFieldSpec? other, double t) {
    return RemixTextFieldSpec(
      text: text?.lerp(other?.text, t),
      hintText: hintText?.lerp(other?.hintText, t),
      textAlign: MixOps.lerpSnap(textAlign, other?.textAlign, t),
      cursorWidth: MixOps.lerp(cursorWidth, other?.cursorWidth, t),
      cursorHeight: MixOps.lerp(cursorHeight, other?.cursorHeight, t),
      cursorRadius: MixOps.lerpSnap(cursorRadius, other?.cursorRadius, t),
      cursorColor: MixOps.lerp(cursorColor, other?.cursorColor, t),
      cursorOffset: MixOps.lerp(cursorOffset, other?.cursorOffset, t),
      selectionHeightStyle: MixOps.lerpSnap(
        selectionHeightStyle,
        other?.selectionHeightStyle,
        t,
      ),
      selectionWidthStyle: MixOps.lerpSnap(
        selectionWidthStyle,
        other?.selectionWidthStyle,
        t,
      ),
      scrollPadding: MixOps.lerp(scrollPadding, other?.scrollPadding, t),
      keyboardAppearance: MixOps.lerpSnap(
        keyboardAppearance,
        other?.keyboardAppearance,
        t,
      ),
      cursorOpacityAnimates: MixOps.lerpSnap(
        cursorOpacityAnimates,
        other?.cursorOpacityAnimates,
        t,
      ),
      spacing: MixOps.lerp(spacing, other?.spacing, t),
      container: container?.lerp(other?.container, t),
      helperText: helperText?.lerp(other?.helperText, t),
      label: label?.lerp(other?.label, t),
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
      ..add(DiagnosticsProperty('selectionHeightStyle', selectionHeightStyle))
      ..add(DiagnosticsProperty('selectionWidthStyle', selectionWidthStyle))
      ..add(DiagnosticsProperty('scrollPadding', scrollPadding))
      ..add(DiagnosticsProperty('keyboardAppearance', keyboardAppearance))
      ..add(DiagnosticsProperty('cursorOpacityAnimates', cursorOpacityAnimates))
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
    selectionHeightStyle,
    selectionWidthStyle,
    scrollPadding,
    keyboardAppearance,
    cursorOpacityAnimates,
    spacing,
    container,
    helperText,
    label,
  ];
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixTextFieldStyleMixin on Style<RemixTextFieldSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $container;
  Prop<Color>? get $cursorColor;
  Prop<double>? get $cursorHeight;
  Prop<Offset>? get $cursorOffset;
  Prop<bool>? get $cursorOpacityAnimates;
  Prop<Radius>? get $cursorRadius;
  Prop<double>? get $cursorWidth;
  Prop<StyleSpec<TextSpec>>? get $helperText;
  Prop<StyleSpec<TextSpec>>? get $hintText;
  Prop<Brightness>? get $keyboardAppearance;
  Prop<StyleSpec<TextSpec>>? get $label;
  Prop<EdgeInsets>? get $scrollPadding;
  Prop<BoxHeightStyle>? get $selectionHeightStyle;
  Prop<BoxWidthStyle>? get $selectionWidthStyle;
  Prop<double>? get $spacing;
  Prop<StyleSpec<TextSpec>>? get $text;
  Prop<TextAlign>? get $textAlign;

  /// Sets the container.
  RemixTextFieldStyle container(FlexBoxStyler value) {
    return merge(RemixTextFieldStyle(container: value));
  }

  /// Sets the cursorColor.
  RemixTextFieldStyle cursorColor(Color value) {
    return merge(RemixTextFieldStyle(cursorColor: value));
  }

  /// Sets the cursorHeight.
  RemixTextFieldStyle cursorHeight(double value) {
    return merge(RemixTextFieldStyle(cursorHeight: value));
  }

  /// Sets the cursorOffset.
  RemixTextFieldStyle cursorOffset(Offset value) {
    return merge(RemixTextFieldStyle(cursorOffset: value));
  }

  /// Sets the cursorOpacityAnimates.
  RemixTextFieldStyle cursorOpacityAnimates(bool value) {
    return merge(RemixTextFieldStyle(cursorOpacityAnimates: value));
  }

  /// Sets the cursorRadius.
  RemixTextFieldStyle cursorRadius(Radius value) {
    return merge(RemixTextFieldStyle(cursorRadius: value));
  }

  /// Sets the cursorWidth.
  RemixTextFieldStyle cursorWidth(double value) {
    return merge(RemixTextFieldStyle(cursorWidth: value));
  }

  /// Sets the helperText.
  RemixTextFieldStyle helperText(TextStyler value) {
    return merge(RemixTextFieldStyle(helperText: value));
  }

  /// Sets the hintText.
  RemixTextFieldStyle hintText(TextStyler value) {
    return merge(RemixTextFieldStyle(hintText: value));
  }

  /// Sets the keyboardAppearance.
  RemixTextFieldStyle keyboardAppearance(Brightness value) {
    return merge(RemixTextFieldStyle(keyboardAppearance: value));
  }

  /// Sets the label.
  RemixTextFieldStyle label(TextStyler value) {
    return merge(RemixTextFieldStyle(label: value));
  }

  /// Sets the scrollPadding.
  RemixTextFieldStyle scrollPadding(EdgeInsets value) {
    return merge(RemixTextFieldStyle(scrollPadding: value));
  }

  /// Sets the selectionHeightStyle.
  RemixTextFieldStyle selectionHeightStyle(BoxHeightStyle value) {
    return merge(RemixTextFieldStyle(selectionHeightStyle: value));
  }

  /// Sets the selectionWidthStyle.
  RemixTextFieldStyle selectionWidthStyle(BoxWidthStyle value) {
    return merge(RemixTextFieldStyle(selectionWidthStyle: value));
  }

  /// Sets the spacing.
  RemixTextFieldStyle spacing(double value) {
    return merge(RemixTextFieldStyle(spacing: value));
  }

  /// Sets the text.
  RemixTextFieldStyle text(TextStyler value) {
    return merge(RemixTextFieldStyle(text: value));
  }

  /// Sets the textAlign.
  RemixTextFieldStyle textAlign(TextAlign value) {
    return merge(RemixTextFieldStyle(textAlign: value));
  }

  /// Sets the animation configuration.
  RemixTextFieldStyle animate(AnimationConfig value) {
    return merge(RemixTextFieldStyle(animation: value));
  }

  /// Sets the style variants.
  RemixTextFieldStyle variants(List<VariantStyle<RemixTextFieldSpec>> value) {
    return merge(RemixTextFieldStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixTextFieldStyle wrap(WidgetModifierConfig value) {
    return merge(RemixTextFieldStyle(modifier: value));
  }

  /// Merges with another [RemixTextFieldStyle].
  @override
  RemixTextFieldStyle merge(RemixTextFieldStyle? other) {
    return RemixTextFieldStyle.create(
      container: MixOps.merge($container, other?.$container),
      cursorColor: MixOps.merge($cursorColor, other?.$cursorColor),
      cursorHeight: MixOps.merge($cursorHeight, other?.$cursorHeight),
      cursorOffset: MixOps.merge($cursorOffset, other?.$cursorOffset),
      cursorOpacityAnimates: MixOps.merge(
        $cursorOpacityAnimates,
        other?.$cursorOpacityAnimates,
      ),
      cursorRadius: MixOps.merge($cursorRadius, other?.$cursorRadius),
      cursorWidth: MixOps.merge($cursorWidth, other?.$cursorWidth),
      helperText: MixOps.merge($helperText, other?.$helperText),
      hintText: MixOps.merge($hintText, other?.$hintText),
      keyboardAppearance: MixOps.merge(
        $keyboardAppearance,
        other?.$keyboardAppearance,
      ),
      label: MixOps.merge($label, other?.$label),
      scrollPadding: MixOps.merge($scrollPadding, other?.$scrollPadding),
      selectionHeightStyle: MixOps.merge(
        $selectionHeightStyle,
        other?.$selectionHeightStyle,
      ),
      selectionWidthStyle: MixOps.merge(
        $selectionWidthStyle,
        other?.$selectionWidthStyle,
      ),
      spacing: MixOps.merge($spacing, other?.$spacing),
      text: MixOps.merge($text, other?.$text),
      textAlign: MixOps.merge($textAlign, other?.$textAlign),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixTextFieldSpec>] using context.
  @override
  StyleSpec<RemixTextFieldSpec> resolve(BuildContext context) {
    final spec = RemixTextFieldSpec(
      container: MixOps.resolve(context, $container),
      cursorColor: MixOps.resolve(context, $cursorColor),
      cursorHeight: MixOps.resolve(context, $cursorHeight),
      cursorOffset: MixOps.resolve(context, $cursorOffset),
      cursorOpacityAnimates: MixOps.resolve(context, $cursorOpacityAnimates),
      cursorRadius: MixOps.resolve(context, $cursorRadius),
      cursorWidth: MixOps.resolve(context, $cursorWidth),
      helperText: MixOps.resolve(context, $helperText),
      hintText: MixOps.resolve(context, $hintText),
      keyboardAppearance: MixOps.resolve(context, $keyboardAppearance),
      label: MixOps.resolve(context, $label),
      scrollPadding: MixOps.resolve(context, $scrollPadding),
      selectionHeightStyle: MixOps.resolve(context, $selectionHeightStyle),
      selectionWidthStyle: MixOps.resolve(context, $selectionWidthStyle),
      spacing: MixOps.resolve(context, $spacing),
      text: MixOps.resolve(context, $text),
      textAlign: MixOps.resolve(context, $textAlign),
    );

    return StyleSpec(
      spec: spec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', $container))
      ..add(DiagnosticsProperty('cursorColor', $cursorColor))
      ..add(DiagnosticsProperty('cursorHeight', $cursorHeight))
      ..add(DiagnosticsProperty('cursorOffset', $cursorOffset))
      ..add(
        DiagnosticsProperty('cursorOpacityAnimates', $cursorOpacityAnimates),
      )
      ..add(DiagnosticsProperty('cursorRadius', $cursorRadius))
      ..add(DiagnosticsProperty('cursorWidth', $cursorWidth))
      ..add(DiagnosticsProperty('helperText', $helperText))
      ..add(DiagnosticsProperty('hintText', $hintText))
      ..add(DiagnosticsProperty('keyboardAppearance', $keyboardAppearance))
      ..add(DiagnosticsProperty('label', $label))
      ..add(DiagnosticsProperty('scrollPadding', $scrollPadding))
      ..add(DiagnosticsProperty('selectionHeightStyle', $selectionHeightStyle))
      ..add(DiagnosticsProperty('selectionWidthStyle', $selectionWidthStyle))
      ..add(DiagnosticsProperty('spacing', $spacing))
      ..add(DiagnosticsProperty('text', $text))
      ..add(DiagnosticsProperty('textAlign', $textAlign));
  }

  @override
  List<Object?> get props => [
    $container,
    $cursorColor,
    $cursorHeight,
    $cursorOffset,
    $cursorOpacityAnimates,
    $cursorRadius,
    $cursorWidth,
    $helperText,
    $hintText,
    $keyboardAppearance,
    $label,
    $scrollPadding,
    $selectionHeightStyle,
    $selectionWidthStyle,
    $spacing,
    $text,
    $textAlign,
    $animation,
    $modifier,
    $variants,
  ];
}
