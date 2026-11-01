// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'close_button.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixIconButton]: the 24px `CloseButton`.
///
/// The cross is the project icon library's; HeroUI draws its own. Pass [icon]
/// to replace it. [semanticLabel] defaults to "Close".
class HeroUiCloseButton extends StatelessWidget {
  const HeroUiCloseButton({
    super.key,
    this.icon = RemixIcons.cross2,
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
  Widget build(BuildContext context) {
    return RemixIconButton(
      key: this.key,
      style: heroUiCloseButtonStyle(
        icon: this.icon,
        semanticLabel: this.semanticLabel,
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
