// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Avatar recipe.
///
/// It reads top to bottom: the size and fallback text, then the variant's
/// colors. The corners turn into a circle when the theme radius is `full`.
///
/// [highContrast] moves the solid fill, and the text of the soft variant, to
/// accent step 12.
///
/// [fallbackLength] selects the pinned one- or two-character fallback
/// typography. Pass `2` when [RemixAvatar.label] contains two initials.
class UiAvatar extends StatelessWidget {
  const UiAvatar({
    super.key,
    this.variant = .soft,
    this.size = .size3,
    this.highContrast = false,
    this.fallbackLength = 1,
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

  /// A tinted accent fill under accent text.
  const UiAvatar.soft({
    super.key,
    this.size = .size3,
    this.highContrast = false,
    this.fallbackLength = 1,
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
  }) : variant = UiAvatarVariant.soft;

  /// The accent's solid fill under its contrast text.
  const UiAvatar.solid({
    super.key,
    this.size = .size3,
    this.highContrast = false,
    this.fallbackLength = 1,
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
  }) : variant = UiAvatarVariant.solid;

  final UiAvatarVariant variant;

  final UiAvatarSize size;

  final bool highContrast;

  final int fallbackLength;

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
      style: uiAvatarStyle(
        variant: variant,
        size: size,
        highContrast: highContrast,
        fallbackLength: fallbackLength,
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
