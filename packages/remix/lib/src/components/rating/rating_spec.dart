part of 'rating.dart';

/// Resolved visual values for a [RemixRating].
///
/// The field reads top to bottom: [label], a row holding the [stars] and the
/// [valueText], then [description].
@MixableSpec(
  target: RemixRating.new,
  extraStylerMixins: [RemixBoxStylerMixin, LabelStyleMixin],
)
class RatingSpec with _$RatingSpec {
  /// Layout of the whole field: label, row and description.
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<FlexBoxSpec> container;

  /// Layout of the row that holds the stars and the value text.
  @override
  final StyleSpec<FlexBoxSpec> controlRow;

  /// Layout of the stars, such as the gap between cells.
  @override
  final StyleSpec<FlexBoxSpec> stars;

  /// Default style of every star, resolved under each star's own states.
  @override
  final StyleSpec<RatingStarSpec> star;

  /// Text style of the visible label.
  @override
  final StyleSpec<TextSpec> label;

  /// Text style of the value text beside the stars.
  @override
  final StyleSpec<TextSpec> valueText;

  /// Text style of the description under the row.
  @override
  final StyleSpec<TextSpec> description;

  /// How a star's fill moves when the shown value changes. Accepts
  /// [CurveAnimationConfig] or [SpringAnimationConfig]. `null` moves over
  /// 150 ms along `Curves.easeOut`. Reduced motion jumps.
  @override
  final AnimationConfig? fillMotion;

  /// Extra delay per star along the fill's sweep, so the fill travels star by
  /// star away from the previous value. `null` sweeps every star at once.
  @override
  final Duration? fillStagger;

  /// How a star's committed mark moves when the value changes. Accepts the
  /// same configs as [fillMotion] and uses the same default.
  @override
  final AnimationConfig? keptMotion;

  /// Shifts the whole field this much toward its leading edge and reports
  /// that much less width, while keeping the shifted part hit-testable.
  ///
  /// Use it to let the star cells reach past the field's edge so a glyph,
  /// not its cell, lines up with the label: inset the label and description
  /// by the same amount. `null` or 0 shifts nothing.
  @override
  final double? leadingOverhang;

  const RatingSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<FlexBoxSpec>? controlRow,
    StyleSpec<FlexBoxSpec>? stars,
    StyleSpec<RatingStarSpec>? star,
    StyleSpec<TextSpec>? label,
    StyleSpec<TextSpec>? valueText,
    StyleSpec<TextSpec>? description,
    this.fillMotion,
    this.fillStagger,
    this.keptMotion,
    this.leadingOverhang,
  }) : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
       controlRow = controlRow ?? const StyleSpec(spec: FlexBoxSpec()),
       stars = stars ?? const StyleSpec(spec: FlexBoxSpec()),
       star = star ?? const StyleSpec(spec: RatingStarSpec()),
       label = label ?? const StyleSpec(spec: TextSpec()),
       valueText = valueText ?? const StyleSpec(spec: TextSpec()),
       description = description ?? const StyleSpec(spec: TextSpec());
}

/// Backward-compatible name for [RatingSpec], matching sibling components.
typedef RemixRatingSpec = RatingSpec;

/// Resolved visual values for one star of a [RemixRating].
///
/// The star paints three layers on one glyph: the empty star in
/// [emptyColor] and [outlineColor], the committed value in [keptColor], and
/// the shown value in [fillColor]. The kept and fill layers are clipped from
/// the reading-order start to the star's fraction.
@MixableSpec(extraStylerMixins: [RemixBoxStylerMixin])
class RatingStarSpec with _$RatingStarSpec {
  /// The star's cell: its hit area, corner radius and alignment.
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;

  /// Outline and paint layers drawn around [container] without affecting
  /// layout, such as a focus ring.
  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? containerEffects;

  /// Width and height of the star glyph. Defaults to 24.
  @override
  final double? glyphSize;

  /// Stroke width of every layer. Defaults to 1.5.
  @override
  final double? strokeWidth;

  /// Scale of the glyph inside its cell. Defaults to 1.
  @override
  final double? glyphScale;

  /// Fill of the empty star. `null` leaves it hollow.
  @override
  final Color? emptyColor;

  /// Stroke of the empty star. Defaults to a mid gray.
  @override
  final Color? outlineColor;

  /// Color of the committed value while a preview shows a different value.
  /// `null` draws no committed layer.
  @override
  final Color? keptColor;

  /// Color of the shown value. Defaults to amber.
  @override
  final Color? fillColor;

  const RatingStarSpec({
    StyleSpec<BoxSpec>? container,
    this.containerEffects,
    this.glyphSize,
    this.strokeWidth,
    this.glyphScale,
    this.emptyColor,
    this.outlineColor,
    this.keptColor,
    this.fillColor,
  }) : container = container ?? const StyleSpec(spec: BoxSpec());

  // Deliberate: route effects through lerpNullable so shadows/blends animate;
  // the generator's default snap-lerps unrecognized spec types.
  @override
  RatingStarSpec lerp(RatingStarSpec? other, double t) {
    final generated = super.lerp(other, t);
    if (other == null) return generated;
    return generated.copyWith(
      containerEffects: RemixBoxEffectsSpec.lerpNullable(
        containerEffects,
        other.containerEffects,
        t,
      ),
    );
  }
}

/// Backward-compatible name for [RatingStarSpec], matching sibling components.
typedef RemixRatingStarSpec = RatingStarSpec;
