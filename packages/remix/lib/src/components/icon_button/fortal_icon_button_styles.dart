part of 'icon_button.dart';

enum FortalIconButtonSize { size1, size2, size3, size4 }

enum FortalIconButtonVariant { solid, soft, surface, outline, ghost }

/// FortalIconButtonStyles utility class for creating Fortal-themed icon button styles.
///
/// Provides factory constructor with variant and size parameters plus named
/// static methods for direct access. Composes the correct base metrics,
/// variant visuals, and size-specific styles sourced from the Fortal token JSON.
class FortalIconButtonStyles {
  const FortalIconButtonStyles._();

  /// Factory constructor for FortalIconButtonStyles with variant and size parameters.
  ///
  /// Returns a RemixIconButtonStyle configured with Fortal design tokens.
  /// Defaults to solid variant with size2.
  static RemixIconButtonStyle create({
    FortalIconButtonVariant variant = FortalIconButtonVariant.solid,
    FortalIconButtonSize size = FortalIconButtonSize.size2,
  }) {
    return switch (variant) {
      FortalIconButtonVariant.solid => solid(size: size),
      FortalIconButtonVariant.soft => soft(size: size),
      FortalIconButtonVariant.surface => surface(size: size),
      FortalIconButtonVariant.outline => outline(size: size),
      FortalIconButtonVariant.ghost => ghost(size: size),
    };
  }

  static RemixIconButtonStyle base({
    FortalIconButtonSize size = FortalIconButtonSize.size2,
  }) {
    return RemixIconButtonStyle()
        // Generic spinner properties (size set by _sizeStyle)
        .spinner(
          RemixSpinnerStyle(
            strokeWidth: FortalTokens.borderWidth2(),
            duration: const Duration(milliseconds: 800),
          ),
        )
        // Focus ring (generic)
        .onFocused(
          RemixIconButtonStyle().borderAll(
            color: FortalTokens.focusA8(),
            width: FortalTokens.focusRingWidth(),
          ),
        )
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  static RemixIconButtonStyle solid({
    FortalIconButtonSize size = FortalIconButtonSize.size2,
  }) {
    return base(size: size)
        .color(FortalTokens.accent9())
        .iconColor(FortalTokens.accentContrast())
        .spinner(
          RemixSpinnerStyle().indicatorColor(FortalTokens.accentContrast()),
        )
        .onHovered(RemixIconButtonStyle().color(FortalTokens.accent10()))
        .onPressed(RemixIconButtonStyle().color(FortalTokens.accent10()))
        .onDisabled(
          RemixIconButtonStyle()
              .color(FortalTokens.grayA3())
              .iconColor(FortalTokens.gray8())
              .spinner(
                RemixSpinnerStyle()
                    .indicatorColor(FortalTokens.gray8())
                    .strokeWidth(FortalTokens.borderWidth1()),
              ),
        );
  }

  static RemixIconButtonStyle soft({
    FortalIconButtonSize size = FortalIconButtonSize.size2,
  }) {
    return base(size: size)
        .color(FortalTokens.accent3())
        .iconColor(FortalTokens.accent11())
        .spinner(RemixSpinnerStyle().indicatorColor(FortalTokens.accent11()))
        .onHovered(RemixIconButtonStyle().color(FortalTokens.accent4()))
        .onPressed(RemixIconButtonStyle().color(FortalTokens.accent5()))
        .onDisabled(
          RemixIconButtonStyle()
              .color(FortalTokens.grayA3())
              .iconColor(FortalTokens.gray8())
              .spinner(
                RemixSpinnerStyle()
                    .indicatorColor(FortalTokens.gray8())
                    .strokeWidth(FortalTokens.borderWidth1()),
              ),
        );
  }

  static RemixIconButtonStyle surface({
    FortalIconButtonSize size = FortalIconButtonSize.size2,
  }) {
    return base(size: size)
        .color(FortalTokens.accentA2())
        .borderAll(
          color: FortalTokens.accent6(),
          width: FortalTokens.borderWidth1(),
        )
        .iconColor(FortalTokens.accent11())
        .spinner(RemixSpinnerStyle().indicatorColor(FortalTokens.accent11()))
        .onHovered(
          RemixIconButtonStyle().borderAll(
            color: FortalTokens.accent8(),
            width: FortalTokens.borderWidth1(),
          ),
        )
        .onDisabled(
          RemixIconButtonStyle()
              .color(FortalTokens.grayA2())
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

  static RemixIconButtonStyle outline({
    FortalIconButtonSize size = FortalIconButtonSize.size2,
  }) {
    return base(size: size)
        .color(Colors.transparent)
        .borderAll(
          color: FortalTokens.accent7(),
          width: FortalTokens.borderWidth1(),
        )
        .iconColor(FortalTokens.accent11())
        .spinner(RemixSpinnerStyle().indicatorColor(FortalTokens.accent11()))
        .onHovered(
          RemixIconButtonStyle()
              .color(FortalTokens.accentA2())
              .borderAll(
                color: FortalTokens.accent8(),
                width: FortalTokens.borderWidth1(),
              ),
        )
        .onDisabled(
          RemixIconButtonStyle()
              .iconColor(FortalTokens.gray8())
              .borderAll(color: FortalTokens.gray5())
              .spinner(
                RemixSpinnerStyle()
                    .indicatorColor(FortalTokens.gray8())
                    .strokeWidth(FortalTokens.borderWidth1()),
              ),
        );
  }

  static RemixIconButtonStyle ghost({
    FortalIconButtonSize size = FortalIconButtonSize.size2,
  }) {
    return base(size: size)
        .color(Colors.transparent)
        .iconColor(FortalTokens.accent11())
        .spinner(RemixSpinnerStyle().indicatorColor(FortalTokens.accent11()))
        .onHovered(RemixIconButtonStyle().color(FortalTokens.accentA3()))
        .onPressed(RemixIconButtonStyle().color(FortalTokens.accentA4()))
        .onDisabled(
          RemixIconButtonStyle()
              .iconColor(FortalTokens.gray8())
              .spinner(
                RemixSpinnerStyle().indicatorColor(FortalTokens.gray8()),
              ),
        );
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixIconButtonStyle _sizeStyle(FortalIconButtonSize size) {
    final style = RemixIconButtonStyle();

    return switch (size) {
      FortalIconButtonSize.size1 =>
        style
            .width(24.0)
            .height(24.0)
            .borderRadiusAll(FortalTokens.radius2())
            .iconSize(12.0)
            .spinner(RemixSpinnerStyle(size: 12.0)),
      FortalIconButtonSize.size2 =>
        style
            .width(32.0)
            .height(32.0)
            .borderRadiusAll(FortalTokens.radius3())
            .iconSize(16.0)
            .spinner(RemixSpinnerStyle(size: 16.0)),
      FortalIconButtonSize.size3 =>
        style
            .width(40.0)
            .height(40.0)
            .borderRadiusAll(FortalTokens.radius4())
            .iconSize(20.0)
            .spinner(RemixSpinnerStyle(size: 20.0)),
      FortalIconButtonSize.size4 =>
        style
            .width(48.0)
            .height(48.0)
            .borderRadiusAll(FortalTokens.radius5())
            .iconSize(24.0)
            .spinner(RemixSpinnerStyle(size: 24.0)),
    };
  }
}
