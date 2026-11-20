// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Link recipe.
///
/// `textSm` at medium weight in `primary`, underlined under the pointer and
/// ringed on keyboard focus. That suits a link that stands alone; a link inside
/// running prose should stay identifiable without the pointer, so underline it
/// at rest through [style]:
///
/// ```dart
/// PlaygroundLink(
///   label: 'terms of service',
///   style: LinkStyler().label(.decoration(TextDecoration.underline)),
///   onPressed: openTerms,
/// )
/// ```
///
/// There is no pressed fragment: a link replaces the page, and the destination
/// arriving is the feedback.
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
