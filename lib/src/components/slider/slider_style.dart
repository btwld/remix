part of 'slider.dart';

class RemixSliderStyle
    extends RemixContainerStyle<RemixSliderSpec, RemixSliderStyle> {
  final Prop<StyleSpec<BoxSpec>>? $thumb;
  final Prop<Paint>? $track;
  final Prop<Paint>? $range;

  const RemixSliderStyle.create({
    Prop<StyleSpec<BoxSpec>>? thumb,
    Prop<Paint>? track,
    Prop<Paint>? range,
    super.variants,
    super.animation,
    super.modifier,
  }) : $thumb = thumb,
       $track = track,
       $range = range;

  RemixSliderStyle({
    BoxStyler? thumb,
    Paint? track,
    Paint? range,
    AnimationConfig? animation,
    List<VariantStyle<RemixSliderSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         thumb: Prop.maybeMix(thumb),
         track: track != null ? Prop.value(track) : null,
         range: range != null ? Prop.value(range) : null,
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
    return merge(
      RemixSliderStyle(
        track: _buildTrackPaint(
          $track,
          fallback: _defaultTrackPaint,
          color: value,
        ),
      ),
    );
  }

  /// Sets range color (filled progress portion)
  RemixSliderStyle rangeColor(Color value) {
    return merge(
      RemixSliderStyle(
        range: _buildTrackPaint(
          $range,
          fallback: _defaultRangePaint,
          color: value,
        ),
      ),
    );
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
    return merge(
      RemixSliderStyle(
        track: _buildTrackPaint(
          $track,
          fallback: _defaultTrackPaint,
          strokeWidth: value,
        ),
        range: _buildTrackPaint(
          $range,
          fallback: _defaultRangePaint,
          strokeWidth: value,
        ),
      ),
    );
  }

  /// Sets stroke width for the track only (background rail).
  RemixSliderStyle trackThickness(double value) {
    return merge(
      RemixSliderStyle(
        track: _buildTrackPaint(
          $track,
          fallback: _defaultTrackPaint,
          strokeWidth: value,
        ),
      ),
    );
  }

  /// Sets stroke width for the range only (filled portion).
  RemixSliderStyle rangeThickness(double value) {
    return merge(
      RemixSliderStyle(
        range: _buildTrackPaint(
          $range,
          fallback: _defaultRangePaint,
          strokeWidth: value,
        ),
      ),
    );
  }

  // RemixContainerStyle mixin implementations
  @override
  RemixSliderStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixSliderStyle(thumb: BoxStyler(padding: value)));
  }

  @override
  RemixSliderStyle textColor(Color value) {
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

  @override
  StyleSpec<RemixSliderSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixSliderSpec(
        thumb: MixOps.resolve(context, $thumb),
        track: MixOps.resolve(context, $track),
        range: MixOps.resolve(context, $range),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixSliderStyle merge(RemixSliderStyle? other) {
    if (other == null) return this;

    return RemixSliderStyle.create(
      thumb: MixOps.merge($thumb, other.$thumb),
      track: MixOps.merge($track, other.$track),
      range: MixOps.merge($range, other.$range),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixSliderStyle variants(List<VariantStyle<RemixSliderSpec>> value) {
    return merge(RemixSliderStyle(variants: value));
  }

  @override
  RemixSliderStyle wrap(WidgetModifierConfig value) {
    return merge(RemixSliderStyle(modifier: value));
  }

  @override
  RemixSliderStyle animate(AnimationConfig animation) {
    return merge(RemixSliderStyle(animation: animation));
  }

  @override
  List<Object?> get props => [
    $thumb,
    $track,
    $range,
    $variants,
    $animation,
    $modifier,
  ];
}

Paint _buildTrackPaint(
  Prop<Paint>? source, {
  required Paint fallback,
  Color? color,
  double? strokeWidth,
}) {
  final existing = _extractPaint(source);
  final template = existing != null ? _clonePaint(existing) : fallback;
  final paint = _clonePaint(template);

  if (color != null) paint.color = color;
  if (strokeWidth != null) paint.strokeWidth = strokeWidth;

  // Ensure expected defaults
  paint
    ..style = PaintingStyle.stroke
    ..isAntiAlias = template.isAntiAlias;

  return paint;
}

Paint _clonePaint(Paint paint) {
  return Paint()
    ..color = paint.color
    ..strokeWidth = paint.strokeWidth
    ..strokeCap = paint.strokeCap
    ..strokeJoin = paint.strokeJoin
    ..strokeMiterLimit = paint.strokeMiterLimit
    ..style = paint.style
    ..isAntiAlias = paint.isAntiAlias
    ..blendMode = paint.blendMode
    ..shader = paint.shader
    ..filterQuality = paint.filterQuality
    ..maskFilter = paint.maskFilter
    ..colorFilter = paint.colorFilter
    ..imageFilter = paint.imageFilter;
}

Paint? _extractPaint(Prop<Paint>? prop) {
  if (prop == null) return null;
  for (final source in prop.sources.reversed) {
    if (source is ValueSource<Paint>) {
      return source.value;
    }
  }

  return null;
}
