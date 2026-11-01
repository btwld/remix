import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'dropdown.g.dart';

/// HeroUI menu-item tones: the default item, or `menu-item--danger`.
enum HeroUiDropdownItemVariant { defaultItem, danger }

/// HeroUI recipe for [RemixMenu]: the dropdown trigger and its popover menu.
///
/// Style a single row with [heroUiDropdownItemStyle], for example a danger item
/// in `RemixMenuItem.style`.
@MixWidget(target: RemixMenu.new)
MenuStyler heroUiDropdownStyle({
  MenuStyler style = const MenuStyler.create(),
}) => MenuStyler()
    .trigger(_trigger)
    .overlay(_popover)
    .containerEffects(heroUiSurfaceEffects(overlay: true))
    .item(heroUiDropdownItemStyle())
    .divider(
      DividerStyler().height(_dividerHeight).color(HeroUiTokens.separator()),
    )
    .merge(style);

/// The `.menu-item` row: `min-h-9 gap-3 rounded-2xl`, `px-2.5` inside the
/// dropdown popover.
MenuItemStyler heroUiDropdownItemStyle({
  HeroUiDropdownItemVariant variant = .defaultItem,
}) {
  final danger = variant == .danger;
  final label = danger ? HeroUiTokens.danger : HeroUiTokens.foreground;

  return MenuItemStyler()
      .direction(.horizontal)
      .crossAxisAlignment(.center)
      .spacing(_gap)
      .minHeight(_minHeight)
      .padding(.horizontal(_paddingX))
      .padding(.vertical(_paddingY))
      .borderRadius(.all(HeroUiTokens.radius2xl()))
      .label(.style(HeroUiTokens.textSm.mix()).fontWeight(.w500).color(label()))
      // `.menu-item__indicator` is `text-muted`, `text-danger` on danger items;
      // its check mark is `size-2.5`.
      .indicator(
        .size(
          _indicator,
        ).color(danger ? HeroUiTokens.danger() : HeroUiTokens.muted()),
      )
      // The CSS leaves item icons to the content; HeroUI's menu examples size
      // them `size-4`.
      .leadingIcon(.size(_leadingIcon).color(label()))
      .trailingIcon(.size(_trailingIcon).color(HeroUiTokens.muted()))
      .onHovered(.color(HeroUiTokens.defaultColor()))
      .onPressed(MenuItemStyler().scale(_itemPressedScale))
      .onFocusVisible(MenuItemStyler().containerEffects(heroUiFocusRing()))
      .animate(HeroUiTokens.transformMotion)
      .onDisabled(
        MenuItemStyler()
            .label(.color(heroUiDisabledLabelColor(danger: danger)()))
            .wrap(.opacity(HeroUiTokens.disabledOpacity)),
      );
}

/// `.dropdown__trigger`: a bare trigger that scales on press and shows the
/// focus ring.
final _trigger = MenuTriggerStyler()
    .onPressed(MenuTriggerStyler().scale(_triggerPressedScale))
    .onFocusVisible(MenuTriggerStyler().containerEffects(heroUiFocusRing()))
    .animate(HeroUiTokens.transformMotion);

/// `.dropdown__popover` around `.dropdown__menu`: `bg-overlay` and the panel
/// radius.
final _popover = FlexBoxStyler()
    .padding(.all(_menuPadding))
    .spacing(_menuGap)
    .color(HeroUiTokens.overlay())
    .borderRadius(.all(HeroUiTokens.radiusPanel()))
    .clipBehavior(.antiAlias)
    .onBreakpoint(
      const Breakpoint.minWidth(HeroUiTokens.breakpointMd),
      FlexBoxStyler().minWidth(_minPopoverWidth),
    );

/// `.menu-item`: `gap-3 min-h-9 px-2.5 py-1.5` (`px-2.5` from
/// `.dropdown__popover`), and its check mark's `size-2.5`.
const _gap = 12.0;
const _minHeight = 36.0;
const _paddingX = 10.0;
const _paddingY = 6.0;
const _indicator = 10.0;

/// An item's leading icon, `size-4` in HeroUI's menu examples, and the
/// trailing submenu chevron's `size-3.5` (`menu-item.css`).
const _leadingIcon = 16.0;
const _trailingIcon = 14.0;

/// `[data-slot=dropdown-menu]` `p-1.5` around rows `gap-0.5` apart, and the
/// popover's `md:min-w-55`.
const _menuPadding = 6.0;
const _menuGap = 2.0;
const _minPopoverWidth = 220.0;

/// `separator.css`: `h-px`.
const _dividerHeight = 1.0;

/// `transform: scale(0.98)` on a pressed row (`menu-item.css`) and
/// `scale(0.97)` on the pressed trigger (`dropdown.css`).
const _itemPressedScale = .98;
const _triggerPressedScale = .97;
