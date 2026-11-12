// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icon_button.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Ui IconButton recipe.
///
/// It reads top to bottom: what every icon button shares, then the size, then
/// the variant's colors for each state, then focus and disabled. [style]
/// merges last, so a call site can override any part of it.
///
/// The variants restate the labelled button's colors rather than sharing
/// them, so each recipe can be read and edited on its own. Change one and
/// change the other to keep the two a family.
///
/// [highContrast] strengthens a variant: the solid fill, and the icon of every
/// other variant, move to accent step 12.
class UiIconButton extends StatelessWidget {
  const UiIconButton({
    super.key,
    this.variant = .solid,
    this.size = .size2,
    this.highContrast = false,
    this.style = const IconButtonStyler.create(),
    required this.icon,
    required this.semanticLabel,
    this.iconBuilder,
    this.loadingBuilder,
    this.loading = false,
    this.enabled = true,
    this.enableFeedback = true,
    this.onPressed,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  });

  /// The accent's solid fill under its contrast icon.
  const UiIconButton.solid({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const IconButtonStyler.create(),
    required this.icon,
    required this.semanticLabel,
    this.iconBuilder,
    this.loadingBuilder,
    this.loading = false,
    this.enabled = true,
    this.enableFeedback = true,
    this.onPressed,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = UiIconButtonVariant.solid;

  /// A tinted accent fill under an accent icon.
  const UiIconButton.soft({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const IconButtonStyler.create(),
    required this.icon,
    required this.semanticLabel,
    this.iconBuilder,
    this.loadingBuilder,
    this.loading = false,
    this.enabled = true,
    this.enableFeedback = true,
    this.onPressed,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = UiIconButtonVariant.soft;

  /// A faint accent surface inside a 1px accent frame.
  const UiIconButton.surface({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const IconButtonStyler.create(),
    required this.icon,
    required this.semanticLabel,
    this.iconBuilder,
    this.loadingBuilder,
    this.loading = false,
    this.enabled = true,
    this.enableFeedback = true,
    this.onPressed,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = UiIconButtonVariant.surface;

  /// No fill inside a 1px accent frame.
  const UiIconButton.outline({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const IconButtonStyler.create(),
    required this.icon,
    required this.semanticLabel,
    this.iconBuilder,
    this.loadingBuilder,
    this.loading = false,
    this.enabled = true,
    this.enableFeedback = true,
    this.onPressed,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = UiIconButtonVariant.outline;

  /// An accent icon alone, with a tint under the pointer.
  const UiIconButton.ghost({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const IconButtonStyler.create(),
    required this.icon,
    required this.semanticLabel,
    this.iconBuilder,
    this.loadingBuilder,
    this.loading = false,
    this.enabled = true,
    this.enableFeedback = true,
    this.onPressed,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = UiIconButtonVariant.ghost;

  final UiIconButtonVariant variant;

  final UiIconButtonSize size;

  final bool highContrast;

  final IconButtonStyler style;

  final IconData? icon;

  final String semanticLabel;

  final RemixIconButtonIconBuilder? iconBuilder;

  final RemixIconButtonLoadingBuilder? loadingBuilder;

  final bool loading;

  final bool enabled;

  final bool enableFeedback;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  final FocusNode? focusNode;

  final bool autofocus;

  final String? semanticHint;

  final bool excludeSemantics;

  final MouseCursor mouseCursor;

  @override
  Widget build(BuildContext context) {
    return RemixIconButton(
      key: this.key,
      style: uiIconButtonStyle(
        variant: this.variant,
        size: this.size,
        highContrast: this.highContrast,
        style: this.style,
      ),
      icon: this.icon,
      semanticLabel: this.semanticLabel,
      iconBuilder: this.iconBuilder,
      loadingBuilder: this.loadingBuilder,
      loading: this.loading,
      enabled: this.enabled,
      enableFeedback: this.enableFeedback,
      onPressed: this.onPressed,
      onLongPress: this.onLongPress,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      semanticHint: this.semanticHint,
      excludeSemantics: this.excludeSemantics,
      mouseCursor: this.mouseCursor,
    );
  }
}
