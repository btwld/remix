part of 'progress.dart';

/// Style builder for [RemixProgress].
///
/// Use this class to style the progress container, track, indicator, and track
/// layout container.
extension RemixProgressStylerRemixHelpers on RemixProgressStyler {
  /// Sets track color
  RemixProgressStyler trackColor(Color value) {
    return merge(
      RemixProgressStyler(
        track: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets fill color
  RemixProgressStyler indicatorColor(Color value) {
    return merge(
      RemixProgressStyler(
        indicator: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Creates a [RemixProgress] widget with this style applied.
  RemixProgress call({Key? key, required double value}) {
    return RemixProgress(key: key, value: value, style: this);
  }
}
