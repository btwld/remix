// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toast.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Toast recipe, for [RemixToast] and [RemixToastScope].
///
/// A toast is a raised, blurred panel in a 1px frame, with a ghost action and
/// close button. It caps at 360px and shrinks with the available width.
///
/// ```dart
/// RemixToastScope(style: fortalToastStyle(), child: const Shell())
/// ```
class FortalToast extends StatelessWidget {
  const FortalToast({
    super.key,
    this.variant = .classic,
    this.size = .size2,
    this.intent = .accent,
    this.style = const ToastStyler.create(),
    required this.title,
    this.description,
    this.icon,
    this.action,
    this.onDismiss,
    this.dismissLabel,
    this.excludeMessageSemantics = false,
  });

  /// A quiet shadow.
  const FortalToast.surface({
    super.key,
    this.size = .size2,
    this.intent = .accent,
    this.style = const ToastStyler.create(),
    required this.title,
    this.description,
    this.icon,
    this.action,
    this.onDismiss,
    this.dismissLabel,
    this.excludeMessageSemantics = false,
  }) : variant = FortalToastVariant.surface;

  /// A deeper shadow. The default.
  const FortalToast.classic({
    super.key,
    this.size = .size2,
    this.intent = .accent,
    this.style = const ToastStyler.create(),
    required this.title,
    this.description,
    this.icon,
    this.action,
    this.onDismiss,
    this.dismissLabel,
    this.excludeMessageSemantics = false,
  }) : variant = FortalToastVariant.classic;

  final FortalToastVariant variant;

  final FortalToastSize size;

  final FortalToastIntent intent;

  final ToastStyler style;

  final String title;

  final String? description;

  final IconData? icon;

  final RemixToastAction? action;

  final VoidCallback? onDismiss;

  final String? dismissLabel;

  final bool excludeMessageSemantics;

  @override
  Widget build(BuildContext _) {
    return RemixToast(
      style: fortalToastStyle(
        variant: variant,
        size: size,
        intent: intent,
        style: style,
      ),
      title: title,
      description: description,
      icon: icon,
      action: action,
      onDismiss: onDismiss,
      dismissLabel: dismissLabel,
      excludeMessageSemantics: excludeMessageSemantics,
    );
  }
}
