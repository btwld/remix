import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'menu.g.dart';

/// The application's Menu recipe.
///
/// One recipe covers every row kind: `MenuSpec` falls back to `item` for
/// `checkboxItem`, `radioItem` and `submenuItem`, so styling only `item` keeps
/// the menu one list.
///
/// The panel matches the popover's `popover` fill and `border` hairline, so a
/// menu and a popover beside each other do not read as two systems.
@MixWidget(target: RemixMenu.new)
MenuStyler vanillaMenuStyle({MenuStyler style = const MenuStyler.create()}) =>
    MenuStyler()
        .trigger(_triggerStyle())
        // The panel pads above and below only; each row takes the side inset
        // as its own margin, so a divider can run edge to edge.
        .overlay(
          FlexBoxStyler()
              .direction(.vertical)
              .mainAxisSize(.min)
              .color(VanillaTokens.popover())
              .border(
                .color(
                  VanillaTokens.border(),
                ).width(VanillaTokens.strokeHairline),
              )
              .borderRadius(.all(VanillaTokens.radiusMd()))
              .padding(.vertical(VanillaTokens.s1))
              .minWidth(VanillaTokens.panelMinWidth),
        )
        .containerEffects(.behindContent(VanillaShadow.md.effects))
        .item(_itemStyle())
        .divider(_dividerStyle())
        .merge(style);

/// The label trigger: quiet at rest, with hover and focus so a keyboard user
/// can see where they are. A button trigger (`RemixMenuTrigger.control`) owns
/// its own look.
MenuTriggerStyler _triggerStyle() => MenuTriggerStyler()
    .animate(VanillaTokens.motion)
    .direction(.horizontal)
    .mainAxisSize(.min)
    .crossAxisAlignment(.center)
    .minHeight(VanillaTokens.controlSm)
    .padding(
      .symmetric(horizontal: VanillaTokens.s2, vertical: VanillaTokens.s1_5),
    )
    .spacing(VanillaTokens.s2)
    .borderRadius(.all(VanillaTokens.radiusMd()))
    .label(
      .style(VanillaTokens.textSm.mix())
          .fontWeight(FontWeight.w500)
          .color(VanillaTokens.foreground())
          .maxLines(1)
          .softWrap(false)
          .overflow(.ellipsis),
    )
    .icon(.size(VanillaTokens.icon).color(VanillaTokens.foreground()))
    .onHovered(.color(VanillaTokens.accent()))
    // An outline rather than a border, which would nudge the label.
    .onFocusVisible(.containerEffects(vanillaFocusRing()))
    .onDisabled(
      MenuTriggerStyler().wrap(.opacity(VanillaTokens.disabledOpacity)),
    );

/// One row of any kind. `accent` marks the highlighted row on hover and on
/// focus, so arrow-key users see the same row a pointer user would.
MenuItemStyler _itemStyle() => MenuItemStyler()
    .direction(.horizontal)
    .crossAxisAlignment(.center)
    .minHeight(VanillaTokens.controlSm)
    .margin(.horizontal(VanillaTokens.s1))
    .padding(
      .symmetric(horizontal: VanillaTokens.s2, vertical: VanillaTokens.s1_5),
    )
    .spacing(VanillaTokens.s2)
    .borderRadius(.all(VanillaTokens.radiusSm()))
    .label(
      .style(
        VanillaTokens.textSm.mix(),
      ).color(VanillaTokens.popoverForeground()),
    )
    .leadingIcon(
      .size(VanillaTokens.icon).color(VanillaTokens.mutedForeground()),
    )
    // 10px sizes Remix's edge-to-edge 9x9 chevron and check paths.
    .trailingIcon(
      .size(VanillaTokens.s2_5).color(VanillaTokens.mutedForeground()),
    )
    .trailingText(
      .style(VanillaTokens.textXs.mix()).color(VanillaTokens.mutedForeground()),
    )
    .indicator(
      .size(VanillaTokens.s2_5).color(VanillaTokens.popoverForeground()),
    )
    .onHovered(_highlighted())
    .onFocused(_highlighted())
    .onDisabled(MenuItemStyler().wrap(.opacity(VanillaTokens.disabledOpacity)));

/// The label and check mark follow the row onto `accentForeground`; the icons
/// and trailing text stay `mutedForeground`.
MenuItemStyler _highlighted() => MenuItemStyler()
    .color(VanillaTokens.accent())
    .label(.color(VanillaTokens.accentForeground()))
    .indicator(.color(VanillaTokens.accentForeground()));

/// A `border` hairline between groups of rows, edge to edge across the panel.
DividerStyler _dividerStyle() => DividerStyler()
    .color(VanillaTokens.border())
    .height(VanillaTokens.strokeHairline)
    .margin(.vertical(VanillaTokens.s1))
    .wrap(.fractionallySizedBox(widthFactor: 1));
