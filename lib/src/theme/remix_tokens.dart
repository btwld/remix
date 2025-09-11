import 'radix_tokens.dart';

/// Legacy Design tokens for the Remix component library.
///
/// **DEPRECATED**: This class now internally maps to RadixTokens for consistency.
/// New components should use RadixTokens directly for better flexibility and
/// alignment with the Radix UI design system.
/// 
/// These tokens maintain backward compatibility while leveraging the comprehensive
/// RadixTokens system under the hood.
class RemixTokens {
  // ============================================================================
  // LEGACY COLOR TOKENS (NOW MAPPED TO RADIX)
  // ============================================================================

  /// Primary color for main emphasis and solid surfaces
  /// Maps to RadixTokens.accent9() (solid accent color)
  static const primary = RadixTokens.accent9;

  /// Foreground that sits on top of [primary]
  /// Maps to RadixTokens.accentContrast() (legible text on accent backgrounds)
  static const onPrimary = RadixTokens.accentContrast;

  /// Secondary neutral/supporting color (outlines, subtle UI)
  /// Maps to RadixTokens.gray7() (UI borders and subtle elements)
  static const secondary = RadixTokens.gray7;

  /// Foreground that sits on top of [secondary]
  /// Maps to RadixTokens.gray12() (high-contrast text)
  static const onSecondary = RadixTokens.gray12;

  // ============================================================================
  // LEGACY SPACING TOKENS (NOW MAPPED TO RADIX)
  // ============================================================================
  
  /// Extra small spacing: 4px
  /// Maps to RadixTokens.space1()
  static const spaceXs = RadixTokens.space1;
  
  /// Small spacing: 8px
  /// Maps to RadixTokens.space2()
  static const spaceSm = RadixTokens.space2;
  
  /// Medium spacing: 12px  
  /// Maps to RadixTokens.space3()
  static const spaceMd = RadixTokens.space3;
  
  /// Large spacing: 16px
  /// Maps to RadixTokens.space4()
  static const spaceLg = RadixTokens.space4;

  // ============================================================================
  // LEGACY SHAPE TOKENS (NOW MAPPED TO RADIX)
  // ============================================================================
  
  /// Shared border radius value: 8px
  /// Maps to RadixTokens.radius4()
  /// Use with BorderRadiusMix.all(RemixTokens.radius())
  static const radius = RadixTokens.radius4;

  const RemixTokens._();
}

/// Opacity/alpha tokens to normalize UI overlays and subtle elements
// Opacity tokens removed; keep only muted color tokens above.
