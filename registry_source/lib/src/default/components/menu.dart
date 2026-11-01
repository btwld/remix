import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'menu.g.dart';

/// The application's Menu recipe.
///
/// Remix owns the rendering, the overlay, the anchor positioning, keyboard
/// traversal, submenu timing, dismissal, and the menu accessibility
/// semantics; this recipe supplies the trigger, the floating panel, and every
/// kind of row inside it.
///
/// One recipe covers all of them, because `MenuSpec` carries each row kind as
/// a field: `item` is the default, and `checkboxItem`, `radioItem`, and
/// `submenuItem` fall back to it unless a recipe says otherwise. Setting only
/// `item` is what keeps a menu looking like one list rather than four.
///
/// The panel is the same `popover` fill and `border` hairline the popover and
/// the select's options use. The files are deliberately separate — the
/// components have separate update stories — but the values are meant to
/// match, so a menu and a popover anchored to adjacent buttons do not read as
/// two systems.
@MixWidget(target: RemixMenu.new)
MenuStyler vanillaMenuStyle({MenuStyler style = const MenuStyler.create()}) =>
    MenuStyler()
        .trigger(_triggerStyle())
        // The panel: `popover` inside a `border` hairline, `radiusMd` corners,
        // a 4px inset, the `md` shadow, and at least 128px wide. The inset is
        // split: the panel pads above and below, and each row takes the side
        // inset as its own margin, which is what lets a separator run edge to
        // edge.
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

/// The standard label trigger of the menu.
///
/// It is quiet at rest, with no fill and no outline, and still answers hover
/// and focus, so a bare label never ends up keyboard-reachable while showing
/// nothing when it is reached. A real button is the trigger through
/// `RemixMenuTrigger.control`, which owns its own look; none of this styles it.
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

/// One row, in every kind the menu can hold: 32px tall, with an 8px side inset,
/// `radiusSm` corners, and `textSm`.
///
/// `accent` is what makes the highlighted row visible, and it is applied on
/// hover *and* on focus: a menu is as often driven by the arrow keys as by
/// the pointer, and a keyboard user has to see the same row a mouse user
/// would.
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
    // 10px (`VanillaTokens.s2_5`) sizes Remix's edge-to-edge 9×9 submenu
    // chevron and choice check paths.
    .trailingIcon(
      .size(VanillaTokens.s2_5).color(VanillaTokens.mutedForeground()),
    )
    .indicator(
      .size(VanillaTokens.s2_5).color(VanillaTokens.popoverForeground()),
    )
    .onHovered(_highlighted())
    .onFocused(_highlighted())
    .onDisabled(MenuItemStyler().wrap(.opacity(VanillaTokens.disabledOpacity)));

/// The row under the pointer or the keyboard cursor.
///
/// The label and the check mark follow the row onto `accentForeground`; the
/// leading and trailing icons stay `mutedForeground`, so they keep reading as
/// markers beside the label rather than as part of it.
MenuItemStyler _highlighted() => MenuItemStyler()
    .color(VanillaTokens.accent())
    .label(.color(VanillaTokens.accentForeground()))
    .indicator(.color(VanillaTokens.accentForeground()));

/// The rule between two groups of rows: a `border` hairline with 4px above and
/// below.
///
/// It runs edge to edge across the panel, which is why the panel's side inset
/// lives on the rows rather than on the panel.
DividerStyler _dividerStyle() => DividerStyler()
    .color(VanillaTokens.border())
    .height(VanillaTokens.strokeHairline)
    .margin(.vertical(VanillaTokens.s1))
    .wrap(.fractionallySizedBox(widthFactor: 1));
