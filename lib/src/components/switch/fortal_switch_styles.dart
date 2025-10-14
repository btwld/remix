part of 'switch.dart';

enum FortalSwitchSize { size1, size2, size3 }

enum FortalSwitchVariant { surface, soft }

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
    FortalSwitchVariant variant = FortalSwitchVariant.surface,
    FortalSwitchSize size = FortalSwitchSize.size2,
  }) {
    return switch (variant) {
      FortalSwitchVariant.surface => surface(size: size),
      FortalSwitchVariant.soft => soft(size: size),
    };
  }

  static RemixSwitchStyle base({
    FortalSwitchSize size = FortalSwitchSize.size2,
  }) {
    return RemixSwitchStyle()
        .thumbColor(Colors.white)
        .thumb(
          BoxStyler().shapeCircle().shadow(
            BoxShadowMix()
                .color(FortalTokens.grayA7())
                .offset(const Offset(0, 2))
                .blurRadius(3),
          ),
        )
        // Focus state (generic)
        .onFocused(
          RemixSwitchStyle().borderAll(
            color: FortalTokens.focusA8(),
            width: FortalTokens.focusRingWidth(),
          ),
        )
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  /// Creates a surface variant switch style.
  ///
  /// Surface switches use neutral track with neutral thumb when checked.
  /// Used for forms with softer visual appearance.
  static RemixSwitchStyle surface({
    FortalSwitchSize size = FortalSwitchSize.size2,
  }) {
    return base(size: size)
        .color(FortalTokens.gray5())
        .borderRadius(BorderRadiusMix.circular(999))
        .borderAll(
          color: FortalTokens.gray8(),
          width: FortalTokens.borderWidth1(),
          strokeAlign: BorderSide.strokeAlignCenter,
        )
        .onSelected(
          RemixSwitchStyle()
              .color(FortalTokens.accentTrack())
              .borderAll(color: FortalTokens.accent9()),
        )
        .onDisabled(
          RemixSwitchStyle()
              .color(FortalTokens.grayA3())
              .borderAll(color: FortalTokens.gray5())
              .thumbColor(FortalTokens.gray2()),
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
        .color(FortalTokens.gray5())
        .borderRadius(BorderRadiusMix.circular(999))
        .borderAll(
          color: FortalTokens.gray5(),
          width: FortalTokens.borderWidth1(),
          strokeAlign: BorderSide.strokeAlignCenter,
        )
        .onSelected(
          RemixSwitchStyle()
              .color(FortalTokens.accentA7())
              .borderAll(color: FortalTokens.accent7()),
        )
        .onDisabled(
          RemixSwitchStyle()
              .color(FortalTokens.gray5())
              .borderAll(color: FortalTokens.gray5())
              .shadow(BoxShadowMix())
              .thumbColor(FortalTokens.gray2()),
        );
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixSwitchStyle _sizeStyle(FortalSwitchSize size) {
    return switch (size) {
      FortalSwitchSize.size1 => RemixSwitchStyle(
        container: BoxStyler().width(28.0).height(16.0),
        thumb: BoxStyler().width(16.0).height(16.0),
      ),
      FortalSwitchSize.size2 => RemixSwitchStyle(
        container: BoxStyler().width(35.0).height(20.0),
        thumb: BoxStyler().size(20.0, 20.0),
      ),
      FortalSwitchSize.size3 => RemixSwitchStyle(
        container: BoxStyler().width(42.0).height(24.0),
        thumb: BoxStyler().size(24.0, 24.0),
      ),
    };
  }
}
