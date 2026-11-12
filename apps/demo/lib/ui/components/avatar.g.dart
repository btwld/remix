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
class FortalAvatar extends StatelessWidget {
  const FortalAvatar({
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
  });

  /// A tinted accent fill under accent text.
  const FortalAvatar.soft({
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
  }) : variant = FortalAvatarVariant.soft;

  /// The accent's solid fill under its contrast text.
  const FortalAvatar.solid({
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
  }) : variant = FortalAvatarVariant.solid;

  final FortalAvatarVariant variant;

  final FortalAvatarSize size;

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

  @override
  Widget build(BuildContext context) {
    return RemixAvatar(
      key: this.key,
      style: fortalAvatarStyle(
        variant: this.variant,
        size: this.size,
        highContrast: this.highContrast,
        fallbackLength: this.fallbackLength,
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
