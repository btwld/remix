// ABOUTME: Factory for creating RemixAvatarStyle instances using Radix tokens
// ABOUTME: Provides size + variant composition following the button pattern

import 'package:mix/mix.dart';

import '../../radix/radix.dart';
import 'avatar.dart';

enum RadixAvatarSize {
  size1,
  size2,
  size3,
  size4,
}

enum RadixAvatarVariant {
  surface, // neutral surface background
  soft, // accent tinted background
  solid, // strong accent background
}

/// Radix-compliant avatar styles.
///
/// Note: radix_components.generated.json exposes avatar-size and fallback
/// font sizes; we apply sizes and typical backgrounds using core tokens.
class RadixAvatarStyles {
  const RadixAvatarStyles._();

  static RemixAvatarStyle create({
    RadixAvatarVariant variant = RadixAvatarVariant.surface,
    RadixAvatarSize size = RadixAvatarSize.size2,
  }) {
    return switch (variant) {
      RadixAvatarVariant.surface => surface(size: size),
      RadixAvatarVariant.soft => soft(size: size),
      RadixAvatarVariant.solid => solid(size: size),
    };
  }

  static RemixAvatarStyle base({RadixAvatarSize size = RadixAvatarSize.size2}) {
    return RemixAvatarStyle()
        .borderRadiusAll(RadixTokens.radiusFull())
        .merge(_sizeStyle(size));
  }

  /// Neutral background + neutral text/icon
  static RemixAvatarStyle surface({RadixAvatarSize size = RadixAvatarSize.size2}) {
    return base(size: size)
        .color(RadixTokens.colorSurface())
        .merge(
          RemixAvatarStyle(
            text: TextStyler(style: RadixTokens.text2.mix()).color(RadixTokens.gray12()),
          ),
        )
        .iconColor(RadixTokens.gray12());
  }

  /// Accent tinted background + accent11 text/icon
  static RemixAvatarStyle soft({RadixAvatarSize size = RadixAvatarSize.size2}) {
    return base(size: size)
        .color(RadixTokens.accent3())
        .merge(
          RemixAvatarStyle(
            text: TextStyler(style: RadixTokens.text2.mix()).color(RadixTokens.accent11()),
          ),
        )
        .iconColor(RadixTokens.accent11());
  }

  /// Strong accent background + contrast text/icon
  static RemixAvatarStyle solid({RadixAvatarSize size = RadixAvatarSize.size2}) {
    return base(size: size)
        .color(RadixTokens.accent9())
        .merge(
          RemixAvatarStyle(
            text: TextStyler(style: RadixTokens.text2.mix()).color(RadixTokens.accentContrast()),
          ),
        )
        .iconColor(RadixTokens.accentContrast());
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------
  static RemixAvatarStyle _sizeStyle(RadixAvatarSize size) {
    // NOTE: JSON has "avatar-size: 160px" as a token; we provide practical UI
    // sizes for typical use, and keep radius as full circle.
    // TODO: Expose tokenized avatar-size tiers when available.
    return switch (size) {
      RadixAvatarSize.size1 => RemixAvatarStyle()
          .square(24.0)
          .merge(RemixAvatarStyle(text: TextStyler(style: RadixTokens.text1.mix()))),
      RadixAvatarSize.size2 => RemixAvatarStyle()
          .square(32.0)
          .merge(RemixAvatarStyle(text: TextStyler(style: RadixTokens.text2.mix()))),
      RadixAvatarSize.size3 => RemixAvatarStyle()
          .square(40.0)
          .merge(RemixAvatarStyle(text: TextStyler(style: RadixTokens.text3.mix()))),
      RadixAvatarSize.size4 => RemixAvatarStyle()
          .square(64.0)
          .merge(RemixAvatarStyle(text: TextStyler(style: RadixTokens.text4.mix()))),
    };
  }
}
