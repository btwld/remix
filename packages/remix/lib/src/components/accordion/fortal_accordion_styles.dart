part of 'accordion.dart';

RemixAccordionStyle fortalAccordionStyle() {
  return RemixAccordionStyle()
      .trigger(
        FlexBoxStyler()
            .direction(.horizontal)
            .paddingX(FortalTokens.space3())
            .paddingY(FortalTokens.space3())
            .color(FortalTokens.gray1()),
      )
      .title(
        TextStyler()
            .fontSize(15)
            .fontWeight(FontWeight.w500)
            .color(FortalTokens.gray12()),
      )
      .trailingIcon(IconStyler().color(FortalTokens.gray11()).size(20))
      .content(
        BoxStyler()
            .width(double.infinity)
            .borderTop(
              color: FortalTokens.gray6(),
              width: FortalTokens.borderWidth1(),
            )
            .color(FortalTokens.gray2())
            .paddingAll(FortalTokens.space3()),
      );
}
