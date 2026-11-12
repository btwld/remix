// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Ui Button recipe.
///
/// It reads top to bottom: what every button shares, then the size, then the
/// variant's colors for each state, then focus and disabled. [style] merges
/// last, so a call site can override any part of it.
///
/// [highContrast] strengthens a variant: the solid fill, and the text of every
/// other variant, move to accent step 12.
///
/// An icon takes the size's icon size rather than the ambient `IconTheme`. An
/// icon size in [style] overrides it.
class UiButton extends StatelessWidget {
  const UiButton({
    super.key,
    this.variant = .solid,
    this.size = .size2,
    this.highContrast = false,
    this.style = const ButtonStyler.create(),
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.textBuilder,
    this.leadingIconBuilder,
    this.trailingIconBuilder,
    this.loadingBuilder,
    this.loading = false,
    this.enabled = true,
    this.onPressed,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  });

  /// The accent's solid fill under its contrast label.
  const UiButton.solid({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const ButtonStyler.create(),
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.textBuilder,
    this.leadingIconBuilder,
    this.trailingIconBuilder,
    this.loadingBuilder,
    this.loading = false,
    this.enabled = true,
    this.onPressed,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = UiButtonVariant.solid;

  /// A tinted accent fill under accent text.
  const UiButton.soft({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const ButtonStyler.create(),
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.textBuilder,
    this.leadingIconBuilder,
    this.trailingIconBuilder,
    this.loadingBuilder,
    this.loading = false,
    this.enabled = true,
    this.onPressed,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = UiButtonVariant.soft;

  /// A faint accent surface inside a 1px accent frame.
  const UiButton.surface({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const ButtonStyler.create(),
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.textBuilder,
    this.leadingIconBuilder,
    this.trailingIconBuilder,
    this.loadingBuilder,
    this.loading = false,
    this.enabled = true,
    this.onPressed,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = UiButtonVariant.surface;

  /// No fill inside a 1px accent frame.
  const UiButton.outline({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const ButtonStyler.create(),
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.textBuilder,
    this.leadingIconBuilder,
    this.trailingIconBuilder,
    this.loadingBuilder,
    this.loading = false,
    this.enabled = true,
    this.onPressed,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = UiButtonVariant.outline;

  /// Accent text alone, with a tint under the pointer.
  const UiButton.ghost({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const ButtonStyler.create(),
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.textBuilder,
    this.leadingIconBuilder,
    this.trailingIconBuilder,
    this.loadingBuilder,
    this.loading = false,
    this.enabled = true,
    this.onPressed,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = UiButtonVariant.ghost;

  final UiButtonVariant variant;

  final UiButtonSize size;

  final bool highContrast;

  final ButtonStyler style;

  final String label;

  final IconData? leadingIcon;

  final IconData? trailingIcon;

  final RemixButtonTextBuilder? textBuilder;

  final RemixButtonIconBuilder? leadingIconBuilder;

  final RemixButtonIconBuilder? trailingIconBuilder;

  final RemixButtonLoadingBuilder? loadingBuilder;

  final bool loading;

  final bool enabled;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  final FocusNode? focusNode;

  final bool autofocus;

  final bool enableFeedback;

  final String? semanticLabel;

  final String? semanticHint;

  final bool excludeSemantics;

  final MouseCursor mouseCursor;

  @override
  Widget build(BuildContext context) {
    return RemixButton(
      key: this.key,
      style: uiButtonStyle(
        variant: this.variant,
        size: this.size,
        highContrast: this.highContrast,
        style: this.style,
      ),
      label: this.label,
      leadingIcon: this.leadingIcon,
      trailingIcon: this.trailingIcon,
      textBuilder: this.textBuilder,
      leadingIconBuilder: this.leadingIconBuilder,
      trailingIconBuilder: this.trailingIconBuilder,
      loadingBuilder: this.loadingBuilder,
      loading: this.loading,
      enabled: this.enabled,
      onPressed: this.onPressed,
      onLongPress: this.onLongPress,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      enableFeedback: this.enableFeedback,
      semanticLabel: this.semanticLabel,
      semanticHint: this.semanticHint,
      excludeSemantics: this.excludeSemantics,
      mouseCursor: this.mouseCursor,
    );
  }
}
