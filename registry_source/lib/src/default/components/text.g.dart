// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Text recipe.
///
/// Each variant is one of the Typography page's styles. Every variant sets
/// its own size, line, weight and color rather than inheriting them, so it
/// reads the same inside a button, a card, or a Material `Scaffold`. Align,
/// wrap, or truncate it through [style]:
///
/// ```dart
/// VanillaText.muted(
///   'Enter your email address.',
///   style: TextStyler().maxLines(1).overflow(.ellipsis),
/// )
/// ```
class VanillaText extends StatelessWidget {
  const VanillaText(
    this.text, {
    super.key,
    this.variant = .p,
    this.style = const TextStyler.create(),
  });

  /// A paragraph: `textBase` on a 28px line, in `foreground`.
  const VanillaText.p(
    this.text, {
    super.key,
    this.style = const TextStyler.create(),
  }) : variant = VanillaTextVariant.p;

  /// The paragraph that opens a page: `textXl` in `mutedForeground`.
  const VanillaText.lead(
    this.text, {
    super.key,
    this.style = const TextStyler.create(),
  }) : variant = VanillaTextVariant.lead;

  /// Text that stands out without being a heading: `textLg` at semibold
  /// weight, in `foreground`.
  const VanillaText.large(
    this.text, {
    super.key,
    this.style = const TextStyler.create(),
  }) : variant = VanillaTextVariant.large;

  /// A label: `textSm` at medium weight on a line as tall as the text, in
  /// `foreground`.
  const VanillaText.small(
    this.text, {
    super.key,
    this.style = const TextStyler.create(),
  }) : variant = VanillaTextVariant.small;

  /// Secondary text: `textSm` in `mutedForeground`.
  const VanillaText.muted(
    this.text, {
    super.key,
    this.style = const TextStyler.create(),
  }) : variant = VanillaTextVariant.muted;

  /// A quotation: `textBase` in italics, 24px in from a 2px `border` rule at
  /// its start.
  const VanillaText.blockquote(
    this.text, {
    super.key,
    this.style = const TextStyler.create(),
  }) : variant = VanillaTextVariant.blockquote;

  final VanillaTextVariant variant;

  final TextStyler style;

  final String text;

  @override
  Widget build(BuildContext context) {
    return vanillaTextStyle(
      variant: this.variant,
      style: this.style,
    ).call(this.text, key: this.key);
  }
}
