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
/// The fill is `background`, the same token the page uses, so a card is told
/// apart by its outline rather than by a second surface color. The theme's
/// thirty-three tokens do include a `card` surface, a step lighter than the
/// page in the dark theme; pointing this one line at it lifts every card.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it:
///
/// ```dart
/// PlaygroundCard(
///   style: CardStyler().color(PlaygroundTokens.muted()),
///   child: summary,
/// )
/// ```
class PlaygroundCard extends StatelessWidget {
  const PlaygroundCard({
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
      style: playgroundCardStyle(style: this.style),
      child: this.child,
    );
  }
}
