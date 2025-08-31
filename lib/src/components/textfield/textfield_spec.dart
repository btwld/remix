part of 'textfield.dart';

class TextFieldSpec extends Spec<TextFieldSpec> with Diagnosticable {
  final StyleSpec<TextSpec> text;
  final StyleSpec<TextSpec> hintText;
  final TextAlign textAlign;

  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Offset cursorOffset;
  final bool? cursorOpacityAnimates;

  final BoxHeightStyle selectionHeightStyle;
  final BoxWidthStyle selectionWidthStyle;

  final EdgeInsets scrollPadding;
  final Brightness? keyboardAppearance;
  final double spacing;
  final StyleSpec<FlexBoxSpec> container;
  final StyleSpec<TextSpec> helperText;
  final StyleSpec<TextSpec> label;

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
