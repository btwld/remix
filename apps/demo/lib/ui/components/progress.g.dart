// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Progress recipe.
///
/// It reads top to bottom: the size, then the variant's track and fill.
///
/// A bare progress bar carries its value in two extents: the whole track (the
/// total) and the filled indicator (the value). The track is edged in
/// controlBorder, which keeps 3:1 on the page and panels, so the total stays
/// readable at 0. The fill keeps 3:1 against those surroundings through its
/// own color or, for the surface variant, an inset outline in accentThumbRing:
/// seamless on fills that already contrast, a dark ink on bright fills.
///
/// [highContrast] moves the fill to accent step 12.
class FortalProgress extends StatelessWidget {
  const FortalProgress({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    this.highContrast = false,
    this.style = const ProgressStyler.create(),
    required this.value,
    this.semanticsLabel,
    this.semanticsValue,
  });

  /// A gray track with a 1px frame, and a solid accent fill.
  const FortalProgress.surface({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const ProgressStyler.create(),
    required this.value,
    this.semanticsLabel,
    this.semanticsValue,
  }) : variant = FortalProgressVariant.surface;

  /// A gray track with a 1px frame, and a softer accent fill.
  const FortalProgress.soft({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const ProgressStyler.create(),
    required this.value,
    this.semanticsLabel,
    this.semanticsValue,
  }) : variant = FortalProgressVariant.soft;

  final FortalProgressVariant variant;

  final FortalProgressSize size;

  final bool highContrast;

  final ProgressStyler style;

  final double value;

  final String? semanticsLabel;

  final String? semanticsValue;

  @override
  Widget build(BuildContext context) {
    return RemixProgress(
      key: this.key,
      style: fortalProgressStyle(
        variant: this.variant,
        size: this.size,
        highContrast: this.highContrast,
        style: this.style,
      ),
      value: this.value,
      semanticsLabel: this.semanticsLabel,
      semanticsValue: this.semanticsValue,
    );
  }
}
