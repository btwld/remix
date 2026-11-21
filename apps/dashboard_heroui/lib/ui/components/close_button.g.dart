// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'close_button.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixIconButton]: the 24px `CloseButton`.
///
/// The cross is the project icon library's; HeroUI draws its own. Pass [icon]
/// to replace it. [semanticLabel] defaults to "Close".
class UiCloseButton extends StatelessWidget {
  const UiCloseButton({
    super.key,
    this.icon = RemixIcons.close,
    this.semanticLabel = 'Close',
    this.style = const IconButtonStyler.create(),
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

  final IconData? icon;

  final String semanticLabel;

  final IconButtonStyler style;

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
      style: uiCloseButtonStyle(
        icon: icon,
        semanticLabel: semanticLabel,
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
