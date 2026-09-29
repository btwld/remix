// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Link recipe.
///
/// Remix owns the link role, the destination, focus, activation, and the rule
/// that a link with no callback is a disabled link; this recipe supplies its
/// type, its color, and its states.
///
/// It is shadcn's link button: `textSm` at medium weight in `primary`,
/// underlined while the pointer is on it, and ringed like every other control
/// when it has keyboard focus. That suits a link standing on its own — "Forgot
/// password?", "View all" — which is what shadcn's link variant is for. A
/// link set inside running prose should stay identifiable without the
/// pointer; give that call site an underline at rest through [style]:
///
/// ```dart
/// PlaygroundLink(
///   label: 'terms of service',
///   style: LinkStyler().label(.decoration(TextDecoration.underline)),
///   onPressed: openTerms,
/// )
/// ```
///
/// There is no pressed fragment. A link's press is over in the time it takes
/// to navigate, and the destination arriving is the feedback — the same reason
/// the checkbox has none, arrived at from the other direction: a checkbox
/// flips its own state, and a link replaces the page.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it. State fragments merge by state, not
/// by depth: an override that must beat the recipe's hover underline has to be
/// declared as a hover fragment too (`LinkStyler().onHovered(...)`).
class PlaygroundLink extends StatelessWidget {
  const PlaygroundLink({
    super.key,
    this.style = const LinkStyler.create(),
    this.label,
    this.child,
    this.onPressed,
    this.enabled = true,
    this.linkUrl,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.mouseCursor = SystemMouseCursors.click,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
  });

  final LinkStyler style;

  final String? label;

  final Widget? child;

  final VoidCallback? onPressed;

  final bool enabled;

  final Uri? linkUrl;

  final FocusNode? focusNode;

  final bool autofocus;

  final bool enableFeedback;

  final MouseCursor mouseCursor;

  final String? semanticLabel;

  final String? semanticHint;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    return RemixLink(
      key: this.key,
      style: playgroundLinkStyle(style: this.style),
      label: this.label,
      child: this.child,
      onPressed: this.onPressed,
      enabled: this.enabled,
      linkUrl: this.linkUrl,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      enableFeedback: this.enableFeedback,
      mouseCursor: this.mouseCursor,
      semanticLabel: this.semanticLabel,
      semanticHint: this.semanticHint,
      excludeSemantics: this.excludeSemantics,
    );
  }
}
