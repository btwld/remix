// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'callout.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Callout recipe.
///
/// The default is a resting card: a 13px medium title over 12px secondary
/// text, with only the icon tinted by [intent]. It reads top to bottom: the
/// size, the intent's icon, the text colors, then the variant's fill and frame.
///
/// [highContrast], or the theme's high contrast, moves the icon and text to
/// the foreground and the frames to gray 10, which holds 3:1 on the card.
class UiCallout extends StatelessWidget {
  const UiCallout({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    this.intent = .info,
    this.highContrast = false,
    this.style = const CalloutStyler.create(),
    this.text,
    this.title,
    this.icon,
    this.child,
    this.onDismiss,
    this.dismissLabel,
  });

  /// A tinted accent fill.
  const UiCallout.soft({
    super.key,
    this.size = .size2,
    this.intent = .info,
    this.highContrast = false,
    this.style = const CalloutStyler.create(),
    this.text,
    this.title,
    this.icon,
    this.child,
    this.onDismiss,
    this.dismissLabel,
  }) : variant = UiCalloutVariant.soft;

  /// A resting card: the surface fill in a 1px border with a soft shadow.
  /// The default.
  const UiCallout.surface({
    super.key,
    this.size = .size2,
    this.intent = .info,
    this.highContrast = false,
    this.style = const CalloutStyler.create(),
    this.text,
    this.title,
    this.icon,
    this.child,
    this.onDismiss,
    this.dismissLabel,
  }) : variant = UiCalloutVariant.surface;

  /// No fill inside a 1px strong border.
  const UiCallout.outline({
    super.key,
    this.size = .size2,
    this.intent = .info,
    this.highContrast = false,
    this.style = const CalloutStyler.create(),
    this.text,
    this.title,
    this.icon,
    this.child,
    this.onDismiss,
    this.dismissLabel,
  }) : variant = UiCalloutVariant.outline;

  final UiCalloutVariant variant;

  final UiCalloutSize size;

  final UiCalloutIntent intent;

  final bool highContrast;

  final CalloutStyler style;

  final String? text;

  final String? title;

  final IconData? icon;

  final Widget? child;

  final VoidCallback? onDismiss;

  final String? dismissLabel;

  @override
  Widget build(BuildContext _) {
    return RemixCallout(
      style: uiCalloutStyle(
        variant: variant,
        size: size,
        intent: intent,
        highContrast: highContrast,
        style: style,
      ),
      text: text,
      title: title,
      icon: icon,
      onDismiss: onDismiss,
      dismissLabel: dismissLabel,
      child: child,
    );
  }
}
