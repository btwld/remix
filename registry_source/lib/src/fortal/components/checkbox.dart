import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'checkbox.g.dart';

/// Fortal Checkbox size presets.
enum FortalCheckboxSize { size1, size2, size3 }

/// Fortal Checkbox variants.
enum FortalCheckboxVariant { surface, soft }

/// Fortal recipe for [RemixCheckbox].
@MixWidget(target: RemixCheckbox.new)
CheckboxStyler fortalCheckboxStyle({
  FortalCheckboxVariant variant = .surface,
  FortalCheckboxSize size = .size2,
  bool highContrast = false,
  CheckboxStyler style = const CheckboxStyler.create(),
}) {
  final metrics = _fortalCheckboxMetrics(size);
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
  ).onFocusVisible(.containerEffects(fortalFocusOutline()));

  return (switch (variant) {
        .surface => _fortalCheckboxSurface(base, highContrast),
        .soft => _fortalCheckboxSoft(base, highContrast),
      })
      .wrap(fortalTouchTarget())
      .onDisabled(
        CheckboxStyler().containerEffects(
          RemixBoxEffectsMix(outline: BorderSideMix(style: .none)),
        ),
      )
      .merge(style);
}

/// Fortal recipe for [RemixCheckboxGroupItem].
///
///
/// It exists because `RemixCheckboxGroup` is behavioral and carries no styler,
/// so unlike every other Remix item (menu, select, segmented control, toggle
/// group) there is no parent recipe to push item styling down. Without this,
/// callers hand-attach a styler to each item and a missed one in a loop renders
/// unstyled beside its styled siblings.
@MixWidget(target: RemixCheckboxGroupItem.new)
CheckboxStyler fortalCheckboxGroupItemStyle({
  FortalCheckboxVariant variant = .surface,
  FortalCheckboxSize size = .size2,
  bool highContrast = false,
  CheckboxStyler style = const CheckboxStyler.create(),
}) {
  final checkbox = fortalCheckboxStyle(
    variant: variant,
    size: size,
    highContrast: highContrast,
  );

  return (switch (size) {
        .size1 =>
          checkbox
              .label(.style(FortalTokens.text1.mix()))
              .labelSpacing(FortalTokens.space1()),
        .size2 =>
          checkbox
              .label(.style(FortalTokens.text2.mix()))
              .labelSpacing(FortalTokens.space2()),
        .size3 =>
          checkbox
              .label(.style(FortalTokens.text3.mix()))
              .labelSpacing(FortalTokens.space2()),
      })
      .wrap(fortalTouchTarget())
      .onDisabled(
        CheckboxStyler().containerEffects(
          RemixBoxEffectsMix(outline: BorderSideMix(style: .none)),
        ),
      )
      .merge(style);
}

({double size, double indicatorSize, Radius radius}) _fortalCheckboxMetrics(
  FortalCheckboxSize size,
) => switch (size) {
  .size1 => (
    size: FortalTokens.checkboxSize1(),
    indicatorSize: FortalTokens.checkboxIndicatorSize1(),
    radius: FortalTokens.checkboxRadius1(),
  ),
  .size2 => (
    size: FortalTokens.space4(),
    indicatorSize: FortalTokens.checkboxIndicatorSize2(),
    radius: FortalTokens.radius1(),
  ),
  .size3 => (
    size: FortalTokens.checkboxSize3(),
    indicatorSize: FortalTokens.space3(),
    radius: FortalTokens.checkboxRadius3(),
  ),
};

CheckboxStyler _fortalCheckboxSurface(CheckboxStyler base, bool highContrast) {
  final selected = CheckboxStyler()
      .color(
        highContrast ? FortalTokens.accent12() : FortalTokens.accentIndicator(),
      )
      .containerEffects(
        RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
      )
      .containerEffects(
        RemixBoxEffectsMix.overContent(
          RemixBoxEffectLayerMix(shadows: const []),
        ),
      )
      .indicatorColor(
        highContrast ? FortalTokens.accent1() : FortalTokens.accentContrast(),
      );

  return base
      .color(FortalTokens.colorSurface())
      .containerEffects(
        RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
      )
      .containerEffects(
        RemixBoxEffectsMix.overContent(
          fortalInsetSurface(strokes: [FortalTokens.grayA7()]),
        ),
      )
      .onSelected(selected)
      .onIndeterminate(selected)
      .onDisabled(
        .color(FortalTokens.grayA3())
            .containerEffects(
              RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
            )
            .containerEffects(
              RemixBoxEffectsMix.overContent(
                fortalInsetSurface(strokes: [FortalTokens.grayA6()]),
              ),
            )
            .indicatorColor(FortalTokens.grayA8()),
      );
}

CheckboxStyler _fortalCheckboxSoft(CheckboxStyler base, bool highContrast) {
  final selected = CheckboxStyler().indicatorColor(
    highContrast ? FortalTokens.accent12() : FortalTokens.accentA11(),
  );

  return base
      .color(FortalTokens.accentA5())
      .containerEffects(
        RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
      )
      .onSelected(selected)
      .onIndeterminate(selected)
      .onDisabled(
        .color(FortalTokens.grayA3())
            .containerEffects(
              RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
            )
            .indicatorColor(FortalTokens.grayA8()),
      );
}
