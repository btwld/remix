part of 'dialog.dart';

class FortalDialogTheme {
  static RemixDialogStyle dialog = RemixDialogStyle(
    container: BoxStyler(
      padding: EdgeInsetsMix.all(FortalTokens.space5()),
      constraints: BoxConstraintsMix(maxWidth: 450),
      decoration: BoxDecorationMix(
        border: BorderMix.all(
          BorderSideMix(
            color: FortalTokens.gray6(),
            width: FortalTokens.borderWidth1(),
          ),
        ),
        borderRadius: BorderRadiusMix.all(FortalTokens.radius3()),
        color: FortalTokens.gray1(),
        boxShadow: [
          BoxShadowMix(
            color: FortalTokens.blackA7(),
            offset: const Offset(0, 16),
            blurRadius: 32,
            spreadRadius: 0,
          ),
          BoxShadowMix(
            color: FortalTokens.blackA3(),
            offset: const Offset(0, 0),
            blurRadius: 0,
            spreadRadius: 1,
          ),
        ],
      ),
    ),
    title: TextStyler()
        .fontSize(18)
        .fontWeight(FontWeight.w600)
        .color(FortalTokens.gray12()),
    description: TextStyler().fontSize(14).color(FortalTokens.gray11()),
    actions: FlexBoxStyler()
        .mainAxisAlignment(MainAxisAlignment.end)
        .crossAxisAlignment(CrossAxisAlignment.center)
        .spacing(FortalTokens.space3()),
    overlay: BoxStyler(
      decoration: BoxDecorationMix(color: FortalTokens.blackA7()),
    ),
  );
}
