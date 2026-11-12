import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'toggle_group.g.dart';

/// The sizes a toggle group comes in. Pixel values are at 100% theme scaling.
enum FortalToggleGroupSize {
  /// 12px text with 8px by 4px item padding.
  size1,

  /// 14px text with 12px by 8px item padding. The default.
  size2,

  /// 16px text with 16px by 8px item padding.
  size3,
}

/// The looks a toggle group's selected item comes in.
enum FortalToggleGroupVariant {
  /// An accent tint behind the selected item.
  soft,

  /// A faint accent surface behind the selected item.
  surface,
}

/// The Fortal ToggleGroup recipe: a segmented control, a 1px gray frame around
/// items that share it.
///
/// It reads top to bottom: the frame, the item's colors for rest, hover,
/// press, selected, focus and disabled, then the size.
///
/// [highContrast] moves the selected item's label and icon to accent step 12.
@MixWidget(target: RemixToggleGroup.new)
ToggleGroupStyler fortalToggleGroupStyle({
  FortalToggleGroupVariant variant = .soft,
  FortalToggleGroupSize size = .size2,
  bool highContrast = false,
  ToggleGroupStyler style = const ToggleGroupStyler.create(),
}) {
  final (selected, selectedHover, selectedPressed) = switch (variant) {
    .soft => (
      FortalTokens.accent3(),
      FortalTokens.accent4(),
      FortalTokens.accent5(),
    ),
    .surface => (
      FortalTokens.accentSurface(),
      FortalTokens.accentA4(),
      FortalTokens.accentA5(),
    ),
  };
  final selectedContent = highContrast
      ? FortalTokens.accent12()
      : FortalTokens.accentContent();

  return ToggleGroupStyler(
    container: FlexBoxStyler(
      decoration: BoxDecorationMix(
        border: BorderMix.all(
          BorderSideMix(
            color: FortalTokens.gray7(),
            width: FortalTokens.borderWidth1(),
          ),
        ),
        color: FortalTokens.colorSurface(),
      ),
      mainAxisSize: .min,
      spacing: FortalTokens.space1(),
    ),
    item: ToggleGroupItemStyler()
        .wrap(fortalTouchTarget())
        .alignment(.center)
        .labelColor(FortalTokens.gray11())
        .iconColor(FortalTokens.gray11())
        .labelFontWeight(FortalTokens.fontWeightMedium())
        .onHovered(.color(FortalTokens.grayA3()))
        .onPressed(.color(FortalTokens.grayA4()))
        .onSelected(
          ToggleGroupItemStyler()
              .color(selected)
              .labelColor(selectedContent)
              .iconColor(selectedContent)
              .onHovered(.color(selectedHover))
              .onPressed(.color(selectedPressed)),
        )
        .onFocusVisible(.containerEffects(fortalFocusOutline()))
        .onDisabled(
          ToggleGroupItemStyler()
              .containerEffects(.outline(.style(.none)))
              .color(FortalTokens.grayA3())
              .labelColor(FortalTokens.gray8())
              .iconColor(FortalTokens.gray8()),
        ),
  ).merge(_scale(size)).merge(style);
}

/// The corner, item padding, text and icon size of each step.
ToggleGroupStyler _scale(FortalToggleGroupSize size) => switch (size) {
  .size1 => ToggleGroupStyler(
    container: FlexBoxStyler().borderRadius(.all(FortalTokens.radius2())),
    item:
        .container(
              FlexBoxStyler()
                  .padding(.horizontal(FortalTokens.space2()))
                  .padding(.vertical(FortalTokens.space1()))
                  .spacing(FortalTokens.space1()),
            )
            .label(.style(FortalTokens.text1.mix()))
            .icon(.size(FortalTokens.space3())),
  ),
  .size2 => ToggleGroupStyler(
    container: FlexBoxStyler().borderRadius(.all(FortalTokens.radius2())),
    item:
        .container(
              FlexBoxStyler()
                  .padding(.horizontal(FortalTokens.space3()))
                  .padding(.vertical(FortalTokens.space2()))
                  .spacing(FortalTokens.space1()),
            )
            .label(.style(FortalTokens.text2.mix()))
            .icon(.size(FortalTokens.space4())),
  ),
  .size3 => ToggleGroupStyler(
    container: FlexBoxStyler().borderRadius(.all(FortalTokens.radius3())),
    item:
        .container(
              FlexBoxStyler()
                  .padding(.horizontal(FortalTokens.space4()))
                  .padding(.vertical(FortalTokens.space2()))
                  .spacing(FortalTokens.space2()),
            )
            .label(.style(FortalTokens.text3.mix()))
            .icon(.size(FortalTokens.spinnerSize3())),
  ),
};
