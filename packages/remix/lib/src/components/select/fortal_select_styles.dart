part of 'select.dart';

enum FortalSelectSize { size1, size2, size3 }

enum FortalSelectVariant { surface, soft, ghost }

RemixSelectStyle fortalSelectStyle({
  FortalSelectVariant variant = .surface,
  FortalSelectSize size = .size2,
}) {
  return switch (variant) {
    .surface => _fortalSelectSurfaceStyle(size),
    .soft => _fortalSelectSoftStyle(size),
    .ghost => _fortalSelectGhostStyle(size),
  };
}

RemixSelectStyle _fortalSelectBaseStyle(FortalSelectSize size) {
  return RemixSelectStyle()
      .trigger(
        RemixSelectTriggerStyle()
            .direction(.horizontal)
            .mainAxisAlignment(.spaceBetween)
            .crossAxisAlignment(.center)
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
      .merge(_fortalSelectSizeStyle(size));
}

RemixSelectStyle _fortalSelectSurfaceStyle([FortalSelectSize size = .size2]) {
  return _fortalSelectBaseStyle(size).trigger(
    RemixSelectTriggerStyle()
        .color(FortalTokens.colorSurface())
        .borderAll(
          color: FortalTokens.gray6(),
          width: FortalTokens.borderWidth1(),
        ),
  );
}

RemixSelectStyle _fortalSelectSoftStyle([FortalSelectSize size = .size2]) {
  return _fortalSelectBaseStyle(size).trigger(
    RemixSelectTriggerStyle()
        .color(FortalTokens.accent3())
        .label(TextStyler().color(FortalTokens.accent11()))
        .icon(IconStyler(color: FortalTokens.accent11(), size: 16.0)),
  );
}

RemixSelectStyle _fortalSelectGhostStyle([FortalSelectSize size = .size2]) {
  return _fortalSelectBaseStyle(
    size,
  ).trigger(RemixSelectTriggerStyle().color(Colors.transparent).paddingY(6.0));
}

RemixSelectStyle _fortalSelectSizeStyle(FortalSelectSize size) {
  return switch (size) {
    .size1 => RemixSelectStyle().trigger(
      RemixSelectTriggerStyle().paddingX(8.0).height(24.0),
    ),
    .size2 => RemixSelectStyle().trigger(
      RemixSelectTriggerStyle().paddingX(12.0).height(32.0),
    ),
    .size3 => RemixSelectStyle().trigger(
      RemixSelectTriggerStyle().paddingX(16.0).height(40.0),
    ),
  };
}

RemixSelectMenuItemStyle fortalSelectMenuItemStyle({
  FortalSelectVariant variant = .surface,
  FortalSelectSize size = .size2,
}) {
  return switch (variant) {
    .surface => _fortalSelectMenuItemSurfaceStyle(size),
    .soft => _fortalSelectMenuItemSoftStyle(size),
    .ghost => _fortalSelectMenuItemGhostStyle(size),
  };
}

RemixSelectMenuItemStyle _fortalSelectMenuItemBaseStyle(FortalSelectSize size) {
  return RemixSelectMenuItemStyle()
      .icon(IconStyler(size: 16.0))
      .borderRadiusAll(FortalTokens.radius2())
      .merge(_fortalSelectMenuItemSizeStyle(size));
}

RemixSelectMenuItemStyle _fortalSelectMenuItemSurfaceStyle([
  FortalSelectSize size = .size2,
]) {
  return _fortalSelectMenuItemBaseStyle(size)
      .color(Colors.transparent)
      .text(TextStyler().color(FortalTokens.gray12()))
      .onHovered(
        RemixSelectMenuItemStyle()
            .color(FortalTokens.grayA3())
            .text(TextStyler().color(FortalTokens.gray12())),
      );
}

RemixSelectMenuItemStyle _fortalSelectMenuItemSoftStyle([
  FortalSelectSize size = .size2,
]) {
  return _fortalSelectMenuItemBaseStyle(size)
      .color(Colors.transparent)
      .text(TextStyler().color(FortalTokens.gray12()))
      .onHovered(
        RemixSelectMenuItemStyle()
            .color(FortalTokens.accentA3())
            .iconColor(FortalTokens.accent11())
            .text(TextStyler().color(FortalTokens.accent11())),
      );
}

RemixSelectMenuItemStyle _fortalSelectMenuItemGhostStyle([
  FortalSelectSize size = .size2,
]) {
  return _fortalSelectMenuItemBaseStyle(size)
      .color(Colors.transparent)
      .text(TextStyler().color(FortalTokens.gray12()))
      .onHovered(
        RemixSelectMenuItemStyle()
            .color(FortalTokens.grayA2())
            .text(TextStyler().color(FortalTokens.gray12())),
      );
}

RemixSelectMenuItemStyle _fortalSelectMenuItemSizeStyle(FortalSelectSize size) {
  return switch (size) {
    .size1 => RemixSelectMenuItemStyle().paddingX(6.0).height(20.0),
    .size2 => RemixSelectMenuItemStyle().paddingX(8.0).height(24.0),
    .size3 => RemixSelectMenuItemStyle().paddingX(10.0).height(28.0),
  };
}
