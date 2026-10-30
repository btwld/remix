// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Fortal-themed body text on the Fortal nine-step scale.
class FortalText extends StatelessWidget {
  const FortalText(
    this.text, {
    super.key,
    this.size,
    this.weight,
    this.align,
    this.softWrap = true,
    this.truncate = false,
    this.accent = false,
    this.highContrast = false,
    this.style = const TextStyler.create(),
  });

  final FortalTextSize? size;

  final FortalTextWeight? weight;

  final TextAlign? align;

  final bool softWrap;

  final bool truncate;

  final bool accent;

  final bool highContrast;

  final TextStyler style;

  final String text;

  @override
  Widget build(BuildContext context) {
    return fortalTextStyle(
      size: this.size,
      weight: this.weight,
      align: this.align,
      softWrap: this.softWrap,
      truncate: this.truncate,
      accent: this.accent,
      highContrast: this.highContrast,
      style: this.style,
    ).call(this.text, key: this.key);
  }
}
