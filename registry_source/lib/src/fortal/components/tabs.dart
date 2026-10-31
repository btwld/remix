import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'tabs.g.dart';

/// Fortal tab-list size presets on the shared scale.
enum FortalTabsSize { size1, size2 }

/// Fortal-themed preset for [RemixTabBar].
@MixWidget(target: RemixTabBar.new)
TabBarStyler fortalTabBarStyle({
  TabBarStyler style = const TabBarStyler.create(),
}) {
  return TabBarStyler()
      .border(
        .bottom(
          .color(FortalTokens.grayA5()).width(FortalTokens.borderWidth1()),
        ),
      )
      .merge(style);
}

/// Fortal-themed preset for [RemixTabView].
@MixWidget(target: RemixTabView.new)
TabViewStyler fortalTabViewStyle({
  TabViewStyler style = const TabViewStyler.create(),
}) => TabViewStyler().merge(style);

/// Fortal-themed preset for [RemixTab].
@MixWidget(target: RemixTab.new)
TabStyler fortalTabStyle({
  FortalTabsSize size = FortalTabsSize.size2,
  bool highContrast = false,
  TabStyler style = const TabStyler.create(),
}) {
  final metrics = switch (size) {
    FortalTabsSize.size1 => (
      height: FortalTokens.space6(),
      outerPaddingX: FortalTokens.space1(),
      innerPaddingX: FortalTokens.space1(),
      innerPaddingY: FortalTokens.tabInnerPaddingY1(),
      radius: FortalTokens.radius1(),
      text: FortalTokens.text1.mix(),
      activeLetterSpacing: FortalTokens.tabActiveLetterSpacing1(),
    ),
    FortalTabsSize.size2 => (
      height: FortalTokens.space7(),
      outerPaddingX: FortalTokens.space2(),
      innerPaddingX: FortalTokens.space2(),
      innerPaddingY: FortalTokens.space1(),
      radius: FortalTokens.radius2(),
      text: FortalTokens.text2.mix(),
      activeLetterSpacing: FortalTokens.tabActiveLetterSpacing2(),
    ),
  };

  return TabStyler()
      .label(
        .style(metrics.text).letterSpacing(0.0).color(FortalTokens.grayA11()),
      )
      .icon(.color(FortalTokens.grayA11()).size(FortalTokens.space4()))
      .wrap(
        .box(
          BoxStyler()
              .height(metrics.height)
              .padding(.horizontal(metrics.outerPaddingX))
              .alignment(.center)
              .border(
                .bottom(
                  .color(
                    const Color(0x00000000),
                  ).width(FortalTokens.borderWidth2()),
                ),
              ),
        ),
      )
      .container(
        .direction(.horizontal)
            .padding(.horizontal(metrics.innerPaddingX))
            .padding(.vertical(metrics.innerPaddingY))
            .borderRadius(.all(metrics.radius))
            .mainAxisAlignment(.center)
            .spacing(FortalTokens.space2()),
      )
      .onHovered(
        .label(.color(FortalTokens.gray12()))
            .icon(.color(FortalTokens.gray12()))
            .color(FortalTokens.grayA3())
            .onFocusVisible(.color(FortalTokens.accentA3())),
      )
      .onFocusVisible(TabStyler().containerEffects(fortalFocusOutline()))
      .onSelected(
        .label(
              .color(FortalTokens.gray12())
                  .fontWeight(FortalTokens.fontWeightMedium())
                  .letterSpacing(metrics.activeLetterSpacing),
            )
            .icon(.color(FortalTokens.gray12()))
            .wrap(
              .box(
                BoxStyler().border(
                  .bottom(
                    .color(
                      highContrast
                          ? FortalTokens.accent12()
                          : FortalTokens.accentIndicator(),
                    ).width(FortalTokens.borderWidth2()),
                  ),
                ),
              ),
            ),
      )
      .wrap(fortalTouchTarget())
      .onDisabled(
        TabStyler().containerEffects(
          RemixBoxEffectsMix(outline: BorderSideMix(style: .none)),
        ),
      )
      .merge(style);
}
