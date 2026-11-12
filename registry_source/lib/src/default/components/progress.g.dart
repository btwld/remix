// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Progress recipe.
///
/// An 8px bar with a `primary` indicator on a track of `primary` at 20%, so the
/// track reads as the same bar, not yet filled. Both ends are fully rounded:
/// the theme radius is authored for 32-40px controls. Set `.height(...)`
/// through [style] for another weight.
class VanillaProgress extends StatelessWidget {
  const VanillaProgress({
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
      style: vanillaProgressStyle(style: this.style),
      value: this.value,
      semanticsLabel: this.semanticsLabel,
      semanticsValue: this.semanticsValue,
    );
  }
}
