// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spinner.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Spinner recipe, drawn in the inherited foreground color.
class UiSpinner extends StatelessWidget {
  const UiSpinner({
    super.key,
    this.size = .size2,
    this.style = const SpinnerStyler.create(),
    this.semanticsLabel,
    this.semanticsValue,
  });

  final UiSpinnerSize size;

  final SpinnerStyler style;

  final String? semanticsLabel;

  final String? semanticsValue;

  @override
  Widget build(BuildContext _) {
    return RemixSpinner(
      style: uiSpinnerStyle(size: size, style: style),
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
    );
  }
}
