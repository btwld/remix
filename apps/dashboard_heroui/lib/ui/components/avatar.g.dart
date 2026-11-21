// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixAvatar].
///
/// The label is HeroUI's `Avatar.Fallback`; images are Remix's
/// `foregroundImage`, which falls back to the label when it fails to load.
class UiAvatar extends StatelessWidget {
  const UiAvatar({
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
  });

  /// The neutral `default` fill.
  const UiAvatar.defaultAvatar({
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
  }) : variant = UiAvatarVariant.defaultAvatar;

  /// A tinted fill in the avatar's color.
  const UiAvatar.soft({
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
  }) : variant = UiAvatarVariant.soft;

  final UiAvatarVariant variant;

  final UiColor color;

  final UiAvatarSize size;

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
  Widget build(BuildContext _) {
    return RemixAvatar(
      style: uiAvatarStyle(
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
      child: child,
    );
  }
}
