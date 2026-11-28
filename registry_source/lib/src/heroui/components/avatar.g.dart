// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixAvatar].
///
/// The label is HeroUI's `Avatar.Fallback`; images are Remix's
/// `foregroundImage`, which falls back to the label when it fails to load.
class HeroUiAvatar extends StatelessWidget {
  const HeroUiAvatar({
    super.key,
    this.variant = .defaultAvatar,
    this.color = .defaultColor,
    this.size = .md,
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

  /// The neutral `default` fill.
  const HeroUiAvatar.defaultAvatar({
    super.key,
    this.color = .defaultColor,
    this.size = .md,
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
  }) : variant = HeroUiAvatarVariant.defaultAvatar;

  /// A tinted fill in the avatar's color.
  const HeroUiAvatar.soft({
    super.key,
    this.color = .defaultColor,
    this.size = .md,
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
  }) : variant = HeroUiAvatarVariant.soft;

  final HeroUiAvatarVariant variant;

  final HeroUiColor color;

  final HeroUiAvatarSize size;

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
      style: heroUiAvatarStyle(
        variant: variant,
        color: color,
        size: size,
        style: style,
      ),
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
