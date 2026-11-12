import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

/// HeroUI surface fills.
enum HeroUiSurfaceVariant {
  /// No fill, under the `foreground` text color.
  transparent,

  /// The `surface` fill.
  defaultSurface,

  /// The `surface-secondary` fill.
  secondary,

  /// The `surface-tertiary` fill.
  tertiary,
}

/// HeroUI's `Surface`: a filled box that sets the text color for its content.
///
/// `text-surface-*-foreground` is the CSS `color`, which `currentColor` icons
/// inherit too, so the icon theme takes the same color.
class HeroUiSurface extends StatelessWidget {
  const HeroUiSurface({
    super.key,
    this.variant = .defaultSurface,
    this.style = const BoxStyler.create(),
    required this.child,
  });

  final HeroUiSurfaceVariant variant;
  final BoxStyler style;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final (fill, foreground) = switch (variant) {
      .transparent => (null, HeroUiTokens.foreground),
      .defaultSurface => (
        HeroUiTokens.surface(),
        HeroUiTokens.surfaceForeground,
      ),
      .secondary => (
        HeroUiTokens.surfaceSecondary(),
        HeroUiTokens.surfaceSecondaryForeground,
      ),
      .tertiary => (
        HeroUiTokens.surfaceTertiary(),
        HeroUiTokens.surfaceTertiaryForeground,
      ),
    };
    final color = foreground.resolve(context);
    return Box(
      style: BoxStyler()
          .merge(fill == null ? null : BoxStyler().color(fill))
          .merge(style),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: color),
        child: IconTheme.merge(
          data: IconThemeData(color: color),
          child: child,
        ),
      ),
    );
  }
}
