// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixProgress], also the look of HeroUI's Meter, which
/// shares every progress-bar style.
///
/// The label and value output beside the bar are the app's composition.
class HeroUiProgress extends StatelessWidget {
  const HeroUiProgress({
    super.key,
    this.size = .md,
    this.color = .accent,
    this.style = const ProgressStyler.create(),
    required this.value,
    this.semanticsLabel,
    this.semanticsValue,
  });

  final HeroUiProgressSize size;

  final HeroUiColor color;

  final ProgressStyler style;

  final double value;

  final String? semanticsLabel;

  final String? semanticsValue;

  @override
  Widget build(BuildContext _) {
    return RemixProgress(
      style: heroUiProgressStyle(size: size, color: color, style: style),
      value: value,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
    );
  }
}
