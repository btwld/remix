import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'button.dart';

/// Examples demonstrating the three-tier RemixButtonStyle API approach.
///
/// **Tier 1**: Individual property helpers - for simple, common styling
/// **Tier 2**: TextStyleMix helpers - for multiple text properties at once
/// **Tier 3**: Full TextStyler/IconStyler - for complex scenarios with full control
class RemixButtonStyleExamples {
  // ==========================================================================
  // BEST PRACTICES
  // ==========================================================================

  /// Example showing when to use which tier
  static void bestPracticesExample() {
    // TIER 1: Use for simple, single property changes
    // ignore: unused_local_variable
    final simpleButton = RemixButtonStyle()
        .labelColor(Colors.blue)
        .iconSize(20.0)
        .spinnerColor(Colors.blue);

    // TIER 2: Use when setting multiple text properties
    // ignore: unused_local_variable
    final textStyledButton = RemixButtonStyle().labelTextStyle(TextStyleMix(
      color: Colors.blue,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ));

    // TIER 3: Use for advanced text features or complex styling
    // ignore: unused_local_variable
    final advancedButton = RemixButtonStyle().label(TextStyler()
        .style(TextStyleMix(color: Colors.blue, fontSize: 16.0))
        .uppercase()
        .maxLines(2)
        .overflow(TextOverflow.ellipsis));
  }

  // ==========================================================================
  // TIER 1: INDIVIDUAL PROPERTY HELPERS (Most Common Usage)
  // ==========================================================================

  /// Simple primary button with basic styling
  static RemixButtonStyle get primary => RemixButtonStyle()
      .color(Colors.blue)
      .labelColor(Colors.white)
      .labelFontSize(16.0)
      .iconColor(Colors.white)
      .iconSize(20.0)
      .borderRadiusAll(Radius.circular(8.0))
      .paddingAll(16.0);

  /// Secondary button with different colors
  static RemixButtonStyle get secondary => RemixButtonStyle()
      .color(Colors.grey.shade100)
      .labelColor(Colors.grey.shade800)
      .labelFontWeight(FontWeight.w500)
      .iconColor(Colors.grey.shade600)
      .iconSize(18.0)
      .borderAll(color: Colors.grey.shade300, width: 1.0)
      .borderRadiusAll(Radius.circular(6.0));

  /// Destructive/danger button styling
  static RemixButtonStyle get destructive => RemixButtonStyle()
      .color(Colors.red)
      .labelColor(Colors.white)
      .labelFontWeight(FontWeight.w600)
      .iconColor(Colors.white)
      .iconOpacity(0.9)
      .onHovered(RemixButtonStyle().color(Colors.red.shade700))
      .onPressed(RemixButtonStyle().color(Colors.red.shade800));

  // ==========================================================================
  // TIER 2: TEXTSTYLEMIX HELPERS (Multiple Properties)
  // ==========================================================================

  /// Button with complex text styling using TextStyleMix
  static RemixButtonStyle get styledLabel => RemixButtonStyle()
      .color(Colors.purple)
      .labelTextStyle(TextStyleMix(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        height: 1.2,
      ))
      .iconColor(Colors.white)
      .iconSize(22.0);

  /// Sophisticated typography button
  static RemixButtonStyle get typography => RemixButtonStyle()
      .color(Colors.indigo)
      .labelTextStyle(TextStyleMix(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        letterSpacing: 0.2,
        wordSpacing: 1.0,
        decoration: TextDecoration.none,
      ))
      .iconColor(Colors.white.withValues(alpha: 0.9))
      .iconSize(20.0);

  // ==========================================================================
  // TIER 3: FULL CONTROL (Complex Scenarios)
  // ==========================================================================

  /// Complex button with full TextStyler control
  static RemixButtonStyle get advanced => RemixButtonStyle()
      .color(Colors.teal)
      .label(
        TextStyler()
            .style(TextStyleMix(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ))
            .uppercase()
            .maxLines(1)
            .overflow(TextOverflow.ellipsis),
      )
      .icon(IconStyler(
        color: Colors.white,
        size: 20.0,
        shadows: [
          ShadowMix(
            blurRadius: 4.0,
            color: Colors.black.withValues(alpha: 0.1),
            offset: Offset(0, 2),
          ),
        ],
        opacity: 0.95,
      ));

  // ==========================================================================
  // MIGRATION EXAMPLES (Old vs New)
  // ==========================================================================

  /// OLD APPROACH - verbose and harder to read
  static RemixButtonStyle get oldApproach => RemixButtonStyle()
      .color(Colors.green)
      .label(TextStyler().color(Colors.white).fontSize(16.0))
      .icon(IconStyler(color: Colors.white, size: 20.0));

  /// NEW APPROACH - clean and readable using helper methods
  static RemixButtonStyle get newApproach => RemixButtonStyle()
      .color(Colors.green)
      .labelColor(Colors.white)
      .labelFontSize(16.0)
      .iconColor(Colors.white)
      .iconSize(20.0);

  // ==========================================================================
  // COMMON PATTERNS
  // ==========================================================================

  /// Outline button pattern
  static RemixButtonStyle get outline => RemixButtonStyle()
      .color(Colors.transparent)
      .labelColor(Colors.blue)
      .labelFontWeight(FontWeight.w500)
      .iconColor(Colors.blue)
      .borderAll(color: Colors.blue, width: 2.0)
      .borderRadiusAll(Radius.circular(8.0))
      .onHovered(RemixButtonStyle()
          .color(Colors.blue.withValues(alpha: 0.05))
          .labelColor(Colors.blue.shade700)
          .iconColor(Colors.blue.shade700));

  /// Ghost/text button pattern
  static RemixButtonStyle get ghost => RemixButtonStyle()
      .color(Colors.transparent)
      .labelColor(Colors.grey.shade700)
      .labelFontWeight(FontWeight.w500)
      .iconColor(Colors.grey.shade600)
      .iconOpacity(0.8)
      .onHovered(RemixButtonStyle()
          .color(Colors.grey.shade50)
          .labelColor(Colors.grey.shade900)
          .iconColor(Colors.grey.shade800));

  /// Large button with increased sizing
  static RemixButtonStyle get large => RemixButtonStyle()
      .color(Colors.orange)
      .labelColor(Colors.white)
      .labelFontSize(18.0)
      .labelFontWeight(FontWeight.w600)
      .iconColor(Colors.white)
      .iconSize(24.0)
      .paddingX(24.0)
      .paddingY(16.0)
      .borderRadiusAll(Radius.circular(12.0));

  /// Small/compact button
  static RemixButtonStyle get small => RemixButtonStyle()
      .color(Colors.amber)
      .labelColor(Colors.white)
      .labelFontSize(12.0)
      .labelFontWeight(FontWeight.w500)
      .iconColor(Colors.white)
      .iconSize(14.0)
      .paddingX(12.0)
      .paddingY(6.0)
      .borderRadiusAll(Radius.circular(4.0));

  /// Loading state button using spinner helpers
  static RemixButtonStyle get loading => RemixButtonStyle()
      .color(Colors.grey.shade400)
      .labelColor(Colors.white.withValues(alpha: 0.7))
      .iconColor(Colors.white.withValues(alpha: 0.7))
      // Using new spinner helper methods
      .spinnerColor(Colors.white)
      .spinnerSize(16.0)
      .spinnerStrokeWidth(2.0)
      .spinnerFast(); // 500ms duration

  /// Alternative loading button with different spinner style
  static RemixButtonStyle get loadingDotted => RemixButtonStyle()
      .color(Colors.purple)
      .labelColor(Colors.white.withValues(alpha: 0.7))
      .iconColor(Colors.white.withValues(alpha: 0.7))
      .spinnerColor(Colors.white)
      .spinnerSize(18.0)
      .spinnerDotted() // Dotted spinner style
      .spinnerSlow(); // 1500ms duration

  // ==========================================================================
  // CHAINING EXAMPLES
  // ==========================================================================

  /// Demonstrates method chaining for complex styles
  static RemixButtonStyle get chainedStyle => RemixButtonStyle()
      // Background and structure
      .color(Colors.deepPurple)
      .borderRadiusAll(Radius.circular(16.0))
      .paddingX(20.0)
      .paddingY(12.0)
      .spacing(8.0)

      // Label styling
      .labelColor(Colors.white)
      .labelFontSize(16.0)
      .labelFontWeight(FontWeight.w600)
      .labelLetterSpacing(0.3)

      // Icon styling
      .iconColor(Colors.white)
      .iconSize(20.0)
      .iconOpacity(0.95)

      // Interactive states
      .onHovered(RemixButtonStyle()
          .color(Colors.deepPurple.shade700)
          .labelColor(Colors.white.withValues(alpha: 0.95))
          .iconColor(Colors.white.withValues(alpha: 0.95)))
      .onPressed(RemixButtonStyle().color(Colors.deepPurple.shade800))
      .onFocused(RemixButtonStyle()
          .borderAll(color: Colors.deepPurple.shade300, width: 2.0))
      .onDisabled(RemixButtonStyle()
          .color(Colors.grey.shade300)
          .labelColor(Colors.grey.shade600)
          .iconColor(Colors.grey.shade600));
}

/// Usage examples for common button scenarios
class CommonButtonPatterns {
  /// Creates a button using the primary pattern
  static RemixButton primaryButton({
    required String label,
    IconData? icon,
    required VoidCallback? onPressed,
  }) {
    return RemixButtonStyleExamples.primary(
      label: label,
      icon: icon,
      onPressed: onPressed,
    );
  }

  /// Creates a button using the secondary pattern
  static RemixButton secondaryButton({
    required String label,
    IconData? icon,
    required VoidCallback? onPressed,
  }) {
    return RemixButtonStyleExamples.secondary(
      label: label,
      icon: icon,
      onPressed: onPressed,
    );
  }

  /// Creates a button using the destructive pattern
  static RemixButton destructiveButton({
    required String label,
    IconData? icon,
    required VoidCallback? onPressed,
  }) {
    return RemixButtonStyleExamples.destructive(
      label: label,
      icon: icon,
      onPressed: onPressed,
    );
  }
}
