import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'select.g.dart';

/// The application's Select recipe.
///
/// One recipe covers the trigger, the floating panel and the option rows,
/// because `SelectSpec` carries all three. The trigger is styled as a field,
/// like the text field; the panel matches the menu's.
@MixWidget(target: RemixSelect.new)
SelectStyler playgroundSelectStyle({
  SelectStyler style = const SelectStyler.create(),
}) {
  return SelectStyler()
      .trigger(_triggerStyle())
      .content(_contentStyle())
      .menuContainer(.direction(.vertical).mainAxisSize(.min))
      .item(_itemStyle())
      .merge(style);
}

/// The closed control: a field showing the current value and a chevron.
/// See "Select trigger vertical padding" in the spec's Deviations.
SelectTriggerStyler _triggerStyle() => SelectTriggerStyler()
    .animate(PlaygroundTokens.motion)
    .direction(.horizontal)
    .crossAxisAlignment(.center)
    .mainAxisAlignment(.spaceBetween)
    .minHeight(PlaygroundTokens.controlMd)
    .padding(
      .symmetric(
        horizontal: PlaygroundTokens.s3,
        vertical: PlaygroundTokens.s1,
      ),
    )
    .spacing(PlaygroundTokens.s2)
    // Transparent, or `input` at 30% in the dark theme.
    .color(playgroundTint(PlaygroundTokens.input, 0, dark: 0.3)())
    .border(
      .color(PlaygroundTokens.input()).width(PlaygroundTokens.strokeHairline),
    )
    .borderRadius(.all(PlaygroundTokens.radiusMd()))
    // In the effects layer: the fill is transparent, and a decoration shadow
    // would show through it.
    .containerEffects(.behindContent(PlaygroundShadow.xs.effects))
    .label(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).color(PlaygroundTokens.foreground()),
    )
    // Quieter than a value, or an empty select looks answered.
    .placeholder(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).color(PlaygroundTokens.mutedForeground()),
    )
    .icon(
      .size(PlaygroundTokens.icon).color(PlaygroundTokens.mutedForeground()),
    )
    // 10px sizes Remix's edge-to-edge 9x9 chevron path.
    .indicator(
      .size(PlaygroundTokens.s2_5).color(PlaygroundTokens.mutedForeground()),
    )
    .indicatorOpacity(0.5)
    // Only the dark trigger changes on hover; the chevron already says it opens.
    .onHovered(
      SelectTriggerStyler().color(
        playgroundTint(PlaygroundTokens.input, 0, dark: 0.5)(),
      ),
    )
    .onFocusVisible(
      SelectTriggerStyler()
          .containerEffects(playgroundFocusRing())
          .border(playgroundFocusBorder()),
    )
    .onDisabled(
      SelectTriggerStyler()
          .containerEffects(.outline(.style(.none)))
          .wrap(.opacity(PlaygroundTokens.disabledOpacity)),
    );

/// The floating panel: at least 128px wide and at least as wide as its
/// trigger.
SelectContentStyler _contentStyle() => SelectContentStyler()
    .color(PlaygroundTokens.popover())
    .border(
      .color(PlaygroundTokens.border()).width(PlaygroundTokens.strokeHairline),
    )
    .borderRadius(.all(PlaygroundTokens.radiusMd()))
    .padding(.all(PlaygroundTokens.s1))
    .minWidth(PlaygroundTokens.panelMinWidth)
    // A second minimum on a modifier, so the trigger's width holds even if a
    // caller replaces the 128px floor.
    .wrap(.box(BoxStyler().minWidth(remixAnchorWidth())))
    .maxHeight(PlaygroundTokens.panelMaxHeight)
    .containerEffects(.behindContent(PlaygroundShadow.md.effects));

/// One option row. Remix lays the check mark out after the label, so the
/// symmetric 8px padding puts it 8px from the trailing edge. `accent` marks the
/// row under the pointer and the one the arrow keys are on.
SelectMenuItemStyler _itemStyle() => SelectMenuItemStyler()
    .direction(.horizontal)
    .crossAxisAlignment(.center)
    .minHeight(PlaygroundTokens.controlSm)
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
    // The check stays `mutedForeground`, highlighted or not. 10px sizes
    // Remix's edge-to-edge 9x9 check path.
    .icon(
      .size(PlaygroundTokens.s2_5).color(PlaygroundTokens.mutedForeground()),
    )
    .onHovered(_highlighted())
    .onFocused(_highlighted())
    .onDisabled(
      SelectMenuItemStyler().wrap(.opacity(PlaygroundTokens.disabledOpacity)),
    );

SelectMenuItemStyler _highlighted() => SelectMenuItemStyler()
    .color(PlaygroundTokens.accent())
    .label(.color(PlaygroundTokens.accentForeground()));
