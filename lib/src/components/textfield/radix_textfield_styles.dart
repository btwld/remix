// ABOUTME: Factory constructors for RemixTextFieldStyle variants using Radix design tokens
// ABOUTME: Provides RadixTextFieldStyle subclass with variant + size aware composition

import 'package:mix/mix.dart';

import '../../radix/radix.dart';
import 'textfield.dart';

enum RadixTextFieldSize {
  size1,
  size2,
  size3,
}

enum RadixTextFieldVariant {
  classic,
  surface,
  soft,
}

/// RadixTextFieldStyle utility class for creating Radix-themed textfield styles.
///
/// Provides factory constructor with variant and size parameters plus named
/// static methods for direct access. Composes the correct base metrics,
/// variant visuals, and size-specific styles sourced from the Radix token JSON.
class RadixTextFieldStyle {
  const RadixTextFieldStyle._();

  /// Factory constructor for RadixTextFieldStyle with variant and size parameters.
  ///
  /// Returns a RemixTextFieldStyle configured with Radix design tokens.
  /// Defaults to classic variant with size2.
  static RemixTextFieldStyle create({
    RadixTextFieldVariant variant = RadixTextFieldVariant.classic,
    RadixTextFieldSize size = RadixTextFieldSize.size2,
  }) {
    return switch (variant) {
      RadixTextFieldVariant.classic => classic(size: size),
      RadixTextFieldVariant.surface => surface(size: size),
      RadixTextFieldVariant.soft => soft(size: size),
    };
  }

  static RemixTextFieldStyle base({
    RadixTextFieldSize size = RadixTextFieldSize.size2,
  }) {
    return RemixTextFieldStyle(
        // Basic text styling (colors are set by variants)
        cursorWidth: 1.5,
      )
        // Focus state
        .onFocused(
          RemixTextFieldStyle().borderAll(
            color: RadixTokens.accent8(),
            width: RadixTokens.borderWidth1(),
          ),
        )
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  static RemixTextFieldStyle classic({
    RadixTextFieldSize size = RadixTextFieldSize.size2,
  }) {
    return base(size: size)
        .merge(RemixTextFieldStyle(
          text: TextStyler()
              .color(RadixTokens.gray12())
              .fontWeight(RadixTokens.fontWeightRegular()),
          hintText: TextStyler()
              .color(RadixTokens.gray10())
              .fontWeight(RadixTokens.fontWeightRegular()),
          cursorColor: RadixTokens.gray12(),
          helperText: TextStyler()
              .color(RadixTokens.gray11())
              .fontWeight(RadixTokens.fontWeightRegular()),
          label: TextStyler()
              .color(RadixTokens.gray12())
              .fontWeight(RadixTokens.fontWeightMedium()),
        ))
        .color(RadixTokens.colorSurface())
        .borderAll(
          color: RadixTokens.gray7(),
          width: RadixTokens.borderWidth1(),
        )
        .onDisabled(
          RemixTextFieldStyle(
            text: TextStyler().color(RadixTokens.gray10()),
            hintText: TextStyler().color(RadixTokens.gray8()),
          ).color(RadixTokens.colorSurface()).borderAll(
                color: RadixTokens.gray7(),
                width: RadixTokens.borderWidth1(),
              ),
        );
  }

  static RemixTextFieldStyle surface({
    RadixTextFieldSize size = RadixTextFieldSize.size2,
  }) {
    return base(size: size)
        .merge(RemixTextFieldStyle(
          text: TextStyler()
              .color(RadixTokens.gray12())
              .fontWeight(RadixTokens.fontWeightRegular()),
          hintText: TextStyler()
              .color(RadixTokens.gray10())
              .fontWeight(RadixTokens.fontWeightRegular()),
          cursorColor: RadixTokens.gray12(),
          helperText: TextStyler()
              .color(RadixTokens.gray11())
              .fontWeight(RadixTokens.fontWeightRegular()),
          label: TextStyler()
              .color(RadixTokens.gray12())
              .fontWeight(RadixTokens.fontWeightMedium()),
        ))
        .color(RadixTokens.colorSurface())
        .borderAll(
          color: RadixTokens.gray6(),
          width: RadixTokens.borderWidth1(),
        )
        // Override focus for surface variant (different border color)
        .onFocused(
          RemixTextFieldStyle().borderAll(
            color: RadixTokens.accent7(),
            width: RadixTokens.borderWidth1(),
          ),
        )
        .onDisabled(
          RemixTextFieldStyle(
            text: TextStyler().color(RadixTokens.gray10()),
            hintText: TextStyler().color(RadixTokens.gray8()),
          ).color(RadixTokens.colorSurface()).borderAll(
                color: RadixTokens.gray6(),
                width: RadixTokens.borderWidth1(),
              ),
        );
  }

  static RemixTextFieldStyle soft({
    RadixTextFieldSize size = RadixTextFieldSize.size2,
  }) {
    return base(size: size)
        .merge(RemixTextFieldStyle(
          text: TextStyler()
              .color(RadixTokens.accent12())
              .fontWeight(RadixTokens.fontWeightRegular()),
          hintText: TextStyler()
              .color(RadixTokens.accent10())
              .fontWeight(RadixTokens.fontWeightRegular()),
          cursorColor: RadixTokens.accent12(),
          helperText: TextStyler()
              .color(RadixTokens.gray11())
              .fontWeight(RadixTokens.fontWeightRegular()),
          label: TextStyler()
              .color(RadixTokens.gray12())
              .fontWeight(RadixTokens.fontWeightMedium()),
        ))
        .color(RadixTokens.accent3())
        .borderAll(
          color: RadixTokens.accent6(),
          width: RadixTokens.borderWidth1(),
        )
        .onDisabled(
          RemixTextFieldStyle(
            text: TextStyler().color(RadixTokens.accent11()),
            hintText: TextStyler().color(RadixTokens.accent9()),
          ).color(RadixTokens.accent3()).borderAll(
                color: RadixTokens.accent6(),
                width: RadixTokens.borderWidth1(),
              ),
        );
  }


  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixTextFieldStyle _sizeStyle(RadixTextFieldSize size) {
    return switch (size) {
      RadixTextFieldSize.size1 => RemixTextFieldStyle(
          text: TextStyler().fontSize(12.0),
          hintText: TextStyler().fontSize(12.0),
          helperText: TextStyler().fontSize(11.0),
          label: TextStyler().fontSize(11.0),
        ).borderRadiusAll(RadixTokens.radius2()).paddingAll(8.0).height(32.0),
      RadixTextFieldSize.size2 => RemixTextFieldStyle(
          text: TextStyler().fontSize(14.0),
          hintText: TextStyler().fontSize(14.0),
          helperText: TextStyler().fontSize(12.0),
          label: TextStyler().fontSize(13.0),
        ).borderRadiusAll(RadixTokens.radius3()).paddingAll(12.0).height(40.0),
      RadixTextFieldSize.size3 => RemixTextFieldStyle(
          text: TextStyler().fontSize(16.0),
          hintText: TextStyler().fontSize(16.0),
          helperText: TextStyler().fontSize(14.0),
          label: TextStyler().fontSize(15.0),
        ).borderRadiusAll(RadixTokens.radius4()).paddingAll(16.0).height(48.0),
    };
  }
}

