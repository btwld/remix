part of 'select.dart';

/// Fortal select size presets.
enum FortalSelectSize {
  /// Compact select.
  size1,

  /// Default select.
  size2,

  /// Large select.
  size3,
}

/// Fortal select color and emphasis variants.
enum FortalSelectVariant {
  /// Surface-backed trigger with border.
  surface,

  /// Soft accent trigger.
  soft,

  /// Transparent trigger.
  ghost,
}

/// Fortal-themed preset for [RemixSelect].
@MixWidget(
  name: 'FortalSelect',
  target: RemixSelect.new,
  factoryParameters: .only({'variant', 'size'}),
)
RemixSelectStyler fortalSelectStyler({
  FortalSelectVariant variant = .surface,
  FortalSelectSize size = .size2,
}) {
  return switch (variant) {
    .surface => _fortalSelectSurfaceStyler(size),
    .soft => _fortalSelectSoftStyler(size),
    .ghost => _fortalSelectGhostStyler(size),
  };
}

RemixSelectStyler _fortalSelectBaseStyler(
  FortalSelectVariant variant,
  FortalSelectSize size,
) {
  return RemixSelectStyler()
      .trigger(
        RemixSelectTriggerStyler()
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
      .item(fortalSelectMenuItemStyler(variant: variant, size: size))
      .onFocused(
        RemixSelectStyler().trigger(
          RemixSelectTriggerStyler().borderAll(
            color: FortalTokens.focusA8(),
            width: FortalTokens.focusRingWidth(),
          ),
        ),
      )
      .merge(_fortalSelectSizeStyler(size));
}

RemixSelectStyler _fortalSelectSurfaceStyler([FortalSelectSize size = .size2]) {
  return _fortalSelectBaseStyler(.surface, size).trigger(
    RemixSelectTriggerStyler()
        .color(FortalTokens.colorSurface())
        .borderAll(
          color: FortalTokens.gray6(),
          width: FortalTokens.borderWidth1(),
        ),
  );
}

RemixSelectStyler _fortalSelectSoftStyler([FortalSelectSize size = .size2]) {
  return _fortalSelectBaseStyler(.soft, size).trigger(
    RemixSelectTriggerStyler()
        .color(FortalTokens.accent3())
        .label(TextStyler().color(FortalTokens.accent11()))
        .icon(IconStyler(color: FortalTokens.accent11(), size: 16.0)),
  );
}

RemixSelectStyler _fortalSelectGhostStyler([FortalSelectSize size = .size2]) {
  return _fortalSelectBaseStyler(
    .ghost,
    size,
  ).trigger(RemixSelectTriggerStyler().color(Colors.transparent).paddingY(6.0));
}

RemixSelectStyler _fortalSelectSizeStyler(FortalSelectSize size) {
  return switch (size) {
    .size1 => RemixSelectStyler().trigger(
      RemixSelectTriggerStyler().paddingX(8.0).height(24.0),
    ),
    .size2 => RemixSelectStyler().trigger(
      RemixSelectTriggerStyler().paddingX(12.0).height(32.0),
    ),
    .size3 => RemixSelectStyler().trigger(
      RemixSelectTriggerStyler().paddingX(16.0).height(40.0),
    ),
  };
}

/// Creates a Fortal-themed [RemixSelectMenuItemStyler].
RemixSelectMenuItemStyler fortalSelectMenuItemStyler({
  FortalSelectVariant variant = .surface,
  FortalSelectSize size = .size2,
}) {
  return switch (variant) {
    .surface => _fortalSelectMenuItemSurfaceStyler(size),
    .soft => _fortalSelectMenuItemSoftStyler(size),
    .ghost => _fortalSelectMenuItemGhostStyler(size),
  };
}

RemixSelectMenuItemStyler _fortalSelectMenuItemBaseStyler(
  FortalSelectSize size,
) {
  return RemixSelectMenuItemStyler()
      .icon(IconStyler(size: 16.0))
      .borderRadiusAll(FortalTokens.radius2())
      .merge(_fortalSelectMenuItemSizeStyler(size));
}

RemixSelectMenuItemStyler _fortalSelectMenuItemSurfaceStyler([
  FortalSelectSize size = .size2,
]) {
  return _fortalSelectMenuItemBaseStyler(size)
      .color(Colors.transparent)
      .text(TextStyler().color(FortalTokens.gray12()))
      .onHovered(
        RemixSelectMenuItemStyler()
            .color(FortalTokens.grayA3())
            .text(TextStyler().color(FortalTokens.gray12())),
      );
}

RemixSelectMenuItemStyler _fortalSelectMenuItemSoftStyler([
  FortalSelectSize size = .size2,
]) {
  return _fortalSelectMenuItemBaseStyler(size)
      .color(Colors.transparent)
      .text(TextStyler().color(FortalTokens.gray12()))
      .onHovered(
        RemixSelectMenuItemStyler()
            .color(FortalTokens.accentA3())
            .iconColor(FortalTokens.accent11())
            .text(TextStyler().color(FortalTokens.accent11())),
      );
}

RemixSelectMenuItemStyler _fortalSelectMenuItemGhostStyler([
  FortalSelectSize size = .size2,
]) {
  return _fortalSelectMenuItemBaseStyler(size)
      .color(Colors.transparent)
      .text(TextStyler().color(FortalTokens.gray12()))
      .onHovered(
        RemixSelectMenuItemStyler()
            .color(FortalTokens.grayA2())
            .text(TextStyler().color(FortalTokens.gray12())),
      );
}

RemixSelectMenuItemStyler _fortalSelectMenuItemSizeStyler(
  FortalSelectSize size,
) {
  return switch (size) {
    .size1 => RemixSelectMenuItemStyler().paddingX(6.0).height(20.0),
    .size2 => RemixSelectMenuItemStyler().paddingX(8.0).height(24.0),
    .size3 => RemixSelectMenuItemStyler().paddingX(10.0).height(28.0),
  };
}

/// Fortal-themed preset for [RemixSelect].
