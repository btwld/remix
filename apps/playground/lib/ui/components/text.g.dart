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
/// PlaygroundText.muted(
///   'Enter your email address.',
///   style: TextStyler().maxLines(1).overflow(.ellipsis),
/// )
/// ```
class PlaygroundText extends StatelessWidget {
  const PlaygroundText(
    this.text, {
    super.key,
    this.variant = .p,
    this.style = const TextStyler.create(),
  });

  /// A paragraph: `textBase` on a 28px line, in `foreground`.
  const PlaygroundText.p(
    this.text, {
    super.key,
    this.style = const TextStyler.create(),
  }) : variant = PlaygroundTextVariant.p;

  /// The paragraph that opens a page: `textXl` in `mutedForeground`.
  const PlaygroundText.lead(
    this.text, {
    super.key,
    this.style = const TextStyler.create(),
  }) : variant = PlaygroundTextVariant.lead;

  /// Text that stands out without being a heading: `textLg` at semibold
  /// weight, in `foreground`.
  const PlaygroundText.large(
    this.text, {
    super.key,
    this.style = const TextStyler.create(),
  }) : variant = PlaygroundTextVariant.large;

  /// A label: `textSm` at medium weight on a line as tall as the text, in
  /// `foreground`.
  const PlaygroundText.small(
    this.text, {
    super.key,
    this.style = const TextStyler.create(),
  }) : variant = PlaygroundTextVariant.small;

  /// Secondary text: `textSm` in `mutedForeground`.
  const PlaygroundText.muted(
    this.text, {
    super.key,
    this.style = const TextStyler.create(),
  }) : variant = PlaygroundTextVariant.muted;

  /// A quotation: `textBase` in italics, 24px in from a 2px `border` rule at
  /// its start.
  const PlaygroundText.blockquote(
    this.text, {
    super.key,
    this.style = const TextStyler.create(),
  }) : variant = PlaygroundTextVariant.blockquote;

  final PlaygroundTextVariant variant;

  final TextStyler style;

  final String text;

  @override
  Widget build(BuildContext context) {
    return playgroundTextStyle(
      variant: this.variant,
      style: this.style,
    ).call(this.text, key: this.key);
  }
}
