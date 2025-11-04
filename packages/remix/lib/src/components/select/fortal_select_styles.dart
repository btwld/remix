// ignore_for_file: unused_element

part of 'select.dart';

enum FortalSelectSize { size1, size2, size3 }

enum FortalSelectVariant { surface, soft, ghost }

/// FortalSelectStyles utility class for creating Fortal-themed select styles.
///
/// Provides factory constructor with variant and size parameters plus named
/// static methods for direct access. Composes the correct base metrics,
/// variant visuals, and size-specific styles sourced from the Fortal token JSON.
class FortalSelectStyles {
  const FortalSelectStyles._();

  /// Factory constructor for FortalSelectStyles with variant and size parameters.
  ///
  /// Returns a RemixSelectStyle configured with Fortal design tokens.
  /// Defaults to surface variant with size2.
  static RemixSelectStyle create({
    FortalSelectVariant variant = FortalSelectVariant.surface,
    FortalSelectSize size = FortalSelectSize.size2,
  }) {
    return switch (variant) {
      FortalSelectVariant.surface => surface(size: size),
      FortalSelectVariant.soft => soft(size: size),
      FortalSelectVariant.ghost => ghost(size: size),
    };
  }

  static RemixSelectStyle base({
    FortalSelectSize size = FortalSelectSize.size2,
  }) {
    return RemixSelectStyle()
        .trigger(
          RemixSelectTriggerStyle()
              .direction(Axis.horizontal)
              .mainAxisAlignment(MainAxisAlignment.spaceBetween)
              .crossAxisAlignment(CrossAxisAlignment.center)
              .borderRadiusAll(FortalTokens.radius3())
              .label(TextStyler().color(FortalTokens.gray12()))
              .icon(IconStyler(color: FortalTokens.gray12(), size: 16.0)),
        )
        .menuContainer(
          FlexBoxStyler()
              .width(150)
              .color(FortalTokens.colorPanelSolid())
              .marginTop(8)
              .borderAll(
                color: FortalTokens.gray6(),
                width: FortalTokens.borderWidth1(),
              )
              .borderRadiusAll(FortalTokens.radius3())
              .padding(EdgeInsetsMix.all(8.0)),
        )
        .onFocused(
          RemixSelectStyle().trigger(
            RemixSelectTriggerStyle().borderAll(
              color: FortalTokens.focusA8(),
              width: FortalTokens.focusRingWidth(),
            ),
          ),
        )
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  static RemixSelectStyle surface({
    FortalSelectSize size = FortalSelectSize.size2,
  }) {
    return base(size: size).trigger(
      RemixSelectTriggerStyle()
          .color(FortalTokens.colorSurface())
          .borderAll(
            color: FortalTokens.gray6(),
            width: FortalTokens.borderWidth1(),
          ),
    );
  }

  static RemixSelectStyle soft({
    FortalSelectSize size = FortalSelectSize.size2,
  }) {
    return base(size: size).trigger(
      RemixSelectTriggerStyle()
          .color(FortalTokens.accent3())
          .label(TextStyler().color(FortalTokens.accent11()))
          .icon(IconStyler(color: FortalTokens.accent11(), size: 16.0)),
    );
  }

  static RemixSelectStyle ghost({
    FortalSelectSize size = FortalSelectSize.size2,
  }) {
    return base(size: size).trigger(
      RemixSelectTriggerStyle()
          .color(Colors.transparent)
          .paddingY(6.0), // Adjust padding for ghost variant
    );
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixSelectStyle _sizeStyle(FortalSelectSize size) {
    return switch (size) {
      FortalSelectSize.size1 => RemixSelectStyle().trigger(
        RemixSelectTriggerStyle().paddingX(8.0).height(24.0),
      ),
      FortalSelectSize.size2 => RemixSelectStyle().trigger(
        RemixSelectTriggerStyle().paddingX(12.0).height(32.0),
      ),
      FortalSelectSize.size3 => RemixSelectStyle().trigger(
        RemixSelectTriggerStyle().paddingX(16.0).height(40.0),
      ),
    };
  }
}

/// FortalSelectItemStyles utility class for creating Fortal-themed select item styles.
///
/// Provides static methods for creating menu item styles with Fortal design tokens.
class FortalSelectItemStyles {
  const FortalSelectItemStyles._();

  /// Factory constructor for FortalSelectItemStyles with variant and size parameters.
  ///
  /// Returns a RemixSelectMenuItemStyle configured with Fortal design tokens.
  /// Defaults to surface variant with size2.
  static RemixSelectMenuItemStyle create({
    FortalSelectVariant variant = FortalSelectVariant.surface,
    FortalSelectSize size = FortalSelectSize.size2,
  }) {
    return switch (variant) {
      FortalSelectVariant.surface => surface(size: size),
      FortalSelectVariant.soft => soft(size: size),
      FortalSelectVariant.ghost => ghost(size: size),
    };
  }

  static RemixSelectMenuItemStyle base({
    FortalSelectSize size = FortalSelectSize.size2,
  }) {
    return RemixSelectMenuItemStyle()
        .icon(IconStyler(size: 16.0))
        .borderRadiusAll(FortalTokens.radius2())
        .merge(_sizeStyle(size));
  }

  static RemixSelectMenuItemStyle surface({
    FortalSelectSize size = FortalSelectSize.size2,
  }) {
    return base(size: size)
        .color(Colors.transparent)
        .text(TextStyler().color(FortalTokens.gray12()))
        .onHovered(
          RemixSelectMenuItemStyle()
              .color(FortalTokens.grayA3())
              .text(TextStyler().color(FortalTokens.gray12())),
        );
  }

  static RemixSelectMenuItemStyle soft({
    FortalSelectSize size = FortalSelectSize.size2,
  }) {
    return base(size: size)
        .color(Colors.transparent)
        .text(TextStyler().color(FortalTokens.gray12()))
        .onHovered(
          RemixSelectMenuItemStyle()
              .color(FortalTokens.accentA3())
              .iconColor(FortalTokens.accent11())
              .text(TextStyler().color(FortalTokens.accent11())),
        );
  }

  static RemixSelectMenuItemStyle ghost({
    FortalSelectSize size = FortalSelectSize.size2,
  }) {
    return base(size: size)
        .color(Colors.transparent)
        .text(TextStyler().color(FortalTokens.gray12()))
        .onHovered(
          RemixSelectMenuItemStyle()
              .color(FortalTokens.grayA2())
              .text(TextStyler().color(FortalTokens.gray12())),
        );
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixSelectMenuItemStyle _sizeStyle(FortalSelectSize size) {
    return switch (size) {
      FortalSelectSize.size1 =>
        RemixSelectMenuItemStyle().paddingX(6.0).height(20.0),
      FortalSelectSize.size2 =>
        RemixSelectMenuItemStyle().paddingX(8.0).height(24.0),
      FortalSelectSize.size3 =>
        RemixSelectMenuItemStyle().paddingX(10.0).height(28.0),
    };
  }
}
