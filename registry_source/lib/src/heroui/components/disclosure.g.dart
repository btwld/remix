// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disclosure.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixDisclosure].
///
/// [animationStyle] defaults to the panel's `200ms var(--ease-out-quad)`.
class HeroUiDisclosure extends StatelessWidget {
  const HeroUiDisclosure({
    super.key,
    this.animationStyle = const AnimationStyle(
      curve: HeroUiTokens.easeOutQuad,
      duration: _panelDuration,
      reverseDuration: _panelDuration,
    ),
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
  });

  final AnimationStyle animationStyle;

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

  @override
  Widget build(BuildContext _) {
    return RemixDisclosure(
      style: heroUiDisclosureStyle(
        animationStyle: animationStyle,
        style: style,
      ),
      trigger: trigger,
      content: content,
      triggerBuilder: triggerBuilder,
      expanded: expanded,
      defaultExpanded: defaultExpanded,
      onExpandedChanged: onExpandedChanged,
      enabled: enabled,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      focusNode: focusNode,
      autofocus: autofocus,
      onFocusChange: onFocusChange,
      onHoverChange: onHoverChange,
      onPressChange: onPressChange,
      semanticLabel: semanticLabel,
      semanticHint: semanticHint,
      excludeSemantics: excludeSemantics,
      transitionBuilder: transitionBuilder,
      animationStyle: animationStyle,
    );
  }
}
