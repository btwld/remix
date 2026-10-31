import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'checkbox.g.dart';

/// Ui Checkbox size presets.
enum UiCheckboxSize { size1, size2, size3 }

/// Ui Checkbox variants.
enum UiCheckboxVariant { surface, soft }

/// Ui recipe for [RemixCheckbox].
@MixWidget(target: RemixCheckbox.new)
CheckboxStyler uiCheckboxStyle({
  UiCheckboxVariant variant = .surface,
  UiCheckboxSize size = .size2,
  bool highContrast = false,
  CheckboxStyler style = const CheckboxStyler.create(),
}) {
  final metrics = _uiCheckboxMetrics(size);
  final base = CheckboxStyler(
    container: .size(
      metrics.size,
      metrics.size,
    ).alignment(.center).borderRadius(.all(metrics.radius)),
    indicator: .size(metrics.indicatorSize),
    containerEffects: RemixBoxEffectsMix(
      behindContent: RemixBoxEffectLayerMix(),
      overContent: RemixBoxEffectLayerMix(),
    ),
  ).onFocusVisible(.containerEffects(uiFocusOutline()));

  return (switch (variant) {
        .surface => _uiCheckboxSurface(base, highContrast),
        .soft => _uiCheckboxSoft(base, highContrast),
      })
      .wrap(uiTouchTarget())
      .onDisabled(
        CheckboxStyler().containerEffects(
          RemixBoxEffectsMix(outline: BorderSideMix(style: .none)),
        ),
      )
      .merge(style);
}

/// Ui recipe for [RemixCheckboxGroupItem].
///
///
/// It exists because `RemixCheckboxGroup` is behavioral and carries no styler,
/// so unlike every other Remix item (menu, select, segmented control, toggle
/// group) there is no parent recipe to push item styling down. Without this,
/// callers hand-attach a styler to each item and a missed one in a loop renders
/// unstyled beside its styled siblings.
@MixWidget(target: RemixCheckboxGroupItem.new)
CheckboxStyler uiCheckboxGroupItemStyle({
  UiCheckboxVariant variant = .surface,
  UiCheckboxSize size = .size2,
  bool highContrast = false,
  CheckboxStyler style = const CheckboxStyler.create(),
}) {
  final checkbox = uiCheckboxStyle(
    variant: variant,
    size: size,
    highContrast: highContrast,
  );

  return (switch (size) {
        .size1 =>
          checkbox
              .label(.style(UiTokens.text1.mix()))
              .labelSpacing(UiTokens.space1()),
        .size2 =>
          checkbox
              .label(.style(UiTokens.text2.mix()))
              .labelSpacing(UiTokens.space2()),
        .size3 =>
          checkbox
              .label(.style(UiTokens.text3.mix()))
              .labelSpacing(UiTokens.space2()),
      })
      .wrap(uiTouchTarget())
      .onDisabled(
        CheckboxStyler().containerEffects(
          RemixBoxEffectsMix(outline: BorderSideMix(style: .none)),
        ),
      )
      .merge(style);
}

({double size, double indicatorSize, Radius radius}) _uiCheckboxMetrics(
  UiCheckboxSize size,
) => switch (size) {
  .size1 => (
    size: UiTokens.checkboxSize1(),
    indicatorSize: UiTokens.checkboxIndicatorSize1(),
    radius: UiTokens.checkboxRadius1(),
  ),
  .size2 => (
    size: UiTokens.space4(),
    indicatorSize: UiTokens.checkboxIndicatorSize2(),
    radius: UiTokens.radius1(),
  ),
  .size3 => (
    size: UiTokens.checkboxSize3(),
    indicatorSize: UiTokens.space3(),
    radius: UiTokens.checkboxRadius3(),
  ),
};

CheckboxStyler _uiCheckboxSurface(CheckboxStyler base, bool highContrast) {
  final selected = CheckboxStyler()
      .color(highContrast ? UiTokens.accent12() : UiTokens.accentIndicator())
      .containerEffects(
        RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
      )
      .containerEffects(
        RemixBoxEffectsMix.overContent(
          RemixBoxEffectLayerMix(shadows: const []),
        ),
      )
      .indicatorColor(
        highContrast ? UiTokens.accent1() : UiTokens.accentContrast(),
      );

  return base
      .color(UiTokens.colorSurface())
      .containerEffects(
        RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
      )
      .containerEffects(
        RemixBoxEffectsMix.overContent(
          uiInsetSurface(strokes: [UiTokens.grayA7()]),
        ),
      )
      .onSelected(selected)
      .onIndeterminate(selected)
      .onDisabled(
        .color(UiTokens.grayA3())
            .containerEffects(
              RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
            )
            .containerEffects(
              RemixBoxEffectsMix.overContent(
                uiInsetSurface(strokes: [UiTokens.grayA6()]),
              ),
            )
            .indicatorColor(UiTokens.grayA8()),
      );
}

CheckboxStyler _uiCheckboxSoft(CheckboxStyler base, bool highContrast) {
  final selected = CheckboxStyler().indicatorColor(
    highContrast ? UiTokens.accent12() : UiTokens.accentA11(),
  );

  return base
      .color(UiTokens.accentA5())
      .containerEffects(
        RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
      )
      .onSelected(selected)
      .onIndeterminate(selected)
      .onDisabled(
        .color(UiTokens.grayA3())
            .containerEffects(
              RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
            )
            .indicatorColor(UiTokens.grayA8()),
      );
}
