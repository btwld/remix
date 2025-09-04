part of 'avatar.dart';

/// A customizable avatar component that can display an image or a label.
///
/// The [RemixAvatar] widget is designed to present a user's avatar with various customization options.
/// It supports displaying background and foreground images, a text label, and provides builders for loading and error states.
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
  ///
  /// The [label] parameter is optional. If provided, it will be displayed as text content.
  /// Other parameters allow customizing the avatar's appearance including background and foreground images.
  factory RemixAvatar({
    Key? key,
    ImageProvider? backgroundImage,
    ImageProvider? foregroundImage,
    ImageErrorListener? onBackgroundImageError,
    ImageErrorListener? onForegroundImageError,
    RemixAvatarStyle style = const RemixAvatarStyle.create(),
    String? label,
  }) {
    return RemixAvatar.raw(
      key: key,
      backgroundImage: backgroundImage,
      foregroundImage: foregroundImage,
      onBackgroundImageError: onBackgroundImageError,
      onForegroundImageError: onForegroundImageError,
      style: style,
      child: label != null ? _AvatarText(label: label) : null,
    );
  }

  /// Creates a Remix avatar with custom content.
  ///
  /// This constructor allows for custom avatar content beyond the default layout.
  /// The [child] parameter is optional and will be used as the avatar's content.
  ///
  /// Example:
  /// ```dart
  /// RemixAvatar.raw(
  ///   backgroundImage: NetworkImage('https://example.com/avatar.png'),
  ///   foregroundImage: NetworkImage('https://example.com/badge.png'),
  ///   child: Icon(Icons.person),
  ///   style: RemixAvatarStyle.create(),
  /// )
  /// ```
  const RemixAvatar.raw({
    super.key,
    this.backgroundImage,
    this.foregroundImage,
    this.onBackgroundImageError,
    this.onForegroundImageError,
    this.child,
    this.style = const RemixAvatarStyle.create(),
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

  /// The style configuration for the avatar.
  final RemixAvatarStyle style;

  /// The child widget to display inside the avatar.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return StyleBuilder(
      style: RemixAvatarStyles.defaultStyle.merge(style),
      builder: (context, spec) {
        final ContainerWidget = spec.container.createWidget;

        return ContainerWidget(
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
            child: child,
          ),
        );
      },
    );
  }
}

class _AvatarText extends StatelessWidget {
  const _AvatarText({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return StyleBuilder(
      style: const RemixAvatarStyle.create(),
      builder: (context, spec) {
        final TextWidget = spec.text.createWidget;

        return TextWidget(label);
      },
    );
  }
}
