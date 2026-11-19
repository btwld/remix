// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spinner.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Deui recipe for [RemixSpinner].
///
/// Remix's arc sits on the same ring as Deui's icon (radius and thickness
/// scale with the size); Deui fades a full ring where Remix draws a solid
/// arc.
class DeuiSpinner extends StatelessWidget {
  const DeuiSpinner({
    super.key,
    this.size = .md,
    this.color = .accent,
    this.style = const SpinnerStyler.create(),
    this.semanticsLabel,
    this.semanticsValue,
  });

  final DeuiSpinnerSize size;

  final DeuiSpinnerColor color;

  final SpinnerStyler style;

  final String? semanticsLabel;

  final String? semanticsValue;

  @override
  Widget build(BuildContext context) {
    return RemixSpinner(
      key: this.key,
      style: deuiSpinnerStyle(
        size: this.size,
        color: this.color,
        style: this.style,
      ),
      semanticsLabel: this.semanticsLabel,
      semanticsValue: this.semanticsValue,
    );
  }
}
