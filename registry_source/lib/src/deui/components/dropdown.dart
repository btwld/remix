import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'dropdown.g.dart';

/// Deui menu-item tones.
enum DeuiDropdownItemVariant {
  /// The ordinary item.
  defaultItem,

  /// `menu-item--danger`: a destructive action, in the `danger` color.
  danger,
}

/// Deui recipe for [RemixMenu]: the dropdown trigger and its popover menu.
///
/// Style a single row with [deuiDropdownItemStyle], for example a danger item
/// in `RemixMenuItem.style`.
@MixWidget(target: RemixMenu.new)
MenuStyler deuiDropdownStyle({MenuStyler style = const MenuStyler.create()}) =>
    MenuStyler()
        .trigger(
          MenuTriggerStyler().onFocusVisible(
            .containerEffects(deuiFocusRing()),
          ),
        )
        .overlay(_popover)
        .item(deuiDropdownItemStyle())
        .divider(
          DividerStyler()
              .height(1)
              .color(DeuiTokens.border())
              .margin(.symmetric(vertical: _dividerGap)),
        )
        .merge(style);

/// One row of the menu: 40px, 8px corners, muted 16px icons.
MenuItemStyler deuiDropdownItemStyle({
  DeuiDropdownItemVariant variant = .defaultItem,
}) {
  final danger = variant == .danger;
  final label = danger ? DeuiTokens.danger : DeuiTokens.foreground;

  return MenuItemStyler()
      .direction(.horizontal)
      .crossAxisAlignment(.center)
      .minHeight(_minHeight)
      .padding(.symmetric(horizontal: _paddingX, vertical: _paddingY))
      .borderRadius(.circular(_itemRadius))
      .label(.style(DeuiTokens.textSm.mix()).color(label()))
      .indicator(
        .size(
          _indicator,
        ).color(danger ? DeuiTokens.danger() : DeuiTokens.muted()),
      )
      .leadingIcon(
        .size(_icon)
            .color(danger ? DeuiTokens.danger() : DeuiTokens.muted())
            .wrap(.padding(.only(right: _iconGap))),
      )
      .trailingIcon(.size(_icon).color(DeuiTokens.muted()))
      .trailingText(.style(DeuiTokens.textXs.mix()).color(DeuiTokens.muted()))
      .onHovered(.color(deuiRowHover()))
      .onFocusVisible(.color(deuiRowHover()))
      .onDisabled(MenuItemStyler().wrap(.opacity(DeuiTokens.disabledOpacity)));
}

final _popover = FlexBoxStyler()
    .padding(.symmetric(vertical: _menuPadding, horizontal: _menuPadding))
    .color(DeuiTokens.overlay())
    .borderRadius(.all(DeuiTokens.radiusLg()))
    .border(deuiHairline())
    .clipBehavior(.antiAlias);

const _minHeight = 40.0;
const _paddingX = 10.0;
const _paddingY = 8.0;
const _itemRadius = 8.0;
const _indicator = 14.0;
const _icon = 16.0;
const _iconGap = 10.0;
const _menuPadding = 6.0;
const _dividerGap = 4.0;
