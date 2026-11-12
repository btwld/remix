// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spinner.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Spinner recipe.
///
/// The standalone spinner: 16px, the size of the icons it sits among (a button
/// draws its own). It is `foreground`, not `primary`, because it usually
/// replaces text and should read at that weight. Set `.size(...)` through
/// [style] for another size.
class PlaygroundSpinner extends StatelessWidget {
  const PlaygroundSpinner({
    super.key,
    this.style = const SpinnerStyler.create(),
    this.semanticsLabel,
    this.semanticsValue,
  });

  final SpinnerStyler style;

  final String? semanticsLabel;

  final String? semanticsValue;

  @override
  Widget build(BuildContext context) {
    return RemixSpinner(
      key: this.key,
      style: playgroundSpinnerStyle(style: this.style),
      semanticsLabel: this.semanticsLabel,
      semanticsValue: this.semanticsValue,
    );
  }
}
