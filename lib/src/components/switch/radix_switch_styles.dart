part of 'switch.dart';

enum FortalSwitchSize {
  size1,
  size2,
  size3,
}

enum FortalSwitchVariant {
  classic,
  surface,
  soft,
}

/// Factory class for creating Fortal-compliant switch styles.
///
/// Provides static methods to create RemixSwitchStyle instances for all
/// Fortal UI switch variants using the FortalTokens system.
class FortalSwitchStyles {
  const FortalSwitchStyles._();

  /// Factory constructor for FortalSwitchStyle with variant and size parameters.
  ///
  /// Returns a RemixSwitchStyle configured with Fortal design tokens.
  /// Defaults to classic variant with size2.
  static RemixSwitchStyle create({
    FortalSwitchVariant variant = FortalSwitchVariant.classic,
    FortalSwitchSize size = FortalSwitchSize.size2,
  }) {
    return switch (variant) {
      FortalSwitchVariant.classic => classic(size: size),
      FortalSwitchVariant.surface => surface(size: size),
      FortalSwitchVariant.soft => soft(size: size),
    };
  }

  static RemixSwitchStyle base({
    FortalSwitchSize size = FortalSwitchSize.size2,
  }) {
    return RemixSwitchStyle()
        // Focus state (generic)
        .onFocused(
          RemixSwitchStyle().container(
            BoxStyler().borderAll(
              color: FortalTokens.focusA8(),
              width: FortalTokens.focusRingWidth(),
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
    FortalSwitchSize size = FortalSwitchSize.size2,
  }) {
    return base(size: size)
        // Container styling (unchecked state) - acts as track background
        .container(
          BoxStyler()
              .color(FortalTokens.accentTrack()) // gray6 equivalent
              .borderRadius(BorderRadiusMix.circular(999)),
        )
        // Thumb styling (unchecked state) - no size properties
        .thumb(
          BoxStyler()
              .color(FortalTokens.colorSurface())
              .borderRadius(BorderRadiusMix.circular(999)),
        )
        // Checked state - use .onSelected for state changes
        .onSelected(
          RemixSwitchStyle()
              .container(BoxStyler().color(FortalTokens.accent9()))
              .thumb(BoxStyler().color(FortalTokens.accentContrast())),
        )
        // Disabled state
        .onDisabled(
          RemixSwitchStyle()
              .container(BoxStyler().color(FortalTokens.accentTrack()))
              .thumb(BoxStyler().color(FortalTokens.colorSurface())),
        );
  }

  /// Creates a surface variant switch style.
  ///
  /// Surface switches use neutral track with neutral thumb when checked.
  /// Used for forms with softer visual appearance.
  static RemixSwitchStyle surface({
    FortalSwitchSize size = FortalSwitchSize.size2,
  }) {
    return base(size: size)
        // Container styling (unchecked state) - acts as track background
        .container(
          BoxStyler()
              .color(FortalTokens.accentTrack()) // gray6 equivalent
              .borderRadius(BorderRadiusMix.circular(999)),
        )
        // Thumb styling (unchecked state) - no size properties
        .thumb(
          BoxStyler()
              .color(FortalTokens.colorSurface())
              .borderRadius(BorderRadiusMix.circular(999)),
        )
        // Checked state - different from classic (thumb stays colorSurface)
        .onSelected(
          RemixSwitchStyle()
              .container(BoxStyler().color(FortalTokens.accent9()))
              .thumb(
                BoxStyler()
                    .color(FortalTokens.colorSurface()), // Stays white/surface
              ),
        )
        // Disabled state
        .onDisabled(
          RemixSwitchStyle()
              .container(BoxStyler().color(FortalTokens.accentTrack()))
              .thumb(BoxStyler().color(FortalTokens.colorSurface())),
        );
  }

  /// Creates a soft variant switch style.
  ///
  /// Soft switches use accent-tinted track with accent thumb.
  /// Used for forms that need accent color integration.
  static RemixSwitchStyle soft({
    FortalSwitchSize size = FortalSwitchSize.size2,
  }) {
    return base(size: size)
        // Container styling (unchecked state) - uses accent3 instead of gray, acts as track background
        .container(
          BoxStyler()
              .color(FortalTokens.accent3())
              .borderRadius(BorderRadiusMix.circular(999)),
        )
        // Thumb styling (unchecked state) - uses accent11, no size properties
        .thumb(
          BoxStyler()
              .color(FortalTokens.accent11())
              .borderRadius(BorderRadiusMix.circular(999)),
        )
        // Checked state - container becomes accent5, thumb stays accent11
        .onSelected(
          RemixSwitchStyle()
              .container(BoxStyler().color(FortalTokens.accent5()))
              .thumb(BoxStyler().color(FortalTokens.accent11())),
        )
        // Disabled state
        .onDisabled(
          RemixSwitchStyle()
              .container(BoxStyler().color(FortalTokens.accent3()))
              .thumb(BoxStyler().color(FortalTokens.accent11())),
        );
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixSwitchStyle _sizeStyle(FortalSwitchSize size) {
    return switch (size) {
      FortalSwitchSize.size1 => RemixSwitchStyle(
          container: BoxStyler().width(32.0).height(20.0),
          thumb: BoxStyler().width(16.0).height(16.0),
        ),
      // Per JSON:
      // switch-height = var(--space-5) = 20px
      // switch-width = calc(height * 1.75) = 35px
      // switch-thumb-inset = 1px (handled in widget)
      // switch-thumb-size = calc(height - inset*2) = 18px
      FortalSwitchSize.size2 => RemixSwitchStyle(
          container: BoxStyler().width(35.0).height(20.0),
          thumb: BoxStyler().width(18.0).height(18.0),
        ),
      FortalSwitchSize.size3 => RemixSwitchStyle(
          container: BoxStyler().width(48.0).height(28.0),
          thumb: BoxStyler().width(24.0).height(24.0),
        ),
    };
  }
}
