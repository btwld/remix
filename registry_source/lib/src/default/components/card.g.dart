// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Card recipe.
///
/// A card is a surface that groups related content. Everything visual about
/// it lives in this function; Remix owns nothing but the rendering, because a
/// card has no interaction and no state of its own.
///
/// It takes no variant and no size. A card is one surface, and its content
/// decides how tall it is — an axis with nothing behind it would only be one
/// more thing to keep consistent.
///
/// It is shadcn's card: the `card` surface — the page color in the light
/// theme and a step lighter than the page in the dark one — with a `border`
/// hairline, large corners, a small shadow, and a 24px inset. `card` is one of
/// the vocabulary's thirty-three tokens precisely so a theme can set cards
/// apart from the page without touching this recipe.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it:
///
/// ```dart
/// VanillaCard(
///   style: CardStyler().color(VanillaTokens.muted()),
///   child: summary,
/// )
/// ```
class VanillaCard extends StatelessWidget {
  const VanillaCard({
    super.key,
    this.style = const CardStyler.create(),
    this.child,
  });

  final CardStyler style;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return RemixCard(
      key: this.key,
      style: vanillaCardStyle(style: this.style),
      child: this.child,
    );
  }
}
