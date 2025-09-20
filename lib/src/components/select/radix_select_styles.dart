part of 'select.dart';

/// Fortal select styles for trigger and menu content.
class FortalSelectStyles {
  const FortalSelectStyles._();

  // Trigger variants

  static RemixSelectStyle triggerClassic() {
    return RemixSelectStyle()
        .trigger(
          RemixSelectTriggerStyle()
              // Use standard trigger padding X = space-3 (12px), Y = space-2 (8px)
              .paddingY(8.0)
              .paddingX(12.0)
              // Per JSON: select-trigger-height = space-7 (28px)
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

  static RemixSelectStyle triggerSurface() {
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

  static RemixSelectStyle triggerSoft() {
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

  static RemixSelectStyle triggerGhost() {
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

  // Content (menu) variants

  static RemixSelectStyle contentSolid() {
    return RemixSelectStyle()
        .menuContainer(
          BoxStyler()
              .color(FortalTokens.colorPanelSolid())
              .borderAll(
                color: FortalTokens.gray6(),
                width: FortalTokens.borderWidth1(),
              )
              .borderRadiusAll(FortalTokens.radius3())
              .paddingAll(8.0),
        )
        .item(
          RemixSelectMenuItemStyle()
              .paddingX(8.0)
              .height(24.0)
              .text(TextStyler().color(FortalTokens.gray12()))
              .icon(IconStyler(size: 20.0)),
        );
  }

  static RemixSelectStyle contentSoft() {
    return RemixSelectStyle()
        .menuContainer(
          BoxStyler()
              .color(FortalTokens.colorPanelTranslucent())
              .borderAll(
                color: FortalTokens.gray6(),
                width: FortalTokens.borderWidth1(),
              )
              .borderRadiusAll(FortalTokens.radius3())
              .paddingAll(8.0),
        )
        .item(
          RemixSelectMenuItemStyle()
              .paddingX(8.0)
              .height(24.0)
              .text(TextStyler().color(FortalTokens.gray12()))
              .icon(IconStyler(size: 20.0)),
        );
  }
}
