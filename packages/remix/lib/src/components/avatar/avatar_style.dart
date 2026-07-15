part of 'avatar.dart';

/// Style configuration for [RemixAvatar] container, label, and fallback icon.
extension RemixAvatarStylerRemixHelpers on RemixAvatarStyler {
  /// Sets the foreground color (text and icon) of the avatar.
  RemixAvatarStyler foregroundColor(Color value) {
    return labelColor(value).iconColor(value);
  }

  /// Sets the background color of the avatar.
  RemixAvatarStyler backgroundColor(Color value) {
    return color(value);
  }

  /// Sets avatar size to a square
  RemixAvatarStyler square(double size) {
    return this.size(size, size);
  }

  /// Sets avatar size with width and height (alias)
  RemixAvatarStyler sizeWH(double width, double height) {
    return merge(
      RemixAvatarStyler(
        container: BoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: width,
            maxWidth: width,
            minHeight: height,
            maxHeight: height,
          ),
        ),
      ),
    );
  }

  /// Creates a [RemixAvatar] widget with this style applied.
  RemixAvatar call({
    Key? key,
    ImageProvider? backgroundImage,
    ImageProvider? foregroundImage,
    ImageErrorListener? onBackgroundImageError,
    ImageErrorListener? onForegroundImageError,
    Widget? child,
    String? label,
    RemixAvatarLabelBuilder? labelBuilder,
    IconData? icon,
    RemixAvatarIconBuilder? iconBuilder,
  }) {
    return RemixAvatar(
      key: key,
      backgroundImage: backgroundImage,
      foregroundImage: foregroundImage,
      onBackgroundImageError: onBackgroundImageError,
      onForegroundImageError: onForegroundImageError,
      label: label,
      labelBuilder: labelBuilder,
      icon: icon,
      iconBuilder: iconBuilder,
      style: this,
      child: child,
    );
  }
}
