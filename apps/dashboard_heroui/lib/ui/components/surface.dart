import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

/// HeroUI surface fills.
enum UiSurfaceVariant {
  /// No fill, under the `foreground` text color.
  transparent,

  /// HeroUI's `default`: the `surface` fill.
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
class UiSurface extends StatelessWidget {
  const UiSurface({
    super.key,
    this.variant = .defaultSurface,
    this.style = const BoxStyler.create(),
    required this.child,
  });

  final UiSurfaceVariant variant;
  final BoxStyler style;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final (fill, foreground) = switch (variant) {
      .transparent => (null, UiTokens.foreground),
      .defaultSurface => (UiTokens.surface(), UiTokens.surfaceForeground),
      .secondary => (
        UiTokens.surfaceSecondary(),
        UiTokens.surfaceSecondaryForeground,
      ),
      .tertiary => (
        UiTokens.surfaceTertiary(),
        UiTokens.surfaceTertiaryForeground,
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
