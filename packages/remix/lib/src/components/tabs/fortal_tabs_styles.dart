part of 'tabs.dart';

/// Creates a Fortal-themed [RemixTabBarStyler].
@MixWidget(name: 'FortalTabBar')
RemixTabBarStyler fortalTabBarStyler() {
  return RemixTabBarStyler().container(
    FlexBoxStyler()
        .direction(.horizontal)
        .spacing(FortalTokens.space1())
        .mainAxisSize(.min),
  );
}

/// Creates a Fortal-themed [RemixTabViewStyler].
@MixWidget(name: 'FortalTabView')
RemixTabViewStyler fortalTabViewStyler() {
  return RemixTabViewStyler().paddingAll(FortalTokens.space3());
}

/// Creates a Fortal-themed [RemixTabStyler].
@MixWidget(name: 'FortalTab')
RemixTabStyler fortalTabStyler() {
  return RemixTabStyler()
      .label(TextStyler().color(FortalTokens.gray12()))
      .icon(IconStyler(color: FortalTokens.gray12(), size: 16.0))
      .wrap(
        WidgetModifierConfig.box(
          BoxStyler()
              .height(40)
              .paddingX(4)
              .alignment(.center)
              .borderBottom(
                color: Colors.transparent,
                width: FortalTokens.borderWidth2(),
              ),
        ),
      )
      .container(
        FlexBoxStyler()
            .direction(.horizontal)
            .borderRadiusAll(FortalTokens.radius2())
            .mainAxisAlignment(.center)
            .crossAxisAlignment(.center)
            .spacing(8.0),
      )
      .onHovered(RemixTabStyler().color(FortalTokens.gray3()))
      .onSelected(
        RemixTabStyler()
            .label(TextStyler().fontWeight(FortalTokens.fontWeightMedium()))
            .wrap(
              WidgetModifierConfig.box(
                BoxStyler().borderBottom(color: FortalTokens.accent9()),
              ),
            ),
      )
      .padding(EdgeInsetsMix.symmetric(vertical: 6.0, horizontal: 12.0));
}
