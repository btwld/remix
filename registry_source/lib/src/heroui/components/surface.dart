import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

/// HeroUI surface fills; `defaultSurface` is HeroUI's `default`.
enum HeroUiSurfaceVariant { transparent, defaultSurface, secondary, tertiary }

/// HeroUI's `Surface`: a filled box that sets the text colour for its content.
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
    var base = BoxStyler();
    if (fill != null) base = base.color(fill);

    return Box(
      style: base.merge(style),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: foreground.resolve(context)),
        child: child,
      ),
    );
  }
}
