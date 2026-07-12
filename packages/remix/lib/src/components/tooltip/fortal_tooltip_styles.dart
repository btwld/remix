part of 'tooltip.dart';

/// Fortal-themed preset for [RemixTooltip].
@MixWidget(name: 'FortalTooltip')
RemixTooltipStyler fortalTooltipStyler() {
  return RemixTooltipStyler()
      .borderRadiusAll(FortalTokens.radius2())
      .paddingY(FortalTokens.space2())
      .paddingX(FortalTokens.space2())
      .marginY(FortalTokens.space1())
      .wrap(
        .defaultTextStyle(style: TextStyleMix().color(FortalTokens.gray1())),
      )
      .backgroundColor(FortalTokens.gray11());
}
