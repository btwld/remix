// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Avatar recipe.
///
/// A 32px circle on `muted`, so an avatar without an image reads as a
/// placeholder. Remix picks the fallback (image, then label, then icon) and
/// centers it; the label is `textSm` in `mutedForeground` and the icon is 16px.
/// Set a larger size through [style].
class VanillaAvatar extends StatelessWidget {
  const VanillaAvatar({
    super.key,
    this.style = const AvatarStyler.create(),
    this.backgroundImage,
    this.foregroundImage,
    this.onBackgroundImageError,
    this.onForegroundImageError,
    this.child,
    this.label,
    this.labelBuilder,
    this.icon,
    this.iconBuilder,
  });

  final AvatarStyler style;

  final ImageProvider<Object>? backgroundImage;

  final ImageProvider<Object>? foregroundImage;

  final ImageErrorListener? onBackgroundImageError;

  final ImageErrorListener? onForegroundImageError;

  final Widget? child;

  final String? label;

  final RemixAvatarLabelBuilder? labelBuilder;

  final IconData? icon;

  final RemixAvatarIconBuilder? iconBuilder;

  @override
  Widget build(BuildContext context) {
    return RemixAvatar(
      key: this.key,
      style: vanillaAvatarStyle(style: this.style),
      backgroundImage: this.backgroundImage,
      foregroundImage: this.foregroundImage,
      onBackgroundImageError: this.onBackgroundImageError,
      onForegroundImageError: this.onForegroundImageError,
      child: this.child,
      label: this.label,
      labelBuilder: this.labelBuilder,
      icon: this.icon,
      iconBuilder: this.iconBuilder,
    );
  }
}
