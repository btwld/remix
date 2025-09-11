// ABOUTME: Creates TokenDefinition objects to connect MixTokens to actual Radix color values
// ABOUTME: Provides adaptive token resolution based on RadixThemeData configuration

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'radix_theme_data.dart';
import 'radix_tokens.dart';

/// Creates token definitions that resolve RadixTokens to actual color values
/// based on the current RadixThemeData configuration.
class RadixTokenDefinitions {
  /// Creates all token definitions for the given RadixThemeData.
  static List<TokenDefinition> createDefinitions(RadixThemeData themeData) {
    final componentTokens = themeData.componentTokens;
    final tokens = themeData.tokens;

    return [
      // =======================================================================
      // CORE BACKGROUND TOKENS
      // =======================================================================
      RadixTokens.colorBackground.defineValue(tokens.colorBackground),
      RadixTokens.colorSurface.defineValue(tokens.colorSurface),
      RadixTokens.colorPanelSolid.defineValue(tokens.colorPanelSolid),
      RadixTokens.colorPanelTranslucent.defineValue(tokens.colorPanelTranslucent),
      RadixTokens.colorOverlay.defineValue(tokens.colorOverlay),

      // =======================================================================
      // ACCENT FUNCTIONAL TOKENS
      // =======================================================================
      RadixTokens.accentSurface.defineValue(tokens.accentSurface),
      RadixTokens.accentIndicator.defineValue(tokens.accentIndicator),
      RadixTokens.accentTrack.defineValue(tokens.accentTrack),
      RadixTokens.accentContrast.defineValue(tokens.accentContrast),

      // =======================================================================
      // FOCUS TOKENS
      // =======================================================================
      RadixTokens.focus8.defineValue(tokens.focus.step(8)),
      RadixTokens.focusA8.defineValue(tokens.focus.alphaStep(8)),

      // =======================================================================
      // SOLID VARIANT TOKENS
      // =======================================================================
      RadixTokens.solidBackground.defineValue(componentTokens.solid.background),
      RadixTokens.solidBackgroundHover.defineValue(
        componentTokens.solid.backgroundHover ?? componentTokens.solid.background,
      ),
      RadixTokens.solidText.defineValue(componentTokens.solid.text),
      RadixTokens.solidFocusRing.defineValue(
        componentTokens.solid.focusRing ?? Colors.transparent,
      ),

      // =======================================================================
      // SOFT VARIANT TOKENS
      // =======================================================================
      RadixTokens.softBackground.defineValue(componentTokens.soft.background),
      RadixTokens.softBackgroundHover.defineValue(
        componentTokens.soft.backgroundHover ?? componentTokens.soft.background,
      ),
      RadixTokens.softBackgroundActive.defineValue(
        componentTokens.soft.backgroundActive ?? componentTokens.soft.background,
      ),
      RadixTokens.softBorder.defineValue(
        componentTokens.soft.border ?? Colors.transparent,
      ),
      RadixTokens.softBorderHover.defineValue(
        componentTokens.soft.borderHover ?? 
        componentTokens.soft.border ?? 
        Colors.transparent,
      ),
      RadixTokens.softText.defineValue(componentTokens.soft.text),
      RadixTokens.softFocusRing.defineValue(
        componentTokens.soft.focusRing ?? Colors.transparent,
      ),

      // =======================================================================
      // SURFACE VARIANT TOKENS
      // =======================================================================
      RadixTokens.surfaceBackground.defineValue(componentTokens.surface.background),
      RadixTokens.surfaceBackgroundHover.defineValue(
        componentTokens.surface.backgroundHover ?? componentTokens.surface.background,
      ),
      RadixTokens.surfaceBorder.defineValue(
        componentTokens.surface.border ?? Colors.transparent,
      ),
      RadixTokens.surfaceBorderHover.defineValue(
        componentTokens.surface.borderHover ?? 
        componentTokens.surface.border ?? 
        Colors.transparent,
      ),
      RadixTokens.surfaceText.defineValue(componentTokens.surface.text),
      RadixTokens.surfaceFocusRing.defineValue(
        componentTokens.surface.focusRing ?? Colors.transparent,
      ),

      // =======================================================================
      // OUTLINE VARIANT TOKENS
      // =======================================================================
      RadixTokens.outlineBackground.defineValue(componentTokens.outline.background),
      RadixTokens.outlineBackgroundHover.defineValue(
        componentTokens.outline.backgroundHover ?? componentTokens.outline.background,
      ),
      RadixTokens.outlineBorder.defineValue(
        componentTokens.outline.border ?? Colors.transparent,
      ),
      RadixTokens.outlineBorderHover.defineValue(
        componentTokens.outline.borderHover ?? 
        componentTokens.outline.border ?? 
        Colors.transparent,
      ),
      RadixTokens.outlineText.defineValue(componentTokens.outline.text),
      RadixTokens.outlineFocusRing.defineValue(
        componentTokens.outline.focusRing ?? Colors.transparent,
      ),

      // =======================================================================
      // GHOST VARIANT TOKENS
      // =======================================================================
      RadixTokens.ghostBackground.defineValue(componentTokens.ghost.background),
      RadixTokens.ghostBackgroundHover.defineValue(
        componentTokens.ghost.backgroundHover ?? componentTokens.ghost.background,
      ),
      RadixTokens.ghostBackgroundActive.defineValue(
        componentTokens.ghost.backgroundActive ?? componentTokens.ghost.background,
      ),
      RadixTokens.ghostText.defineValue(componentTokens.ghost.text),
      RadixTokens.ghostFocusRing.defineValue(
        componentTokens.ghost.focusRing ?? Colors.transparent,
      ),

      // =======================================================================
      // CLASSIC VARIANT TOKENS
      // =======================================================================
      RadixTokens.classicBackground.defineValue(componentTokens.classic.background),
      RadixTokens.classicBackgroundHover.defineValue(
        componentTokens.classic.backgroundHover ?? componentTokens.classic.background,
      ),
      RadixTokens.classicBorder.defineValue(
        componentTokens.classic.border ?? Colors.transparent,
      ),
      RadixTokens.classicBorderHover.defineValue(
        componentTokens.classic.borderHover ?? 
        componentTokens.classic.border ?? 
        Colors.transparent,
      ),
      RadixTokens.classicText.defineValue(componentTokens.classic.text),
      RadixTokens.classicFocusRing.defineValue(
        componentTokens.classic.focusRing ?? Colors.transparent,
      ),

      // =======================================================================
      // SIZE TOKENS - Radix button sizes (1-4)
      // =======================================================================
      // Size 1 - Small
      RadixTokens.size1FontSize.defineValue(12.0),
      RadixTokens.size1PaddingX.defineValue(8.0),
      RadixTokens.size1PaddingY.defineValue(4.0),
      RadixTokens.size1IconSize.defineValue(12.0),

      // Size 2 - Medium (default)
      RadixTokens.size2FontSize.defineValue(14.0),
      RadixTokens.size2PaddingX.defineValue(12.0),
      RadixTokens.size2PaddingY.defineValue(6.0),
      RadixTokens.size2IconSize.defineValue(16.0),

      // Size 3 - Large
      RadixTokens.size3FontSize.defineValue(16.0),
      RadixTokens.size3PaddingX.defineValue(16.0),
      RadixTokens.size3PaddingY.defineValue(8.0),
      RadixTokens.size3IconSize.defineValue(18.0),

      // Size 4 - Extra Large
      RadixTokens.size4FontSize.defineValue(18.0),
      RadixTokens.size4PaddingX.defineValue(20.0),
      RadixTokens.size4PaddingY.defineValue(10.0),
      RadixTokens.size4IconSize.defineValue(20.0),
    ];
  }

  /// Creates token definitions that automatically adapt to the current RadixTheme.
  /// 
  /// This creates adaptive token definitions that resolve based on the RadixTheme
  /// found in the current BuildContext.
  static List<TokenDefinition> createAdaptiveDefinitions() {
    return [
      // Core background tokens - adaptive based on current RadixTheme
      RadixTokens.colorBackground.defineBuilder((context) {
        final themeData = context.radixThemeOrNull;
        if (themeData == null) return Colors.white;

        return themeData.tokens.colorBackground;
      }),

      RadixTokens.colorSurface.defineBuilder((context) {
        final themeData = context.radixThemeOrNull;
        if (themeData == null) return const Color(0xFFF8F9FA);

        return themeData.tokens.colorSurface;
      }),

      RadixTokens.colorPanelSolid.defineBuilder((context) {
        final themeData = context.radixThemeOrNull;
        if (themeData == null) return Colors.white;

        return themeData.tokens.colorPanelSolid;
      }),

      // Add more adaptive definitions as needed...
      // For now, we'll use the static createDefinitions approach
    ];
  }
}