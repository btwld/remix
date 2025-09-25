part of 'accordion.dart';

class FortalAccordionTheme {
  static RemixAccordionStyle accordion = RemixAccordionStyle(
    container: FlexBoxStyler()
        .direction(Axis.vertical)
        .spacing(FortalTokens.space1()),
    item: RemixAccordionItemStyle(
      trigger: FlexBoxStyler()
          .direction(Axis.horizontal)
          .mainAxisAlignment(MainAxisAlignment.spaceBetween)
          .crossAxisAlignment(CrossAxisAlignment.center)
          .paddingX(FortalTokens.space3())
          .paddingY(FortalTokens.space3())
          .borderRadiusAll(FortalTokens.radius2())
          .borderAll(width: FortalTokens.borderWidth1(), color: FortalTokens.gray6())
          .color(FortalTokens.gray1()),
      title: TextStyler()
          .fontSize(15)
          .fontWeight(FontWeight.w500)
          .color(FortalTokens.gray12()),
      icon: IconStyler()
          .color(FortalTokens.gray11())
          .size(20),
      content: BoxStyler(
        padding: EdgeInsetsMix.all(FortalTokens.space3()),
        decoration: BoxDecorationMix(
          borderRadius: BorderRadiusMix.all(FortalTokens.radius2()),
          border: BorderMix.all(
            BorderSideMix(
              width: FortalTokens.borderWidth1(),
              color: FortalTokens.gray6(),
            ),
          ),
          color: FortalTokens.gray2(),
        ),
      ),
    ),
  );
}