// ignore_for_file: unused_element

part of 'menu.dart';

enum FortalMenuSize { size1, size2 }

enum FortalMenuVariant { solid, soft }

/// FortalMenuStyles utility class for creating Fortal-themed menu styles.
///
/// Provides factory constructor with variant and size parameters plus named
/// static methods for direct access. Composes the correct base metrics,
/// variant visuals, and size-specific styles sourced from the Fortal token JSON.
class FortalMenuStyles {
  const FortalMenuStyles._();

  /// Factory constructor for FortalMenuStyles with variant and size parameters.
  ///
  /// Returns a RemixMenuStyle configured with Fortal design tokens.
  /// Defaults to solid variant with size2.
  static RemixMenuStyle create({
    FortalMenuVariant variant = .solid,
    FortalMenuSize size = .size2,
  }) {
    return switch (variant) {
      .solid => solid(size: size),
      .soft => soft(size: size),
    };
  }

  static RemixMenuStyle base({FortalMenuSize size = .size2}) {
    return RemixMenuStyle()
        .trigger(
          RemixMenuTriggerStyle()
              .borderRadius(BorderRadiusMix.all(FortalTokens.radius2()))
              .label(
                TextStyler(
                  style: TextStyleMix(
                    color: FortalTokens.gray12(),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
              .icon(IconStyler(color: FortalTokens.gray11(), size: 16)),
        )
        .overlay(
          FlexBoxStyler(
            decoration: BoxDecorationMix(
              border: BorderMix.all(
                BorderSideMix(
                  color: FortalTokens.gray7(),
                  width: FortalTokens.borderWidth1(),
                ),
              ),
              borderRadius: BorderRadiusMix.all(FortalTokens.radius3()),
              color: FortalTokens.gray1(),
            ),
            padding: EdgeInsetsMix.all(FortalTokens.space1()),
          ).marginTop(8),
        )
        .divider(
          RemixDividerStyle()
              .margin(EdgeInsetsMix.symmetric(vertical: FortalTokens.space1()))
              .height(FortalTokens.borderWidth1())
              .color(FortalTokens.gray6()),
        )
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  static RemixMenuStyle solid({FortalMenuSize size = .size2}) {
    return base(size: size).trigger(
      RemixMenuTriggerStyle()
          .icon(IconStyler(color: FortalTokens.accentContrast(), size: 16))
          .spacing(8)
          .color(FortalTokens.accent9())
          .label(TextStyler().color(FortalTokens.accentContrast())),
    );
  }

  static RemixMenuStyle soft({FortalMenuSize size = .size2}) {
    return base(size: size).trigger(
      RemixMenuTriggerStyle()
          .decoration(BoxDecorationMix(color: FortalTokens.accent3()))
          .label(
            TextStyler(
              style: TextStyleMix(
                color: FortalTokens.accent11(),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
          .icon(IconStyler(color: FortalTokens.accent11(), size: 16)),
    );
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixMenuStyle _sizeStyle(FortalMenuSize size) {
    return switch (size) {
      .size1 => RemixMenuStyle().trigger(
        RemixMenuTriggerStyle().padding(
          EdgeInsetsMix.symmetric(
            vertical: FortalTokens.space1(),
            horizontal: FortalTokens.space2(),
          ),
        ),
      ),
      .size2 => RemixMenuStyle().trigger(
        RemixMenuTriggerStyle().padding(
          EdgeInsetsMix.symmetric(
            vertical: FortalTokens.space2(),
            horizontal: FortalTokens.space3(),
          ),
        ),
      ),
    };
  }
}

/// FortalMenuItemStyles utility class for creating Fortal-themed menu item styles.
///
/// Provides static methods for creating menu item styles with Fortal design tokens.
class FortalMenuItemStyles {
  const FortalMenuItemStyles._();

  /// Factory constructor for FortalMenuItemStyles with variant and size parameters.
  ///
  /// Returns a RemixMenuItemStyle configured with Fortal design tokens.
  /// Defaults to solid variant with size2.
  static RemixMenuItemStyle create({
    FortalMenuVariant variant = .solid,
    FortalMenuSize size = .size2,
  }) {
    return switch (variant) {
      .solid => solid(size: size),
      .soft => soft(size: size),
    };
  }

  static RemixMenuItemStyle base({FortalMenuSize size = .size2}) {
    return RemixMenuItemStyle()
        .borderRadius(BorderRadiusMix.all(FortalTokens.radius2()))
        .label(
          TextStyler(
            style: TextStyleMix(color: FortalTokens.gray12(), fontSize: 14),
          ),
        )
        .leadingIcon(IconStyler(color: FortalTokens.gray11(), size: 16))
        .trailingIcon(IconStyler(color: FortalTokens.gray11(), size: 16))
        .merge(_sizeStyle(size));
  }

  static RemixMenuItemStyle solid({
    FortalMenuSize size = .size2,
  }) {
    return base(size: size)
        .color(FortalTokens.graySurface())
        .onHovered(
          RemixMenuItemStyle()
              .color(FortalTokens.accent9())
              .label(TextStyler().color(FortalTokens.accentContrast())),
        );
  }

  static RemixMenuItemStyle soft({FortalMenuSize size = .size2}) {
    return base(size: size)
        .decoration(BoxDecorationMix(color: Colors.transparent))
        .onHovered(
          RemixMenuItemStyle()
              .decoration(BoxDecorationMix(color: FortalTokens.accentA3()))
              .label(
                TextStyler(
                  style: TextStyleMix(
                    color: FortalTokens.accent11(),
                    fontSize: 14,
                  ),
                ),
              )
              .leadingIcon(IconStyler(color: FortalTokens.accent11(), size: 16))
              .trailingIcon(
                IconStyler(color: FortalTokens.accent11(), size: 16),
              ),
        );
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixMenuItemStyle _sizeStyle(FortalMenuSize size) {
    return switch (size) {
      .size1 => RemixMenuItemStyle().padding(
        EdgeInsetsMix.symmetric(
          vertical: FortalTokens.space1(),
          horizontal: FortalTokens.space1(),
        ),
      ),
      .size2 => RemixMenuItemStyle().padding(
        EdgeInsetsMix.symmetric(
          vertical: FortalTokens.space2(),
          horizontal: FortalTokens.space2(),
        ),
      ),
    };
  }
}
