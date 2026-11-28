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
class PlaygroundAvatar extends StatelessWidget {
  const PlaygroundAvatar({
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
    this.badge,
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

  final Widget? badge;

  @override
  Widget build(BuildContext _) {
    return RemixAvatar(
      style: playgroundAvatarStyle(style: style),
      backgroundImage: backgroundImage,
      foregroundImage: foregroundImage,
      onBackgroundImageError: onBackgroundImageError,
      onForegroundImageError: onForegroundImageError,
      label: label,
      labelBuilder: labelBuilder,
      icon: icon,
      iconBuilder: iconBuilder,
      badge: badge,
      child: child,
    );
  }
}
