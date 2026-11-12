import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'tabs.g.dart';

/// The sizes a tab comes in. Pixel values are at 100% theme scaling.
enum FortalTabsSize {
  /// 32px tall, with 12px text.
  size1,

  /// 40px tall, with 14px text. The default.
  size2,
}

/// The Fortal TabBar recipe: the row of tabs over a 1px gray line.
@MixWidget(target: RemixTabBar.new)
TabBarStyler fortalTabBarStyle({
  TabBarStyler style = const TabBarStyler.create(),
}) => TabBarStyler()
    .border(
      .bottom(.color(FortalTokens.grayA5()).width(FortalTokens.borderWidth1())),
    )
    .merge(style);

/// The Fortal TabView recipe: the panel under the tabs, which it leaves
/// unstyled.
@MixWidget(target: RemixTabView.new)
TabViewStyler fortalTabViewStyle({
  TabViewStyler style = const TabViewStyler.create(),
}) => TabViewStyler().merge(style);

/// The Fortal Tab recipe.
///
/// A tab is gray text, darker under the pointer, with a 2px underline in the
/// accent when selected. The underline is a transparent border at rest, so
/// selecting a tab does not move it. The selected label is medium weight, and
/// its letter spacing is adjusted so the bolder label keeps its width.
///
/// [highContrast] moves the underline to accent step 12.
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
      .onFocusVisible(.containerEffects(fortalFocusOutline()))
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
      .onDisabled(.containerEffects(.outline(.style(.none))))
      .merge(style);
}
