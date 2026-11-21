// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accordion.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Accordion recipe.
///
/// It reads top to bottom: what every accordion shares, then the size, then
/// the variant's panel colors for rest, hover, press, focus and disabled.
class FortalAccordion<T> extends StatelessWidget {
  const FortalAccordion({
    super.key,
    this.variant = .surface,
    this.size = .size2,
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

  /// The `gray2` panel inside a 1px gray frame.
  const FortalAccordion.surface({
    super.key,
    this.size = .size2,
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
  }) : variant = FortalAccordionVariant.surface;

  /// An accent-tinted panel inside a 1px accent frame.
  const FortalAccordion.soft({
    super.key,
    this.size = .size2,
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
  }) : variant = FortalAccordionVariant.soft;

  final FortalAccordionVariant variant;

  final FortalAccordionSize size;

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
      style: fortalAccordionStyle(variant: variant, size: size, style: style),
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
