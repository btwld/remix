import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/scale.dart';
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
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it. State fragments merge by state, not
/// by depth: an override that must beat a row's hover fill has to be declared
/// as a hover fragment too.
@MixWidget(target: RemixMenu.new)
MenuStyler playgroundMenuStyle({
  MenuStyler style = const MenuStyler.create(),
}) => MenuStyler()
    .trigger(_triggerStyle())
    // shadcn's `DropdownMenuContent`: `rounded-md border bg-popover p-1
    // shadow-md`, at least 128px wide. The inset is split: the panel pads
    // above and below, and each row takes the side inset as its own
    // margin, which is what lets a separator run edge to edge.
    .overlay(
      FlexBoxStyler()
          .direction(.vertical)
          .mainAxisSize(.min)
          .color(PlaygroundTokens.popover())
          .border(
            .color(PlaygroundTokens.border()).width(PlaygroundStroke.hairline),
          )
          .borderRadius(.all(PlaygroundTokens.radiusMd()))
          .padding(.vertical(PlaygroundSpace.s1))
          .minWidth(PlaygroundSize.panelMinWidth),
    )
    .containerEffects(.behindContent(PlaygroundShadow.md.effects))
    .item(_itemStyle())
    .divider(_dividerStyle())
    .merge(style);

/// The control that opens the menu.
///
/// It is deliberately quiet at rest — no fill, no outline — because the
/// trigger usually already wraps a button or an icon button with a recipe of
/// its own, and two competing surfaces would read as a control inside a
/// control. It still answers hover and focus, because a caller is equally
/// free to wrap a bare `Text`, and that caller must not end up with a
/// keyboard-reachable control that shows nothing when it is reached.
MenuTriggerStyler _triggerStyle() => MenuTriggerStyler()
    .animate(PlaygroundMotion.standard)
    .direction(.horizontal)
    .mainAxisSize(.min)
    .crossAxisAlignment(.center)
    .minHeight(PlaygroundSize.controlSm)
    .padding(
      .symmetric(
        horizontal: PlaygroundSpace.s2,
        vertical: PlaygroundSpace.s1_5,
      ),
    )
    .spacing(PlaygroundSpace.s2)
    .borderRadius(.all(PlaygroundTokens.radiusMd()))
    .label(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).fontWeight(FontWeight.w500).color(PlaygroundTokens.foreground()),
    )
    .icon(.size(PlaygroundSize.icon).color(PlaygroundTokens.foreground()))
    .onHovered(.color(PlaygroundTokens.accent()))
    // A trigger is keyboard-reachable whether or not it wraps a control that
    // rings itself, so it rings too. A *foreground* decoration, because
    // `MenuTriggerSpec` has no `containerEffects` layer and a real border
    // would nudge the label.
    .onFocusVisible(.foregroundDecoration(playgroundFocusRingDecoration()))
    .onDisabled(MenuTriggerStyler().wrap(.opacity(PlaygroundOpacity.disabled)));

/// One row, in every kind the menu can hold: shadcn's `DropdownMenuItem`,
/// `px-2 py-1.5 rounded-sm text-sm`, 32px tall.
///
/// `accent` is what makes the highlighted row visible, and it is applied on
/// hover *and* on focus: a menu is as often driven by the arrow keys as by
/// the pointer, and a keyboard user has to see the same row a mouse user
/// would.
MenuItemStyler _itemStyle() => MenuItemStyler()
    .animate(PlaygroundMotion.standard)
    .direction(.horizontal)
    .crossAxisAlignment(.center)
    .minHeight(PlaygroundSize.controlSm)
    .margin(.horizontal(PlaygroundSpace.s1))
    .padding(
      .symmetric(
        horizontal: PlaygroundSpace.s2,
        vertical: PlaygroundSpace.s1_5,
      ),
    )
    .spacing(PlaygroundSpace.s2)
    .borderRadius(.all(PlaygroundTokens.radiusSm()))
    .label(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).color(PlaygroundTokens.popoverForeground()),
    )
    .leadingIcon(
      .size(PlaygroundSize.icon).color(PlaygroundTokens.mutedForeground()),
    )
    .trailingIcon(
      .size(PlaygroundSize.icon).color(PlaygroundTokens.mutedForeground()),
    )
    .indicator(
      .size(PlaygroundSize.icon).color(PlaygroundTokens.mutedForeground()),
    )
    .onHovered(_highlighted())
    .onFocused(_highlighted())
    .onDisabled(MenuItemStyler().wrap(.opacity(PlaygroundOpacity.disabled)));

/// The row under the pointer or the keyboard cursor.
MenuItemStyler _highlighted() => MenuItemStyler()
    .color(PlaygroundTokens.accent())
    .label(.color(PlaygroundTokens.accentForeground()))
    .leadingIcon(.color(PlaygroundTokens.accentForeground()))
    .trailingIcon(.color(PlaygroundTokens.accentForeground()))
    .indicator(.color(PlaygroundTokens.accentForeground()));

/// The rule between two groups of rows: shadcn's `-mx-1 my-1 h-px bg-border`.
///
/// It runs edge to edge across the panel, which is why the panel's side inset
/// lives on the rows rather than on the panel.
DividerStyler _dividerStyle() => DividerStyler()
    .color(PlaygroundTokens.border())
    .height(PlaygroundStroke.hairline)
    .margin(.vertical(PlaygroundSpace.s1))
    .wrap(.fractionallySizedBox(widthFactor: 1));
