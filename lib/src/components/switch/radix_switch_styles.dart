// ABOUTME: Factory for creating RemixSwitchStyle instances using Radix design tokens
// ABOUTME: Provides 3 Radix switch variants with proper token-based styling

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../theme/radix_tokens.dart';
import 'switch.dart';

/// Factory class for creating Radix-compliant switch styles.
///
/// Provides static methods to create RemixSwitchStyle instances for all
/// Radix UI switch variants using the RadixTokens system.
class RadixSwitchStyles {
  const RadixSwitchStyles._();

  /// Creates a classic variant switch style.
  ///
  /// Classic switches use neutral track color with accent when checked.
  /// Used for standard form controls.
  static RemixSwitchStyle classic({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixSwitchStyle()
        // Container styling
        .container(
          BoxStyler()
              .width(sizeConfig.trackWidth)
              .height(sizeConfig.trackHeight),
        )
        // Track styling (unchecked state)
        .track(
          BoxStyler()
              .color(RadixTokens.accentTrack()) // gray6 equivalent
              .borderRadius(RadixTokens.radiusFull())
              .width(sizeConfig.trackWidth)
              .height(sizeConfig.trackHeight),
        )
        // Thumb styling (unchecked state)
        .thumb(
          BoxStyler()
              .color(RadixTokens.colorSurface())
              .borderRadius(RadixTokens.radiusFull())
              .width(sizeConfig.thumbSize)
              .height(sizeConfig.thumbSize),
        )
        // Checked state - use .onVariant for state changes
        .onVariant(
          'checked',
          RemixSwitchStyle()
              .track(
                BoxStyler().color(RadixTokens.accent9()),
              )
              .thumb(
                BoxStyler().color(RadixTokens.accentContrast()),
              ),
        )
        // Focus state
        .onFocused(
          RemixSwitchStyle().track(
            BoxStyler().borderAll(
              color: RadixTokens.focusA8(),
              width: RadixTokens.focusRingWidth(),
            ),
          ),
        )
        // Disabled state
        .onDisabled(
          RemixSwitchStyle()
              .track(
                BoxStyler().color(RadixTokens.accentTrack()),
              )
              .thumb(
                BoxStyler().color(RadixTokens.colorSurface()),
              ),
        );
  }

  /// Creates a surface variant switch style.
  ///
  /// Surface switches use neutral track with neutral thumb when checked.
  /// Used for forms with softer visual appearance.
  static RemixSwitchStyle surface({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixSwitchStyle()
        // Container styling
        .container(
          BoxStyler()
              .width(sizeConfig.trackWidth)
              .height(sizeConfig.trackHeight),
        )
        // Track styling (unchecked state)
        .track(
          BoxStyler()
              .color(RadixTokens.accentTrack()) // gray6 equivalent
              .borderRadius(RadixTokens.radiusFull())
              .width(sizeConfig.trackWidth)
              .height(sizeConfig.trackHeight),
        )
        // Thumb styling (unchecked state)
        .thumb(
          BoxStyler()
              .color(RadixTokens.colorSurface())
              .borderRadius(RadixTokens.radiusFull())
              .width(sizeConfig.thumbSize)
              .height(sizeConfig.thumbSize),
        )
        // Checked state - different from classic (thumb stays colorSurface)
        .onVariant(
          'checked',
          RemixSwitchStyle()
              .track(
                BoxStyler().color(RadixTokens.accent9()),
              )
              .thumb(
                BoxStyler().color(RadixTokens.colorSurface()), // Stays white/surface
              ),
        )
        // Focus state
        .onFocused(
          RemixSwitchStyle().track(
            BoxStyler().borderAll(
              color: RadixTokens.focusA8(),
              width: RadixTokens.focusRingWidth(),
            ),
          ),
        )
        // Disabled state
        .onDisabled(
          RemixSwitchStyle()
              .track(
                BoxStyler().color(RadixTokens.accentTrack()),
              )
              .thumb(
                BoxStyler().color(RadixTokens.colorSurface()),
              ),
        );
  }

  /// Creates a soft variant switch style.
  ///
  /// Soft switches use accent-tinted track with accent thumb.
  /// Used for forms that need accent color integration.
  static RemixSwitchStyle soft({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixSwitchStyle()
        // Container styling
        .container(
          BoxStyler()
              .width(sizeConfig.trackWidth)
              .height(sizeConfig.trackHeight),
        )
        // Track styling (unchecked state) - uses accent3 instead of gray
        .track(
          BoxStyler()
              .color(RadixTokens.accent3())
              .borderRadius(RadixTokens.radiusFull())
              .width(sizeConfig.trackWidth)
              .height(sizeConfig.trackHeight),
        )
        // Thumb styling (unchecked state) - uses accent11
        .thumb(
          BoxStyler()
              .color(RadixTokens.accent11())
              .borderRadius(RadixTokens.radiusFull())
              .width(sizeConfig.thumbSize)
              .height(sizeConfig.thumbSize),
        )
        // Checked state - track becomes accent5, thumb stays accent11
        .onVariant(
          'checked',
          RemixSwitchStyle()
              .track(
                BoxStyler().color(RadixTokens.accent5()),
              )
              .thumb(
                BoxStyler().color(RadixTokens.accent11()),
              ),
        )
        // Focus state
        .onFocused(
          RemixSwitchStyle().track(
            BoxStyler().borderAll(
              color: RadixTokens.focusA8(),
              width: RadixTokens.focusRingWidth(),
            ),
          ),
        )
        // Disabled state
        .onDisabled(
          RemixSwitchStyle()
              .track(
                BoxStyler().color(RadixTokens.accent3()),
              )
              .thumb(
                BoxStyler().color(RadixTokens.accent11()),
              ),
        );
  }

  /// Gets size configuration for the given size index.
  static _SwitchSizeConfig _getSizeConfig(int size) {
    switch (size) {
      case 1:
        return _SwitchSizeConfig(
          trackWidth: 32.0,
          trackHeight: 18.0,
          thumbSize: 14.0,
        );
      case 2:
        return _SwitchSizeConfig(
          trackWidth: 44.0,
          trackHeight: 24.0,
          thumbSize: 20.0,
        );
      case 3:
        return _SwitchSizeConfig(
          trackWidth: 56.0,
          trackHeight: 30.0,
          thumbSize: 26.0,
        );
      default:
        // Default to size 2 if invalid size provided
        return _SwitchSizeConfig(
          trackWidth: 44.0,
          trackHeight: 24.0,
          thumbSize: 20.0,
        );
    }
  }
}

/// Internal configuration for switch sizes.
class _SwitchSizeConfig {
  final double trackWidth;
  final double trackHeight;
  final double thumbSize;

  const _SwitchSizeConfig({
    required this.trackWidth,
    required this.trackHeight,
    required this.thumbSize,
  });
}