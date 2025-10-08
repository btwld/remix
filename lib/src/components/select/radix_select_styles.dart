// ignore_for_file: unused_element

part of 'select.dart';

/// Enum for select style variants.
enum FortalSelectVariant { classic, surface, soft, ghost }

/// Style class holding trigger, content, and items styles.
class FortalSelectStyle {
  final RemixSelectStyle select;
  final RemixSelectMenuItemStyle items;

  const FortalSelectStyle._({required this.select, required this.items});

  /// Factory to create style based on variant.
  factory FortalSelectStyle(FortalSelectVariant variant) {
    switch (variant) {
      case FortalSelectVariant.classic:
        return FortalSelectStyle._(
          select: _selectClassic(),
          items: _itemSolid(),
        );
      case FortalSelectVariant.surface:
        return FortalSelectStyle._(
          select: _selectSurface(),
          items: _itemSolid(),
        );
      case FortalSelectVariant.soft:
        return FortalSelectStyle._(select: _selectSoft(), items: _itemSoft());
      case FortalSelectVariant.ghost:
        return FortalSelectStyle._(select: _selectGhost(), items: _itemSolid());
    }
  }

  // Private static style builders for each variant

  static RemixSelectStyle _selectClassic() {
    return RemixSelectStyle()
        .trigger(
          RemixSelectTriggerStyle()
              .paddingY(8.0)
              .paddingX(12.0)
              .height(28.0)
              .direction(Axis.horizontal)
              .mainAxisAlignment(MainAxisAlignment.spaceBetween)
              .crossAxisAlignment(CrossAxisAlignment.center)
              .color(FortalTokens.colorSurface())
              .borderAll(
                color: FortalTokens.gray7(),
                width: FortalTokens.borderWidth1(),
              )
              .borderRadiusAll(FortalTokens.radius3())
              .label(TextStyler().color(FortalTokens.gray12()))
              .icon(IconStyler(color: FortalTokens.gray12(), size: 16.0)),
        )
        .onHovered(
          RemixSelectStyle().trigger(
            RemixSelectTriggerStyle().borderAll(
              color: FortalTokens.gray8(),
              width: FortalTokens.borderWidth1(),
            ),
          ),
        )
        .onFocused(
          RemixSelectStyle().trigger(
            RemixSelectTriggerStyle().borderAll(
              color: FortalTokens.focusA8(),
              width: FortalTokens.focusRingWidth(),
            ),
          ),
        );
  }

  static RemixSelectStyle _selectSurface() {
    return RemixSelectStyle()
        .trigger(
          RemixSelectTriggerStyle()
              .paddingY(8.0)
              .paddingX(12.0)
              .height(28.0)
              .direction(Axis.horizontal)
              .mainAxisAlignment(MainAxisAlignment.spaceBetween)
              .crossAxisAlignment(CrossAxisAlignment.center)
              .color(FortalTokens.colorSurface())
              .borderAll(
                color: FortalTokens.gray6(),
                width: FortalTokens.borderWidth1(),
              )
              .borderRadiusAll(FortalTokens.radius3())
              .label(TextStyler().color(FortalTokens.gray12()))
              .icon(IconStyler(color: FortalTokens.gray12(), size: 16.0)),
        )
        .onFocused(
          RemixSelectStyle().trigger(
            RemixSelectTriggerStyle().borderAll(
              color: FortalTokens.focusA8(),
              width: FortalTokens.focusRingWidth(),
            ),
          ),
        );
  }

  static RemixSelectStyle _selectSoft() {
    return RemixSelectStyle()
        .trigger(
          RemixSelectTriggerStyle()
              .paddingY(8.0)
              .paddingX(12.0)
              .height(28.0)
              .direction(Axis.horizontal)
              .mainAxisAlignment(MainAxisAlignment.spaceBetween)
              .crossAxisAlignment(CrossAxisAlignment.center)
              .color(FortalTokens.accent3())
              .borderAll(
                color: FortalTokens.accent6(),
                width: FortalTokens.borderWidth1(),
              )
              .borderRadiusAll(FortalTokens.radius3())
              .label(TextStyler().color(FortalTokens.accent11()))
              .icon(IconStyler(color: FortalTokens.accent11(), size: 16.0)),
        )
        .onFocused(
          RemixSelectStyle().trigger(
            RemixSelectTriggerStyle().borderAll(
              color: FortalTokens.focusA8(),
              width: FortalTokens.focusRingWidth(),
            ),
          ),
        );
  }

  static RemixSelectStyle _selectGhost() {
    return RemixSelectStyle()
        .trigger(
          RemixSelectTriggerStyle()
              .paddingY(6.0)
              .paddingX(12.0)
              .height(28.0)
              .direction(Axis.horizontal)
              .mainAxisAlignment(MainAxisAlignment.spaceBetween)
              .crossAxisAlignment(CrossAxisAlignment.center)
              .color(Colors.transparent)
              .borderRadiusAll(FortalTokens.radius3())
              .label(TextStyler().color(FortalTokens.gray12()))
              .icon(IconStyler(color: FortalTokens.gray12(), size: 16.0)),
        )
        .onFocused(
          RemixSelectStyle().trigger(
            RemixSelectTriggerStyle().borderAll(
              color: FortalTokens.focusA8(),
              width: FortalTokens.focusRingWidth(),
            ),
          ),
        );
  }

  static RemixSelectStyle _contentSolid() {
    return RemixSelectStyle().menuContainer(
      FlexBoxStyler()
          .color(FortalTokens.colorPanelSolid())
          .borderAll(
            color: FortalTokens.gray6(),
            width: FortalTokens.borderWidth1(),
          )
          .borderRadiusAll(FortalTokens.radius3())
          .padding(EdgeInsetsMix.all(8.0)),
    );
  }

  static RemixSelectMenuItemStyle _itemSolid() {
    return RemixSelectMenuItemStyle()
        .paddingX(8.0)
        .height(24.0)
        .text(TextStyler().color(FortalTokens.gray12()))
        .icon(IconStyler(size: 20.0));
  }

  static RemixSelectStyle _contentSoft() {
    return RemixSelectStyle().menuContainer(
      FlexBoxStyler()
          .color(FortalTokens.colorPanelTranslucent())
          .borderAll(
            color: FortalTokens.gray6(),
            width: FortalTokens.borderWidth1(),
          )
          .borderRadiusAll(FortalTokens.radius3())
          .padding(EdgeInsetsMix.all(8.0)),
    );
  }

  static RemixSelectMenuItemStyle _itemSoft() {
    return RemixSelectMenuItemStyle()
        .paddingX(8.0)
        .height(24.0)
        .text(TextStyler().color(FortalTokens.gray12()))
        .icon(IconStyler(size: 20.0));
  }
}
