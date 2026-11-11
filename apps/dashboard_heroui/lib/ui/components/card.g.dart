// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixCard].
///
/// Lay the content out with a column spaced 12px (`gap-3`); [UiCardTitle]
/// and [UiCardDescription] carry the header's text styles.
class UiCard extends StatelessWidget {
  const UiCard({
    super.key,
    this.variant = .defaultCard,
    this.style = const CardStyler.create(),
    this.child,
  });

  const UiCard.defaultCard({
    super.key,
    this.style = const CardStyler.create(),
    this.child,
  }) : variant = UiCardVariant.defaultCard;

  const UiCard.secondary({
    super.key,
    this.style = const CardStyler.create(),
    this.child,
  }) : variant = UiCardVariant.secondary;

  const UiCard.tertiary({
    super.key,
    this.style = const CardStyler.create(),
    this.child,
  }) : variant = UiCardVariant.tertiary;

  const UiCard.transparent({
    super.key,
    this.style = const CardStyler.create(),
    this.child,
  }) : variant = UiCardVariant.transparent;

  final UiCardVariant variant;

  final CardStyler style;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return RemixCard(
      key: this.key,
      style: uiCardStyle(variant: this.variant, style: this.style),
      child: this.child,
    );
  }
}
