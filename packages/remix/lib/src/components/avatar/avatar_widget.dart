part of 'avatar.dart';

/// Builder for rendering avatar label content with the resolved text spec.
typedef RemixAvatarLabelBuilder =
    Widget Function(BuildContext context, TextSpec spec, String label);

/// Builder for rendering avatar icon content with the resolved icon spec.
typedef RemixAvatarIconBuilder =
    Widget Function(BuildContext context, IconSpec spec, IconData? icon);

/// A customizable avatar component that can display an image, label, icon, or
/// custom child.
///
/// The [RemixAvatar] widget presents user or entity identity with optional
/// background and foreground images. Text and icon content can use builders to
/// preserve resolved Remix typography or icon styling.
///
/// ## Example
///
/// ```dart
/// RemixAvatar(
///   backgroundImage: NetworkImage('https://example.com/avatar.png'),
///   foregroundImage: NetworkImage('https://example.com/badge.png'),
///   label: 'User',
/// )
/// ```
class RemixAvatar extends StyleWidget<RemixAvatarSpec> {
  /// Creates a Remix avatar with optional text [label], custom [child], and
  /// background/foreground imagery. When textual content is supplied, it is
  /// styled using the avatar text spec so typography stays consistent.
  const RemixAvatar({
    super.key,
    this.backgroundImage,
    this.foregroundImage,
    this.onBackgroundImageError,
    this.onForegroundImageError,
    this.child,
    this.label,
    this.labelBuilder,
    this.icon,
    this.iconBuilder,
    super.style = const RemixAvatarStyle.create(),
    super.styleSpec,
  });

  static final styleFrom = RemixAvatarStyle.new;

  /// The background image to display in the avatar.
  final ImageProvider? backgroundImage;

  /// The foreground image to display in the avatar.
  final ImageProvider? foregroundImage;

  /// Callback function called when the background image fails to load.
  final ImageErrorListener? onBackgroundImageError;

  /// Callback function called when the foreground image fails to load.
  final ImageErrorListener? onForegroundImageError;

  /// Custom content to display inside the avatar. When provided the caller is
  /// responsible for applying typography.
  final Widget? child;

  /// Optional text rendered within the avatar using the text spec.
  final String? label;

  /// Optional builder that exposes the resolved [TextSpec] for custom label
  /// rendering while keeping the configured typography.
  final RemixAvatarLabelBuilder? labelBuilder;

  /// Optional icon rendered when no [child] or [label] is provided.
  final IconData? icon;

  /// Optional builder that exposes the resolved [IconSpec] for custom icon
  /// rendering while preserving configured icon styling.
  final RemixAvatarIconBuilder? iconBuilder;

  @override
  Widget build(BuildContext context, RemixAvatarSpec spec) {
    Widget? content = child;
    final resolvedLabel = label ?? '';

    if (content == null) {
      if (labelBuilder != null || label != null) {
        content = labelBuilder == null
            ? StyledText(resolvedLabel, styleSpec: spec.label)
            : StyleSpecBuilder<TextSpec>(
                styleSpec: spec.label,
                builder: (context, textSpec) =>
                    labelBuilder!(context, textSpec, resolvedLabel),
              );
      } else if (iconBuilder != null || icon != null) {
        content = iconBuilder == null
            ? StyledIcon(icon: icon, styleSpec: spec.icon)
            : StyleSpecBuilder<IconSpec>(
                styleSpec: spec.icon,
                builder: (context, iconSpec) =>
                    iconBuilder!(context, iconSpec, icon),
              );
      }
    }

    return Box(
      styleSpec: spec.container,
      child: Container(
        alignment: .center,
        decoration: backgroundImage != null
            ? BoxDecoration(
                image: DecorationImage(
                  image: backgroundImage!,
                  onError: onBackgroundImageError,
                  fit: .cover,
                ),
              )
            : null,
        foregroundDecoration: foregroundImage != null
            ? BoxDecoration(
                image: DecorationImage(
                  image: foregroundImage!,
                  onError: onForegroundImageError,
                  fit: .cover,
                ),
              )
            : null,
        child: content,
      ),
    );
  }
}
