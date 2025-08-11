part of 'avatar.dart';

/// A customizable avatar component that can display an image, icon, or text.
///
/// The [RemixAvatar] widget is designed to present a user's avatar with various customization options.
/// It supports displaying background and foreground images, text labels, or icons.
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
class RemixAvatar extends StatelessWidget {
  /// Creates a Remix avatar.
  const RemixAvatar({
    super.key,
    this.backgroundImage,
    this.foregroundImage,
    this.onBackgroundImageError,
    this.onForegroundImageError,
    this.label,
    this.icon,
    this.style = const AvatarStyle.create(),
  })  : assert(backgroundImage != null || onBackgroundImageError == null),
        assert(foregroundImage != null || onForegroundImageError == null);

  /// The background image to display in the avatar.
  final ImageProvider? backgroundImage;

  /// The foreground image to display in the avatar.
  final ImageProvider? foregroundImage;

  /// Callback function called when the background image fails to load.
  final ImageErrorListener? onBackgroundImageError;

  /// Callback function called when the foreground image fails to load.
  final ImageErrorListener? onForegroundImageError;

  /// The text label to display in the avatar.
  final String? label;

  /// The icon to display in the avatar.
  final IconData? icon;

  /// The style configuration for the avatar.
  final AvatarStyle style;

  Widget? _buildChild(AvatarSpec spec) {
    if (label != null) {
      return Text(
        label!,
        style: TextStyle(
          color: spec.text.style?.color,
          fontSize: spec.text.style?.fontSize,
          fontWeight: spec.text.style?.fontWeight,
        ),
      );
    } else if (icon != null) {
      return Icon(icon, size: spec.icon.size, color: spec.icon.color);
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return StyleBuilder(
      style: DefaultAvatarStyle.merge(style),
      builder: (context, spec) {
        return IconTheme(
          data: IconThemeData(size: spec.icon.size, color: spec.icon.color),
          child: DefaultTextStyle(
            style: TextStyle(
              color: spec.text.style?.color,
              fontSize: spec.text.style?.fontSize,
              fontWeight: spec.text.style?.fontWeight,
            ),
            child: spec.container(
              child: Container(
                alignment: Alignment.center,
                decoration: backgroundImage != null
                    ? BoxDecoration(
                        image: DecorationImage(
                          image: backgroundImage!,
                          onError: onBackgroundImageError,
                          fit: BoxFit.cover,
                        ),
                      )
                    : null,
                foregroundDecoration: foregroundImage != null
                    ? BoxDecoration(
                        image: DecorationImage(
                          image: foregroundImage!,
                          onError: onForegroundImageError,
                          fit: BoxFit.cover,
                        ),
                      )
                    : null,
                child: _buildChild(spec),
              ),
            ),
          ),
        );
      },
    );
  }
}
