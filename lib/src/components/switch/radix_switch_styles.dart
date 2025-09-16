// ABOUTME: Factory for creating RemixSwitchStyle instances using Radix design tokens
// ABOUTME: Provides 3 Radix switch variants with proper token-based styling

import 'package:mix/mix.dart';

import '../../radix/radix.dart';
import 'switch.dart';

enum RadixSwitchSize {
  size1,
  size2,
  size3,
}

enum RadixSwitchVariant {
  classic,
  surface,
  soft,
}

/// Factory class for creating Radix-compliant switch styles.
///
/// Provides static methods to create RemixSwitchStyle instances for all
/// Radix UI switch variants using the RadixTokens system.
class RadixSwitchStyles {
  const RadixSwitchStyles._();

  /// Factory constructor for RadixSwitchStyle with variant and size parameters.
  ///
  /// Returns a RemixSwitchStyle configured with Radix design tokens.
  /// Defaults to classic variant with size2.
  static RemixSwitchStyle create({
    RadixSwitchVariant variant = RadixSwitchVariant.classic,
    RadixSwitchSize size = RadixSwitchSize.size2,
  }) {
    return switch (variant) {
      RadixSwitchVariant.classic => classic(size: size),
      RadixSwitchVariant.surface => surface(size: size),
      RadixSwitchVariant.soft => soft(size: size),
    };
  }

  static RemixSwitchStyle base({
    RadixSwitchSize size = RadixSwitchSize.size2,
  }) {
    return RemixSwitchStyle()
        // Focus state (generic)
        .onFocused(
          RemixSwitchStyle().track(
            BoxStyler().borderAll(
              color: RadixTokens.focusA8(),
              width: RadixTokens.focusRingWidth(),
            ),
          ),
        )
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  /// Creates a classic variant switch style.
  ///
  /// Classic switches use neutral track color with accent when checked.
  /// Used for standard form controls.
  static RemixSwitchStyle classic({
    RadixSwitchSize size = RadixSwitchSize.size2,
  }) {
    return base(size: size)
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
              .track(BoxStyler().color(RadixTokens.accent9()))
              .thumb(BoxStyler().color(RadixTokens.accentContrast())),
        )
        // Disabled state
        .onDisabled(
          RemixSwitchStyle()
              .track(BoxStyler().color(RadixTokens.accentTrack()))
              .thumb(BoxStyler().color(RadixTokens.colorSurface())),
        );
  }

  /// Creates a surface variant switch style.
  ///
  /// Surface switches use neutral track with neutral thumb when checked.
  /// Used for forms with softer visual appearance.
  static RemixSwitchStyle surface({
    RadixSwitchSize size = RadixSwitchSize.size2,
  }) {
    return base(size: size)
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
              .track(BoxStyler().color(RadixTokens.accent9()))
              .thumb(
                BoxStyler()
                    .color(RadixTokens.colorSurface()), // Stays white/surface
              ),
        )
        // Disabled state
        .onDisabled(
          RemixSwitchStyle()
              .track(BoxStyler().color(RadixTokens.accentTrack()))
              .thumb(BoxStyler().color(RadixTokens.colorSurface())),
        );
  }

  /// Creates a soft variant switch style.
  ///
  /// Soft switches use accent-tinted track with accent thumb.
  /// Used for forms that need accent color integration.
  static RemixSwitchStyle soft({
    RadixSwitchSize size = RadixSwitchSize.size2,
  }) {
    return base(size: size)
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
              .track(BoxStyler().color(RadixTokens.accent5()))
              .thumb(BoxStyler().color(RadixTokens.accent11())),
        )
        // Disabled state
        .onDisabled(
          RemixSwitchStyle()
              .track(BoxStyler().color(RadixTokens.accent3()))
              .thumb(BoxStyler().color(RadixTokens.accent11())),
        );
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixSwitchStyle _sizeStyle(RadixSwitchSize size) {
    return switch (size) {
      RadixSwitchSize.size1 => RemixSwitchStyle(
          track: BoxStyler().width(32.0).height(20.0),
          thumb: BoxStyler().width(16.0).height(16.0),
        ),
      // Per JSON:
      // switch-height = var(--space-5) = 20px
      // switch-width = calc(height * 1.75) = 35px
      // switch-thumb-inset = 1px (handled in widget)
      // switch-thumb-size = calc(height - inset*2) = 18px
      RadixSwitchSize.size2 => RemixSwitchStyle(
          track: BoxStyler().width(35.0).height(20.0),
          thumb: BoxStyler().width(18.0).height(18.0),
        ),
      RadixSwitchSize.size3 => RemixSwitchStyle(
          track: BoxStyler().width(48.0).height(28.0),
          thumb: BoxStyler().width(24.0).height(24.0),
        ),
    };
  }
}
