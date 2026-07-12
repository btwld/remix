part of 'slider.dart';

/// Style builder for [RemixSlider].
///
/// Use this class to customize the thumb, track, and filled range. It supports
/// Mix variants and widget state variants such as disabled, hovered, focused,
/// and pressed states.
@MixableStyler()
class RemixSliderStyler
    extends RemixContainerStyler<RemixSliderSpec, RemixSliderStyler>
    with Diagnosticable, _$RemixSliderStylerMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $thumb;
  final Prop<Color>? $trackColor;
  final Prop<double>? $trackWidth;
  final Prop<Color>? $rangeColor;
  final Prop<double>? $rangeWidth;

  /// Creates a slider style from raw Mix properties.
  const RemixSliderStyler.create({
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
  RemixSliderStyler({
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
  RemixSliderStyler thumbColor(Color value) {
    return merge(
      RemixSliderStyler(
        thumb: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets track color (background rail)
  RemixSliderStyler trackColor(Color value) {
    return merge(RemixSliderStyler(trackColor: value));
  }

  /// Sets range color (filled progress portion)
  RemixSliderStyler rangeColor(Color value) {
    return merge(RemixSliderStyler(rangeColor: value));
  }

  /// Sets thumb styling
  RemixSliderStyler thumb(BoxStyler value) {
    return merge(RemixSliderStyler(thumb: value));
  }

  /// Sets thumb to a fixed [size].
  RemixSliderStyler thumbSize(Size size) {
    return merge(
      RemixSliderStyler(
        thumb: BoxStyler(constraints: BoxConstraintsMix.size(size)),
      ),
    );
  }

  /// Sets thumb alignment
  RemixSliderStyler alignment(Alignment value) {
    return merge(RemixSliderStyler(thumb: BoxStyler(alignment: value)));
  }

  /// Sets stroke width for both track and range.
  RemixSliderStyler thickness(double value) {
    return merge(RemixSliderStyler(trackWidth: value, rangeWidth: value));
  }

  /// Sets stroke width for the track only (background rail).
  RemixSliderStyler trackThickness(double value) {
    return merge(RemixSliderStyler(trackWidth: value));
  }

  /// Sets stroke width for the range only (filled portion).
  RemixSliderStyler rangeThickness(double value) {
    return merge(RemixSliderStyler(rangeWidth: value));
  }

  /// Creates a [RemixSlider] widget with this style applied.
  ///
  /// Example:
  /// ```dart
  /// final slider = RemixSliderStyler()
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
    Key? key,
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
      key: key,
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

  // RemixContainerStyler mixin implementations
  @override
  RemixSliderStyler padding(EdgeInsetsGeometryMix value) {
    return merge(RemixSliderStyler(thumb: BoxStyler(padding: value)));
  }

  @override
  RemixSliderStyler color(Color value) {
    return merge(
      RemixSliderStyler(
        thumb: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  @override
  RemixSliderStyler size(double width, double height) {
    return merge(
      RemixSliderStyler(
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
  RemixSliderStyler borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixSliderStyler(
        thumb: BoxStyler(decoration: BoxDecorationMix(borderRadius: radius)),
      ),
    );
  }

  @override
  RemixSliderStyler constraints(BoxConstraintsMix value) {
    return merge(RemixSliderStyler(thumb: BoxStyler(constraints: value)));
  }

  @override
  RemixSliderStyler decoration(DecorationMix value) {
    return merge(RemixSliderStyler(thumb: BoxStyler(decoration: value)));
  }

  @override
  RemixSliderStyler margin(EdgeInsetsGeometryMix value) {
    return merge(RemixSliderStyler(thumb: BoxStyler(margin: value)));
  }

  @override
  RemixSliderStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixSliderStyler(thumb: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixSliderStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixSliderStyler(
        thumb: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }
}
