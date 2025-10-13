part of 'button.dart';

enum FortalButtonSize { size1, size2, size3, size4 }

enum FortalButtonVariant { solid, soft, surface, outline, ghost }

/// FortalButtonStyle utility class for creating Fortal-themed button styles.
///
/// Provides factory constructor with variant and size parameters plus named
/// static methods for direct access. Composes the correct base metrics,
/// variant visuals, and size-specific styles sourced from the Fortal token JSON.
class FortalButtonStyle {
  const FortalButtonStyle._();

  /// Factory constructor for FortalButtonStyle with variant and size parameters.
  ///
  /// Returns a RemixButtonStyle configured with Fortal design tokens.
  /// Defaults to solid variant with size2.
  static RemixButtonStyle create({
    FortalButtonVariant variant = FortalButtonVariant.solid,
    FortalButtonSize size = FortalButtonSize.size2,
  }) {
    return switch (variant) {
      FortalButtonVariant.solid => solid(size: size),
      FortalButtonVariant.soft => soft(size: size),
      FortalButtonVariant.surface => surface(size: size),
      FortalButtonVariant.outline => outline(size: size),
      FortalButtonVariant.ghost => ghost(size: size),
    };
  }

  static RemixButtonStyle base({
    FortalButtonSize size = FortalButtonSize.size2,
  }) {
    return RemixButtonStyle()
        // Generic font weight (not size-specific)
        .label(TextStyler().fontWeight(FortalTokens.fontWeightMedium()))
        // Generic spinner properties (size set by _sizeStyle)
        .spinner(
          RemixSpinnerStyle(
            strokeWidth: FortalTokens.borderWidth2(),
            duration: const Duration(milliseconds: 800),
          ),
        )
        // Focus ring (generic)
        .onFocused(
          RemixButtonStyle().borderAll(
            color: FortalTokens.focusA8(),
            width: FortalTokens.focusRingWidth(),
          ),
        )
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  static RemixButtonStyle solid({
    FortalButtonSize size = FortalButtonSize.size2,
  }) {
    return base(size: size)
        .textColor(FortalTokens.accent9())
        .labelColor(FortalTokens.accentContrast())
        .iconColor(FortalTokens.accentContrast())
        .spinner(
          RemixSpinnerStyle().indicatorColor(FortalTokens.accentContrast()),
        )
        .onHovered(RemixButtonStyle().textColor(FortalTokens.accent10()))
        .onPressed(RemixButtonStyle().textColor(FortalTokens.accent10()))
        .onDisabled(
          RemixButtonStyle()
              .textColor(FortalTokens.grayA3())
              .labelColor(FortalTokens.gray8())
              .iconColor(FortalTokens.gray8())
              .spinner(
                RemixSpinnerStyle()
                    .indicatorColor(FortalTokens.gray8())
                    .strokeWidth(FortalTokens.borderWidth1()),
              ),
        );
  }

  static RemixButtonStyle soft({
    FortalButtonSize size = FortalButtonSize.size2,
  }) {
    return base(size: size)
        .textColor(FortalTokens.accent3())
        .labelColor(FortalTokens.accent11())
        .iconColor(FortalTokens.accent11())
        .spinner(RemixSpinnerStyle().indicatorColor(FortalTokens.accent11()))
        .onHovered(RemixButtonStyle().textColor(FortalTokens.accent4()))
        .onPressed(RemixButtonStyle().textColor(FortalTokens.accent5()))
        .onDisabled(
          RemixButtonStyle()
              .textColor(FortalTokens.grayA3())
              .labelColor(FortalTokens.gray8())
              .iconColor(FortalTokens.gray8())
              .spinner(
                RemixSpinnerStyle()
                    .indicatorColor(FortalTokens.gray8())
                    .strokeWidth(FortalTokens.borderWidth1()),
              ),
        );
  }

  static RemixButtonStyle surface({
    FortalButtonSize size = FortalButtonSize.size2,
  }) {
    return base(size: size)
        .textColor(FortalTokens.accentA2())
        .borderAll(
          color: FortalTokens.accent6(),
          width: FortalTokens.borderWidth1(),
        )
        .labelColor(FortalTokens.accent11())
        .iconColor(FortalTokens.accent11())
        .spinner(RemixSpinnerStyle().indicatorColor(FortalTokens.accent11()))
        .onHovered(
          RemixButtonStyle().borderAll(
            color: FortalTokens.accent8(),
            width: FortalTokens.borderWidth1(),
          ),
        )
        .onDisabled(
          RemixButtonStyle()
              .textColor(FortalTokens.grayA2())
              .labelColor(FortalTokens.gray8())
              .iconColor(FortalTokens.gray8())
              .borderAll(
                color: FortalTokens.gray5(),
                width: FortalTokens.borderWidth1(),
              )
              .spinner(
                RemixSpinnerStyle()
                    .indicatorColor(FortalTokens.gray8())
                    .strokeWidth(FortalTokens.borderWidth1()),
              ),
        );
  }

  static RemixButtonStyle outline({
    FortalButtonSize size = FortalButtonSize.size2,
  }) {
    return base(size: size)
        .textColor(Colors.transparent)
        .borderAll(
          color: FortalTokens.accent7(),
          width: FortalTokens.borderWidth1(),
        )
        .labelColor(FortalTokens.accent11())
        .iconColor(FortalTokens.accent11())
        .spinner(RemixSpinnerStyle().indicatorColor(FortalTokens.accent11()))
        .onHovered(
          RemixButtonStyle()
              .textColor(FortalTokens.accentA2())
              .borderAll(
                color: FortalTokens.accent8(),
                width: FortalTokens.borderWidth1(),
              ),
        )
        .onDisabled(
          RemixButtonStyle()
              .labelColor(FortalTokens.gray8())
              .iconColor(FortalTokens.gray8())
              .borderAll(color: FortalTokens.gray5())
              .spinner(
                RemixSpinnerStyle()
                    .indicatorColor(FortalTokens.gray8())
                    .strokeWidth(FortalTokens.borderWidth1()),
              ),
        );
  }

  static RemixButtonStyle ghost({
    FortalButtonSize size = FortalButtonSize.size2,
  }) {
    var style = base(size: size)
        .textColor(Colors.transparent)
        .labelColor(FortalTokens.accent11())
        .iconColor(FortalTokens.accent11())
        .spinner(RemixSpinnerStyle().indicatorColor(FortalTokens.accent11()))
        .onHovered(RemixButtonStyle().textColor(FortalTokens.accentA3()))
        .onPressed(RemixButtonStyle().textColor(FortalTokens.accentA4()))
        .onDisabled(
          RemixButtonStyle()
              .labelColor(FortalTokens.gray8())
              .iconColor(FortalTokens.gray8())
              .spinner(
                RemixSpinnerStyle().indicatorColor(FortalTokens.accent11()),
              ),
        );

    // Ghost variant uses special padding for size2 from JSON:
    // button-ghost-padding-x: var(--space-4)
    // button-ghost-padding-y: var(--space-2)
    if (size == FortalButtonSize.size2) {
      style = style
          .paddingX(FortalTokens.space4())
          .paddingY(FortalTokens.space2());
    }

    return style;
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixButtonStyle _sizeStyle(FortalButtonSize size) {
    final style = RemixButtonStyle();

    return switch (size) {
      FortalButtonSize.size1 =>
        style
            .paddingX(FortalTokens.space2())
            .paddingY(FortalTokens.space1())
            .spacing(FortalTokens.space1())
            .borderRadiusAll(FortalTokens.radius2())
            .label(
              TextStyler()
                  .fontSize(12.0)
                  .height(16.0 / 12.0) // lineHeight as ratio
                  .letterSpacing(0.0025),
            )
            .iconSize(12.0)
            .spinner(RemixSpinnerStyle(size: 12.0)),
      FortalButtonSize.size2 =>
        style
            // Generic size padding (ghost overrides provided via variant config)
            .paddingX(FortalTokens.space3())
            .paddingY(FortalTokens.space2())
            .spacing(FortalTokens.space2())
            .borderRadiusAll(FortalTokens.radius3())
            .label(
              TextStyler()
                  .fontSize(14.0)
                  .height(20.0 / 14.0) // lineHeight as ratio
                  .letterSpacing(0.0),
            )
            .iconSize(16.0)
            .spinner(RemixSpinnerStyle(size: 16.0)),
      FortalButtonSize.size3 =>
        style
            .paddingX(FortalTokens.space4())
            .paddingY(FortalTokens.space3())
            .spacing(FortalTokens.space3())
            .borderRadiusAll(FortalTokens.radius4())
            .label(
              TextStyler()
                  .fontSize(16.0)
                  .height(24.0 / 16.0) // lineHeight as ratio
                  .letterSpacing(0.0),
            )
            .iconSize(20.0)
            .spinner(RemixSpinnerStyle(size: 20.0)),
      FortalButtonSize.size4 =>
        style
            .paddingX(FortalTokens.space5())
            .paddingY(FortalTokens.space4())
            .spacing(FortalTokens.space4())
            .borderRadiusAll(FortalTokens.radius5())
            .label(
              TextStyler()
                  .fontSize(18.0)
                  .height(26.0 / 18.0) // lineHeight as ratio
                  .letterSpacing(-0.0025),
            )
            .iconSize(24.0)
            .spinner(RemixSpinnerStyle(size: 24.0)),
    };
  }
}
