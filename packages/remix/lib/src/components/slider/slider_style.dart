part of 'slider.dart';

/// Style builder for [RemixSlider].
///
/// Use this class to customize the thumb, track, and filled range. It supports
/// Mix variants and widget state variants such as disabled, hovered, focused,
/// and pressed states.
@MixableStyler()
class RemixSliderStyle
    extends RemixContainerStyle<RemixSliderSpec, RemixSliderStyle>
    with Diagnosticable, _$RemixSliderStyleMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $thumb;
  final Prop<Color>? $trackColor;
  final Prop<double>? $trackWidth;
  final Prop<Color>? $rangeColor;
  final Prop<double>? $rangeWidth;

  /// Creates a slider style from raw Mix properties.
  const RemixSliderStyle.create({
    Prop<StyleSpec<BoxSpec>>? thumb,
    Prop<Color>? trackColor,
    Prop<double>? trackWidth,
    Prop<Color>? rangeColor,
    Prop<double>? rangeWidth,
    super.variants,
    super.animation,
    super.modifier,
  }) : $thumb = thumb,
       $trackColor = trackColor,
       $trackWidth = trackWidth,
       $rangeColor = rangeColor,
       $rangeWidth = rangeWidth;

  /// Creates a slider style from plain Dart values and Mix stylers.
  RemixSliderStyle({
    BoxStyler? thumb,
    Color? trackColor,
    double? trackWidth,
    Color? rangeColor,
    double? rangeWidth,
    AnimationConfig? animation,
    List<VariantStyle<RemixSliderSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         thumb: Prop.maybeMix(thumb),
         trackColor: trackColor != null ? Prop.value(trackColor) : null,
         trackWidth: trackWidth != null ? Prop.value(trackWidth) : null,
         rangeColor: rangeColor != null ? Prop.value(rangeColor) : null,
         rangeWidth: rangeWidth != null ? Prop.value(rangeWidth) : null,
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets thumb color
  RemixSliderStyle thumbColor(Color value) {
    return merge(
      RemixSliderStyle(
        thumb: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets track color (background rail)
  RemixSliderStyle trackColor(Color value) {
    return merge(RemixSliderStyle(trackColor: value));
  }

  /// Sets range color (filled progress portion)
  RemixSliderStyle rangeColor(Color value) {
    return merge(RemixSliderStyle(rangeColor: value));
  }

  /// Sets thumb styling
  RemixSliderStyle thumb(BoxStyler value) {
    return merge(RemixSliderStyle(thumb: value));
  }

  /// Sets thumb to a fixed [size].
  RemixSliderStyle thumbSize(Size size) {
    return merge(
      RemixSliderStyle(
        thumb: BoxStyler(constraints: BoxConstraintsMix.size(size)),
      ),
    );
  }

  /// Sets thumb alignment
  RemixSliderStyle alignment(Alignment value) {
    return merge(RemixSliderStyle(thumb: BoxStyler(alignment: value)));
  }

  /// Sets stroke width for both track and range.
  RemixSliderStyle thickness(double value) {
    return merge(RemixSliderStyle(trackWidth: value, rangeWidth: value));
  }

  /// Sets stroke width for the track only (background rail).
  RemixSliderStyle trackThickness(double value) {
    return merge(RemixSliderStyle(trackWidth: value));
  }

  /// Sets stroke width for the range only (filled portion).
  RemixSliderStyle rangeThickness(double value) {
    return merge(RemixSliderStyle(rangeWidth: value));
  }

  // RemixContainerStyle mixin implementations
  @override
  RemixSliderStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixSliderStyle(thumb: BoxStyler(padding: value)));
  }

  @override
  RemixSliderStyle color(Color value) {
    return merge(
      RemixSliderStyle(
        thumb: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  @override
  RemixSliderStyle size(double width, double height) {
    return merge(
      RemixSliderStyle(
        thumb: BoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: width,
            maxWidth: width,
            minHeight: height,
            maxHeight: height,
          ),
        ),
      ),
    );
  }

  @override
  RemixSliderStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixSliderStyle(
        thumb: BoxStyler(decoration: BoxDecorationMix(borderRadius: radius)),
      ),
    );
  }

  @override
  RemixSliderStyle constraints(BoxConstraintsMix value) {
    return merge(RemixSliderStyle(thumb: BoxStyler(constraints: value)));
  }

  @override
  RemixSliderStyle decoration(DecorationMix value) {
    return merge(RemixSliderStyle(thumb: BoxStyler(decoration: value)));
  }

  @override
  RemixSliderStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixSliderStyle(thumb: BoxStyler(margin: value)));
  }

  @override
  RemixSliderStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixSliderStyle(thumb: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixSliderStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixSliderStyle(
        thumb: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }

  /// Creates a [RemixSlider] widget with this style applied.
  ///
  /// Example:
  /// ```dart
  /// final slider = RemixSliderStyle()
  ///   .thumbColor(Colors.blue)
  ///   .rangeColor(Colors.blue.shade200);
  ///
  /// // Use it like a function
  /// slider(
  ///   value: _sliderValue,
  ///   onChanged: (value) => setState(() => _sliderValue = value),
  /// )
  /// ```
  RemixSlider call({
    required double value,
    ValueChanged<double>? onChanged,
    ValueChanged<double>? onChangeStart,
    ValueChanged<double>? onChangeEnd,
    double min = 0.0,
    double max = 1.0,
    bool enabled = true,
    bool enableFeedback = true,
    FocusNode? focusNode,
    bool autofocus = false,
    int? snapDivisions,
  }) {
    return RemixSlider(
      value: value,
      onChanged: onChanged,
      onChangeStart: onChangeStart,
      onChangeEnd: onChangeEnd,
      min: min,
      max: max,
      enabled: enabled,
      enableFeedback: enableFeedback,
      focusNode: focusNode,
      autofocus: autofocus,
      snapDivisions: snapDivisions,
      style: this,
    );
  }
}
