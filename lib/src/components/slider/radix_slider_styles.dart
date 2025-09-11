// ABOUTME: Factory for creating RemixSliderStyle instances using Radix design tokens
// ABOUTME: Provides 3 Radix slider variants with proper token-based styling

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../theme/radix_tokens.dart';
import 'slider.dart';

/// Factory class for creating Radix-compliant slider styles.
///
/// Provides static methods to create RemixSliderStyle instances for all
/// Radix UI slider variants using the RadixTokens system.
class RadixSliderStyles {
  const RadixSliderStyles._();

  /// Creates a classic variant slider style.
  ///
  /// Classic sliders use neutral track with accent active track and neutral thumb.
  /// Used for standard form controls.
  static RemixSliderStyle classic({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixSliderStyle()
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
                width: sizeConfig.thumbBorderWidth,
              )
              .borderRadius(RadixTokens.radiusFull())
              .width(sizeConfig.thumbSize)
              .height(sizeConfig.thumbSize),
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
                      width: sizeConfig.thumbBorderWidth,
                    ),
              ),
        );
  }

  /// Creates a surface variant slider style.
  ///
  /// Surface sliders are similar to classic but without thumb border.
  /// Used for forms with softer visual appearance.
  static RemixSliderStyle surface({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixSliderStyle()
        // Base track styling (inactive portion)
        .baseTrackColor(RadixTokens.accentTrack()) // gray6 equivalent
        // Active track styling (active portion)
        .activeTrackColor(RadixTokens.accentIndicator()) // accent9 equivalent
        // Thumb styling without border
        .thumb(
          BoxStyler()
              .color(RadixTokens.colorSurface())
              .borderRadius(RadixTokens.radiusFull())
              .width(sizeConfig.thumbSize)
              .height(sizeConfig.thumbSize),
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
  /// Used for sliders that need accent color integration.
  static RemixSliderStyle soft({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixSliderStyle()
        // Base track styling (inactive portion) - uses accent4 instead of gray
        .baseTrackColor(RadixTokens.accent4())
        // Active track styling (active portion) - uses accent9
        .activeTrackColor(RadixTokens.accent9())
        // Thumb styling - uses accent9 color
        .thumb(
          BoxStyler()
              .color(RadixTokens.accent9())
              .borderRadius(RadixTokens.radiusFull())
              .width(sizeConfig.thumbSize)
              .height(sizeConfig.thumbSize),
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

  /// Gets size configuration for the given size index.
  static _SliderSizeConfig _getSizeConfig(int size) {
    switch (size) {
      case 1:
        return _SliderSizeConfig(
          thumbSize: 16.0,
          thumbBorderWidth: 1.5,
          trackHeight: 4.0,
        );
      case 2:
        return _SliderSizeConfig(
          thumbSize: 20.0,
          thumbBorderWidth: 2.0,
          trackHeight: 6.0,
        );
      case 3:
        return _SliderSizeConfig(
          thumbSize: 24.0,
          thumbBorderWidth: 2.5,
          trackHeight: 8.0,
        );
      default:
        // Default to size 2 if invalid size provided
        return _SliderSizeConfig(
          thumbSize: 20.0,
          thumbBorderWidth: 2.0,
          trackHeight: 6.0,
        );
    }
  }
}

/// Internal configuration for slider sizes.
class _SliderSizeConfig {
  final double thumbSize;
  final double thumbBorderWidth;
  final double trackHeight;

  const _SliderSizeConfig({
    required this.thumbSize,
    required this.thumbBorderWidth,
    required this.trackHeight,
  });
}