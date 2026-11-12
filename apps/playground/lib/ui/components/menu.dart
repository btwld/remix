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
MenuStyler playgroundMenuStyle({
  MenuStyler style = const MenuStyler.create(),
}) => MenuStyler()
    .trigger(_triggerStyle())
    // The panel pads above and below only; each row takes the side inset
    // as its own margin, so a divider can run edge to edge.
    .overlay(
      FlexBoxStyler()
          .direction(.vertical)
          .mainAxisSize(.min)
          .color(PlaygroundTokens.popover())
          .border(
            .color(
              PlaygroundTokens.border(),
            ).width(PlaygroundTokens.strokeHairline),
          )
          .borderRadius(.all(PlaygroundTokens.radiusMd()))
          .padding(.vertical(PlaygroundTokens.s1))
          .minWidth(PlaygroundTokens.panelMinWidth),
    )
    .containerEffects(.behindContent(PlaygroundShadow.md.effects))
    .item(_itemStyle())
    .divider(_dividerStyle())
    .merge(style);

/// The label trigger: quiet at rest, with hover and focus so a keyboard user
/// can see where they are. A button trigger (`RemixMenuTrigger.control`) owns
/// its own look.
MenuTriggerStyler _triggerStyle() => MenuTriggerStyler()
    .animate(PlaygroundTokens.motion)
    .direction(.horizontal)
    .mainAxisSize(.min)
    .crossAxisAlignment(.center)
    .minHeight(PlaygroundTokens.controlSm)
    .padding(
      .symmetric(
        horizontal: PlaygroundTokens.s2,
        vertical: PlaygroundTokens.s1_5,
      ),
    )
    .spacing(PlaygroundTokens.s2)
    .borderRadius(.all(PlaygroundTokens.radiusMd()))
    .label(
      .style(PlaygroundTokens.textSm.mix())
          .fontWeight(FontWeight.w500)
          .color(PlaygroundTokens.foreground())
          .maxLines(1)
          .softWrap(false)
          .overflow(.ellipsis),
    )
    .icon(.size(PlaygroundTokens.icon).color(PlaygroundTokens.foreground()))
    .onHovered(.color(PlaygroundTokens.accent()))
    // An outline rather than a border, which would nudge the label.
    .onFocusVisible(.containerEffects(playgroundFocusRing()))
    .onDisabled(
      MenuTriggerStyler().wrap(.opacity(PlaygroundTokens.disabledOpacity)),
    );

/// One row of any kind. `accent` marks the highlighted row on hover and on
/// focus, so arrow-key users see the same row a pointer user would.
MenuItemStyler _itemStyle() => MenuItemStyler()
    .direction(.horizontal)
    .crossAxisAlignment(.center)
    .minHeight(PlaygroundTokens.controlSm)
    .margin(.horizontal(PlaygroundTokens.s1))
    .padding(
      .symmetric(
        horizontal: PlaygroundTokens.s2,
        vertical: PlaygroundTokens.s1_5,
      ),
    )
    .spacing(PlaygroundTokens.s2)
    .borderRadius(.all(PlaygroundTokens.radiusSm()))
    .label(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).color(PlaygroundTokens.popoverForeground()),
    )
    .leadingIcon(
      .size(PlaygroundTokens.icon).color(PlaygroundTokens.mutedForeground()),
    )
    // 10px sizes Remix's edge-to-edge 9x9 chevron and check paths.
    .trailingIcon(
      .size(PlaygroundTokens.s2_5).color(PlaygroundTokens.mutedForeground()),
    )
    .trailingText(
      .style(
        PlaygroundTokens.textXs.mix(),
      ).color(PlaygroundTokens.mutedForeground()),
    )
    .indicator(
      .size(PlaygroundTokens.s2_5).color(PlaygroundTokens.popoverForeground()),
    )
    .onHovered(_highlighted())
    .onFocused(_highlighted())
    .onDisabled(
      MenuItemStyler().wrap(.opacity(PlaygroundTokens.disabledOpacity)),
    );

/// The label and check mark follow the row onto `accentForeground`; the icons
/// and trailing text stay `mutedForeground`.
MenuItemStyler _highlighted() => MenuItemStyler()
    .color(PlaygroundTokens.accent())
    .label(.color(PlaygroundTokens.accentForeground()))
    .indicator(.color(PlaygroundTokens.accentForeground()));

/// A `border` hairline between groups of rows, edge to edge across the panel.
DividerStyler _dividerStyle() => DividerStyler()
    .color(PlaygroundTokens.border())
    .height(PlaygroundTokens.strokeHairline)
    .margin(.vertical(PlaygroundTokens.s1))
    .wrap(.fractionallySizedBox(widthFactor: 1));
