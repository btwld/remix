// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixCard].
///
/// Lay the content out with a column spaced 12px (`gap-3`); [HeroUiCardTitle]
/// and [HeroUiCardDescription] carry the header's text styles.
class HeroUiCard extends StatelessWidget {
  const HeroUiCard({
    super.key,
    this.variant = .defaultCard,
    this.style = const CardStyler.create(),
    this.child,
  });

  const HeroUiCard.defaultCard({
    super.key,
    this.style = const CardStyler.create(),
    this.child,
  }) : variant = HeroUiCardVariant.defaultCard;

  const HeroUiCard.secondary({
    super.key,
    this.style = const CardStyler.create(),
    this.child,
  }) : variant = HeroUiCardVariant.secondary;

  const HeroUiCard.tertiary({
    super.key,
    this.style = const CardStyler.create(),
    this.child,
  }) : variant = HeroUiCardVariant.tertiary;

  const HeroUiCard.transparent({
    super.key,
    this.style = const CardStyler.create(),
    this.child,
  }) : variant = HeroUiCardVariant.transparent;

  final HeroUiCardVariant variant;

  final CardStyler style;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return RemixCard(
      key: this.key,
      style: heroUiCardStyle(variant: this.variant, style: this.style),
      child: this.child,
    );
  }
}
