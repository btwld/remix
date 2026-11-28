// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toast.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Toast recipe, for [RemixToast] and [RemixToastScope].
///
/// A toast is a floating card in a 1px border with a round tinted icon chip,
/// a medium title over secondary text, and a round close button. It caps at
/// 416px and shrinks with the available width. Inside a [RemixToastScope] it
/// rises 16px and grows from 96% on the morph spring while it fades in over
/// 200ms, and leaves in 140ms, sinking 8px to 97%.
///
/// ```dart
/// RemixToastScope(style: uiToastStyle(), child: const Shell())
/// ```
class UiToast extends StatelessWidget {
  const UiToast({
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

  /// The raised shadow.
  const UiToast.surface({
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
  }) : variant = UiToastVariant.surface;

  /// The floating shadow. The default.
  const UiToast.classic({
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
  }) : variant = UiToastVariant.classic;

  final UiToastVariant variant;

  final UiToastSize size;

  final UiToastIntent intent;

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
      style: uiToastStyle(
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
