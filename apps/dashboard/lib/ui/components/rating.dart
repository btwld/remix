import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

/// The sizes a rating comes in. Pixel values are at 100% theme scaling.
enum UiRatingSize {
  /// 18px stars in 28px cells.
  size1,

  /// 24px stars in 36px cells. The default.
  size2,

  /// 30px stars in 44px cells.
  size3,
}

/// The committed value under a hovered preview: the warning tone at 30%.
final _kept = ContextToken<Color>(
  (context) => UiTokens.warning.resolve(context).withValues(alpha: .3),
);

/// The Fortal Rating recipe: outlined stars that fill in the warning tone,
/// with a label above, the value in words beside them and an optional
/// description below.
///
/// It reads top to bottom: the field, the label, value and description text,
/// the fill motion, the star's layers for rest, rated, filled, pressed, focus
/// and disabled, then the size.
///
/// Once a value shows, empty stars soften from an outline into a quiet solid
/// and shrink a little, so a partly filled row reads as one shape. While a
/// preview shows, the committed value stays as a faint mark.
///
/// [highContrast] moves the empty outline, the empty value text and the
/// description to gray step 11.
///
/// The label and description are inset by the cell's margin. [UiRating]
/// pulls the field back by the same amount, so the first glyph, not its cell,
/// lines up with the label.
RatingStyler uiRatingStyle({
  UiRatingSize size = .size2,
  bool highContrast = false,
  RatingStyler style = const RatingStyler.create(),
}) {
  final muted = highContrast ? UiTokens.gray11() : UiTokens.gray10();
  final outline = highContrast ? UiTokens.gray11() : UiTokens.controlBorder();
  final inset = _inset(size);

  return RatingStyler()
      .spacing(6)
      .label(
        TextStyler()
            .style(UiTokens.text2.mix())
            .color(UiTokens.gray12())
            .fontWeight(UiTokens.fontWeightMedium())
            .wrap(.padding(EdgeInsetsGeometryMix.directional(start: inset))),
      )
      .controlRow(FlexBoxStyler().spacing(8 - inset))
      .stars(FlexBoxStyler().spacing(2))
      .valueText(
        TextStyler().style(UiTokens.text2.mix()).color(muted).fontFeatures([
          const FontFeature.tabularFigures(),
        ]),
      )
      .description(
        TextStyler()
            .style(UiTokens.text1.mix())
            .color(muted)
            .fontFeatures([const FontFeature.tabularFigures()])
            .wrap(.padding(EdgeInsetsGeometryMix.directional(start: inset))),
      )
      .onRated(RatingStyler().valueText(TextStyler().color(UiTokens.gray11())))
      .fillMotion(const SpringAnimationConfig(spring: UiMotion.springSnappy))
      .fillStagger(UiMotion.staggerItem)
      .keptMotion(const SpringAnimationConfig(spring: UiMotion.springSmooth))
      .star(
        RatingStarStyler()
            .alignment(.center)
            .outlineColor(outline)
            .fillColor(UiTokens.warning())
            .keptColor(_kept())
            .glyphScale(1)
            .onRated(
              RatingStarStyler()
                  .emptyColor(UiTokens.gray7())
                  .outlineColor(UiTokens.gray7())
                  .glyphScale(.9),
            )
            .onFilled(RatingStarStyler().glyphScale(1))
            .onPressed(RatingStarStyler().glyphScale(.86))
            .onFocusVisible(.containerEffects(uiFocusOutline()))
            .animate(
              const SpringAnimationConfig(spring: UiMotion.springSnappy),
            ),
      )
      .onDisabled(
        RatingStyler()
            .stars(FlexBoxStyler().wrap(.opacity(.5)))
            .valueText(TextStyler().wrap(.opacity(.5))),
      )
      .merge(_scale(size))
      .merge(style);
}

double _inset(UiRatingSize size) => (_cell(size) - _glyph(size)) / 2;

double _cell(UiRatingSize size) => switch (size) {
  .size1 => 28,
  .size2 => 36,
  .size3 => 44,
};

double _glyph(UiRatingSize size) => switch (size) {
  .size1 => 18,
  .size2 => 24,
  .size3 => 30,
};

/// The cell, glyph and stroke of each step. The stroke keeps 1.75 at a 24px
/// star and scales with the glyph.
RatingStyler _scale(UiRatingSize size) {
  final glyph = _glyph(size);
  return RatingStyler().star(
    RatingStarStyler()
        .size(_cell(size), _cell(size))
        .borderRadius(.circular(8))
        .glyphSize(glyph)
        .strokeWidth(1.75 * glyph / 24),
  );
}

/// A Fortal star rating: [RemixRating] styled by [uiRatingStyle].
///
/// The field overhangs its leading edge by the star cell's margin, as the
/// reference look does, so the first glyph lines up with the label.
class UiRating extends StatelessWidget {
  const UiRating({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const RatingStyler.create(),
    required this.value,
    this.onChanged,
    this.max = 5,
    this.allowClear = true,
    this.enabled = true,
    this.label,
    this.description,
    this.semanticLabel,
    this.valueLabelBuilder = RemixRating.defaultValueLabel,
    this.starSemanticLabelBuilder = RemixRating.defaultStarSemanticLabel,
  });

  /// The cell and star size.
  final UiRatingSize size;

  /// Moves muted text and the empty outline to gray step 11.
  final bool highContrast;

  /// Merged over the recipe.
  final RatingStyler style;

  /// See [RemixRating.value].
  final int? value;

  /// See [RemixRating.onChanged].
  final ValueChanged<int?>? onChanged;

  /// See [RemixRating.max].
  final int max;

  /// See [RemixRating.allowClear].
  final bool allowClear;

  /// See [RemixRating.enabled].
  final bool enabled;

  /// See [RemixRating.label].
  final String? label;

  /// See [RemixRating.description].
  final String? description;

  /// See [RemixRating.semanticLabel].
  final String? semanticLabel;

  /// See [RemixRating.valueLabelBuilder].
  final RemixRatingValueLabelBuilder? valueLabelBuilder;

  /// See [RemixRating.starSemanticLabelBuilder].
  final RemixRatingStarLabelBuilder starSemanticLabelBuilder;

  @override
  Widget build(BuildContext context) {
    return _RatingOverhang(
      extent: _inset(size),
      child: RemixRating(
        value: value,
        onChanged: onChanged,
        max: max,
        allowClear: allowClear,
        enabled: enabled,
        label: label,
        description: description,
        semanticLabel: semanticLabel,
        valueLabelBuilder: valueLabelBuilder,
        starSemanticLabelBuilder: starSemanticLabelBuilder,
        style: uiRatingStyle(
          size: size,
          highContrast: highContrast,
          style: style,
        ),
      ),
    );
  }
}

/// Lays its child out [extent] wider than it reports, shifted toward the
/// leading edge by that much. Visual only: it adds no semantics.
///
/// Hit testing reaches the shifted part only when every ancestor spans it,
/// as a centred or padded rating does. A tight ancestor that ends at the
/// field's edge, such as a start-aligned column with no padding, rejects
/// taps there, so the first cell's outer [extent] is not tappable in it.
class _RatingOverhang extends SingleChildRenderObjectWidget {
  const _RatingOverhang({required this.extent, required super.child});

  final double extent;

  @override
  _RenderRatingOverhang createRenderObject(BuildContext context) =>
      _RenderRatingOverhang(extent, Directionality.of(context));

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderRatingOverhang renderObject,
  ) {
    renderObject
      ..extent = extent
      ..textDirection = Directionality.of(context);
  }
}

class _RenderRatingOverhang extends RenderShiftedBox {
  _RenderRatingOverhang(this._extent, this._textDirection) : super(null);

  double _extent;
  set extent(double value) {
    if (value == _extent) return;
    _extent = value;
    markNeedsLayout();
  }

  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (value == _textDirection) return;
    _textDirection = value;
    markNeedsLayout();
  }

  bool get _ltr => _textDirection == TextDirection.ltr;

  double _narrower(double width) => width > _extent ? width - _extent : 0;

  @override
  double computeMinIntrinsicWidth(double height) =>
      _narrower(child?.getMinIntrinsicWidth(height) ?? 0);

  @override
  double computeMaxIntrinsicWidth(double height) =>
      _narrower(child?.getMaxIntrinsicWidth(height) ?? 0);

  // The child lays out at the given width plus the overhang, so its height
  // at that width is the height at ours.
  @override
  double computeMinIntrinsicHeight(double width) =>
      child?.getMinIntrinsicHeight(width + _extent) ?? 0;

  @override
  double computeMaxIntrinsicHeight(double width) =>
      child?.getMaxIntrinsicHeight(width + _extent) ?? 0;

  BoxConstraints _childConstraints(BoxConstraints constraints) =>
      constraints.copyWith(
        minWidth: constraints.minWidth == 0
            ? 0
            : constraints.minWidth + _extent,
        maxWidth: constraints.maxWidth + _extent,
      );

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final childSize =
        child?.getDryLayout(_childConstraints(constraints)) ?? Size.zero;
    return constraints.constrain(
      Size(_narrower(childSize.width), childSize.height),
    );
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    child.layout(_childConstraints(constraints), parentUsesSize: true);
    size = constraints.constrain(
      Size(_narrower(child.size.width), child.size.height),
    );
    (child.parentData! as BoxParentData).offset = Offset(
      _ltr ? -_extent : 0,
      0,
    );
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final reach = _ltr
        ? Rect.fromLTRB(-_extent, 0, size.width, size.height)
        : Rect.fromLTRB(0, 0, size.width + _extent, size.height);
    if (!reach.contains(position)) return false;
    if (!hitTestChildren(result, position: position)) return false;
    result.add(BoxHitTestEntry(this, position));
    return true;
  }
}
