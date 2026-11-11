// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toast.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixToast] and, as its `style`, [RemixToastScope].
///
/// Stacking, timing, and dismissal stay with Remix. The action is HeroUI's
/// default button, as in `Toast` (`toast-default-action`): beside the message
/// above 768px and under it from 768px down. Below 640px it adds `mt-2`
/// through a second `action`.
///
/// An `action` replaces rather than merges, so a caller who styles it restates
/// `uiButtonStyle()` in their `action`, and again, with `.margin(.top(2))`,
/// in an `onNot(ContextVariant.breakpoint(Breakpoint.minWidth(
/// UiTokens.breakpointSm)), ...)` fragment; without that fragment the
/// recipe's own action wins below 640px.
class UiToast extends StatelessWidget {
  const UiToast({
    super.key,
    this.variant = .defaultToast,
    this.style = const ToastStyler.create(),
    required this.title,
    this.description,
    this.icon,
    this.action,
    this.onDismiss,
    this.dismissLabel,
    this.excludeMessageSemantics = false,
  });

  const UiToast.defaultToast({
    super.key,
    this.style = const ToastStyler.create(),
    required this.title,
    this.description,
    this.icon,
    this.action,
    this.onDismiss,
    this.dismissLabel,
    this.excludeMessageSemantics = false,
  }) : variant = UiToastVariant.defaultToast;

  const UiToast.accent({
    super.key,
    this.style = const ToastStyler.create(),
    required this.title,
    this.description,
    this.icon,
    this.action,
    this.onDismiss,
    this.dismissLabel,
    this.excludeMessageSemantics = false,
  }) : variant = UiToastVariant.accent;

  const UiToast.success({
    super.key,
    this.style = const ToastStyler.create(),
    required this.title,
    this.description,
    this.icon,
    this.action,
    this.onDismiss,
    this.dismissLabel,
    this.excludeMessageSemantics = false,
  }) : variant = UiToastVariant.success;

  const UiToast.warning({
    super.key,
    this.style = const ToastStyler.create(),
    required this.title,
    this.description,
    this.icon,
    this.action,
    this.onDismiss,
    this.dismissLabel,
    this.excludeMessageSemantics = false,
  }) : variant = UiToastVariant.warning;

  const UiToast.danger({
    super.key,
    this.style = const ToastStyler.create(),
    required this.title,
    this.description,
    this.icon,
    this.action,
    this.onDismiss,
    this.dismissLabel,
    this.excludeMessageSemantics = false,
  }) : variant = UiToastVariant.danger;

  final UiToastVariant variant;

  final ToastStyler style;

  final String title;

  final String? description;

  final IconData? icon;

  final RemixToastAction? action;

  final VoidCallback? onDismiss;

  final String? dismissLabel;

  final bool excludeMessageSemantics;

  @override
  Widget build(BuildContext context) {
    return RemixToast(
      key: this.key,
      style: uiToastStyle(variant: this.variant, style: this.style),
      title: this.title,
      description: this.description,
      icon: this.icon,
      action: this.action,
      onDismiss: this.onDismiss,
      dismissLabel: this.dismissLabel,
      excludeMessageSemantics: this.excludeMessageSemantics,
    );
  }
}
