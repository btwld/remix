// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Avatar recipe.
///
/// Remix owns the fallback chain — image, then label, then icon — and the
/// clipping; this recipe supplies the circle, the neutral surface behind it,
/// and the scale of whatever fallback shows through.
///
/// The surface is `muted`, so an avatar with no image reads as a placeholder
/// rather than as a filled control. An image covers all of it, which is why
/// the fill only ever shows in the fallback case. The recipe sets no
/// alignment: Remix already centers whichever fallback it renders.
///
/// The fallback is `textSm` in `mutedForeground`, or a 16px icon. The shipped
/// light theme sets `mutedForeground` dark enough that initials on the `muted`
/// circle clear the 4.5:1 text floor.
///
/// It is 32px across; a call site that wants a profile header sets `.size(...)`
/// through [style].
///
/// The shape is a full circle rather than the theme's control radius. An
/// avatar stands for a person or an organisation, and that is a circle in
/// every system this application is likely to sit beside; a theme that wants
/// squircles overrides `borderRadius` in one place.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it.
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
      style: playgroundAvatarStyle(style: this.style),
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
