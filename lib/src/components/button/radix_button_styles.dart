// ABOUTME: Factory constructors for RemixButtonStyle variants using Radix design tokens
// ABOUTME: Provides RadixButtonStyle subclass with variant + size aware composition

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../radix/radix.dart';
import '../spinner/spinner.dart';
import 'button.dart';

enum RadixButtonSize {
  size1,
  size2,
  size3,
  size4,
}

enum RadixButtonVariant {
  solid,
  soft,
  surface,
  outline,
  ghost,
}

/// RadixButtonStyle utility class for creating Radix-themed button styles.
///
/// Provides factory constructor with variant and size parameters plus named
/// static methods for direct access. Composes the correct base metrics,
/// variant visuals, and size-specific styles sourced from the Radix token JSON.
class RadixButtonStyle {
  const RadixButtonStyle._();

  /// Factory constructor for RadixButtonStyle with variant and size parameters.
  ///
  /// Returns a RemixButtonStyle configured with Radix design tokens.
  /// Defaults to solid variant with size2.
  static RemixButtonStyle create({
    RadixButtonVariant variant = RadixButtonVariant.solid,
    RadixButtonSize size = RadixButtonSize.size2,
  }) {
    return switch (variant) {
      RadixButtonVariant.solid => solid(size: size),
      RadixButtonVariant.soft => soft(size: size),
      RadixButtonVariant.surface => surface(size: size),
      RadixButtonVariant.outline => outline(size: size),
      RadixButtonVariant.ghost => ghost(size: size),
    };
  }

  static RemixButtonStyle base({
    RadixButtonSize size = RadixButtonSize.size2,
  }) {
    return RemixButtonStyle()
        // Generic font weight (not size-specific)
        .label(TextStyler().fontWeight(RadixTokens.fontWeightMedium()))
        // Generic spinner properties (size set by _sizeStyle)
        .spinner(
          RemixSpinnerStyle(
            strokeWidth: RadixTokens.borderWidth2(),
            duration: const Duration(milliseconds: 800),
            type: SpinnerType.solid,
          ),
        )
        // Focus ring (generic)
        .onFocused(
          RemixButtonStyle().borderAll(
            color: RadixTokens.focusA8(),
            width: RadixTokens.focusRingWidth(),
          ),
        )
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  static RemixButtonStyle solid({
    RadixButtonSize size = RadixButtonSize.size2,
  }) {
    return base(size: size)
        .color(RadixTokens.accent9())
        .label(TextStyler().color(RadixTokens.accentContrast()))
        .iconColor(RadixTokens.accentContrast())
        .spinner(RemixSpinnerStyle(color: RadixTokens.accentContrast()))
        .onHovered(RemixButtonStyle().color(RadixTokens.accent10()))
        .onPressed(
          RemixButtonStyle().color(RadixTokens
              .accent10()), // NOTE: base-button-solid-active-filter: brightness(1.08) from JSON
          // Flutter doesn't support CSS filters directly, would need ColorFiltered widget,
        )
        .onDisabled(
          RemixButtonStyle()
              .color(RadixTokens.accent9())
              .label(TextStyler().color(RadixTokens.accentContrast()))
              .icon(IconStyler(color: RadixTokens.accentContrast()))
              .spinner(
                RemixSpinnerStyle(color: RadixTokens.accentContrast()),
              ),
        );
    // TODO: Add high-contrast mode support in the future
    // base-button-solid-high-contrast-hover-filter: contrast(0.88) saturate(1.3) brightness(1.18)
    // base-button-solid-high-contrast-active-filter: brightness(0.95) saturate(1.2)
  }

  static RemixButtonStyle soft({
    RadixButtonSize size = RadixButtonSize.size2,
  }) {
    return base(size: size)
        .color(RadixTokens.accent3())
        .borderAll(
          color: RadixTokens.accent6(),
          width: RadixTokens.borderWidth1(),
        )
        .label(TextStyler().color(RadixTokens.accent11()))
        .iconColor(RadixTokens.accent11())
        .spinner(RemixSpinnerStyle(color: RadixTokens.accent11()))
        .onHovered(
          RemixButtonStyle().color(RadixTokens.accent4()).borderAll(
                color: RadixTokens.accent7(),
                width: RadixTokens.borderWidth1(),
              ),
        )
        .onPressed(RemixButtonStyle().color(RadixTokens.accent5()))
        .onDisabled(
          RemixButtonStyle()
              .color(RadixTokens.accent3())
              .borderAll(
                color: RadixTokens.accent6(),
                width: RadixTokens.borderWidth1(),
              )
              .label(TextStyler().color(RadixTokens.accent11()))
              .icon(IconStyler(color: RadixTokens.accent11()))
              .spinner(RemixSpinnerStyle(color: RadixTokens.accent11())),
        );
  }

  static RemixButtonStyle surface({
    RadixButtonSize size = RadixButtonSize.size2,
  }) {
    return base(size: size)
        .color(RadixTokens.accentSurface())
        .borderAll(
          color: RadixTokens.accent6(),
          width: RadixTokens.borderWidth1(),
        )
        .label(TextStyler().color(RadixTokens.accent11()))
        .iconColor(RadixTokens.accent11())
        .spinner(RemixSpinnerStyle(color: RadixTokens.accent11()))
        .onHovered(
          RemixButtonStyle().color(RadixTokens.accentA4()).borderAll(
                color: RadixTokens.accent7(),
                width: RadixTokens.borderWidth1(),
              ),
        )
        .onDisabled(
          RemixButtonStyle()
              .color(RadixTokens.accentSurface())
              .borderAll(
                color: RadixTokens.accent6(),
                width: RadixTokens.borderWidth1(),
              )
              .label(TextStyler().color(RadixTokens.accent11()))
              .icon(IconStyler(color: RadixTokens.accent11()))
              .spinner(RemixSpinnerStyle(color: RadixTokens.accent11())),
        );
  }

  static RemixButtonStyle outline({
    RadixButtonSize size = RadixButtonSize.size2,
  }) {
    return base(size: size)
        .color(Colors.transparent)
        .borderAll(
          color: RadixTokens.accent7(),
          width: RadixTokens.borderWidth1(),
        )
        .label(TextStyler().color(RadixTokens.accent11()))
        .iconColor(RadixTokens.accent11())
        .spinner(RemixSpinnerStyle(color: RadixTokens.accent11()))
        .onHovered(
          RemixButtonStyle().color(RadixTokens.accentA3()).borderAll(
                color: RadixTokens.accent8(),
                width: RadixTokens.borderWidth1(),
              ),
        )
        .onDisabled(
          RemixButtonStyle()
              .borderAll(
                color: RadixTokens.accent7(),
                width: RadixTokens.borderWidth1(),
              )
              .label(TextStyler().color(RadixTokens.accent11()))
              .icon(IconStyler(color: RadixTokens.accent11()))
              .spinner(RemixSpinnerStyle(color: RadixTokens.accent11())),
        );
  }

  static RemixButtonStyle ghost({
    RadixButtonSize size = RadixButtonSize.size2,
  }) {
    var style = base(size: size)
        .color(Colors.transparent)
        .label(TextStyler().color(RadixTokens.accent11()))
        .iconColor(RadixTokens.accent11())
        .spinner(RemixSpinnerStyle(color: RadixTokens.accent11()))
        .onHovered(RemixButtonStyle().color(RadixTokens.accentA3()))
        .onPressed(RemixButtonStyle().color(RadixTokens.accentA4()))
        .onDisabled(
          RemixButtonStyle()
              .label(TextStyler().color(RadixTokens.accent11()))
              .icon(IconStyler(color: RadixTokens.accent11()))
              .spinner(RemixSpinnerStyle(color: RadixTokens.accent11())),
        );

    // Ghost variant uses special padding for size2 from JSON:
    // button-ghost-padding-x: var(--space-4)
    // button-ghost-padding-y: var(--space-2)
    if (size == RadixButtonSize.size2) {
      style =
          style.paddingX(RadixTokens.space4()).paddingY(RadixTokens.space2());
    }

    return style;
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixButtonStyle _sizeStyle(RadixButtonSize size) {
    final style = RemixButtonStyle();

    return switch (size) {
      RadixButtonSize.size1 => style
          .height(24.0)
          .paddingX(RadixTokens.space2())
          .paddingY(RadixTokens.space1())
          .spacing(RadixTokens.space1())
          .borderRadiusAll(RadixTokens.radius2())
          .label(
            TextStyler()
                .fontSize(12.0)
                .height(16.0 / 12.0) // lineHeight as ratio
                .letterSpacing(0.0025),
          )
          .iconSize(12.0)
          .spinner(RemixSpinnerStyle(size: 12.0)),
      RadixButtonSize.size2 => style
          .height(32.0)
          // Generic size padding (ghost overrides provided via variant config)
          .paddingX(RadixTokens.space3())
          .paddingY(RadixTokens.space2())
          .spacing(RadixTokens.space2())
          .borderRadiusAll(RadixTokens.radius3())
          .label(
            TextStyler()
                .fontSize(14.0)
                .height(20.0 / 14.0) // lineHeight as ratio
                .letterSpacing(0.0),
          )
          .iconSize(16.0)
          .spinner(RemixSpinnerStyle(size: 16.0)),
      RadixButtonSize.size3 => style
          .height(40.0)
          .paddingX(RadixTokens.space4())
          .paddingY(RadixTokens.space3())
          .spacing(RadixTokens.space3())
          .borderRadiusAll(RadixTokens.radius4())
          .label(
            TextStyler()
                .fontSize(16.0)
                .height(24.0 / 16.0) // lineHeight as ratio
                .letterSpacing(0.0),
          )
          .iconSize(20.0)
          .spinner(RemixSpinnerStyle(size: 20.0)),
      RadixButtonSize.size4 => style
          .height(48.0)
          .paddingX(RadixTokens.space5())
          .paddingY(RadixTokens.space4())
          .spacing(RadixTokens.space4())
          .borderRadiusAll(RadixTokens.radius5())
          .label(
            TextStyler()
                .fontSize(18.0)
                .height(26.0 / 18.0) // lineHeight as ratio
                .letterSpacing(-0.0025),
          )
          .iconSize(24.0)
          .spinner(RemixSpinnerStyle(size: 24.0)),
    };
  }
}
