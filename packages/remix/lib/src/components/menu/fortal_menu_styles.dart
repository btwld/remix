part of 'menu.dart';

/// Size scale for Fortal menu triggers and items.
enum FortalMenuSize {
  /// Compact menu controls.
  size1,

  /// Default menu controls.
  size2,
}

/// Visual variants for Fortal menu controls.
enum FortalMenuVariant {
  /// High-emphasis menu trigger and item hover treatment.
  solid,

  /// Subtle accent-backed menu trigger and item hover treatment.
  soft,
}

/// Creates a Fortal-themed [RemixMenuStyle].
RemixMenuStyle fortalMenuStyle({
  FortalMenuVariant variant = .solid,
  FortalMenuSize size = .size2,
}) {
  return switch (variant) {
    .solid => _fortalMenuSolidStyle(size),
    .soft => _fortalMenuSoftStyle(size),
  };
}

RemixMenuStyle _fortalMenuBaseStyle(FortalMenuSize size) {
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
      .merge(_fortalMenuSizeStyle(size));
}

RemixMenuStyle _fortalMenuSolidStyle([FortalMenuSize size = .size2]) {
  return _fortalMenuBaseStyle(size).trigger(
    RemixMenuTriggerStyle()
        .icon(IconStyler(color: FortalTokens.accentContrast(), size: 16))
        .spacing(8)
        .color(FortalTokens.accent9())
        .label(TextStyler().color(FortalTokens.accentContrast())),
  );
}

RemixMenuStyle _fortalMenuSoftStyle([FortalMenuSize size = .size2]) {
  return _fortalMenuBaseStyle(size).trigger(
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

RemixMenuStyle _fortalMenuSizeStyle(FortalMenuSize size) {
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

/// Creates a Fortal-themed [RemixMenuItemStyle].
RemixMenuItemStyle fortalMenuItemStyle({
  FortalMenuVariant variant = .solid,
  FortalMenuSize size = .size2,
}) {
  return switch (variant) {
    .solid => _fortalMenuItemSolidStyle(size),
    .soft => _fortalMenuItemSoftStyle(size),
  };
}

RemixMenuItemStyle _fortalMenuItemBaseStyle(FortalMenuSize size) {
  return RemixMenuItemStyle()
      .borderRadius(BorderRadiusMix.all(FortalTokens.radius2()))
      .label(
        TextStyler(
          style: TextStyleMix(color: FortalTokens.gray12(), fontSize: 14),
        ),
      )
      .leadingIcon(IconStyler(color: FortalTokens.gray11(), size: 16))
      .trailingIcon(IconStyler(color: FortalTokens.gray11(), size: 16))
      .merge(_fortalMenuItemSizeStyle(size));
}

RemixMenuItemStyle _fortalMenuItemSolidStyle([FortalMenuSize size = .size2]) {
  return _fortalMenuItemBaseStyle(size)
      .color(FortalTokens.graySurface())
      .onHovered(
        RemixMenuItemStyle()
            .color(FortalTokens.accent9())
            .label(TextStyler().color(FortalTokens.accentContrast())),
      );
}

RemixMenuItemStyle _fortalMenuItemSoftStyle([FortalMenuSize size = .size2]) {
  return _fortalMenuItemBaseStyle(size)
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
            .trailingIcon(IconStyler(color: FortalTokens.accent11(), size: 16)),
      );
}

RemixMenuItemStyle _fortalMenuItemSizeStyle(FortalMenuSize size) {
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
