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
typedef RemixAvatarLabelBuilder = Widget Function(
  BuildContext context,
  TextSpec spec,
  String label,
);

typedef RemixAvatarIconBuilder = Widget Function(
  BuildContext context,
  IconSpec spec,
  IconData? icon,
);

class RemixAvatar extends StatelessWidget {
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
    this.style = const RemixAvatarStyle.create(),
  });

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
  Widget build(BuildContext context) {
    return StyleBuilder<AvatarSpec>(
      style: style,
      builder: (context, spec) {
        final containerBuilder = spec.container.createWidget;

        Widget? content = child;
        final resolvedLabel = label ?? '';

        if (content == null) {
          if (labelBuilder != null || label != null) {
            content = StyleSpecBuilder<TextSpec>(
              styleSpec: spec.text,
              builder: (context, textSpec) {
                if (labelBuilder != null) {
                  return labelBuilder!(context, textSpec, resolvedLabel);
                }

                return textSpec.createWidget(resolvedLabel);
              },
            );
          } else if (iconBuilder != null || icon != null) {
            content = StyleSpecBuilder<IconSpec>(
              styleSpec: spec.icon,
              builder: (context, iconSpec) {
                if (iconBuilder != null) {
                  return iconBuilder!(context, iconSpec, icon);
                }

                return iconSpec.createWidget(icon: icon);
              },
            );
          }
        }

        return containerBuilder(
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
            child: content,
          ),
        );
      },
    );
  }
}
