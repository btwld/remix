// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Deui recipe for [RemixLink].
///
/// The label inherits its size from the surrounding text, as `.link` does.
class DeuiLink extends StatelessWidget {
  const DeuiLink({
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
      style: deuiLinkStyle(style: this.style),
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
