// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

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
class FortalRating extends StatelessWidget {
  const FortalRating({
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

  final FortalRatingSize size;

  final bool highContrast;

  final RatingStyler style;

  final int? value;

  final ValueChanged<int?>? onChanged;

  final int max;

  final bool allowClear;

  final bool enabled;

  final String? label;

  final String? description;

  final String? semanticLabel;

  final RemixRatingValueLabelBuilder? valueLabelBuilder;

  final RemixRatingStarLabelBuilder starSemanticLabelBuilder;

  @override
  Widget build(BuildContext _) {
    return RemixRating(
      style: fortalRatingStyle(
        size: size,
        highContrast: highContrast,
        style: style,
      ),
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
    );
  }
}
