// ABOUTME: Factory for creating RemixCalloutStyle instances using Radix tokens
// ABOUTME: Follows button pattern: base + size + variant composition

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../radix/radix.dart';
import 'callout.dart';

enum RadixCalloutSize {
  size1,
  size2,
  size3,
}

enum RadixCalloutVariant {
  classic,
  surface,
  soft,
}

/// Factory class for creating Radix-compliant callout styles.
///
/// Provides base + variant + size composition like the button pattern.
/// Uses component tokens from radix_components.generated.json where available.
class RadixCalloutStyles {
  const RadixCalloutStyles._();

  /// Factory constructor with variant and size parameters.
  static RemixCalloutStyle create({
    RadixCalloutVariant variant = RadixCalloutVariant.surface,
    RadixCalloutSize size = RadixCalloutSize.size2,
  }) {
    return switch (variant) {
      RadixCalloutVariant.classic => classic(size: size),
      RadixCalloutVariant.surface => surface(size: size),
      RadixCalloutVariant.soft => soft(size: size),
    };
  }

  static RemixCalloutStyle base({
    RadixCalloutSize size = RadixCalloutSize.size2,
  }) {
    return RemixCalloutStyle()
        // Horizontal layout with spacing between icon and text
        .merge(
          RemixCalloutStyle(
            container: FlexBoxStyler(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
        )
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  /// Neutral/gray variant (surface background with gray border + gray text)
  static RemixCalloutStyle classic({
    RadixCalloutSize size = RadixCalloutSize.size2,
  }) {
    return base(size: size)
        .color(RadixTokens.colorSurface())
        .borderAll(
          color: RadixTokens.gray7(),
          width: RadixTokens.borderWidth1(),
        )
        .borderRadiusAll(RadixTokens.radius3())
        .textColor(RadixTokens.gray12())
        .iconColor(RadixTokens.gray12());
  }

  /// Accent-tinted surface variant (accentSurface background + accent border/text)
  static RemixCalloutStyle surface({
    RadixCalloutSize size = RadixCalloutSize.size2,
  }) {
    return base(size: size)
        .color(RadixTokens.accentSurface())
        .borderAll(
          color: RadixTokens.accent6(),
          width: RadixTokens.borderWidth1(),
        )
        .borderRadiusAll(RadixTokens.radius3())
        .textColor(RadixTokens.accent11())
        .iconColor(RadixTokens.accent11());
  }

  /// Soft tinted variant (accent3 background + accent6 border + accent11 text)
  static RemixCalloutStyle soft({
    RadixCalloutSize size = RadixCalloutSize.size2,
  }) {
    return base(size: size)
        .color(RadixTokens.accent3())
        .borderAll(
          color: RadixTokens.accent6(),
          width: RadixTokens.borderWidth1(),
        )
        .borderRadiusAll(RadixTokens.radius3())
        .textColor(RadixTokens.accent11())
        .iconColor(RadixTokens.accent11());
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixCalloutStyle _sizeStyle(RadixCalloutSize size) {
    // NOTE: JSON token "callout-icon-height: var(--line-height-3)" implies
    // icon sized to match text line-height. We approximate sizes below.
    return switch (size) {
      RadixCalloutSize.size1 => RemixCalloutStyle(
          container: FlexBoxStyler(
            padding: EdgeInsetsGeometryMix.symmetric(
              vertical: 8.0,
              horizontal: 12.0,
            ),
            spacing: RadixTokens.space2(), // 8px between icon and text
          ),
          text: TextStyler(style: RadixTokens.text1.mix()),
          icon: IconStyler(
            size: 16.0,
          ), // TODO: align to exact line-height token if exposed
        ),
      RadixCalloutSize.size2 => RemixCalloutStyle(
          container: FlexBoxStyler(
            padding: EdgeInsetsGeometryMix.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            spacing: RadixTokens.space2(),
          ),
          text: TextStyler(style: RadixTokens.text2.mix()),
          icon: IconStyler(size: 20.0), // --line-height-3 approximated as 20px
        ),
      RadixCalloutSize.size3 => RemixCalloutStyle(
          container: FlexBoxStyler(
            padding: EdgeInsetsGeometryMix.symmetric(
              vertical: 16.0,
              horizontal: 20.0,
            ),
            spacing: RadixTokens.space3(),
          ),
          text: TextStyler(style: RadixTokens.text3.mix()),
          icon: IconStyler(size: 24.0), // TODO: confirm with token mapping
        ),
    };
  }
}
