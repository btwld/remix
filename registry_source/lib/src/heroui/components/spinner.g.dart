// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spinner.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixSpinner].
///
/// Remix's arc sits on the same ring as HeroUI's icon (radius and thickness
/// scale with the size); HeroUI fades a full ring where Remix draws a solid
/// arc.
class HeroUiSpinner extends StatelessWidget {
  const HeroUiSpinner({
    super.key,
    this.size = .md,
    this.color = .accent,
    this.style = const SpinnerStyler.create(),
    this.semanticsLabel,
    this.semanticsValue,
  });

  final HeroUiSpinnerSize size;

  final HeroUiSpinnerColor color;

  final SpinnerStyler style;

  final String? semanticsLabel;

  final String? semanticsValue;

  @override
  Widget build(BuildContext context) {
    return RemixSpinner(
      key: this.key,
      style: heroUiSpinnerStyle(
        size: this.size,
        color: this.color,
        style: this.style,
      ),
      semanticsLabel: this.semanticsLabel,
      semanticsValue: this.semanticsValue,
    );
  }
}
