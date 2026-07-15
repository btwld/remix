part of 'popover.dart';

/// Fortal-themed preset for [RemixPopover].
@MixWidget(name: 'FortalPopover')
RemixPopoverStyler fortalPopoverStyler() {
  return RemixPopoverStyler()
      .paddingAll(FortalTokens.space4())
      .marginTop(FortalTokens.space2())
      .constraints(BoxConstraintsMix(maxWidth: 360))
      .borderAll(
        color: FortalTokens.gray6(),
        width: FortalTokens.borderWidth1(),
      )
      .borderRadiusAll(FortalTokens.radius3())
      .backgroundColor(FortalTokens.gray1())
      .shadow(
        BoxShadowMix()
            .color(FortalTokens.blackA3())
            .offset(x: 0, y: 4)
            .blurRadius(12)
            .spreadRadius(0),
      );
}
