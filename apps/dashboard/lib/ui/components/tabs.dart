import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'tabs.g.dart';

/// The sizes a tab comes in. Pixel values are at 100% theme scaling.
enum UiTabsSize {
  /// 32px tall, with 12px text.
  size1,

  /// 40px tall, with 14px text. The default.
  size2,
}

/// The Ui TabBar recipe: the row of tabs over a 1px gray line.
@MixWidget(target: RemixTabBar.new)
TabBarStyler uiTabBarStyle({
  TabBarStyler style = const TabBarStyler.create(),
}) => TabBarStyler()
    .border(.bottom(.color(UiTokens.grayA5()).width(UiTokens.borderWidth1())))
    .merge(style);

/// The Ui TabView recipe: the panel under the tabs, which it leaves
/// unstyled.
@MixWidget(target: RemixTabView.new)
TabViewStyler uiTabViewStyle({
  TabViewStyler style = const TabViewStyler.create(),
}) => TabViewStyler().merge(style);

/// The Ui Tab recipe.
///
/// A tab is gray text, darker under the pointer, with a 2px underline in the
/// accent when selected. The underline is a transparent border at rest, so
/// selecting a tab does not move it. The selected label is medium weight, and
/// its letter spacing is adjusted so the bolder label keeps its width.
///
/// [highContrast] moves the underline to accent step 12.
@MixWidget(target: RemixTab.new)
TabStyler uiTabStyle({
  UiTabsSize size = UiTabsSize.size2,
  bool highContrast = false,
  TabStyler style = const TabStyler.create(),
}) {
  final metrics = switch (size) {
    UiTabsSize.size1 => (
      height: UiTokens.space6(),
      outerPaddingX: UiTokens.space1(),
      innerPaddingX: UiTokens.space1(),
      innerPaddingY: UiTokens.tabInnerPaddingY1(),
      radius: UiTokens.radius1(),
      text: UiTokens.text1.mix(),
      activeLetterSpacing: UiTokens.tabActiveLetterSpacing1(),
    ),
    UiTabsSize.size2 => (
      height: UiTokens.space7(),
      outerPaddingX: UiTokens.space2(),
      innerPaddingX: UiTokens.space2(),
      innerPaddingY: UiTokens.space1(),
      radius: UiTokens.radius2(),
      text: UiTokens.text2.mix(),
      activeLetterSpacing: UiTokens.tabActiveLetterSpacing2(),
    ),
  };

  return TabStyler()
      .label(.style(metrics.text).letterSpacing(0.0).color(UiTokens.grayA11()))
      .icon(.color(UiTokens.grayA11()).size(UiTokens.space4()))
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
                  ).width(UiTokens.borderWidth2()),
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
            .spacing(UiTokens.space2()),
      )
      .onHovered(
        .label(.color(UiTokens.gray12()))
            .icon(.color(UiTokens.gray12()))
            .color(UiTokens.grayA3())
            .onFocusVisible(.color(UiTokens.accentA3())),
      )
      .onFocusVisible(.containerEffects(uiFocusOutline()))
      .onSelected(
        .label(
              .color(UiTokens.gray12())
                  .fontWeight(UiTokens.fontWeightMedium())
                  .letterSpacing(metrics.activeLetterSpacing),
            )
            .icon(.color(UiTokens.gray12()))
            .wrap(
              .box(
                BoxStyler().border(
                  .bottom(
                    .color(
                      highContrast
                          ? UiTokens.accent12()
                          : UiTokens.accentIndicator(),
                    ).width(UiTokens.borderWidth2()),
                  ),
                ),
              ),
            ),
      )
      .wrap(uiTouchTarget())
      .onDisabled(.containerEffects(.outline(.style(.none))))
      .merge(style);
}
