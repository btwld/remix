part of 'dialog.dart';

/// Fortal-themed preset for [RemixDialog].
@MixWidget(name: 'FortalDialog')
RemixDialogStyler fortalDialogStyler() {
  return RemixDialogStyler()
      .title(
        TextStyler()
            .fontSize(18)
            .fontWeight(.w600)
            .color(FortalTokens.gray12())
            .wrap(
              .padding(EdgeInsetsMix.fromLTRB(0, 0, 0, FortalTokens.space4())),
            ),
      )
      .description(TextStyler().fontSize(14).color(FortalTokens.gray11()))
      .actions(
        FlexBoxStyler()
            .mainAxisAlignment(.end)
            .crossAxisAlignment(.center)
            .spacing(FortalTokens.space3())
            .marginTop(FortalTokens.space5()),
      )
      .padding(.all(FortalTokens.space5()))
      .constraints(BoxConstraintsMix(maxWidth: 450))
      .border(
        .all(
          BorderSideMix()
              .color(FortalTokens.gray6())
              .width(FortalTokens.borderWidth1()),
        ),
      )
      .borderRadius(.all(FortalTokens.radius3()))
      .backgroundColor(FortalTokens.gray1())
      .shadow(
        BoxShadowMix()
            .color(FortalTokens.blackA3())
            .offset(x: 0, y: 8)
            .blurRadius(16)
            .spreadRadius(0),
      );
}
