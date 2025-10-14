part of 'dialog.dart';

/// FortalDialogStyle utility class for creating Fortal-themed dialog styles.
///
/// Provides static methods for accessing dialog styles configured with
/// Fortal design tokens.
class FortalDialogStyle {
  const FortalDialogStyle._();

  /// Factory constructor for FortalDialogStyle.
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
              .wrapPadding(
                EdgeInsetsMix.fromLTRB(0, 0, 0, FortalTokens.space4()),
              ),
        )
        .description(TextStyler().fontSize(14).color(FortalTokens.gray11()))
        .actions(
          FlexBoxStyler()
              .mainAxisAlignment(MainAxisAlignment.end)
              .crossAxisAlignment(CrossAxisAlignment.center)
              .spacing(FortalTokens.space3())
              .marginTop(FortalTokens.space5()),
        )
        .overlay(
          BoxStyler().decoration(
            BoxDecorationMix().color(FortalTokens.blackA7()),
          ),
        )
        .padding(EdgeInsetsMix.all(FortalTokens.space5()))
        .constraints(BoxConstraintsMix(maxWidth: 450))
        .border(
          BorderMix.all(
            BorderSideMix()
                .color(FortalTokens.gray6())
                .width(FortalTokens.borderWidth1()),
          ),
        )
        .borderRadius(BorderRadiusMix.all(FortalTokens.radius3()))
        .color(FortalTokens.gray1())
        .shadow(
          BoxShadowMix()
              .color(FortalTokens.blackA3())
              .offset(const Offset(0, 8))
              .blurRadius(16)
              .spreadRadius(0),
        );
  }
}
