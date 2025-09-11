// radix_token_system_final.dart
// Corrected Radix UI token system based on verified mappings
// Track uses neutral gray, indicator uses accent color for proper contrast

import 'package:flutter/painting.dart';
import 'package:mix/mix.dart';

import 'radix_colors.dart'; // Your existing color definitions

// =============================================================================
// THEME CONFIGURATION
// =============================================================================

/// All available accent colors in Radix UI
enum RadixAccentColor {
  amber,
  blue,
  bronze,
  brown,
  crimson,
  cyan,
  gold,
  grass,
  gray,
  green,
  indigo,
  iris,
  jade,
  lime,
  mauve,
  mint,
  olive,
  orange,
  pink,
  plum,
  purple,
  red,
  ruby,
  sand,
  sage,
  sky,
  slate,
  teal,
  tomato,
  violet,
  yellow,
}

/// Available gray scales for neutral colors
enum RadixGrayColor {
  gray, // Pure gray
  mauve, // Purple-tinted gray
  slate, // Blue-tinted gray
  sage, // Green-tinted gray
  olive, // Yellow-green tinted gray
  sand, // Yellow-tinted gray
}

/// Track variant options
enum TrackVariant {
  neutral, // Default: gray track for contrast
  tinted, // Optional: accent-tinted track
}

/// Theme configuration
class RadixTheme {
  final RadixAccentColor accent;
  final RadixGrayColor gray;
  final bool isDark;
  final TrackVariant trackVariant;

  const RadixTheme({
    this.accent = RadixAccentColor.indigo,
    this.gray = RadixGrayColor.slate,
    this.isDark = false,
    this.trackVariant = TrackVariant.neutral, // Default to neutral for contrast
  });
}

// =============================================================================
// COLOR SCALE WITH SEMANTIC ACCESSORS
// =============================================================================

/// Represents a complete 12-step color scale with alpha variants
class RadixColorScale {
  final ColorSwatch<int> solid;
  final ColorSwatch<int> alpha;

  const RadixColorScale(this.solid, this.alpha);

  // Semantic accessors based on Radix documentation

  // Steps 1-2: App backgrounds
  Color get appBackground => step(1);

  Color get subtleBackground => step(2);

  // Steps 3-5: Component backgrounds
  Color get elementBackground => step(3);
  Color get elementBackgroundHover => step(4);

  Color get elementBackgroundActive => step(5); // Steps 6-8: Borders
  Color get subtleBorder => step(6);
  Color get elementBorder => step(7);

  Color get elementBorderHover => step(8); // Steps 9-10: Solid backgrounds
  Color get solidBackground => step(9);
  Color get solidBackgroundHover => step(10);

  // Steps 11-12: Text
  Color get lowContrastText => step(11);
  Color get highContrastText => step(12);

  // Direct step access (1-12)
  Color step(int n) {
    assert(n >= 1 && n <= 12, 'Step must be between 1 and 12');

    return solid[n] ?? solid[9]!;
  }

  Color alphaStep(int n) {
    assert(n >= 1 && n <= 12, 'Step must be between 1 and 12');

    return alpha[n] ?? alpha[9]!;
  }
}

// =============================================================================
// MAIN TOKEN STRUCTURE
// =============================================================================

/// Complete Radix token set for theming
class RadixTokens {
  // Full color scales for direct access
  final RadixColorScale accent;
  final RadixColorScale gray;
  final RadixColorScale focus;

  // Semantic background tokens
  final Color colorBackground; // Page background
  final Color colorSurface; // Overlay surfaces
  final Color colorPanelSolid; // Solid panels
  final Color colorPanelTranslucent; // Translucent panels
  final Color colorOverlay; // Modal overlays

  // Computed accent tokens (CORRECTED)
  final Color accentContrast; // Text color on accent[9]
  final Color accentSurface; // Subtle accent tint
  final Color accentIndicator; // Progress/slider fill (accent[9])
  final Color accentTrack; // Track background (gray[6] by default)

  const RadixTokens({
    required this.accent,
    required this.gray,
    required this.focus,
    required this.colorBackground,
    required this.colorSurface,
    required this.colorPanelSolid,
    required this.colorPanelTranslucent,
    required this.colorOverlay,
    required this.accentContrast,
    required this.accentSurface,
    required this.accentIndicator,
    required this.accentTrack,
  });
}

// =============================================================================
// VARIANT TOKENS FOR COMPONENTS
// =============================================================================

/// Tokens for a specific component variant
class RadixVariantTokens {
  final Color background;
  final Color? backgroundHover;
  final Color? backgroundActive;
  final Color? border;
  final Color? borderHover;
  final Color text;
  final Color? focusRing;

  const RadixVariantTokens({
    required this.background,
    this.backgroundHover,
    this.backgroundActive,
    this.border,
    this.borderHover,
    required this.text,
    this.focusRing,
  });
}

/// Complete set of component variant tokens
class RadixComponentTokens {
  final RadixVariantTokens solid;
  final RadixVariantTokens soft;
  final RadixVariantTokens surface;
  final RadixVariantTokens outline;
  final RadixVariantTokens ghost;
  final RadixVariantTokens classic;

  const RadixComponentTokens({
    required this.solid,
    required this.soft,
    required this.surface,
    required this.outline,
    required this.ghost,
    required this.classic,
  });
}

// =============================================================================
// TOKEN BUILDER (CORRECTED)
// =============================================================================

class RadixTokenBuilder {
  /// Build component-specific tokens for each variant
  static RadixComponentTokens buildComponentTokens(RadixTokens tokens) {
    return RadixComponentTokens(
      // Solid: High emphasis with solid background
      solid: RadixVariantTokens(
        background: tokens.accent.step(9),
        backgroundHover: tokens.accent.step(10),
        text: tokens.accentContrast,
        focusRing: tokens.focus.alphaStep(8),
      ),

      // Soft: Medium emphasis with tinted background
      soft: RadixVariantTokens(
        background: tokens.accent.step(3),
        backgroundHover: tokens.accent.step(4),
        backgroundActive: tokens.accent.step(5),
        border: tokens.accent.step(6),
        text: tokens.accent.step(11),
        focusRing: tokens.focus.alphaStep(8),
      ),

      // Surface: Subtle with accent-tinted surface
      surface: RadixVariantTokens(
        background: tokens.accentSurface,
        backgroundHover:
            _generateSurfaceHover(tokens.accent, tokens.colorSurface),
        border: tokens.accent.step(6),
        borderHover: tokens.accent.step(7),
        text: tokens.accent.step(11),
        focusRing: tokens.focus.alphaStep(8),
      ),

      // Outline: Border-focused variant
      outline: RadixVariantTokens(
        background: MixColors.transparent,
        backgroundHover: tokens.accent.alphaStep(3),
        border: tokens.accent.step(7),
        borderHover: tokens.accent.step(8),
        text: tokens.accent.step(11),
        focusRing: tokens.focus.alphaStep(8),
      ),

      // Ghost: Minimal with no visible container
      ghost: RadixVariantTokens(
        background: MixColors.transparent,
        backgroundHover: tokens.accent.alphaStep(3),
        backgroundActive: tokens.accent.alphaStep(4),
        text: tokens.accent.step(11),
        focusRing: tokens.focus.alphaStep(8),
      ),

      // Classic: Pre-flat UI style with NEUTRAL text by default
      classic: RadixVariantTokens(
        background: tokens
            .colorSurface, // CORRECTED: Use --color-surface per Radix spec
        backgroundHover:
            tokens.gray.step(3), // Based on Radix spec: {gray}[3] on hover
        border: tokens.gray.step(7),
        borderHover: tokens.gray.step(8),
        text: tokens.gray.step(12), // CORRECTED: Neutral text by default
        focusRing: tokens.focus.alphaStep(8),
      ),
    );
  }

  // ==========================================================================
  // PRIVATE HELPERS
  // ==========================================================================

  /// Get accent color scale for the theme
  static RadixColorScale _getAccentScale(RadixAccentColor color, bool isDark) {
    switch (color) {
      case RadixAccentColor.amber:
        return RadixColorScale(
          isDark ? RadixColors.amberDark.swatch : RadixColors.amber.swatch,
          isDark
              ? RadixColors.amberDark.alphaSwatch
              : RadixColors.amber.alphaSwatch,
        );
      case RadixAccentColor.blue:
        return RadixColorScale(
          isDark ? RadixColors.blueDark.swatch : RadixColors.blue.swatch,
          isDark
              ? RadixColors.blueDark.alphaSwatch
              : RadixColors.blue.alphaSwatch,
        );
      case RadixAccentColor.bronze:
        return RadixColorScale(
          isDark ? RadixColors.bronzeDark.swatch : RadixColors.bronze.swatch,
          isDark
              ? RadixColors.bronzeDark.alphaSwatch
              : RadixColors.bronze.alphaSwatch,
        );
      case RadixAccentColor.brown:
        return RadixColorScale(
          isDark ? RadixColors.brownDark.swatch : RadixColors.brown.swatch,
          isDark
              ? RadixColors.brownDark.alphaSwatch
              : RadixColors.brown.alphaSwatch,
        );
      case RadixAccentColor.crimson:
        return RadixColorScale(
          isDark ? RadixColors.crimsonDark.swatch : RadixColors.crimson.swatch,
          isDark
              ? RadixColors.crimsonDark.alphaSwatch
              : RadixColors.crimson.alphaSwatch,
        );
      case RadixAccentColor.cyan:
        return RadixColorScale(
          isDark ? RadixColors.cyanDark.swatch : RadixColors.cyan.swatch,
          isDark
              ? RadixColors.cyanDark.alphaSwatch
              : RadixColors.cyan.alphaSwatch,
        );
      case RadixAccentColor.gold:
        return RadixColorScale(
          isDark ? RadixColors.goldDark.swatch : RadixColors.gold.swatch,
          isDark
              ? RadixColors.goldDark.alphaSwatch
              : RadixColors.gold.alphaSwatch,
        );
      case RadixAccentColor.grass:
        return RadixColorScale(
          isDark ? RadixColors.grassDark.swatch : RadixColors.grass.swatch,
          isDark
              ? RadixColors.grassDark.alphaSwatch
              : RadixColors.grass.alphaSwatch,
        );
      case RadixAccentColor.green:
        return RadixColorScale(
          isDark ? RadixColors.greenDark.swatch : RadixColors.green.swatch,
          isDark
              ? RadixColors.greenDark.alphaSwatch
              : RadixColors.green.alphaSwatch,
        );
      case RadixAccentColor.indigo:
        return RadixColorScale(
          isDark ? RadixColors.indigoDark.swatch : RadixColors.indigo.swatch,
          isDark
              ? RadixColors.indigoDark.alphaSwatch
              : RadixColors.indigo.alphaSwatch,
        );
      case RadixAccentColor.lime:
        return RadixColorScale(
          isDark ? RadixColors.limeDark.swatch : RadixColors.lime.swatch,
          isDark
              ? RadixColors.limeDark.alphaSwatch
              : RadixColors.lime.alphaSwatch,
        );
      case RadixAccentColor.mint:
        return RadixColorScale(
          isDark ? RadixColors.mintDark.swatch : RadixColors.mint.swatch,
          isDark
              ? RadixColors.mintDark.alphaSwatch
              : RadixColors.mint.alphaSwatch,
        );
      case RadixAccentColor.orange:
        return RadixColorScale(
          isDark ? RadixColors.orangeDark.swatch : RadixColors.orange.swatch,
          isDark
              ? RadixColors.orangeDark.alphaSwatch
              : RadixColors.orange.alphaSwatch,
        );
      case RadixAccentColor.pink:
        return RadixColorScale(
          isDark ? RadixColors.pinkDark.swatch : RadixColors.pink.swatch,
          isDark
              ? RadixColors.pinkDark.alphaSwatch
              : RadixColors.pink.alphaSwatch,
        );
      case RadixAccentColor.plum:
        return RadixColorScale(
          isDark ? RadixColors.plumDark.swatch : RadixColors.plum.swatch,
          isDark
              ? RadixColors.plumDark.alphaSwatch
              : RadixColors.plum.alphaSwatch,
        );
      case RadixAccentColor.purple:
        return RadixColorScale(
          isDark ? RadixColors.purpleDark.swatch : RadixColors.purple.swatch,
          isDark
              ? RadixColors.purpleDark.alphaSwatch
              : RadixColors.purple.alphaSwatch,
        );
      case RadixAccentColor.red:
        return RadixColorScale(
          isDark ? RadixColors.redDark.swatch : RadixColors.red.swatch,
          isDark
              ? RadixColors.redDark.alphaSwatch
              : RadixColors.red.alphaSwatch,
        );
      case RadixAccentColor.sky:
        return RadixColorScale(
          isDark ? RadixColors.skyDark.swatch : RadixColors.sky.swatch,
          isDark
              ? RadixColors.skyDark.alphaSwatch
              : RadixColors.sky.alphaSwatch,
        );
      case RadixAccentColor.teal:
        return RadixColorScale(
          isDark ? RadixColors.tealDark.swatch : RadixColors.teal.swatch,
          isDark
              ? RadixColors.tealDark.alphaSwatch
              : RadixColors.teal.alphaSwatch,
        );
      case RadixAccentColor.tomato:
        return RadixColorScale(
          isDark ? RadixColors.tomatoDark.swatch : RadixColors.tomato.swatch,
          isDark
              ? RadixColors.tomatoDark.alphaSwatch
              : RadixColors.tomato.alphaSwatch,
        );
      case RadixAccentColor.violet:
        return RadixColorScale(
          isDark ? RadixColors.violetDark.swatch : RadixColors.violet.swatch,
          isDark
              ? RadixColors.violetDark.alphaSwatch
              : RadixColors.violet.alphaSwatch,
        );
      case RadixAccentColor.yellow:
        return RadixColorScale(
          isDark ? RadixColors.yellowDark.swatch : RadixColors.yellow.swatch,
          isDark
              ? RadixColors.yellowDark.alphaSwatch
              : RadixColors.yellow.alphaSwatch,
        );

      // Handle gray scales that can also be accents
      case RadixAccentColor.gray:
        return RadixColorScale(
          isDark ? RadixColors.grayDark.swatch : RadixColors.gray.swatch,
          isDark
              ? RadixColors.grayDark.alphaSwatch
              : RadixColors.gray.alphaSwatch,
        );
      case RadixAccentColor.mauve:
        return RadixColorScale(
          isDark ? RadixColors.mauveDark.swatch : RadixColors.mauve.swatch,
          isDark
              ? RadixColors.mauveDark.alphaSwatch
              : RadixColors.mauve.alphaSwatch,
        );
      case RadixAccentColor.slate:
        return RadixColorScale(
          isDark ? RadixColors.slateDark.swatch : RadixColors.slate.swatch,
          isDark
              ? RadixColors.slateDark.alphaSwatch
              : RadixColors.slate.alphaSwatch,
        );
      case RadixAccentColor.sage:
        return RadixColorScale(
          isDark ? RadixColors.sageDark.swatch : RadixColors.sage.swatch,
          isDark
              ? RadixColors.sageDark.alphaSwatch
              : RadixColors.sage.alphaSwatch,
        );
      case RadixAccentColor.olive:
        return RadixColorScale(
          isDark ? RadixColors.oliveDark.swatch : RadixColors.olive.swatch,
          isDark
              ? RadixColors.oliveDark.alphaSwatch
              : RadixColors.olive.alphaSwatch,
        );
      case RadixAccentColor.sand:
        return RadixColorScale(
          isDark ? RadixColors.sandDark.swatch : RadixColors.sand.swatch,
          isDark
              ? RadixColors.sandDark.alphaSwatch
              : RadixColors.sand.alphaSwatch,
        );

      // Note: Add these to RadixColors if missing
      case RadixAccentColor.iris:
        return RadixColorScale(
          isDark ? RadixColors.irisDark.swatch : RadixColors.iris.swatch,
          isDark
              ? RadixColors.irisDark.alphaSwatch
              : RadixColors.iris.alphaSwatch,
        );
      case RadixAccentColor.jade:
        return RadixColorScale(
          isDark ? RadixColors.jadeDark.swatch : RadixColors.jade.swatch,
          isDark
              ? RadixColors.jadeDark.alphaSwatch
              : RadixColors.jade.alphaSwatch,
        );
      case RadixAccentColor.ruby:
        return RadixColorScale(
          isDark ? RadixColors.rubyDark.swatch : RadixColors.ruby.swatch,
          isDark
              ? RadixColors.rubyDark.alphaSwatch
              : RadixColors.ruby.alphaSwatch,
        );
    }
  }

  /// Get gray scale for the theme
  static RadixColorScale _getGrayScale(RadixGrayColor color, bool isDark) {
    return switch (color) {
      RadixGrayColor.gray => RadixColorScale(
          isDark ? RadixColors.grayDark.swatch : RadixColors.gray.swatch,
          isDark
              ? RadixColors.grayDark.alphaSwatch
              : RadixColors.gray.alphaSwatch,
        ),
      RadixGrayColor.mauve => RadixColorScale(
          isDark ? RadixColors.mauveDark.swatch : RadixColors.mauve.swatch,
          isDark
              ? RadixColors.mauveDark.alphaSwatch
              : RadixColors.mauve.alphaSwatch,
        ),
      RadixGrayColor.slate => RadixColorScale(
          isDark ? RadixColors.slateDark.swatch : RadixColors.slate.swatch,
          isDark
              ? RadixColors.slateDark.alphaSwatch
              : RadixColors.slate.alphaSwatch,
        ),
      RadixGrayColor.sage => RadixColorScale(
          isDark ? RadixColors.sageDark.swatch : RadixColors.sage.swatch,
          isDark
              ? RadixColors.sageDark.alphaSwatch
              : RadixColors.sage.alphaSwatch,
        ),
      RadixGrayColor.olive => RadixColorScale(
          isDark ? RadixColors.oliveDark.swatch : RadixColors.olive.swatch,
          isDark
              ? RadixColors.oliveDark.alphaSwatch
              : RadixColors.olive.alphaSwatch,
        ),
      RadixGrayColor.sand => RadixColorScale(
          isDark ? RadixColors.sandDark.swatch : RadixColors.sand.swatch,
          isDark
              ? RadixColors.sandDark.alphaSwatch
              : RadixColors.sand.alphaSwatch,
        ),
    };
  }

  /// CORRECTED: Get contrast color for text on accent step 9
  /// Based on verified Radix documentation
  static Color _getContrastColor(RadixAccentColor accent) {
    // Typed neutral swatches for bright palettes (keeps palette-typed values)
    return switch (accent) {
      RadixAccentColor.sky => RadixColors.slate.swatch[12]!, // #1C2024 (exact)
      RadixAccentColor.mint => RadixColors.sage.swatch[12]!, // close to #1A211E
      RadixAccentColor.lime =>
        RadixColors.olive.swatch[12]!, // close to #1D211C
      RadixAccentColor.yellow ||
      RadixAccentColor.amber =>
        RadixColors.sand.swatch[12]!, // close to #21201C
      RadixAccentColor.blue ||
      RadixAccentColor.bronze ||
      RadixAccentColor.brown ||
      RadixAccentColor.crimson ||
      RadixAccentColor.cyan ||
      RadixAccentColor.gold ||
      RadixAccentColor.grass ||
      RadixAccentColor.gray ||
      RadixAccentColor.green ||
      RadixAccentColor.indigo ||
      RadixAccentColor.iris ||
      RadixAccentColor.jade ||
      RadixAccentColor.mauve ||
      RadixAccentColor.olive ||
      RadixAccentColor.orange ||
      RadixAccentColor.pink ||
      RadixAccentColor.plum ||
      RadixAccentColor.purple ||
      RadixAccentColor.red ||
      RadixAccentColor.ruby ||
      RadixAccentColor.sand ||
      RadixAccentColor.sage ||
      RadixAccentColor.slate ||
      RadixAccentColor.teal ||
      RadixAccentColor.tomato ||
      RadixAccentColor.violet =>
        const Color(0xFFFFFFFF),
    };
  }

  /// Generate accent surface color by overlaying low-alpha accent on surface
  /// This creates the subtle tinted background Radix uses
  static Color _generateAccentSurface(RadixColorScale accent, Color surface) {
    // Overlay accent alpha[3] on the surface color and preserve alpha
    final accentAlpha = accent.alphaStep(3);

    return Color.alphaBlend(accentAlpha, surface);
  }

  /// Generate surface hover color by overlaying accent alpha[4] on surface
  /// Based on Radix spec: overlay({accent}Alpha[a4], --color-surface)
  static Color _generateSurfaceHover(RadixColorScale accent, Color surface) {
    // Overlay accent alpha[4] on the surface color for hover state
    final accentAlpha = accent.alphaStep(4);

    return _blendColors(accentAlpha, surface);
  }

  /// Blend two colors using Porter-Duff "over" operation
  static Color _blendColors(Color foreground, Color background) {
    // Delegate to built-in alphaBlend for correctness
    return Color.alphaBlend(foreground, background);
  }

  /// Build complete token set from theme configuration
  static RadixTokens build(RadixTheme theme) {
    // Get color scales
    final accent = _getAccentScale(theme.accent, theme.isDark);
    final gray = _getGrayScale(theme.gray, theme.isDark);
    final focus = accent; // Focus typically uses accent colors

    // Background tokens (following Radix CSS exactly)
    final colorBackground = theme.isDark
        ? gray.step(1) // var(--gray-1) in dark mode
        : const Color(0xFFFFFFFF); // white in light mode

    final colorPanelSolid = theme.isDark
        ? gray.step(2) // var(--gray-2) in dark mode
        : const Color(0xFFFFFFFF); // white in light mode

    // Panel translucent uses specific values
    final colorPanelTranslucent = theme.isDark
        ? gray.alphaStep(2) // grayAlpha[a2] for dark
        : const Color(0xB3FFFFFF); // rgba(255,255,255,0.7) for light

    final colorSurface = theme.isDark
        ? const Color(0x40000000) // rgba(0,0,0,0.25)
        : const Color(0xD9FFFFFF); // rgba(255,255,255,0.85)

    // Align with Themes exactly: black alpha overlay
    // Light: black-a6 (~0.4), Dark: black-a8 (~0.6)
    final colorOverlay = theme.isDark
        ? const Color.fromRGBO(0, 0, 0, 0.6)
        : const Color.fromRGBO(0, 0, 0, 0.4);

    // CORRECTED: Accent tokens following verified rules
    final accentIndicator = accent.step(9); // Strong fill color

    // Track: keep neutral option; tinted option uses accent solid (step 9) per Radix Themes
    final accentTrack = theme.trackVariant == TrackVariant.neutral
        ? gray.step(6)
        : accent.step(9);

    final accentContrast = _getContrastColor(theme.accent);
    final accentSurface = _generateAccentSurface(accent, colorSurface);

    return RadixTokens(
      accent: accent,
      gray: gray,
      focus: focus,
      colorBackground: colorBackground,
      colorSurface: colorSurface,
      colorPanelSolid: colorPanelSolid,
      colorPanelTranslucent: colorPanelTranslucent,
      colorOverlay: colorOverlay,
      accentContrast: accentContrast,
      accentSurface: accentSurface,
      accentIndicator: accentIndicator,
      accentTrack: accentTrack,
    );
  }
}
