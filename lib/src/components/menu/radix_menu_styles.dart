part of 'menu.dart';

class FortalMenuTheme {
  static RemixMenuStyle menu = RemixMenuStyle(
    trigger: FlexBoxStyler()
        .paddingX(FortalTokens.space3())
        .paddingY(FortalTokens.space2())
        .borderRadiusAll(FortalTokens.radius2())
        .borderAll(
            color: FortalTokens.gray7(), width: FortalTokens.borderWidth1(),)
        .color(FortalTokens.gray1()),
    triggerLabel: TextStyler()
        .fontSize(14)
        .fontWeight(FontWeight.w500)
        .color(FortalTokens.gray12()),
    triggerIcon: IconStyler().color(FortalTokens.gray11()).size(16),
    menuContainer: BoxStyler(
      padding: EdgeInsetsMix.all(FortalTokens.space1()),
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
    ),
    item: RemixMenuItemStyle(
      container: FlexBoxStyler()
          .paddingX(FortalTokens.space2())
          .paddingY(FortalTokens.space1())
          .borderRadiusAll(FortalTokens.radius1()),
      label: TextStyler().fontSize(14).color(FortalTokens.gray12()),
      leadingIcon: IconStyler().color(FortalTokens.gray11()).size(16),
      trailingIcon: IconStyler().color(FortalTokens.gray11()).size(16),
    ),
  );
}
