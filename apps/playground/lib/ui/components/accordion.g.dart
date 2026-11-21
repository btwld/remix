// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accordion.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Accordion recipe.
///
/// Sections are separated by a bottom hairline rather than a box, so a stack
/// reads as one list.
///
/// `RemixAccordionGroup`, which owns which values are expanded, has no styler
/// and no recipe. Wrap the sections in it directly:
///
/// ```dart
/// RemixAccordionGroup<String>(
///   controller: RemixAccordionController<String>(),
///   child: Column(children: const [
///     PlaygroundAccordion(
///       value: 'shipping',
///       title: 'Shipping',
///       child: Text('Two to four business days.'),
///     ),
///   ]),
/// )
/// ```
class PlaygroundAccordion<T> extends StatelessWidget {
  const PlaygroundAccordion({
    super.key,
    this.style = const AccordionStyler.create(),
    required this.value,
    required this.child,
    this.title,
    this.leadingIcon,
    this.trailingIcon,
    this.builder,
    this.enabled = true,
    this.mouseCursor = SystemMouseCursors.click,
    this.enableFeedback = true,
    this.autofocus = false,
    this.focusNode,
    this.onFocusChange,
    this.onHoverChange,
    this.onPressChange,
    this.semanticLabel,
    this.transitionBuilder,
  });

  final AccordionStyler style;

  final T value;

  final Widget child;

  final String? title;

  final IconData? leadingIcon;

  final IconData? trailingIcon;

  final NakedAccordionTriggerBuilder<T>? builder;

  final bool enabled;

  final MouseCursor mouseCursor;

  final bool enableFeedback;

  final bool autofocus;

  final FocusNode? focusNode;

  final ValueChanged<bool>? onFocusChange;

  final ValueChanged<bool>? onHoverChange;

  final ValueChanged<bool>? onPressChange;

  final String? semanticLabel;

  final Widget Function(Widget, Animation<double>)? transitionBuilder;

  @override
  Widget build(BuildContext _) {
    return RemixAccordion<T>(
      style: playgroundAccordionStyle(style: style),
      value: value,
      title: title,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      builder: builder,
      enabled: enabled,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      autofocus: autofocus,
      focusNode: focusNode,
      onFocusChange: onFocusChange,
      onHoverChange: onHoverChange,
      onPressChange: onPressChange,
      semanticLabel: semanticLabel,
      transitionBuilder: transitionBuilder,
      child: child,
    );
  }
}
