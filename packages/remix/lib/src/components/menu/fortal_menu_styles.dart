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

/// Fortal-themed preset for [RemixMenu].
@MixWidget(name: 'FortalMenu')
RemixMenuStyler fortalMenuStyler({
  FortalMenuVariant variant = .solid,
  FortalMenuSize size = .size2,
}) {
  return switch (variant) {
    .solid => _fortalMenuSolidStyler(size),
    .soft => _fortalMenuSoftStyler(size),
  };
}

RemixMenuStyler _fortalMenuBaseStyler(FortalMenuSize size) {
  return RemixMenuStyler()
      .trigger(
        RemixMenuTriggerStyler()
            .borderRadius(BorderRadiusMix.all(FortalTokens.radius2()))
            .label(
              TextStyler(
                style: TextStyleMix(
                  color: FortalTokens.gray12(),
                  fontSize: 14,
                  fontWeight: .w500,
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
        RemixDividerStyler()
            .margin(EdgeInsetsMix.symmetric(vertical: FortalTokens.space1()))
            .height(FortalTokens.borderWidth1())
            .color(FortalTokens.gray6()),
      )
      .merge(_fortalMenuSizeStyler(size));
}

RemixMenuStyler _fortalMenuSolidStyler([FortalMenuSize size = .size2]) {
  return _fortalMenuBaseStyler(size)
      .trigger(
        RemixMenuTriggerStyler()
            .icon(IconStyler(color: FortalTokens.accentContrast(), size: 16))
            .spacing(8)
            .color(FortalTokens.accent9())
            .label(TextStyler().color(FortalTokens.accentContrast())),
      )
      .item(_fortalMenuItemSolidStyler(size));
}

RemixMenuStyler _fortalMenuSoftStyler([FortalMenuSize size = .size2]) {
  return _fortalMenuBaseStyler(size)
      .trigger(
        RemixMenuTriggerStyler()
            .decoration(BoxDecorationMix(color: FortalTokens.accent3()))
            .label(
              TextStyler(
                style: TextStyleMix(
                  color: FortalTokens.accent11(),
                  fontSize: 14,
                  fontWeight: .w500,
                ),
              ),
            )
            .icon(IconStyler(color: FortalTokens.accent11(), size: 16)),
      )
      .item(_fortalMenuItemSoftStyler(size));
}

RemixMenuStyler _fortalMenuSizeStyler(FortalMenuSize size) {
  return switch (size) {
    .size1 => RemixMenuStyler().trigger(
      RemixMenuTriggerStyler().padding(
        EdgeInsetsMix.symmetric(
          vertical: FortalTokens.space1(),
          horizontal: FortalTokens.space2(),
        ),
      ),
    ),
    .size2 => RemixMenuStyler().trigger(
      RemixMenuTriggerStyler().padding(
        EdgeInsetsMix.symmetric(
          vertical: FortalTokens.space2(),
          horizontal: FortalTokens.space3(),
        ),
      ),
    ),
  };
}

/// Creates a Fortal-themed [RemixMenuItemStyler].
RemixMenuItemStyler fortalMenuItemStyler({
  FortalMenuVariant variant = .solid,
  FortalMenuSize size = .size2,
}) {
  return switch (variant) {
    .solid => _fortalMenuItemSolidStyler(size),
    .soft => _fortalMenuItemSoftStyler(size),
  };
}

RemixMenuItemStyler _fortalMenuItemBaseStyler(FortalMenuSize size) {
  return RemixMenuItemStyler()
      .borderRadius(BorderRadiusMix.all(FortalTokens.radius2()))
      .label(
        TextStyler(
          style: TextStyleMix(color: FortalTokens.gray12(), fontSize: 14),
        ),
      )
      .leadingIcon(IconStyler(color: FortalTokens.gray11(), size: 16))
      .trailingIcon(IconStyler(color: FortalTokens.gray11(), size: 16))
      .merge(_fortalMenuItemSizeStyler(size));
}

RemixMenuItemStyler _fortalMenuItemSolidStyler([FortalMenuSize size = .size2]) {
  return _fortalMenuItemBaseStyler(size)
      .color(FortalTokens.graySurface())
      .onHovered(
        RemixMenuItemStyler()
            .color(FortalTokens.accent9())
            .label(TextStyler().color(FortalTokens.accentContrast())),
      );
}

RemixMenuItemStyler _fortalMenuItemSoftStyler([FortalMenuSize size = .size2]) {
  return _fortalMenuItemBaseStyler(size)
      .decoration(BoxDecorationMix(color: Colors.transparent))
      .onHovered(
        RemixMenuItemStyler()
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

RemixMenuItemStyler _fortalMenuItemSizeStyler(FortalMenuSize size) {
  return switch (size) {
    .size1 => RemixMenuItemStyler().padding(
      EdgeInsetsMix.symmetric(
        vertical: FortalTokens.space1(),
        horizontal: FortalTokens.space1(),
      ),
    ),
    .size2 => RemixMenuItemStyler().padding(
      EdgeInsetsMix.symmetric(
        vertical: FortalTokens.space2(),
        horizontal: FortalTokens.space2(),
      ),
    ),
  };
}
