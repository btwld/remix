// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'icon_button.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal IconButton recipe.
///
/// It reads top to bottom: what every icon button shares, then the size, then
/// the variant's look in each state, then focus and disabled. [style] merges
/// last, so a call site can override any part of it.
///
/// The variants restate the labelled button's looks rather than sharing them,
/// so each recipe can be read and edited on its own. Change one and change the
/// other to keep the two a family.
///
/// [highContrast] strengthens a variant: the solid fill moves to accent step
/// 12, borders to the strong border, and the ghost icon to ink.
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

  /// An ink fill under a page-colored icon.
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

  /// A muted neutral fill under an ink icon.
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

  /// A surface fill inside a 1px border.
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

  /// No fill inside a 1px border.
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

  /// A secondary icon alone, with a muted fill under the pointer.
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
  Widget build(BuildContext _) {
    return RemixIconButton(
      style: uiIconButtonStyle(
        variant: variant,
        size: size,
        highContrast: highContrast,
        style: style,
      ),
      icon: icon,
      semanticLabel: semanticLabel,
      iconBuilder: iconBuilder,
      loadingBuilder: loadingBuilder,
      loading: loading,
      enabled: enabled,
      enableFeedback: enableFeedback,
      onPressed: onPressed,
      onLongPress: onLongPress,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticHint: semanticHint,
      excludeSemantics: excludeSemantics,
      mouseCursor: mouseCursor,
    );
  }
}
