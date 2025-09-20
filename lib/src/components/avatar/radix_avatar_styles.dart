part of 'avatar.dart';

enum FortalAvatarSize {
  size1,
  size2,
  size3,
  size4,
}

enum FortalAvatarVariant {
  surface, // neutral surface background
  soft, // accent tinted background
  solid, // strong accent background
}

/// Fortal-compliant avatar styles.
///
/// Note: radix_components.generated.json exposes avatar-size and fallback
/// font sizes; we apply sizes and typical backgrounds using core tokens.
class FortalAvatarStyles {
  const FortalAvatarStyles._();

  static RemixAvatarStyle create({
    FortalAvatarVariant variant = FortalAvatarVariant.surface,
    FortalAvatarSize size = FortalAvatarSize.size2,
  }) {
    return switch (variant) {
      FortalAvatarVariant.surface => surface(size: size),
      FortalAvatarVariant.soft => soft(size: size),
      FortalAvatarVariant.solid => solid(size: size),
    };
  }

  static RemixAvatarStyle base({
    FortalAvatarSize size = FortalAvatarSize.size2,
  }) {
    return RemixAvatarStyle()
        .borderRadiusAll(FortalTokens.radiusFull())
        .merge(_sizeStyle(size));
  }

  /// Neutral background + neutral text/icon
  static RemixAvatarStyle surface({
    FortalAvatarSize size = FortalAvatarSize.size2,
  }) {
    return base(size: size)
        .color(FortalTokens.colorSurface())
        .labelTextStyle(FortalTokens.text2.mix())
        .labelColor(FortalTokens.gray12())
        .iconColor(FortalTokens.gray12());
  }

  /// Accent tinted background + accent11 text/icon
  static RemixAvatarStyle soft({
    FortalAvatarSize size = FortalAvatarSize.size2,
  }) {
    return base(size: size)
        .color(FortalTokens.accent3())
        .labelTextStyle(FortalTokens.text2.mix())
        .labelColor(FortalTokens.accent11())
        .iconColor(FortalTokens.accent11());
  }

  /// Strong accent background + contrast text/icon
  static RemixAvatarStyle solid({
    FortalAvatarSize size = FortalAvatarSize.size2,
  }) {
    return base(size: size)
        .color(FortalTokens.accent9())
        .labelTextStyle(FortalTokens.text2.mix())
        .labelColor(FortalTokens.accentContrast())
        .iconColor(FortalTokens.accentContrast());
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------
  static RemixAvatarStyle _sizeStyle(FortalAvatarSize size) {
    // NOTE: JSON has "avatar-size: 160px" as a token; we provide practical UI
    // sizes for typical use, and keep radius as full circle.
    // TODO: Expose tokenized avatar-size tiers when available.
    return switch (size) {
      FortalAvatarSize.size1 => RemixAvatarStyle()
          .square(24.0)
          .labelTextStyle(FortalTokens.text1.mix()),
      FortalAvatarSize.size2 => RemixAvatarStyle()
          .square(32.0)
          .labelTextStyle(FortalTokens.text2.mix()),
      FortalAvatarSize.size3 => RemixAvatarStyle()
          .square(40.0)
          .labelTextStyle(FortalTokens.text3.mix()),
      FortalAvatarSize.size4 => RemixAvatarStyle()
          .square(64.0)
          .labelTextStyle(FortalTokens.text4.mix()),
    };
  }
}
