import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'checkbox.g.dart';

/// The sizes a checkbox comes in. Pixel values are at 100% theme scaling.
enum FortalCheckboxSize {
  /// A 14px box with a 9px check.
  size1,

  /// A 16px box with a 10px check. The default.
  size2,

  /// A 20px box with a 12px check.
  size3,
}

/// The looks a checkbox comes in.
enum FortalCheckboxVariant {
  /// A surface fill inside a 1px neutral frame, filled with the accent when
  /// selected.
  surface,

  /// An accent tint inside a 1px accent ring, with an accent-colored mark.
  soft,
}

/// The Fortal Checkbox recipe.
///
/// It reads top to bottom: the box and its focus ring, then the variant's
/// colors for rest, selected and disabled, then the touch target.
///
/// [highContrast] moves the selected fill (surface) or mark (soft) to accent
/// step 12.
@MixWidget(target: RemixCheckbox.new)
CheckboxStyler fortalCheckboxStyle({
  FortalCheckboxVariant variant = .surface,
  FortalCheckboxSize size = .size2,
  bool highContrast = false,
  CheckboxStyler style = const CheckboxStyler.create(),
}) => _box(size)
    .merge(switch (variant) {
      .surface => _surface(highContrast),
      .soft => _soft(highContrast),
    })
    .wrap(fortalTouchTarget())
    .onDisabled(.containerEffects(.outline(.style(.none))))
    .merge(style);

/// The Fortal CheckboxGroupItem recipe: the checkbox recipe plus a label.
///
/// It exists because `RemixCheckboxGroup` is behavioral and carries no styler,
/// so, unlike the menu, select, segmented control and toggle group items, there
/// is no parent recipe to push item styling down. Radio group items are the
/// same. Without this,
/// callers hand-attach a styler to each item and a missed one in a loop renders
/// unstyled beside its styled siblings.
@MixWidget(target: RemixCheckboxGroupItem.new)
CheckboxStyler fortalCheckboxGroupItemStyle({
  FortalCheckboxVariant variant = .surface,
  FortalCheckboxSize size = .size2,
  bool highContrast = false,
  CheckboxStyler style = const CheckboxStyler.create(),
}) =>
    fortalCheckboxStyle(
          variant: variant,
          size: size,
          highContrast: highContrast,
        )
        .merge(switch (size) {
          .size1 => _label(FortalTokens.text1, FortalTokens.space1),
          .size2 => _label(FortalTokens.text2, FortalTokens.space2),
          .size3 => _label(FortalTokens.text3, FortalTokens.space2),
        })
        .merge(style);

/// The box and check sizes of each step, with the focus ring and no effects.
///
/// The empty effect layers give the variant's state fragments layers to
/// replace.
CheckboxStyler _box(FortalCheckboxSize size) {
  final (:box, :check, :radius) = switch (size) {
    .size1 => (
      box: FortalTokens.checkboxSize1(),
      check: FortalTokens.checkboxIndicatorSize1(),
      radius: FortalTokens.checkboxRadius1(),
    ),
    .size2 => (
      box: FortalTokens.space4(),
      check: FortalTokens.checkboxIndicatorSize2(),
      radius: FortalTokens.radius1(),
    ),
    .size3 => (
      box: FortalTokens.checkboxSize3(),
      check: FortalTokens.space3(),
      radius: FortalTokens.checkboxRadius3(),
    ),
  };

  return CheckboxStyler(
    container: .size(box, box).alignment(.center).borderRadius(.all(radius)),
    indicator: .size(check),
    containerEffects: RemixBoxEffectsMix(
      behindContent: RemixBoxEffectLayerMix(),
      overContent: RemixBoxEffectLayerMix(),
    ),
  ).onFocusVisible(.containerEffects(fortalFocusOutline()));
}

/// The label's text style and its gap to the box.
CheckboxStyler _label(TextStyleToken text, SpaceToken gap) =>
    CheckboxStyler().label(.style(text.mix())).labelSpacing(gap());

/// A surface fill with a neutral frame; the accent fill when selected.
CheckboxStyler _surface(bool highContrast) {
  final selected = CheckboxStyler()
      .color(
        highContrast ? FortalTokens.accent12() : FortalTokens.accentIndicator(),
      )
      .merge(_effects(over: RemixBoxEffectLayerMix(shadows: const [])))
      .indicatorColor(
        highContrast
            ? FortalTokens.accent1()
            : FortalTokens.accentIndicatorContrast(),
      );

  return CheckboxStyler()
      .color(FortalTokens.colorSurface())
      .merge(
        _effects(
          over: fortalInsetSurface(strokes: [FortalTokens.controlBorder()]),
        ),
      )
      .onSelected(selected)
      .onIndeterminate(selected)
      .onDisabled(_disabled(frame: FortalTokens.grayA6()));
}

/// An accent tint with an accent ring; the mark takes the accent when
/// selected.
CheckboxStyler _soft(bool highContrast) {
  final selected = CheckboxStyler().indicatorColor(
    highContrast ? FortalTokens.accent12() : FortalTokens.accentContentAlpha(),
  );

  return CheckboxStyler()
      .color(FortalTokens.accentA5())
      // The tint alone is too faint to show an empty control; the accent-8
      // ring keeps a 3:1 boundary in every enabled state.
      .merge(
        _effects(over: fortalInsetSurface(strokes: [FortalTokens.focus8()])),
      )
      .onSelected(selected)
      .onIndeterminate(selected)
      .onDisabled(_disabled());
}

/// A gray fill and mark. The surface variant keeps a [frame]; soft has none.
CheckboxStyler _disabled({Color? frame}) => CheckboxStyler()
    .color(FortalTokens.grayA3())
    .merge(
      _effects(
        over: frame == null
            ? RemixBoxEffectLayerMix(shadows: const [])
            : fortalInsetSurface(strokes: [frame]),
      ),
    )
    .indicatorColor(FortalTokens.grayA8());

/// Sets the layer over the content and empties the one behind it.
CheckboxStyler _effects({required RemixBoxEffectLayerMix over}) =>
    CheckboxStyler()
        .containerEffects(
          RemixBoxEffectsMix.behindContent(RemixBoxEffectLayerMix()),
        )
        .containerEffects(RemixBoxEffectsMix.overContent(over));
