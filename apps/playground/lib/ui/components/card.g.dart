// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Card recipe.
///
/// A surface that groups content: `card` fill (a step lighter than the page in
/// the dark theme), `border` hairline, large corners, a small shadow and a
/// 24px inset. It has no variant, size or state.
class PlaygroundCard extends StatelessWidget {
  const PlaygroundCard({
    super.key,
    this.style = const CardStyler.create(),
    this.child,
  });

  final CardStyler style;

  final Widget? child;

  @override
  Widget build(BuildContext _) {
    return RemixCard(
      style: playgroundCardStyle(style: style),
      child: child,
    );
  }
}
