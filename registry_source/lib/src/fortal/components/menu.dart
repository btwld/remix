import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'menu.g.dart';

/// The sizes a menu comes in. Pixel values are at 100% theme scaling.
enum FortalMenuSize {
  /// 24px items with 12px text.
  size1,

  /// 32px items with 14px text. The default.
  size2,
}

/// How a menu marks the item under the pointer or keyboard.
enum FortalMenuVariant {
  /// The accent's solid fill under its contrast text.
  solid,

  /// A tinted accent fill.
  soft,
}

/// The Fortal Menu recipe: the trigger, the floating panel, its items,
/// submenu items and dividers.
///
/// [highContrast] moves the highlighted item of the solid variant to accent
/// step 12.
@MixWidget(target: RemixMenu.new)
MenuStyler fortalMenuStyle({
  FortalMenuVariant variant = .solid,
  FortalMenuSize size = .size2,
  bool highContrast = false,
  MenuStyler style = const MenuStyler.create(),
}) {
  final metrics = _metrics(size);

  return MenuStyler()
      .containerEffects(
        RemixBoxEffectsMix.backdropBlur(FortalTokens.panelBlur()),
      )
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
                    color: FortalTokens.gray7(),
                    width: FortalTokens.borderWidth1(),
                  ),
                ),
                borderRadius: BorderRadiusMix.all(metrics.contentRadius),
              ),
            )
            .color(FortalTokens.colorPanel())
            .decoration(
              BoxDecorationMix.create(boxShadow: FortalTokens.shadow5.mix()),
            )
            .clipBehavior(Clip.antiAlias),
      )
      .item(_item(variant, metrics, highContrast: highContrast))
      .submenuItem(_submenuItem(variant, metrics, highContrast: highContrast))
      .divider(_divider(metrics))
      .merge(style);
}

/// The Fortal menu item recipe, for styling one item on its own.
///
/// It is the item style [fortalMenuStyle] gives every item, so a call site can
/// match a menu's items outside the menu.
MenuItemStyler fortalMenuItemStyle({
  FortalMenuVariant variant = .solid,
  FortalMenuSize size = .size2,
  bool highContrast = false,
}) => _item(variant, _metrics(size), highContrast: highContrast);

MenuTriggerStyler _trigger(_Metrics metrics) => MenuTriggerStyler()
    .wrap(fortalTouchTarget())
    .onFocusVisible(
      MenuTriggerStyler().container(
        FlexBoxStyler().wrap(fortalFocusRingModifier()),
      ),
    )
    .onDisabled(
      MenuTriggerStyler().container(
        FlexBoxStyler().wrap(fortalFocusRingModifier(visible: false)),
      ),
    )
    .spacing(metrics.triggerGap)
    .label(.style(metrics.text.mix()).color(FortalTokens.gray12()))
    .icon(.color(FortalTokens.gray12()).size(metrics.contentIconSize));

MenuItemStyler _item(
  FortalMenuVariant variant,
  _Metrics metrics, {
  required bool highContrast,
}) {
  final base = MenuItemStyler()
      .wrap(fortalTouchTarget())
      .direction(.horizontal)
      .spacing(FortalTokens.space2())
      .height(metrics.itemHeight)
      .padding(.horizontal(metrics.leadingInset))
      .borderRadius(.all(metrics.itemRadius))
      .label(.style(metrics.text.mix()).color(FortalTokens.gray12()))
      .leadingIcon(.color(FortalTokens.gray12()).size(metrics.contentIconSize))
      .trailingIcon(
        .color(FortalTokens.grayA11()).size(metrics.contentIconSize),
      )
      // A shortcut or count follows the trailing icon's color in every state.
      .trailingText(.color(FortalTokens.grayA11()))
      .indicator(.color(FortalTokens.gray12()).size(metrics.indicatorSize));
  final highlighted = _highlightedItem(variant, highContrast: highContrast);
  final disabled = MenuItemStyler()
      .container(FlexBoxStyler().wrap(fortalFocusRingModifier(visible: false)))
      .color(const Color(0x00000000))
      .label(.color(FortalTokens.grayA8()))
      .leadingIcon(.color(FortalTokens.grayA8()))
      .trailingIcon(.color(FortalTokens.grayA8()))
      .trailingText(.color(FortalTokens.grayA8()))
      .indicator(.color(FortalTokens.grayA8()));

  return base
      .onHovered(highlighted)
      .onFocused(highlighted)
      .onPressed(highlighted)
      .onFocusVisible(
        MenuItemStyler().container(
          FlexBoxStyler().fortalFocusRing(radius: metrics.itemRadius),
        ),
      )
      .onDisabled(disabled);
}

MenuItemStyler _highlightedItem(
  FortalMenuVariant variant, {
  required bool highContrast,
}) {
  final solidForeground = highContrast
      ? FortalTokens.accent1()
      : FortalTokens.accentContrast();

  return switch (variant) {
    .solid =>
      MenuItemStyler()
          .color(
            highContrast ? FortalTokens.accent12() : FortalTokens.accentSolid(),
          )
          .label(.color(solidForeground))
          .leadingIcon(.color(solidForeground))
          .trailingIcon(.color(solidForeground))
          .trailingText(.color(solidForeground))
          .indicator(.color(solidForeground)),
    .soft =>
      MenuItemStyler()
          .color(FortalTokens.accentA4())
          .trailingIcon(.color(FortalTokens.gray12()))
          .trailingText(.color(FortalTokens.gray12())),
  };
}

MenuItemStyler _submenuItem(
  FortalMenuVariant variant,
  _Metrics metrics, {
  required bool highContrast,
}) {
  final highlighted = _highlightedItem(variant, highContrast: highContrast);
  final submenuOpen = MenuItemStyler()
      .color(switch (variant) {
        .solid => FortalTokens.grayA3(),
        .soft => FortalTokens.accentA3(),
      })
      .onHovered(highlighted)
      // Roving `data-highlighted` state, not a focus-visible ring.
      .onFocused(highlighted)
      .onPressed(highlighted);

  return MenuItemStyler()
      .trailingIcon(.color(FortalTokens.gray12()).size(metrics.indicatorSize))
      .onSelected(submenuOpen);
}

DividerStyler _divider(_Metrics metrics) => DividerStyler()
    .height(FortalTokens.borderWidth1())
    .margin(
      .left(
        metrics.leadingInset,
      ).right(metrics.trailingInset).vertical(FortalTokens.space2()),
    )
    .color(FortalTokens.grayA6());

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

_Metrics _metrics(FortalMenuSize size) => switch (size) {
  .size1 => _Metrics(
    contentPadding: FortalTokens.space1(),
    contentRadius: FortalTokens.radius3(),
    itemHeight: FortalTokens.space5(),
    itemRadius: FortalTokens.radius1(),
    leadingInset: FortalTokens.space2(),
    trailingInset: FortalTokens.space2(),
    indicatorSize: FortalTokens.space2(),
    contentIconSize: FortalTokens.space3(),
    triggerGap: FortalTokens.space1(),
    text: FortalTokens.text1,
  ),
  .size2 => _Metrics(
    contentPadding: FortalTokens.space2(),
    contentRadius: FortalTokens.radius4(),
    itemHeight: FortalTokens.space6(),
    itemRadius: FortalTokens.radius2(),
    leadingInset: FortalTokens.space3(),
    trailingInset: FortalTokens.space3(),
    indicatorSize: FortalTokens.selectIndicatorSize2(),
    contentIconSize: FortalTokens.space4(),
    triggerGap: FortalTokens.space2(),
    text: FortalTokens.text2,
  ),
};
