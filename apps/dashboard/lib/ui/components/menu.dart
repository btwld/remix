import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'menu.g.dart';

/// The sizes a menu comes in. Pixel values are at 100% theme scaling.
enum UiMenuSize {
  /// 24px items with 12px text.
  size1,

  /// 32px items with 14px text. The default.
  size2,
}

/// How a menu marks the item under the pointer or keyboard.
enum UiMenuVariant {
  /// The accent's solid fill under its contrast text.
  solid,

  /// A tinted accent fill.
  soft,
}

/// The Ui Menu recipe: the trigger, the floating panel, its items,
/// submenu items and dividers.
///
/// [highContrast] moves the highlighted item of the solid variant to accent
/// step 12.
@MixWidget(target: RemixMenu.new)
MenuStyler uiMenuStyle({
  UiMenuVariant variant = .solid,
  UiMenuSize size = .size2,
  bool highContrast = false,
  MenuStyler style = const MenuStyler.create(),
}) {
  final metrics = _metrics(size);

  return MenuStyler()
      .containerEffects(RemixBoxEffectsMix.backdropBlur(UiTokens.panelBlur()))
      .trigger(_trigger(metrics))
      .overlay(
        FlexBoxStyler()
            .padding(.all(metrics.contentPadding))
            .borderRadius(.all(metrics.contentRadius))
            // The panel edge, drawn in the foreground to take no layout space.
            .foregroundDecoration(
              BoxDecorationMix(
                border: BoxBorderMix.all(
                  BorderSideMix(
                    color: UiTokens.gray7(),
                    width: UiTokens.borderWidth1(),
                  ),
                ),
                borderRadius: BorderRadiusMix.all(metrics.contentRadius),
              ),
            )
            .color(UiTokens.colorPanel())
            .decoration(
              BoxDecorationMix.create(boxShadow: UiTokens.shadow5.mix()),
            )
            .clipBehavior(Clip.antiAlias),
      )
      .item(_item(variant, metrics, highContrast: highContrast))
      .submenuItem(_submenuItem(variant, metrics, highContrast: highContrast))
      .divider(_divider(metrics))
      .merge(style);
}

/// The Ui menu item recipe, for styling one item on its own.
///
/// It is the item style [uiMenuStyle] gives every item, so a call site can
/// match a menu's items outside the menu.
MenuItemStyler uiMenuItemStyle({
  UiMenuVariant variant = .solid,
  UiMenuSize size = .size2,
  bool highContrast = false,
}) => _item(variant, _metrics(size), highContrast: highContrast);

MenuTriggerStyler _trigger(_Metrics metrics) => MenuTriggerStyler()
    .wrap(uiTouchTarget())
    .onFocusVisible(
      MenuTriggerStyler().container(
        FlexBoxStyler().wrap(uiFocusRingModifier()),
      ),
    )
    .onDisabled(
      MenuTriggerStyler().container(
        FlexBoxStyler().wrap(uiFocusRingModifier(visible: false)),
      ),
    )
    .spacing(metrics.triggerGap)
    .label(.style(metrics.text.mix()).color(UiTokens.gray12()))
    .icon(.color(UiTokens.gray12()).size(metrics.contentIconSize));

MenuItemStyler _item(
  UiMenuVariant variant,
  _Metrics metrics, {
  required bool highContrast,
}) {
  final base = MenuItemStyler()
      .wrap(uiTouchTarget())
      .direction(.horizontal)
      .spacing(UiTokens.space2())
      .height(metrics.itemHeight)
      .padding(.horizontal(metrics.leadingInset))
      .borderRadius(.all(metrics.itemRadius))
      .label(.style(metrics.text.mix()).color(UiTokens.gray12()))
      .leadingIcon(.color(UiTokens.gray12()).size(metrics.contentIconSize))
      .trailingIcon(.color(UiTokens.grayA11()).size(metrics.contentIconSize))
      // A shortcut or count follows the trailing icon's color in every state.
      .trailingText(.color(UiTokens.grayA11()))
      .indicator(.color(UiTokens.gray12()).size(metrics.indicatorSize));
  final highlighted = _highlightedItem(variant, highContrast: highContrast);
  final disabled = MenuItemStyler()
      .container(FlexBoxStyler().wrap(uiFocusRingModifier(visible: false)))
      .color(const Color(0x00000000))
      .label(.color(UiTokens.grayA8()))
      .leadingIcon(.color(UiTokens.grayA8()))
      .trailingIcon(.color(UiTokens.grayA8()))
      .trailingText(.color(UiTokens.grayA8()))
      .indicator(.color(UiTokens.grayA8()));

  return base
      .onHovered(highlighted)
      .onFocused(highlighted)
      .onPressed(highlighted)
      .onFocusVisible(
        MenuItemStyler().container(
          FlexBoxStyler().uiFocusRing(radius: metrics.itemRadius),
        ),
      )
      .onDisabled(disabled);
}

MenuItemStyler _highlightedItem(
  UiMenuVariant variant, {
  required bool highContrast,
}) {
  final solidForeground = highContrast
      ? UiTokens.accent1()
      : UiTokens.accentContrast();

  return switch (variant) {
    .solid =>
      MenuItemStyler()
          .color(highContrast ? UiTokens.accent12() : UiTokens.accentSolid())
          .label(.color(solidForeground))
          .leadingIcon(.color(solidForeground))
          .trailingIcon(.color(solidForeground))
          .trailingText(.color(solidForeground))
          .indicator(.color(solidForeground)),
    .soft =>
      MenuItemStyler()
          .color(UiTokens.accentA4())
          .trailingIcon(.color(UiTokens.gray12()))
          .trailingText(.color(UiTokens.gray12())),
  };
}

MenuItemStyler _submenuItem(
  UiMenuVariant variant,
  _Metrics metrics, {
  required bool highContrast,
}) {
  final highlighted = _highlightedItem(variant, highContrast: highContrast);
  final submenuOpen = MenuItemStyler()
      .color(switch (variant) {
        .solid => UiTokens.grayA3(),
        .soft => UiTokens.accentA3(),
      })
      .onHovered(highlighted)
      // Roving `data-highlighted` state, not a focus-visible ring.
      .onFocused(highlighted)
      .onPressed(highlighted);

  return MenuItemStyler()
      .trailingIcon(.color(UiTokens.gray12()).size(metrics.indicatorSize))
      .onSelected(submenuOpen);
}

DividerStyler _divider(_Metrics metrics) => DividerStyler()
    .height(UiTokens.borderWidth1())
    .margin(
      .left(
        metrics.leadingInset,
      ).right(metrics.trailingInset).vertical(UiTokens.space2()),
    )
    .color(UiTokens.grayA6());

class _Metrics {
  const _Metrics({
    required this.contentPadding,
    required this.contentRadius,
    required this.itemHeight,
    required this.itemRadius,
    required this.leadingInset,
    required this.trailingInset,
    required this.indicatorSize,
    required this.contentIconSize,
    required this.triggerGap,
    required this.text,
  });

  final double contentPadding;
  final Radius contentRadius;
  final double itemHeight;
  final Radius itemRadius;
  final double leadingInset;
  final double trailingInset;
  final double indicatorSize;
  final double contentIconSize;
  final double triggerGap;
  final TextStyleToken text;
}

_Metrics _metrics(UiMenuSize size) => switch (size) {
  .size1 => _Metrics(
    contentPadding: UiTokens.space1(),
    contentRadius: UiTokens.radius3(),
    itemHeight: UiTokens.space5(),
    itemRadius: UiTokens.radius1(),
    leadingInset: UiTokens.space2(),
    trailingInset: UiTokens.space2(),
    indicatorSize: UiTokens.space2(),
    contentIconSize: UiTokens.space3(),
    triggerGap: UiTokens.space1(),
    text: UiTokens.text1,
  ),
  .size2 => _Metrics(
    contentPadding: UiTokens.space2(),
    contentRadius: UiTokens.radius4(),
    itemHeight: UiTokens.space6(),
    itemRadius: UiTokens.radius2(),
    leadingInset: UiTokens.space3(),
    trailingInset: UiTokens.space3(),
    indicatorSize: UiTokens.selectIndicatorSize2(),
    contentIconSize: UiTokens.space4(),
    triggerGap: UiTokens.space2(),
    text: UiTokens.text2,
  ),
};
