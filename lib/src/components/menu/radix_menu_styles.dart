part of 'menu.dart';

class FortalMenuTheme {
  static RemixMenuStyle menu = RemixMenuStyle(
    trigger: RemixMenuTriggerStyle()
        .padding(
          EdgeInsetsMix.symmetric(
            vertical: FortalTokens.space2(),
            horizontal: FortalTokens.space3(),
          ),
        )
        .borderRadius(BorderRadiusMix.all(FortalTokens.radius2()))
        .decoration(
          BoxDecorationMix(
            border: BorderMix.all(
              BorderSideMix(
                color: FortalTokens.gray7(),
                width: FortalTokens.borderWidth1(),
              ),
            ),
            color: FortalTokens.gray1(),
          ),
        )
        .label(
          TextStyler(
            style: TextStyleMix(
              color: FortalTokens.gray12(),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
        .icon(IconStyler(color: FortalTokens.gray11(), size: 16)),
    overlay: FlexBoxStyler(
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
    ),
    item: RemixMenuItemStyle()
        .padding(
          EdgeInsetsMix.symmetric(
            vertical: FortalTokens.space2(),
            horizontal: FortalTokens.space2(),
          ),
        )
        .borderRadius(BorderRadiusMix.all(FortalTokens.radius2()))
        .label(
          TextStyler(
            style: TextStyleMix(color: FortalTokens.gray12(), fontSize: 14),
          ),
        )
        .leadingIcon(IconStyler(color: FortalTokens.gray11(), size: 16))
        .trailingIcon(IconStyler(color: FortalTokens.gray11(), size: 16)),
    divider: RemixDividerStyle()
        .margin(EdgeInsetsMix.symmetric(vertical: FortalTokens.space1()))
        .height(FortalTokens.borderWidth1())
        .textColor(FortalTokens.gray6()),
  );
}
