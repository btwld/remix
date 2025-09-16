// ABOUTME: Factory constructors for RemixSliderStyle variants using Radix design tokens
// ABOUTME: Provides RadixSliderStyle subclass with variant + size aware composition

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../radix/radix.dart';
import 'slider.dart';

enum RadixSliderSize {
  size1,
  size2,
  size3,
}

enum RadixSliderVariant {
  classic,
  surface,
  soft,
}

/// RadixSliderStyle utility class for creating Radix-themed slider styles.
///
/// Provides factory constructor with variant and size parameters plus named
/// static methods for direct access. Composes the correct base metrics,
/// variant visuals, and size-specific styles sourced from the Radix token JSON.
class RadixSliderStyle {
  const RadixSliderStyle._();

  /// Factory constructor for RadixSliderStyle with variant and size parameters.
  ///
  /// Returns a RemixSliderStyle configured with Radix design tokens.
  /// Defaults to classic variant with size2.
  static RemixSliderStyle create({
    RadixSliderVariant variant = RadixSliderVariant.classic,
    RadixSliderSize size = RadixSliderSize.size2,
  }) {
    return switch (variant) {
      RadixSliderVariant.classic => classic(size: size),
      RadixSliderVariant.surface => surface(size: size),
      RadixSliderVariant.soft => soft(size: size),
    };
  }

  static RemixSliderStyle base({
    RadixSliderSize size = RadixSliderSize.size2,
  }) {
    return RemixSliderStyle()
        // Focus state
        .onFocused(
          RemixSliderStyle().thumb(
            BoxStyler().borderAll(
              color: RadixTokens.focusA8(),
              width: RadixTokens.focusRingWidth(),
            ),
          ),
        )
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  static RemixSliderStyle classic({
    RadixSliderSize size = RadixSliderSize.size2,
  }) {
    return base(size: size)
        // Base track styling (inactive portion)
        .baseTrackColor(RadixTokens.accentTrack()) // gray6 equivalent
        // Active track styling (active portion)
        .activeTrackColor(RadixTokens.accentIndicator()) // accent9 equivalent
        // Thumb styling with border
        .thumb(
          BoxStyler()
              .color(RadixTokens.colorSurface())
              .borderAll(
                color: RadixTokens.gray7(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadius(BorderRadiusMix.all(RadixTokens.radiusFull())),
        )
        // Disabled state
        .onDisabled(
          RemixSliderStyle()
              .baseTrackColor(RadixTokens.accentTrack())
              .activeTrackColor(RadixTokens.accentIndicator())
              .thumb(
                BoxStyler()
                    .color(RadixTokens.colorSurface())
                    .borderAll(
                      color: RadixTokens.gray7(),
                      width: RadixTokens.borderWidth1(),
                    ),
              ),
        );
  }

  static RemixSliderStyle surface({
    RadixSliderSize size = RadixSliderSize.size2,
  }) {
    return base(size: size)
        // Base track styling (inactive portion)
        .baseTrackColor(RadixTokens.accentTrack()) // gray6 equivalent
        // Active track styling (active portion)
        .activeTrackColor(RadixTokens.accentIndicator()) // accent9 equivalent
        // Thumb styling without border
        .thumb(
          BoxStyler()
              .color(RadixTokens.colorSurface())
              .borderRadius(BorderRadiusMix.all(RadixTokens.radiusFull())),
        )
        // Disabled state
        .onDisabled(
          RemixSliderStyle()
              .baseTrackColor(RadixTokens.accentTrack())
              .activeTrackColor(RadixTokens.accentIndicator())
              .thumbColor(RadixTokens.colorSurface()),
        );
  }

  static RemixSliderStyle soft({
    RadixSliderSize size = RadixSliderSize.size2,
  }) {
    return base(size: size)
        // Base track styling (inactive portion) - uses accent4 instead of gray
        .baseTrackColor(RadixTokens.accent4())
        // Active track styling (active portion) - uses accent9
        .activeTrackColor(RadixTokens.accent9())
        // Thumb styling - uses accent9 color
        .thumb(
          BoxStyler()
              .color(RadixTokens.accent9())
              .borderRadius(BorderRadiusMix.all(RadixTokens.radiusFull())),
        )
        // Disabled state
        .onDisabled(
          RemixSliderStyle()
              .baseTrackColor(RadixTokens.accent4())
              .activeTrackColor(RadixTokens.accent9())
              .thumbColor(RadixTokens.accent9()),
        );
  }


  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixSliderStyle _sizeStyle(RadixSliderSize size) {
    return switch (size) {
      RadixSliderSize.size1 => RemixSliderStyle(
          thumb: BoxStyler()
              .width(16.0)
              .height(16.0),
          baseTrack: Paint()
            ..strokeWidth = 4.0
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke,
          activeTrack: Paint()
            ..strokeWidth = 4.0
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke,
        ),
      // Per JSON:
      // slider-track-size = calc(space-2 * 1.25) = 10px
      // slider-thumb-size = calc(track-size + space-1) = 14px
      RadixSliderSize.size2 => RemixSliderStyle(
          thumb: BoxStyler()
              .width(14.0)
              .height(14.0),
          baseTrack: Paint()
            ..strokeWidth = 10.0
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke,
          activeTrack: Paint()
            ..strokeWidth = 10.0
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke,
        ),
      RadixSliderSize.size3 => RemixSliderStyle(
          thumb: BoxStyler()
              .width(24.0)
              .height(24.0),
          baseTrack: Paint()
            ..strokeWidth = 8.0
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke,
          activeTrack: Paint()
            ..strokeWidth = 8.0
            ..strokeCap = StrokeCap.round
            ..style = PaintingStyle.stroke,
        ),
    };
  }
}
