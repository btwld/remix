// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Deui recipe for [RemixProgress], also the look of Deui's Meter, which
/// shares every progress-bar style.
///
/// The label and value output beside the bar are the app's composition.
class DeuiProgress extends StatelessWidget {
  const DeuiProgress({
    super.key,
    this.size = .md,
    this.color = .accent,
    this.style = const ProgressStyler.create(),
    required this.value,
    this.semanticsLabel,
    this.semanticsValue,
  });

  final DeuiProgressSize size;

  final DeuiColor color;

  final ProgressStyler style;

  final double value;

  final String? semanticsLabel;

  final String? semanticsValue;

  @override
  Widget build(BuildContext context) {
    return RemixProgress(
      key: this.key,
      style: deuiProgressStyle(
        size: this.size,
        color: this.color,
        style: this.style,
      ),
      value: this.value,
      semanticsLabel: this.semanticsLabel,
      semanticsValue: this.semanticsValue,
    );
  }
}
