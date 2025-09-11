// ABOUTME: Factory for creating RemixSliderStyle instances using Radix design tokens
// ABOUTME: Provides 3 Radix slider variants with proper token-based styling

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../radix/radix.dart';
import 'slider.dart';

// Export the extension so it's available when importing this file
export 'slider.dart' show RadixSliderStyleExt;

/// Factory class for creating Radix-compliant slider styles.
///
/// Provides static methods to create RemixSliderStyle instances for all
/// Radix UI slider variants using the RadixTokens system.
class RadixSliderStyles {
  const RadixSliderStyles._();

  /// Creates a classic variant slider style.
  ///
  /// Classic sliders use neutral track with accent active track and neutral thumb.
  /// Used for standard form controls. Compose with size methods like .size2().
  static RemixSliderStyle classic() {
    return RemixSliderStyle()
        // Base track styling (inactive portion) - no size properties
        .baseTrackColor(RadixTokens.accentTrack()) // gray6 equivalent
        // Active track styling (active portion) - no size properties
        .activeTrackColor(RadixTokens.accentIndicator()) // accent9 equivalent
        // Thumb styling with border - no size properties
        .thumb(
          BoxStyler()
              .color(RadixTokens.colorSurface())
              .borderAll(
                color: RadixTokens.gray7(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadius(BorderRadiusMix.all(RadixTokens.radiusFull())),
        )
        // Focus state
        .onFocused(
          RemixSliderStyle().thumb(
            BoxStyler().borderAll(
              color: RadixTokens.focusA8(),
              width: RadixTokens.focusRingWidth(),
            ),
          ),
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

  /// Creates a surface variant slider style.
  ///
  /// Surface sliders are similar to classic but without thumb border.
  /// Used for forms with softer visual appearance. Compose with size methods like .size2().
  static RemixSliderStyle surface() {
    return RemixSliderStyle()
        // Base track styling (inactive portion) - no size properties
        .baseTrackColor(RadixTokens.accentTrack()) // gray6 equivalent
        // Active track styling (active portion) - no size properties
        .activeTrackColor(RadixTokens.accentIndicator()) // accent9 equivalent
        // Thumb styling without border - no size properties
        .thumb(
          BoxStyler()
              .color(RadixTokens.colorSurface())
              .borderRadius(BorderRadiusMix.all(RadixTokens.radiusFull())),
        )
        // Focus state
        .onFocused(
          RemixSliderStyle().thumb(
            BoxStyler().borderAll(
              color: RadixTokens.focusA8(),
              width: RadixTokens.focusRingWidth(),
            ),
          ),
        )
        // Disabled state
        .onDisabled(
          RemixSliderStyle()
              .baseTrackColor(RadixTokens.accentTrack())
              .activeTrackColor(RadixTokens.accentIndicator())
              .thumbColor(RadixTokens.colorSurface()),
        );
  }

  /// Creates a soft variant slider style.
  ///
  /// Soft sliders use accent color scale for all elements.
  /// Used for sliders that need accent color integration. Compose with size methods like .size2().
  static RemixSliderStyle soft() {
    return RemixSliderStyle()
        // Base track styling (inactive portion) - uses accent4 instead of gray - no size properties
        .baseTrackColor(RadixTokens.accent4())
        // Active track styling (active portion) - uses accent9 - no size properties
        .activeTrackColor(RadixTokens.accent9())
        // Thumb styling - uses accent9 color - no size properties
        .thumb(
          BoxStyler()
              .color(RadixTokens.accent9())
              .borderRadius(BorderRadiusMix.all(RadixTokens.radiusFull())),
        )
        // Focus state
        .onFocused(
          RemixSliderStyle().thumb(
            BoxStyler().borderAll(
              color: RadixTokens.focusA8(),
              width: RadixTokens.focusRingWidth(),
            ),
          ),
        )
        // Disabled state
        .onDisabled(
          RemixSliderStyle()
              .baseTrackColor(RadixTokens.accent4())
              .activeTrackColor(RadixTokens.accent9())
              .thumbColor(RadixTokens.accent9()),
        );
  }

  /// Creates a size 1 slider style (small).
  ///
  /// Small sliders for compact layouts and dense interfaces.
  static RemixSliderStyle size1() {
    return RemixSliderStyle(
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
    );
  }

  /// Creates a size 2 slider style (medium - default).
  ///
  /// Standard sliders for most common use cases.
  static RemixSliderStyle size2() {
    return RemixSliderStyle(
      thumb: BoxStyler()
          .width(20.0)
          .height(20.0),
      baseTrack: Paint()
        ..strokeWidth = 6.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
      activeTrack: Paint()
        ..strokeWidth = 6.0
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    );
  }

  /// Creates a size 3 slider style (large).
  ///
  /// Large sliders for prominent controls and accessibility needs.
  static RemixSliderStyle size3() {
    return RemixSliderStyle(
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
    );
  }
}

/// Extension providing Radix slider size methods for fluent API.
///
/// Enables the pattern: `RadixSliderStyles.classic().size2()`
/// instead of: `RadixSliderStyles.size2().merge(RadixSliderStyles.classic())`
extension RadixSliderStyleExt on RemixSliderStyle {
  /// Creates a size 1 slider style (small).
  ///
  /// Small sliders for compact layouts and dense interfaces.
  RemixSliderStyle size1() {
    return merge(RadixSliderStyles.size1());
  }

  /// Creates a size 2 slider style (medium - default).
  ///
  /// Standard sliders for most common use cases.
  RemixSliderStyle size2() {
    return merge(RadixSliderStyles.size2());
  }

  /// Creates a size 3 slider style (large).
  ///
  /// Large sliders for prominent controls and accessibility needs.
  RemixSliderStyle size3() {
    return merge(RadixSliderStyles.size3());
  }
}
