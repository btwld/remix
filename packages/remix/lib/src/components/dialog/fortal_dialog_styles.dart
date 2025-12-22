part of 'dialog.dart';

/// FortalDialogStyles utility class for creating Fortal-themed dialog styles.
///
/// Provides static methods for accessing dialog styles configured with
/// Fortal design tokens.
class FortalDialogStyles {
  const FortalDialogStyles._();

  /// Factory constructor for FortalDialogStyles.
  ///
  /// Returns a RemixDialogStyle configured with Fortal design tokens.
  static RemixDialogStyle create() {
    return base();
  }

  static RemixDialogStyle base() {
    return RemixDialogStyle.create()
        .title(
          TextStyler()
              .fontSize(18)
              .fontWeight(FontWeight.w600)
              .color(FortalTokens.gray12())
              .wrap(
                WidgetModifierConfig.padding(
                  EdgeInsetsMix.fromLTRB(0, 0, 0, FortalTokens.space4()),
                ),
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
        .overlay(
          BoxStyler().decoration(
            BoxDecorationMix().color(FortalTokens.blackA7()),
          ),
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
        .color(FortalTokens.gray1())
        .shadow(
          BoxShadowMix()
              .color(FortalTokens.blackA3())
              .offset(x: 0, y: 8)
              .blurRadius(16)
              .spreadRadius(0),
        );
  }
}
