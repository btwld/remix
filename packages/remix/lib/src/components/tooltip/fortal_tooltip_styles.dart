part of 'tooltip.dart';

RemixTooltipStyle fortalTooltipStyle() {
  return RemixTooltipStyle()
      .borderRadiusAll(FortalTokens.radius2())
      .paddingY(FortalTokens.space2())
      .paddingX(FortalTokens.space2())
      .marginY(FortalTokens.space1())
      .wrap(
        WidgetModifierConfig.defaultTextStyle(
          style: TextStyleMix().color(FortalTokens.gray1()),
        ),
      )
      .color(FortalTokens.gray11());
}
