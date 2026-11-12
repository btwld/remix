// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Card recipe: a flat panel. Elevation is reserved for floating
/// layers, never cards.
///
/// It reads top to bottom: the size and focus ring, then the variant's colors
/// for rest, hover, press and selected, then disabled.
class FortalCard extends StatelessWidget {
  const FortalCard({
    super.key,
    this.variant = .surface,
    this.size = .size1,
    this.style = const CardStyler.create(),
    this.child,
  });

  /// A panel fill inside a 1px gray frame.
  const FortalCard.surface({
    super.key,
    this.size = .size1,
    this.style = const CardStyler.create(),
    this.child,
  }) : variant = FortalCardVariant.surface;

  /// No fill or frame until hovered. It sits in a negative margin equal to its
  /// padding, so its content lines up with the content around it.
  const FortalCard.ghost({
    super.key,
    this.size = .size1,
    this.style = const CardStyler.create(),
    this.child,
  }) : variant = FortalCardVariant.ghost;

  final FortalCardVariant variant;

  final FortalCardSize size;

  final CardStyler style;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return RemixCard(
      key: this.key,
      style: fortalCardStyle(
        variant: this.variant,
        size: this.size,
        style: this.style,
      ),
      child: this.child,
    );
  }
}
