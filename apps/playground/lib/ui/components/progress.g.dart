// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Progress recipe.
///
/// Remix owns the geometry that maps a 0-1 value onto the filled width, and
/// the progress semantics; this recipe supplies the track and the indicator.
///
/// One weight, not a scale. A progress bar has no size relationship to the
/// controls around it — it spans its container and is read by length rather
/// than by height — so a size axis would be numbers with nothing to anchor
/// them. It is an 8px bar; a call site that wants a different weight sets
/// `.height(...)` through [style], which is one line and says what it means.
///
/// The indicator is `primary` on a track of `primary` at 20%: the track reads
/// as the same bar, not yet filled, rather than as a separate surface.
///
/// Both are fully rounded rather than sharing the theme's control radius. The
/// theme radius is authored for 32-40px controls; on an 8px bar anything
/// short of a full round reads as a rendering artifact.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it:
///
/// ```dart
/// PlaygroundProgress(
///   value: 0.4,
///   style: ProgressStyler().indicatorColor(PlaygroundTokens.destructive()),
/// )
/// ```
class PlaygroundProgress extends StatelessWidget {
  const PlaygroundProgress({
    super.key,
    this.style = const ProgressStyler.create(),
    required this.value,
    this.semanticsLabel,
    this.semanticsValue,
  });

  final ProgressStyler style;

  final double value;

  final String? semanticsLabel;

  final String? semanticsValue;

  @override
  Widget build(BuildContext context) {
    return RemixProgress(
      key: this.key,
      style: playgroundProgressStyle(style: this.style),
      value: this.value,
      semanticsLabel: this.semanticsLabel,
      semanticsValue: this.semanticsValue,
    );
  }
}
