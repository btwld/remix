part of 'slider.dart';

class RemixSliderStyle
    extends RemixContainerStyle<RemixSliderSpec, RemixSliderStyle> {
  final Prop<StyleSpec<BoxSpec>>? $thumb;
  final Prop<Paint>? $baseTrack;
  final Prop<Paint>? $activeTrack;

  const RemixSliderStyle.create({
    Prop<StyleSpec<BoxSpec>>? thumb,
    Prop<Paint>? baseTrack,
    Prop<Paint>? activeTrack,
    super.variants,
    super.animation,
    super.modifier,
  })  : $thumb = thumb,
        $baseTrack = baseTrack,
        $activeTrack = activeTrack;

  RemixSliderStyle({
    BoxStyler? thumb,
    Paint? baseTrack,
    Paint? activeTrack,
    AnimationConfig? animation,
    List<VariantStyle<RemixSliderSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          thumb: Prop.maybeMix(thumb),
          baseTrack: baseTrack != null ? Prop.value(baseTrack) : null,
          activeTrack: activeTrack != null ? Prop.value(activeTrack) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  /// Sets thumb color
  RemixSliderStyle thumbColor(Color value) {
    return merge(RemixSliderStyle(
      thumb: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets base track color
  RemixSliderStyle baseTrackColor(Color value) {
    return merge(
      RemixSliderStyle(
        baseTrack: _buildTrackPaint(
          $baseTrack,
          fallback: _defaultBaseTrackPaint,
          color: value,
        ),
      ),
    );
  }

  /// Sets active track color
  RemixSliderStyle activeTrackColor(Color value) {
    return merge(
      RemixSliderStyle(
        activeTrack: _buildTrackPaint(
          $activeTrack,
          fallback: _defaultActiveTrackPaint,
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

  /// Sets stroke width for both base and active tracks.
  RemixSliderStyle trackThickness(double value) {
    return merge(
      RemixSliderStyle(
        baseTrack: _buildTrackPaint(
          $baseTrack,
          fallback: _defaultBaseTrackPaint,
          strokeWidth: value,
        ),
        activeTrack: _buildTrackPaint(
          $activeTrack,
          fallback: _defaultActiveTrackPaint,
          strokeWidth: value,
        ),
      ),
    );
  }

  /// Sets stroke width for the base track only.
  RemixSliderStyle baseTrackThickness(double value) {
    return merge(
      RemixSliderStyle(
        baseTrack: _buildTrackPaint(
          $baseTrack,
          fallback: _defaultBaseTrackPaint,
          strokeWidth: value,
        ),
      ),
    );
  }

  /// Sets stroke width for the active track only.
  RemixSliderStyle activeTrackThickness(double value) {
    return merge(
      RemixSliderStyle(
        activeTrack: _buildTrackPaint(
          $activeTrack,
          fallback: _defaultActiveTrackPaint,
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
  RemixSliderStyle color(Color value) {
    return merge(RemixSliderStyle(
      thumb: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  @override
  RemixSliderStyle size(double width, double height) {
    return merge(RemixSliderStyle(
      thumb: BoxStyler(
        constraints: BoxConstraintsMix(
          minWidth: width,
          maxWidth: width,
          minHeight: height,
          maxHeight: height,
        ),
      ),
    ));
  }

  @override
  RemixSliderStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixSliderStyle(
      thumb: BoxStyler(decoration: BoxDecorationMix(borderRadius: radius)),
    ));
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
    return merge(RemixSliderStyle(
      thumb: BoxStyler(transform: value, transformAlignment: alignment),
    ));
  }

  @override
  StyleSpec<RemixSliderSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixSliderSpec(
        thumb: MixOps.resolve(context, $thumb),
        baseTrack: MixOps.resolve(context, $baseTrack),
        activeTrack: MixOps.resolve(context, $activeTrack),
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
      baseTrack: MixOps.merge($baseTrack, other.$baseTrack),
      activeTrack: MixOps.merge($activeTrack, other.$activeTrack),
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
        $baseTrack,
        $activeTrack,
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
