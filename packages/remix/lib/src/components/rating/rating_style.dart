part of 'rating.dart';

// Star conditions that are not Flutter WidgetStates. Each star resolves its
// style under the RemixRatingStarState it scopes, so these apply to stars only.
// Mix merges context variants by identity; keys are diagnostic labels only.

RemixRatingStarState? _starState(BuildContext context) =>
    RemixRatingStarState.maybeOf(context);

final _onFilledRatingStarVariant = ContextVariant(
  'remix.rating.star.filled',
  (context) => _starState(context)?.isFilled ?? false,
);

final _onKeptRatingStarVariant = ContextVariant(
  'remix.rating.star.kept',
  (context) => _starState(context)?.isKept ?? false,
);

final _onRatedRatingStarVariant = ContextVariant(
  'remix.rating.star.rated',
  (context) => _starState(context)?.isRated ?? false,
);

extension RemixRatingStarStylerRemixHelpers on RatingStarStyler {
  /// Styles stars inside the shown value: the hovered preview, or the
  /// committed value when nothing is hovered.
  RatingStarStyler onFilled(RatingStarStyler value) {
    return variant(_onFilledRatingStarVariant, value);
  }

  /// Styles stars inside the committed value, whatever the preview shows.
  RatingStarStyler onKept(RatingStarStyler value) {
    return variant(_onKeptRatingStarVariant, value);
  }

  /// Styles every star while the rating shows a value, filled or not.
  ///
  /// Declare [onFilled] after this to set filled stars apart.
  RatingStarStyler onRated(RatingStarStyler value) {
    return variant(_onRatedRatingStarVariant, value);
  }
}
