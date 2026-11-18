import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'card.dart';

/// How loudly a surface speaks, from the ordinary panel to the one block a
/// page leads with. Fortal casts no shadow under a surface, so emphasis comes
/// from fill and contrast alone.
enum FortalSurfaceVariant {
  /// The surface card: a panel inside a hairline frame. For content of
  /// ordinary weight.
  surface,

  /// An accent wash inside an accent hairline, for supporting content that
  /// belongs to the accent: a goal, a tip, a plan.
  soft,

  /// A faint neutral wash, for content that should recede behind its
  /// neighbours.
  quiet,

  /// The surface card in the opposite appearance: a dark panel in light mode
  /// and a light one in dark mode. Reserve it for the one block a page leads
  /// with.
  inverse,
}

/// The sizes a surface comes in: the card's padding and corner steps. Pixel
/// values are at 100% theme scaling.
enum FortalSurfaceSize {
  /// 12px padding.
  size1,

  /// 16px padding. The default.
  size2,

  /// 24px padding.
  size3,

  /// 32px padding.
  size4,

  /// 48px padding.
  size5,
}

/// The Fortal Surface recipe: the surface card, with [variant]'s fill and
/// frame.
///
/// Pressing, hovering and focus resolve from the widget states above it, as
/// they do for the card. An unpadded surface runs its content to the frame,
/// as a cover image or a table does. [style] merges last.
///
/// The inverse variant is the surface card itself: [FortalSurface] resolves
/// it in the opposite appearance.
CardStyler fortalSurfaceStyle({
  FortalSurfaceVariant variant = .surface,
  FortalSurfaceSize size = .size2,
  bool padded = true,
  CardStyler style = const CardStyler.create(),
}) => fortalCardStyle(size: _cardSize(size))
    .merge(switch (variant) {
      .surface || .inverse => null,
      .soft => _soft(),
      .quiet => _quiet(),
    })
    .merge(padded ? null : CardStyler().padding(.all(0)))
    .merge(style);

FortalCardSize _cardSize(FortalSurfaceSize size) => switch (size) {
  .size1 => .size1,
  .size2 => .size2,
  .size3 => .size3,
  .size4 => .size4,
  .size5 => .size5,
};

/// An accent wash and hairline, each a step deeper under the pointer.
CardStyler _soft() => CardStyler()
    .color(FortalTokens.accentA3())
    .border(.all(.color(FortalTokens.accentA4())))
    .onHovered(.border(.all(.color(FortalTokens.accentA5()))))
    .onPressed(.color(FortalTokens.accentA4()));

/// A faint neutral wash and hairline, each a step deeper under the pointer.
CardStyler _quiet() => CardStyler()
    .color(FortalTokens.grayA2())
    .border(.all(.color(FortalTokens.grayA3())))
    .onHovered(.border(.all(.color(FortalTokens.grayA4()))))
    .onPressed(.color(FortalTokens.grayA3()));

/// A card at one of the [FortalSurfaceVariant] levels of emphasis.
///
/// With [onPressed] the whole surface is one button: it takes the press, the
/// hover, the focus ring, Enter and Space. [semanticLabel] then names it, and
/// the child's own text is hidden from assistive technology. Without
/// [onPressed], a [semanticLabel] names the surface as one group.
///
/// The inverse variant resolves everything inside it, text, controls and
/// charts included, in the opposite appearance, so they keep their contrast
/// without special cases.
class FortalSurface extends StatelessWidget {
  const FortalSurface({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    this.padded = true,
    this.onPressed,
    this.semanticLabel,
    this.style = const CardStyler.create(),
    required this.child,
  }) : assert(onPressed == null || semanticLabel != null),
       assert(semanticLabel == null || semanticLabel != '');

  /// The surface card: a panel inside a hairline frame.
  const FortalSurface.surface({
    super.key,
    this.size = .size2,
    this.padded = true,
    this.onPressed,
    this.semanticLabel,
    this.style = const CardStyler.create(),
    required this.child,
  }) : variant = FortalSurfaceVariant.surface,
       assert(onPressed == null || semanticLabel != null),
       assert(semanticLabel == null || semanticLabel != '');

  /// An accent wash inside an accent hairline.
  const FortalSurface.soft({
    super.key,
    this.size = .size2,
    this.padded = true,
    this.onPressed,
    this.semanticLabel,
    this.style = const CardStyler.create(),
    required this.child,
  }) : variant = FortalSurfaceVariant.soft,
       assert(onPressed == null || semanticLabel != null),
       assert(semanticLabel == null || semanticLabel != '');

  /// A faint neutral wash.
  const FortalSurface.quiet({
    super.key,
    this.size = .size2,
    this.padded = true,
    this.onPressed,
    this.semanticLabel,
    this.style = const CardStyler.create(),
    required this.child,
  }) : variant = FortalSurfaceVariant.quiet,
       assert(onPressed == null || semanticLabel != null),
       assert(semanticLabel == null || semanticLabel != '');

  /// The surface card in the opposite appearance.
  const FortalSurface.inverse({
    super.key,
    this.size = .size2,
    this.padded = true,
    this.onPressed,
    this.semanticLabel,
    this.style = const CardStyler.create(),
    required this.child,
  }) : variant = FortalSurfaceVariant.inverse,
       assert(onPressed == null || semanticLabel != null),
       assert(semanticLabel == null || semanticLabel != '');

  /// How much attention the surface asks for.
  final FortalSurfaceVariant variant;

  /// The padding and corner size.
  final FortalSurfaceSize size;

  /// Whether the surface pads its [child].
  final bool padded;

  /// Makes the whole surface one button.
  final VoidCallback? onPressed;

  /// The button's accessible name, or the group's without [onPressed].
  final String? semanticLabel;

  /// Merged last into the surface's style.
  final CardStyler style;

  /// The surface's content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget surface = RemixCard(
      style: fortalSurfaceStyle(
        variant: variant,
        size: size,
        padded: padded,
        style: style,
      ),
      child: child,
    );
    if (variant == .inverse) {
      surface = FortalTheme(
        mode: FortalTheme.of(context).isDark ? .light : .dark,
        hasBackground: false,
        child: surface,
      );
    }
    if (onPressed case final onPressed?) {
      return Pressable(
        onPress: onPressed,
        semanticsLabel: semanticLabel,
        mouseCursor: SystemMouseCursors.click,
        child: ExcludeSemantics(child: surface),
      );
    }
    if (semanticLabel == null) return surface;

    return Semantics(container: true, label: semanticLabel, child: surface);
  }
}
