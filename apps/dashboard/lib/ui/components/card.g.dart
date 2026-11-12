// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Ui Card recipe: a flat panel. Elevation is reserved for floating
/// layers, never cards.
///
/// It reads top to bottom: the size and focus ring, then the variant's colors
/// for rest, hover, press and selected, then disabled.
class UiCard extends StatelessWidget {
  const UiCard({
    super.key,
    this.variant = .surface,
    this.size = .size1,
    this.style = const CardStyler.create(),
    this.child,
  });

  /// A panel fill inside a 1px gray frame.
  const UiCard.surface({
    super.key,
    this.size = .size1,
    this.style = const CardStyler.create(),
    this.child,
  }) : variant = UiCardVariant.surface;

  /// No fill or frame until hovered. It sits in a negative margin equal to its
  /// padding, so its content lines up with the content around it.
  const UiCard.ghost({
    super.key,
    this.size = .size1,
    this.style = const CardStyler.create(),
    this.child,
  }) : variant = UiCardVariant.ghost;

  final UiCardVariant variant;

  final UiCardSize size;

  final CardStyler style;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return RemixCard(
      key: this.key,
      style: uiCardStyle(
        variant: this.variant,
        size: this.size,
        style: this.style,
      ),
      child: this.child,
    );
  }
}
