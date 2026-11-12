import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'select.g.dart';

/// The sizes a select comes in. Pixel values are at 100% theme scaling.
enum FortalSelectSize {
  /// A 24px trigger with 12px text.
  size1,

  /// A 32px trigger with 14px text. The default.
  size2,

  /// A 40px trigger with 16px text.
  size3,
}

/// The looks a select's trigger comes in.
enum FortalSelectVariant {
  /// A near-white fill inside a 1px gray frame.
  surface,

  /// An accent tint under accent text.
  soft,

  /// No fill until hovered. It sits in a negative margin, so its text lines up
  /// with the text around it.
  ghost,
}

/// The Fortal Select recipe: the trigger, the floating panel and its items.
///
/// Content icons use size-matched 12/16/20 token defaults rather than the
/// ambient icon size. Override the trigger icon through [style] when needed.
///
/// The panel is at least as wide as its trigger. A [style] that gives the
/// content a `maxWidth` below the trigger's width must also set `minWidth`,
/// which replaces the minimum, because a minimum above a maximum is invalid.
///
/// [highContrast] moves the highlighted item of the surface and ghost variants
/// to accent step 12.
@MixWidget(target: RemixSelect.new)
SelectStyler fortalSelectStyle({
  FortalSelectVariant variant = .surface,
  FortalSelectSize size = .size2,
  bool highContrast = false,
  SelectStyler style = const SelectStyler.create(),
}) => SelectStyler()
    .trigger(_trigger(variant, size))
    .content(_content(size))
    .item(_item(variant, size, highContrast: highContrast))
    .merge(style);

/// The Fortal select item recipe, for styling one item on its own.
///
/// It is the item style [fortalSelectStyle] gives every item, so a call site
/// can match a select's items outside the select.
SelectMenuItemStyler fortalSelectMenuItemStyle({
  FortalSelectVariant variant = .surface,
  FortalSelectSize size = .size2,
  bool highContrast = false,
}) => _item(variant, size, highContrast: highContrast);

/// The trigger: its shape and text, then the variant's colors.
SelectTriggerStyler _trigger(
  FortalSelectVariant variant,
  FortalSelectSize size,
) => _triggerBase(size)
    .merge(_triggerScale(variant, size))
    .wrap(fortalTouchTarget())
    .merge(switch (variant) {
      .surface => _surfaceTrigger(),
      .soft => _tintedTrigger(
        color: FortalTokens.accentA3(),
        hover: FortalTokens.accentA4(),
        disabled: FortalTokens.grayA3(),
      ),
      .ghost => _tintedTrigger(
        color: const Color(0x00000000),
        hover: FortalTokens.accentA3(),
        disabled: const Color(0x00000000),
      ),
    })
    .onDisabled(.containerEffects(.outline(.style(.none))));

/// The trigger's label, placeholder, icons and focus ring, in gray 12.
SelectTriggerStyler _triggerBase(FortalSelectSize size) {
  final (:text, :icon, :indicator, :radius) = switch (size) {
    .size1 => (
      text: FortalTokens.text1,
      icon: FortalTokens.space3(),
      indicator: FortalTokens.selectTriggerIndicatorSize12(),
      radius: FortalTokens.radius1OrFull(),
    ),
    .size2 => (
      text: FortalTokens.text2,
      icon: FortalTokens.space4(),
      indicator: FortalTokens.selectTriggerIndicatorSize12(),
      radius: FortalTokens.radius2OrFull(),
    ),
    .size3 => (
      text: FortalTokens.text3,
      icon: FortalTokens.spinnerSize3(),
      indicator: FortalTokens.selectTriggerIndicatorSize3(),
      radius: FortalTokens.radius3OrFull(),
    ),
  };
  TextStyler regular(Color color) => TextStyler(
    style: text.mix(),
  ).fontWeight(FortalTokens.fontWeightRegular()).color(color);

  return SelectTriggerStyler()
      .direction(.horizontal)
      .mainAxisAlignment(.spaceBetween)
      .borderRadius(.all(radius))
      .label(regular(FortalTokens.gray12()))
      .placeholder(regular(FortalTokens.grayA10()))
      .icon(.color(FortalTokens.gray12()).size(icon))
      .indicator(.color(FortalTokens.gray12()).size(indicator))
      .onFocusVisible(.containerEffects(fortalFocusOutline()));
}

/// The gap, padding and height of the trigger. A ghost trigger has no height;
/// it takes its padding and cancels it with a negative margin.
SelectTriggerStyler _triggerScale(
  FortalSelectVariant variant,
  FortalSelectSize size,
) {
  final trigger = SelectTriggerStyler().spacing(switch (size) {
    .size1 => FortalTokens.space1(),
    .size2 => FortalTokens.space2(),
    .size3 => FortalTokens.space2(),
  });

  return switch (variant) {
    .ghost => switch (size) {
      .size1 || .size2 =>
        trigger
            .padding(.horizontal(FortalTokens.space2()))
            .padding(.vertical(FortalTokens.space1()))
            .margin(.horizontal(FortalTokens.selectGhostMarginX12()))
            .margin(.vertical(FortalTokens.selectGhostMarginY12())),
      .size3 =>
        trigger
            .padding(.horizontal(FortalTokens.space3()))
            .padding(.vertical(FortalTokens.space2()))
            .margin(.horizontal(FortalTokens.selectGhostMarginX3()))
            .margin(.vertical(FortalTokens.selectGhostMarginY3())),
    },
    .surface || .soft => switch (size) {
      .size1 =>
        trigger
            .height(FortalTokens.space5())
            .padding(.horizontal(FortalTokens.space2())),
      .size2 =>
        trigger
            .height(FortalTokens.space6())
            .padding(.horizontal(FortalTokens.space3())),
      .size3 =>
        trigger
            .height(FortalTokens.space7())
            .padding(.horizontal(FortalTokens.space4())),
    },
  };
}

SelectTriggerStyler _surfaceTrigger() => SelectTriggerStyler()
    .indicatorOpacity(0.9)
    .color(FortalTokens.gray2())
    .containerEffects(
      .behindContent(fortalInsetSurface(strokes: [FortalTokens.gray7()])),
    )
    .onHovered(
      .containerEffects(
        .behindContent(fortalInsetSurface(strokes: [FortalTokens.grayA8()])),
      ),
    )
    .onSelected(
      .containerEffects(
        .behindContent(fortalInsetSurface(strokes: [FortalTokens.grayA8()])),
      ),
    )
    .onDisabled(
      .color(FortalTokens.gray2())
          .label(.color(FortalTokens.grayA11()))
          .icon(.color(FortalTokens.grayA9()))
          .indicator(.color(FortalTokens.grayA9()))
          .containerEffects(
            .behindContent(
              fortalInsetSurface(strokes: [FortalTokens.grayA6()]).merge(
                RemixBoxEffectLayerMix(
                  gradients: [
                    RemixLinearGradientMix(
                      colors: [FortalTokens.grayA2(), FortalTokens.grayA2()],
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

/// Accent text on a [color] fill that takes [hover] while hovered or open.
/// Disabled turns the text gray and the fill [disabled].
SelectTriggerStyler _tintedTrigger({
  required Color color,
  required Color hover,
  required Color disabled,
}) => SelectTriggerStyler()
    .label(.color(FortalTokens.accent12()))
    .placeholder(.color(FortalTokens.accent12()))
    .placeholderOpacity(0.6)
    .icon(.color(FortalTokens.accent12()))
    .indicator(.color(FortalTokens.accent12()))
    .color(color)
    .onHovered(.color(hover))
    .onSelected(.color(hover))
    .onDisabled(
      .label(.color(FortalTokens.grayA11()))
          .icon(.color(FortalTokens.grayA9()))
          .indicator(.color(FortalTokens.grayA9()))
          .color(disabled),
    );

/// The floating panel: a raised, blurred panel at least as wide as the
/// trigger.
SelectContentStyler _content(FortalSelectSize size) {
  final (:padding, :radius) = switch (size) {
    .size1 => (padding: FortalTokens.space1(), radius: FortalTokens.radius3()),
    .size2 ||
    .size3 => (padding: FortalTokens.space2(), radius: FortalTokens.radius4()),
  };

  return SelectContentStyler()
      .maxHeight(320)
      .border(.color(FortalTokens.gray7()).width(FortalTokens.borderWidth1()))
      // The panel is never narrower than its trigger.
      .minWidth(remixAnchorWidth())
      .padding(.all(padding))
      .borderRadius(.all(radius))
      .color(FortalTokens.colorPanel())
      .decoration(
        BoxDecorationMix.create(boxShadow: FortalTokens.shadow5.mix()),
      )
      .clipBehavior(Clip.antiAlias)
      .containerEffects(.backdropBlur(FortalTokens.panelBlur()));
}

/// An item in the panel: gray text, with the variant's highlight under the
/// pointer, keyboard focus and press.
SelectMenuItemStyler _item(
  FortalSelectVariant variant,
  FortalSelectSize size, {
  required bool highContrast,
}) {
  final (
    :height,
    :indicatorWidth,
    :indicatorSize,
    :radius,
    :text,
  ) = switch (size) {
    .size1 => (
      height: FortalTokens.space5(),
      indicatorWidth: FortalTokens.selectIndicatorWidth1(),
      indicatorSize: FortalTokens.space2(),
      radius: FortalTokens.radius1(),
      text: FortalTokens.text1,
    ),
    .size2 => (
      height: FortalTokens.space6(),
      indicatorWidth: FortalTokens.space5(),
      indicatorSize: FortalTokens.selectIndicatorSize2(),
      radius: FortalTokens.radius2(),
      text: FortalTokens.text2,
    ),
    .size3 => (
      height: FortalTokens.space6(),
      indicatorWidth: FortalTokens.space5(),
      indicatorSize: FortalTokens.selectIndicatorSize2(),
      radius: FortalTokens.radius2(),
      text: FortalTokens.text3,
    ),
  };
  final highlighted = _highlighted(variant, highContrast: highContrast);

  return SelectMenuItemStyler()
      .wrap(fortalTouchTarget())
      .direction(.horizontal)
      .height(height)
      .padding(.horizontal(indicatorWidth))
      .borderRadius(.all(radius))
      .text(TextStyler(style: text.mix()).color(FortalTokens.gray12()))
      .indicator(
        BoxStyler(
          alignment: .center,
          constraints: BoxConstraintsMix.width(indicatorWidth),
        ),
      )
      .icon(IconStyler(color: FortalTokens.gray12(), size: indicatorSize))
      .onHovered(highlighted)
      .onFocused(highlighted)
      .onPressed(highlighted)
      .onFocusVisible(
        SelectMenuItemStyler().container(
          FlexBoxStyler().fortalFocusRing(radius: radius),
        ),
      )
      .onDisabled(
        SelectMenuItemStyler()
            .container(
              FlexBoxStyler().wrap(fortalFocusRingModifier(visible: false)),
            )
            .color(const Color(0x00000000))
            .text(.color(FortalTokens.grayA8()))
            .iconColor(FortalTokens.grayA8()),
      );
}

/// The item under the pointer or keyboard: the accent's solid fill under its
/// contrast text, or a tint for the soft variant.
SelectMenuItemStyler _highlighted(
  FortalSelectVariant variant, {
  required bool highContrast,
}) {
  final content = highContrast
      ? FortalTokens.accent1()
      : FortalTokens.accentContrast();

  return switch (variant) {
    .surface || .ghost =>
      SelectMenuItemStyler()
          .color(
            highContrast ? FortalTokens.accent12() : FortalTokens.accentSolid(),
          )
          .text(.color(content))
          .iconColor(content),
    .soft => SelectMenuItemStyler().color(FortalTokens.accentA4()),
  };
}
