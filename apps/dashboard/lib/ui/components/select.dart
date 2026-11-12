import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'select.g.dart';

/// The sizes a select comes in. Pixel values are at 100% theme scaling.
enum UiSelectSize {
  /// A 24px trigger with 12px text.
  size1,

  /// A 32px trigger with 14px text. The default.
  size2,

  /// A 40px trigger with 16px text.
  size3,
}

/// The looks a select's trigger comes in.
enum UiSelectVariant {
  /// A near-white fill inside a 1px gray frame.
  surface,

  /// An accent tint under accent text.
  soft,

  /// No fill until hovered. It sits in a negative margin, so its text lines up
  /// with the text around it.
  ghost,
}

/// The Ui Select recipe: the trigger, the floating panel and its items.
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
SelectStyler uiSelectStyle({
  UiSelectVariant variant = .surface,
  UiSelectSize size = .size2,
  bool highContrast = false,
  SelectStyler style = const SelectStyler.create(),
}) => SelectStyler()
    .trigger(_trigger(variant, size))
    .content(_content(size))
    .item(_item(variant, size, highContrast: highContrast))
    .merge(style);

/// The Ui select item recipe, for styling one item on its own.
///
/// It is the item style [uiSelectStyle] gives every item, so a call site
/// can match a select's items outside the select.
SelectMenuItemStyler uiSelectMenuItemStyle({
  UiSelectVariant variant = .surface,
  UiSelectSize size = .size2,
  bool highContrast = false,
}) => _item(variant, size, highContrast: highContrast);

/// The trigger: its shape and text, then the variant's colors.
SelectTriggerStyler _trigger(UiSelectVariant variant, UiSelectSize size) =>
    _triggerBase(size)
        .merge(_triggerScale(variant, size))
        .wrap(uiTouchTarget())
        .merge(switch (variant) {
          .surface => _surfaceTrigger(),
          .soft => _tintedTrigger(
            color: UiTokens.accentA3(),
            hover: UiTokens.accentA4(),
            disabled: UiTokens.grayA3(),
          ),
          .ghost => _tintedTrigger(
            color: const Color(0x00000000),
            hover: UiTokens.accentA3(),
            disabled: const Color(0x00000000),
          ),
        })
        .onDisabled(.containerEffects(.outline(.style(.none))));

/// The trigger's label, placeholder, icons and focus ring, in gray 12.
SelectTriggerStyler _triggerBase(UiSelectSize size) {
  final (:text, :icon, :indicator, :radius) = switch (size) {
    .size1 => (
      text: UiTokens.text1,
      icon: UiTokens.space3(),
      indicator: UiTokens.selectTriggerIndicatorSize12(),
      radius: UiTokens.radius1OrFull(),
    ),
    .size2 => (
      text: UiTokens.text2,
      icon: UiTokens.space4(),
      indicator: UiTokens.selectTriggerIndicatorSize12(),
      radius: UiTokens.radius2OrFull(),
    ),
    .size3 => (
      text: UiTokens.text3,
      icon: UiTokens.spinnerSize3(),
      indicator: UiTokens.selectTriggerIndicatorSize3(),
      radius: UiTokens.radius3OrFull(),
    ),
  };
  TextStyler regular(Color color) => TextStyler(
    style: text.mix(),
  ).fontWeight(UiTokens.fontWeightRegular()).color(color);

  return SelectTriggerStyler()
      .direction(.horizontal)
      .mainAxisAlignment(.spaceBetween)
      .borderRadius(.all(radius))
      .label(regular(UiTokens.gray12()))
      .placeholder(regular(UiTokens.grayA10()))
      .icon(.color(UiTokens.gray12()).size(icon))
      .indicator(.color(UiTokens.gray12()).size(indicator))
      .onFocusVisible(.containerEffects(uiFocusOutline()));
}

/// The gap, padding and height of the trigger. A ghost trigger has no height;
/// it takes its padding and cancels it with a negative margin.
SelectTriggerStyler _triggerScale(UiSelectVariant variant, UiSelectSize size) {
  final trigger = SelectTriggerStyler().spacing(switch (size) {
    .size1 => UiTokens.space1(),
    .size2 => UiTokens.space2(),
    .size3 => UiTokens.space2(),
  });

  return switch (variant) {
    .ghost => switch (size) {
      .size1 || .size2 =>
        trigger
            .padding(.horizontal(UiTokens.space2()))
            .padding(.vertical(UiTokens.space1()))
            .margin(.horizontal(UiTokens.selectGhostMarginX12()))
            .margin(.vertical(UiTokens.selectGhostMarginY12())),
      .size3 =>
        trigger
            .padding(.horizontal(UiTokens.space3()))
            .padding(.vertical(UiTokens.space2()))
            .margin(.horizontal(UiTokens.selectGhostMarginX3()))
            .margin(.vertical(UiTokens.selectGhostMarginY3())),
    },
    .surface || .soft => switch (size) {
      .size1 =>
        trigger
            .height(UiTokens.space5())
            .padding(.horizontal(UiTokens.space2())),
      .size2 =>
        trigger
            .height(UiTokens.space6())
            .padding(.horizontal(UiTokens.space3())),
      .size3 =>
        trigger
            .height(UiTokens.space7())
            .padding(.horizontal(UiTokens.space4())),
    },
  };
}

SelectTriggerStyler _surfaceTrigger() => SelectTriggerStyler()
    .indicatorOpacity(0.9)
    .color(UiTokens.gray2())
    .containerEffects(
      .behindContent(uiInsetSurface(strokes: [UiTokens.gray7()])),
    )
    .onHovered(
      .containerEffects(
        .behindContent(uiInsetSurface(strokes: [UiTokens.grayA8()])),
      ),
    )
    .onSelected(
      .containerEffects(
        .behindContent(uiInsetSurface(strokes: [UiTokens.grayA8()])),
      ),
    )
    .onDisabled(
      .color(UiTokens.gray2())
          .label(.color(UiTokens.grayA11()))
          .icon(.color(UiTokens.grayA9()))
          .indicator(.color(UiTokens.grayA9()))
          .containerEffects(
            .behindContent(
              uiInsetSurface(strokes: [UiTokens.grayA6()]).merge(
                RemixBoxEffectLayerMix(
                  gradients: [
                    RemixLinearGradientMix(
                      colors: [UiTokens.grayA2(), UiTokens.grayA2()],
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
    .label(.color(UiTokens.accent12()))
    .placeholder(.color(UiTokens.accent12()))
    .placeholderOpacity(0.6)
    .icon(.color(UiTokens.accent12()))
    .indicator(.color(UiTokens.accent12()))
    .color(color)
    .onHovered(.color(hover))
    .onSelected(.color(hover))
    .onDisabled(
      .label(.color(UiTokens.grayA11()))
          .icon(.color(UiTokens.grayA9()))
          .indicator(.color(UiTokens.grayA9()))
          .color(disabled),
    );

/// The floating panel: a raised, blurred panel at least as wide as the
/// trigger.
SelectContentStyler _content(UiSelectSize size) {
  final (:padding, :radius) = switch (size) {
    .size1 => (padding: UiTokens.space1(), radius: UiTokens.radius3()),
    .size2 ||
    .size3 => (padding: UiTokens.space2(), radius: UiTokens.radius4()),
  };

  return SelectContentStyler()
      .maxHeight(320)
      .border(.color(UiTokens.gray7()).width(UiTokens.borderWidth1()))
      // The panel is never narrower than its trigger.
      .minWidth(remixAnchorWidth())
      .padding(.all(padding))
      .borderRadius(.all(radius))
      .color(UiTokens.colorPanel())
      .decoration(BoxDecorationMix.create(boxShadow: UiTokens.shadow5.mix()))
      .clipBehavior(Clip.antiAlias)
      .containerEffects(.backdropBlur(UiTokens.panelBlur()));
}

/// An item in the panel: gray text, with the variant's highlight under the
/// pointer, keyboard focus and press.
SelectMenuItemStyler _item(
  UiSelectVariant variant,
  UiSelectSize size, {
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
      height: UiTokens.space5(),
      indicatorWidth: UiTokens.selectIndicatorWidth1(),
      indicatorSize: UiTokens.space2(),
      radius: UiTokens.radius1(),
      text: UiTokens.text1,
    ),
    .size2 => (
      height: UiTokens.space6(),
      indicatorWidth: UiTokens.space5(),
      indicatorSize: UiTokens.selectIndicatorSize2(),
      radius: UiTokens.radius2(),
      text: UiTokens.text2,
    ),
    .size3 => (
      height: UiTokens.space6(),
      indicatorWidth: UiTokens.space5(),
      indicatorSize: UiTokens.selectIndicatorSize2(),
      radius: UiTokens.radius2(),
      text: UiTokens.text3,
    ),
  };
  final highlighted = _highlighted(variant, highContrast: highContrast);

  return SelectMenuItemStyler()
      .wrap(uiTouchTarget())
      .direction(.horizontal)
      .height(height)
      .padding(.horizontal(indicatorWidth))
      .borderRadius(.all(radius))
      .text(TextStyler(style: text.mix()).color(UiTokens.gray12()))
      .indicator(
        BoxStyler(
          alignment: .center,
          constraints: BoxConstraintsMix.width(indicatorWidth),
        ),
      )
      .icon(IconStyler(color: UiTokens.gray12(), size: indicatorSize))
      .onHovered(highlighted)
      .onFocused(highlighted)
      .onPressed(highlighted)
      .onFocusVisible(
        SelectMenuItemStyler().container(
          FlexBoxStyler().uiFocusRing(radius: radius),
        ),
      )
      .onDisabled(
        SelectMenuItemStyler()
            .container(
              FlexBoxStyler().wrap(uiFocusRingModifier(visible: false)),
            )
            .color(const Color(0x00000000))
            .text(.color(UiTokens.grayA8()))
            .iconColor(UiTokens.grayA8()),
      );
}

/// The item under the pointer or keyboard: the accent's solid fill under its
/// contrast text, or a tint for the soft variant.
SelectMenuItemStyler _highlighted(
  UiSelectVariant variant, {
  required bool highContrast,
}) {
  final content = highContrast ? UiTokens.accent1() : UiTokens.accentContrast();

  return switch (variant) {
    .surface || .ghost =>
      SelectMenuItemStyler()
          .color(highContrast ? UiTokens.accent12() : UiTokens.accentSolid())
          .text(.color(content))
          .iconColor(content),
    .soft => SelectMenuItemStyler().color(UiTokens.accentA4()),
  };
}
