// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kbd.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Kbd recipe: one keyboard key drawn as a key cap.
///
/// `textXs` at medium weight on a `radiusSm` cap at least 20px square, with
/// 4px beside the label. The cap is the 16px line plus 2px above and below,
/// so it grows with the text scale instead of clipping it. Put the keys of
/// one shortcut in a [VanillaKbdGroup].
///
/// Assistive technology reads the key as the text it shows. Name a symbol
/// key through [style]:
///
/// ```dart
/// VanillaKbd('⌘', style: TextStyler().semanticsLabel('Command'))
/// ```
class VanillaKbd extends StatelessWidget {
  const VanillaKbd(
    this.text, {
    super.key,
    this.variant = .muted,
    this.style = const TextStyler.create(),
  });

  /// On the page, a card, or a popover: a `muted` cap under `mutedForeground`
  /// text.
  const VanillaKbd.muted(
    this.text, {
    super.key,
    this.style = const TextStyler.create(),
  }) : variant = VanillaKbdVariant.muted;

  /// Inside a tooltip's content, which inverts the page: `background` at 20%
  /// (10% in the dark theme) under `background` text.
  const VanillaKbd.tooltip(
    this.text, {
    super.key,
    this.style = const TextStyler.create(),
  }) : variant = VanillaKbdVariant.tooltip;

  final VanillaKbdVariant variant;

  final TextStyler style;

  final String text;

  @override
  Widget build(BuildContext _) {
    return vanillaKbdStyle(variant: variant, style: style).call(text);
  }
}
