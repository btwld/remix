part of 'textfield.dart';

enum FortalTextFieldSize { size1, size2, size3 }

enum FortalTextFieldVariant { surface, soft }

/// FortalTextFieldStyles utility class for creating Fortal-themed textfield styles.
///
/// Provides factory constructor with variant and size parameters plus named
/// static methods for direct access. Composes the correct base metrics,
/// variant visuals, and size-specific styles sourced from the Fortal token JSON.
class FortalTextFieldStyles {
  const FortalTextFieldStyles._();

  /// Factory constructor for FortalTextFieldStyles with variant and size parameters.
  ///
  /// Returns a RemixTextFieldStyle configured with Fortal design tokens.
  /// Defaults to surface variant with size2.
  static RemixTextFieldStyle create({
    FortalTextFieldVariant variant = FortalTextFieldVariant.surface,
    FortalTextFieldSize size = FortalTextFieldSize.size2,
  }) {
    return switch (variant) {
      FortalTextFieldVariant.surface => surface(size: size),
      FortalTextFieldVariant.soft => soft(size: size),
    };
  }

  static RemixTextFieldStyle base({
    FortalTextFieldSize size = FortalTextFieldSize.size2,
  }) {
    return RemixTextFieldStyle(
          hintText: TextStyler().textHeightBehavior(
            TextHeightBehaviorMix()
                .applyHeightToFirstAscent(false)
                .applyHeightToLastDescent(true),
          ),
          // Basic text styling (colors are set by variants)
          cursorWidth: 1.5,
        )
        .spacing(8)
        .wrapIconTheme(IconThemeData(size: 16.0, color: FortalTokens.gray10()))
        // Focus state
        .onFocused(
          RemixTextFieldStyle().borderAll(
            color: FortalTokens.accent8(),
            width: FortalTokens.borderWidth1(),
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        )
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  static RemixTextFieldStyle surface({
    FortalTextFieldSize size = FortalTextFieldSize.size2,
  }) {
    return base(size: size)
        .merge(
          RemixTextFieldStyle(
            text: TextStyler()
                .color(FortalTokens.gray12())
                .fontWeight(FortalTokens.fontWeightRegular()),
            hintText: TextStyler()
                .color(FortalTokens.gray10())
                .fontWeight(FortalTokens.fontWeightRegular()),
            cursorColor: FortalTokens.gray12(),
            helperText: TextStyler()
                .color(FortalTokens.gray11())
                .fontWeight(FortalTokens.fontWeightRegular()),
            label: TextStyler()
                .color(FortalTokens.gray12())
                .fontWeight(FortalTokens.fontWeightMedium()),
          ),
        )
        .borderAll(
          color: FortalTokens.gray7(),
          width: FortalTokens.borderWidth1(),
          strokeAlign: BorderSide.strokeAlignOutside,
        )
        .color(FortalTokens.gray12())
        // Override focus for surface variant (different border color)
        .onFocused(
          RemixTextFieldStyle().borderAll(
            color: FortalTokens.accent7(),
            width: FortalTokens.borderWidth1(),
          ),
        )
        .onDisabled(
          RemixTextFieldStyle(
                text: TextStyler().color(FortalTokens.gray10()),
                hintText: TextStyler().color(FortalTokens.gray8()),
              )
              .color(FortalTokens.colorSurface())
              .borderAll(
                color: FortalTokens.gray6(),
                width: FortalTokens.borderWidth1(),
              ),
        );
  }

  static RemixTextFieldStyle soft({
    FortalTextFieldSize size = FortalTextFieldSize.size2,
  }) {
    return base(size: size)
        .merge(
          RemixTextFieldStyle(
            text: TextStyler()
                // .color(Colors.red)
                .fontWeight(FortalTokens.fontWeightRegular()),
            hintText: TextStyler()
                .color(FortalTokens.accentA11())
                .fontWeight(FortalTokens.fontWeightRegular()),
            cursorColor: FortalTokens.accent12(),
            helperText: TextStyler()
                .color(FortalTokens.gray11())
                .fontWeight(FortalTokens.fontWeightRegular()),
            label: TextStyler()
                .color(FortalTokens.gray12())
                .fontWeight(FortalTokens.fontWeightMedium()),
          ),
        )
        .color(FortalTokens.accent12())
        .wrapIconTheme(IconThemeData(color: FortalTokens.accent10()))
        .backgroundColor(FortalTokens.accent3())
        .borderAll(
          color: FortalTokens.accent3(),
          width: FortalTokens.borderWidth1(),
          strokeAlign: BorderSide.strokeAlignOutside,
        )
        .onDisabled(RemixTextFieldStyle(text: TextStyler().color(Colors.red)));
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixTextFieldStyle _sizeStyle(FortalTextFieldSize size) {
    return switch (size) {
      FortalTextFieldSize.size1 => RemixTextFieldStyle(
        text: TextStyler().fontSize(12.0),
        hintText: TextStyler().fontSize(12.0),
        helperText: TextStyler().fontSize(11.0),
        label: TextStyler().fontSize(11.0),
      ).borderRadiusAll(FortalTokens.radius2()).paddingAll(8.0),
      FortalTextFieldSize.size2 => RemixTextFieldStyle(
        text: TextStyler().fontSize(14.0),
        hintText: TextStyler().fontSize(14.0),
        helperText: TextStyler().fontSize(12.0),
        label: TextStyler().fontSize(13.0),
      ).borderRadiusAll(FortalTokens.radius3()).paddingAll(12.0),
      FortalTextFieldSize.size3 => RemixTextFieldStyle(
        text: TextStyler().fontSize(15.0),
        hintText: TextStyler().fontSize(15.0),
        helperText: TextStyler().fontSize(14.0),
        label: TextStyler().fontSize(15.0),
      ).borderRadiusAll(FortalTokens.radius4()).paddingAll(16.0),
    };
  }
}
