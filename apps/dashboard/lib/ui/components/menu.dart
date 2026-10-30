import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'menu.g.dart';

/// Ui menu content sizes.
enum UiMenuSize { size1, size2 }

/// Ui menu content variants.
enum UiMenuVariant { solid, soft }

/// Ui menu content with Ui-owned size, variant, and contrast behavior.
@MixWidget(target: RemixMenu.new)
MenuStyler uiMenuStyle({
  UiMenuVariant variant = .solid,
  UiMenuSize size = .size2,
  bool highContrast = false,
  MenuStyler style = const MenuStyler.create(),
}) {
  final metrics = _uiMenuMetrics(size);
  final base = MenuStyler()
      .containerEffects(RemixBoxEffectsMix.backdropBlur(UiTokens.panelBlur()))
      .trigger(_uiMenuTriggerStyler(metrics))
      .overlay(
        FlexBoxStyler()
            .padding(.all(metrics.contentPadding))
            .borderRadius(.all(metrics.contentRadius))
            .color(UiTokens.colorPanel())
            .decoration(
              BoxDecorationMix.create(boxShadow: UiTokens.shadow5.mix()),
            )
            .clipBehavior(Clip.antiAlias),
      )
      .item(_uiMenuItemStyler(variant, metrics, highContrast: highContrast))
      .submenuItem(
        _uiMenuSubmenuItemStyler(variant, metrics, highContrast: highContrast),
      )
      .divider(_uiMenuDividerStyler(metrics));

  return base.merge(style);
}

/// Ui item recipe for per-item style overrides.
MenuItemStyler uiMenuItemStyle({
  UiMenuVariant variant = .solid,
  UiMenuSize size = .size2,
  bool highContrast = false,
}) => _uiMenuItemStyler(
  variant,
  _uiMenuMetrics(size),
  highContrast: highContrast,
);

MenuTriggerStyler _uiMenuTriggerStyler(_UiMenuMetrics metrics) =>
    MenuTriggerStyler()
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

MenuItemStyler _uiMenuItemStyler(
  UiMenuVariant variant,
  _UiMenuMetrics metrics, {
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
      .indicator(.color(UiTokens.gray12()).size(metrics.indicatorSize));
  final highlighted = _uiMenuHighlightedItemStyler(
    variant,
    highContrast: highContrast,
  );
  final disabled = MenuItemStyler()
      .container(FlexBoxStyler().wrap(uiFocusRingModifier(visible: false)))
      .color(const Color(0x00000000))
      .label(.color(UiTokens.grayA8()))
      .leadingIcon(.color(UiTokens.grayA8()))
      .trailingIcon(.color(UiTokens.grayA8()))
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

MenuItemStyler _uiMenuHighlightedItemStyler(
  UiMenuVariant variant, {
  required bool highContrast,
}) {
  final solidForeground = highContrast
      ? UiTokens.accent1()
      : UiTokens.accentContrast();

  return switch (variant) {
    .solid =>
      MenuItemStyler()
          .color(highContrast ? UiTokens.accent12() : UiTokens.accent9())
          .label(.color(solidForeground))
          .leadingIcon(.color(solidForeground))
          .trailingIcon(.color(solidForeground))
          .indicator(.color(solidForeground)),
    .soft =>
      MenuItemStyler()
          .color(UiTokens.accentA4())
          .trailingIcon(.color(UiTokens.gray12())),
  };
}

MenuItemStyler _uiMenuSubmenuItemStyler(
  UiMenuVariant variant,
  _UiMenuMetrics metrics, {
  required bool highContrast,
}) {
  final highlighted = _uiMenuHighlightedItemStyler(
    variant,
    highContrast: highContrast,
  );
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

DividerStyler _uiMenuDividerStyler(_UiMenuMetrics metrics) => DividerStyler()
    .height(UiTokens.borderWidth1())
    .margin(
      .left(
        metrics.leadingInset,
      ).right(metrics.trailingInset).vertical(UiTokens.space2()),
    )
    .color(UiTokens.grayA6());

class _UiMenuMetrics {
  const _UiMenuMetrics({
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

_UiMenuMetrics _uiMenuMetrics(UiMenuSize size) => switch (size) {
  .size1 => _UiMenuMetrics(
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
  .size2 => _UiMenuMetrics(
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
