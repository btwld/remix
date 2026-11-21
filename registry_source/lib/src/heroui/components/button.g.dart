// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixButton].
///
/// One chain sets every state. The values come from two tables below:
/// [_metrics] has a row per size and [_palette] a row per variant, because
/// every variant sets the same four colors and nothing else.
///
/// HeroUI's pending state is Remix's `loading`: the button dims like a
/// disabled one, as upstream does, and shows Remix's spinner in place of its
/// content. [fullWidth] is HeroUI's `w-full`. [style] merges last.
class HeroUiButton extends StatelessWidget {
  const HeroUiButton({
    super.key,
    this.variant = .primary,
    this.size = .md,
    this.fullWidth = false,
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

  /// The `accent` fill: the main action.
  const HeroUiButton.primary({
    super.key,
    this.size = .md,
    this.fullWidth = false,
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
  }) : variant = HeroUiButtonVariant.primary;

  /// The neutral `default` fill under accent-tinted text.
  const HeroUiButton.secondary({
    super.key,
    this.size = .md,
    this.fullWidth = false,
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
  }) : variant = HeroUiButtonVariant.secondary;

  /// The neutral `default` fill under the ordinary text color.
  const HeroUiButton.tertiary({
    super.key,
    this.size = .md,
    this.fullWidth = false,
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
  }) : variant = HeroUiButtonVariant.tertiary;

  /// No fill, inside a 1px `border` line.
  const HeroUiButton.outline({
    super.key,
    this.size = .md,
    this.fullWidth = false,
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
  }) : variant = HeroUiButtonVariant.outline;

  /// No fill and no border until the pointer arrives.
  const HeroUiButton.ghost({
    super.key,
    this.size = .md,
    this.fullWidth = false,
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
  }) : variant = HeroUiButtonVariant.ghost;

  /// The `danger` fill, for a destructive action.
  const HeroUiButton.danger({
    super.key,
    this.size = .md,
    this.fullWidth = false,
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
  }) : variant = HeroUiButtonVariant.danger;

  /// A soft `danger` tint, for a destructive action of lower emphasis.
  const HeroUiButton.dangerSoft({
    super.key,
    this.size = .md,
    this.fullWidth = false,
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
  }) : variant = HeroUiButtonVariant.dangerSoft;

  final HeroUiButtonVariant variant;

  final HeroUiButtonSize size;

  final bool fullWidth;

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
  Widget build(BuildContext _) {
    return RemixButton(
      style: heroUiButtonStyle(
        variant: variant,
        size: size,
        fullWidth: fullWidth,
        style: style,
      ),
      label: label,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      textBuilder: textBuilder,
      leadingIconBuilder: leadingIconBuilder,
      trailingIconBuilder: trailingIconBuilder,
      loadingBuilder: loadingBuilder,
      loading: loading,
      enabled: enabled,
      onPressed: onPressed,
      onLongPress: onLongPress,
      focusNode: focusNode,
      autofocus: autofocus,
      enableFeedback: enableFeedback,
      semanticLabel: semanticLabel,
      semanticHint: semanticHint,
      excludeSemantics: excludeSemantics,
      mouseCursor: mouseCursor,
    );
  }
}

/// HeroUI's icon-only button, as a recipe for [RemixIconButton].
///
/// The same variants, sizes and states as [heroUiButtonStyle], from the same
/// two tables. The control is square at the button's height.
class HeroUiIconButton extends StatelessWidget {
  const HeroUiIconButton({
    super.key,
    this.variant = .primary,
    this.size = .md,
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

  /// The `accent` fill: the main action.
  const HeroUiIconButton.primary({
    super.key,
    this.size = .md,
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
  }) : variant = HeroUiButtonVariant.primary;

  /// The neutral `default` fill under accent-tinted text.
  const HeroUiIconButton.secondary({
    super.key,
    this.size = .md,
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
  }) : variant = HeroUiButtonVariant.secondary;

  /// The neutral `default` fill under the ordinary text color.
  const HeroUiIconButton.tertiary({
    super.key,
    this.size = .md,
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
  }) : variant = HeroUiButtonVariant.tertiary;

  /// No fill, inside a 1px `border` line.
  const HeroUiIconButton.outline({
    super.key,
    this.size = .md,
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
  }) : variant = HeroUiButtonVariant.outline;

  /// No fill and no border until the pointer arrives.
  const HeroUiIconButton.ghost({
    super.key,
    this.size = .md,
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
  }) : variant = HeroUiButtonVariant.ghost;

  /// The `danger` fill, for a destructive action.
  const HeroUiIconButton.danger({
    super.key,
    this.size = .md,
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
  }) : variant = HeroUiButtonVariant.danger;

  /// A soft `danger` tint, for a destructive action of lower emphasis.
  const HeroUiIconButton.dangerSoft({
    super.key,
    this.size = .md,
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
  }) : variant = HeroUiButtonVariant.dangerSoft;

  final HeroUiButtonVariant variant;

  final HeroUiButtonSize size;

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
      style: heroUiIconButtonStyle(variant: variant, size: size, style: style),
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
