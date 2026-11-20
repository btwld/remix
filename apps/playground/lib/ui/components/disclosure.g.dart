// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disclosure.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Disclosure recipe.
///
/// A single collapsible section. It is the accordion's trigger without the
/// frame: 16px above and below, `textSm` at medium weight, underlined under the
/// pointer. A lone disclosure has no neighbors to separate, so it draws no rule.
///
/// The spec carries plain boxes, not text, so the trigger's type is a default
/// text style: a bare `Text` trigger takes it and one with its own style keeps
/// it.
class PlaygroundDisclosure extends StatelessWidget {
  const PlaygroundDisclosure({
    super.key,
    this.style = const DisclosureStyler.create(),
    required this.trigger,
    required this.content,
    this.triggerBuilder,
    this.expanded,
    this.defaultExpanded = false,
    this.onExpandedChanged,
    this.enabled = true,
    this.mouseCursor = SystemMouseCursors.click,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.onHoverChange,
    this.onPressChange,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.transitionBuilder,
    this.animationStyle = const AnimationStyle(
      curve: Curves.ease,
      duration: Duration(milliseconds: 200),
      reverseDuration: Duration(milliseconds: 200),
    ),
  });

  final DisclosureStyler style;

  final Widget trigger;

  final Widget content;

  final ValueWidgetBuilder<NakedDisclosureState>? triggerBuilder;

  final bool? expanded;

  final bool defaultExpanded;

  final ValueChanged<bool>? onExpandedChanged;

  final bool enabled;

  final MouseCursor mouseCursor;

  final bool enableFeedback;

  final FocusNode? focusNode;

  final bool autofocus;

  final ValueChanged<bool>? onFocusChange;

  final ValueChanged<bool>? onHoverChange;

  final ValueChanged<bool>? onPressChange;

  final String? semanticLabel;

  final String? semanticHint;

  final bool excludeSemantics;

  final NakedDisclosureTransitionBuilder? transitionBuilder;

  final AnimationStyle animationStyle;

  @override
  Widget build(BuildContext context) {
    return RemixDisclosure(
      key: this.key,
      style: playgroundDisclosureStyle(style: this.style),
      trigger: this.trigger,
      content: this.content,
      triggerBuilder: this.triggerBuilder,
      expanded: this.expanded,
      defaultExpanded: this.defaultExpanded,
      onExpandedChanged: this.onExpandedChanged,
      enabled: this.enabled,
      mouseCursor: this.mouseCursor,
      enableFeedback: this.enableFeedback,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      onFocusChange: this.onFocusChange,
      onHoverChange: this.onHoverChange,
      onPressChange: this.onPressChange,
      semanticLabel: this.semanticLabel,
      semanticHint: this.semanticHint,
      excludeSemantics: this.excludeSemantics,
      transitionBuilder: this.transitionBuilder,
      animationStyle: this.animationStyle,
    );
  }
}
