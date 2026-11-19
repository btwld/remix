// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Deui recipe for [RemixAvatar].
///
/// The label is Deui's `Avatar.Fallback`; images are Remix's
/// `foregroundImage`, which falls back to the label when it fails to load.
class DeuiAvatar extends StatelessWidget {
  const DeuiAvatar({
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
  const DeuiAvatar.defaultAvatar({
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
  }) : variant = DeuiAvatarVariant.defaultAvatar;

  /// A tinted fill in the avatar's color.
  const DeuiAvatar.soft({
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
  }) : variant = DeuiAvatarVariant.soft;

  final DeuiAvatarVariant variant;

  final DeuiColor color;

  final DeuiAvatarSize size;

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
      style: deuiAvatarStyle(
        variant: this.variant,
        color: this.color,
        size: this.size,
        style: this.style,
      ),
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
