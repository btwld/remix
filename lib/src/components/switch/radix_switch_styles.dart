// ABOUTME: Factory for creating RemixSwitchStyle instances using Radix design tokens
// ABOUTME: Provides 3 Radix switch variants with proper token-based styling

import 'package:mix/mix.dart';

import '../../theme/radix_tokens.dart';
import 'switch.dart';

// Export the extension so it's available when importing this file
export 'switch.dart' show RadixSwitchStyleExt;

/// Factory class for creating Radix-compliant switch styles.
///
/// Provides static methods to create RemixSwitchStyle instances for all
/// Radix UI switch variants using the RadixTokens system.
class RadixSwitchStyles {
  const RadixSwitchStyles._();

  /// Creates a classic variant switch style.
  ///
  /// Classic switches use neutral track color with accent when checked.
  /// Used for standard form controls. Compose with size methods like .size2().
  static RemixSwitchStyle classic() {
    return RemixSwitchStyle()
        // Track styling (unchecked state) - no size properties
        .track(
          BoxStyler()
              .color(RadixTokens.accentTrack()) // gray6 equivalent
              .borderRadius(BorderRadiusMix.circular(999)),
        )
        // Thumb styling (unchecked state) - no size properties
        .thumb(
          BoxStyler()
              .color(RadixTokens.colorSurface())
              .borderRadius(BorderRadiusMix.circular(999)),
        )
        // Checked state - use .onSelected for state changes
        .onSelected(
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
  /// Used for forms with softer visual appearance. Compose with size methods like .size2().
  static RemixSwitchStyle surface() {
    return RemixSwitchStyle()
        // Track styling (unchecked state) - no size properties
        .track(
          BoxStyler()
              .color(RadixTokens.accentTrack()) // gray6 equivalent
              .borderRadius(BorderRadiusMix.circular(999)),
        )
        // Thumb styling (unchecked state) - no size properties
        .thumb(
          BoxStyler()
              .color(RadixTokens.colorSurface())
              .borderRadius(BorderRadiusMix.circular(999)),
        )
        // Checked state - different from classic (thumb stays colorSurface)
        .onSelected(
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
  /// Used for forms that need accent color integration. Compose with size methods like .size2().
  static RemixSwitchStyle soft() {
    return RemixSwitchStyle()
        // Track styling (unchecked state) - uses accent3 instead of gray, no size properties
        .track(
          BoxStyler()
              .color(RadixTokens.accent3())
              .borderRadius(BorderRadiusMix.circular(999)),
        )
        // Thumb styling (unchecked state) - uses accent11, no size properties
        .thumb(
          BoxStyler()
              .color(RadixTokens.accent11())
              .borderRadius(BorderRadiusMix.circular(999)),
        )
        // Checked state - track becomes accent5, thumb stays accent11
        .onSelected(
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

  /// Creates a size 1 switch style (small).
  ///
  /// Small switches for compact layouts and dense interfaces.
  /// Compose with variant methods like .classic().
  static RemixSwitchStyle size1() {
    return RemixSwitchStyle(
      track: BoxStyler()
        .width(32.0)
        .height(20.0),
      thumb: BoxStyler()
        .width(16.0)
        .height(16.0),
    );
  }

  /// Creates a size 2 switch style (medium - default).
  ///
  /// Standard switches for most common use cases.
  /// Compose with variant methods like .classic().
  static RemixSwitchStyle size2() {
    return RemixSwitchStyle(
      track: BoxStyler()
        .width(40.0)
        .height(24.0),
      thumb: BoxStyler()
        .width(20.0)
        .height(20.0),
    );
  }

  /// Creates a size 3 switch style (large).
  ///
  /// Large switches for accessibility needs and prominent forms.
  /// Compose with variant methods like .classic().
  static RemixSwitchStyle size3() {
    return RemixSwitchStyle(
      track: BoxStyler()
        .width(48.0)
        .height(28.0),
      thumb: BoxStyler()
        .width(24.0)
        .height(24.0),
    );
  }
}