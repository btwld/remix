import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'toggle_group.g.dart';

/// The sizes a toggle group comes in. Pixel values are at 100% theme scaling.
enum UiToggleGroupSize {
  /// 12px text with 8px by 4px item padding.
  size1,

  /// 14px text with 12px by 8px item padding. The default.
  size2,

  /// 16px text with 16px by 8px item padding.
  size3,
}

/// The looks a toggle group's selected item comes in.
enum UiToggleGroupVariant {
  /// An accent tint behind the selected item.
  soft,

  /// A faint accent surface behind the selected item.
  surface,
}

/// The Ui ToggleGroup recipe: a segmented control, a 1px gray frame around
/// items that share it.
///
/// It reads top to bottom: the frame, the item's colors for rest, hover,
/// press, selected, focus and disabled, then the size.
///
/// [highContrast] moves the selected item's label and icon to accent step 12.
@MixWidget(target: RemixToggleGroup.new)
ToggleGroupStyler uiToggleGroupStyle({
  UiToggleGroupVariant variant = .soft,
  UiToggleGroupSize size = .size2,
  bool highContrast = false,
  ToggleGroupStyler style = const ToggleGroupStyler.create(),
}) {
  final (selected, selectedHover, selectedPressed) = switch (variant) {
    .soft => (UiTokens.accent3(), UiTokens.accent4(), UiTokens.accent5()),
    .surface => (
      UiTokens.accentSurface(),
      UiTokens.accentA4(),
      UiTokens.accentA5(),
    ),
  };
  final selectedContent = highContrast
      ? UiTokens.accent12()
      : UiTokens.accentContent();

  return ToggleGroupStyler(
    container: FlexBoxStyler(
      decoration: BoxDecorationMix(
        border: BorderMix.all(
          BorderSideMix(
            color: UiTokens.gray7(),
            width: UiTokens.borderWidth1(),
          ),
        ),
        color: UiTokens.colorSurface(),
      ),
      mainAxisSize: .min,
      spacing: UiTokens.space1(),
    ),
    item: ToggleGroupItemStyler()
        .wrap(uiTouchTarget())
        .alignment(.center)
        .labelColor(UiTokens.gray11())
        .iconColor(UiTokens.gray11())
        .labelFontWeight(UiTokens.fontWeightMedium())
        .onHovered(.color(UiTokens.grayA3()))
        .onPressed(.color(UiTokens.grayA4()))
        .onSelected(
          ToggleGroupItemStyler()
              .color(selected)
              .labelColor(selectedContent)
              .iconColor(selectedContent)
              .onHovered(.color(selectedHover))
              .onPressed(.color(selectedPressed)),
        )
        .onFocusVisible(.containerEffects(uiFocusOutline()))
        .onDisabled(
          ToggleGroupItemStyler()
              .containerEffects(.outline(.style(.none)))
              .color(UiTokens.grayA3())
              .labelColor(UiTokens.gray8())
              .iconColor(UiTokens.gray8()),
        ),
  ).merge(_scale(size)).merge(style);
}

/// The corner, item padding, text and icon size of each step.
ToggleGroupStyler _scale(UiToggleGroupSize size) => switch (size) {
  .size1 => ToggleGroupStyler(
    container: FlexBoxStyler().borderRadius(.all(UiTokens.radius2())),
    item: .container(
      FlexBoxStyler()
          .padding(.horizontal(UiTokens.space2()))
          .padding(.vertical(UiTokens.space1()))
          .spacing(UiTokens.space1()),
    ).label(.style(UiTokens.text1.mix())).icon(.size(UiTokens.space3())),
  ),
  .size2 => ToggleGroupStyler(
    container: FlexBoxStyler().borderRadius(.all(UiTokens.radius2())),
    item: .container(
      FlexBoxStyler()
          .padding(.horizontal(UiTokens.space3()))
          .padding(.vertical(UiTokens.space2()))
          .spacing(UiTokens.space1()),
    ).label(.style(UiTokens.text2.mix())).icon(.size(UiTokens.space4())),
  ),
  .size3 => ToggleGroupStyler(
    container: FlexBoxStyler().borderRadius(.all(UiTokens.radius3())),
    item: .container(
      FlexBoxStyler()
          .padding(.horizontal(UiTokens.space4()))
          .padding(.vertical(UiTokens.space2()))
          .spacing(UiTokens.space2()),
    ).label(.style(UiTokens.text3.mix())).icon(.size(UiTokens.spinnerSize3())),
  ),
};
