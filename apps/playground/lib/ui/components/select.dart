import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'select.g.dart';

/// The application's Select recipe.
///
/// Remix owns the rendering, the overlay, keyboard traversal, the open and
/// close behavior, and the listbox accessibility semantics; this recipe
/// supplies the trigger, the floating panel, and the option rows.
///
/// One recipe covers all three, because `SelectSpec` carries them as fields:
/// `trigger`, `content` with `menuContainer`, and `item`. An option in a loop
/// therefore cannot be left unstyled.
///
/// The trigger is styled as a field rather than as a button — same border,
/// same radius, same heights as the text field — because that is what it is.
/// The panel matches the menu's, so a select and a menu opened side by side
/// do not read as two systems.
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

/// The trigger's fill: the text field's, transparent or `input` at 30% in the
/// dark.
final _triggerFill = playgroundTint(
  PlaygroundTokens.input,
  0,
  dark: _darkTriggerFillAlpha,
);

/// The dark trigger under the pointer, `input` at 50%. A light trigger does not
/// change on hover: the chevron and the pointer cursor already say it opens.
final _triggerHoverFill = playgroundTint(
  PlaygroundTokens.input,
  0,
  dark: _darkTriggerHoverAlpha,
);

const _darkTriggerFillAlpha = 0.3;
const _darkTriggerHoverAlpha = 0.5;

/// Opacity of the trigger's chevron, half strength: it marks the control
/// without competing with the value beside it.
const _chevronOpacity = 0.5;

/// The tallest a panel gets before it scrolls.
///
/// Bounded on purpose: an unbounded list of options grows past the viewport
/// and takes its own dismissal affordances with it.
const _panelMaxHeight = 320.0;

/// The closed control: a field showing the current value and a chevron, 36px
/// tall with a 12px side inset, 8px above and below, and an 8px gap.
SelectTriggerStyler _triggerStyle() => SelectTriggerStyler()
    .animate(PlaygroundTokens.motion)
    .direction(.horizontal)
    .crossAxisAlignment(.center)
    .mainAxisAlignment(.spaceBetween)
    .minHeight(PlaygroundTokens.controlMd)
    .padding(
      .symmetric(
        horizontal: PlaygroundTokens.s3,
        vertical: PlaygroundTokens.s2,
      ),
    )
    .spacing(PlaygroundTokens.s2)
    .color(_triggerFill())
    .border(
      .color(PlaygroundTokens.input()).width(PlaygroundTokens.strokeHairline),
    )
    .borderRadius(.all(PlaygroundTokens.radiusMd()))
    // In the effects layer rather than the decoration: the fill is
    // transparent, and a decoration shadow would show through it.
    .containerEffects(.behindContent(PlaygroundShadow.xs.effects))
    .label(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).color(PlaygroundTokens.foreground()),
    )
    // The placeholder is not a value: it has to read as the quieter of the
    // two, or a select with nothing chosen looks answered.
    .placeholder(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).color(PlaygroundTokens.mutedForeground()),
    )
    .icon(
      .size(PlaygroundTokens.icon).color(PlaygroundTokens.mutedForeground()),
    )
    // 10px (`PlaygroundTokens.s2_5`) sizes Remix's edge-to-edge 9×9 chevron path.
    .indicator(
      .size(PlaygroundTokens.s2_5).color(PlaygroundTokens.mutedForeground()),
    )
    .indicatorOpacity(_chevronOpacity)
    .onHovered(SelectTriggerStyler().color(_triggerHoverFill()))
    // A 3px band of `ring` at half strength, with the trigger's own outline
    // turned `ring`.
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

/// The floating panel the options live in: `popover` inside a `border`
/// hairline, `radiusMd` corners, a 4px inset, and the `md` shadow. It is at
/// least 128px wide and at least as wide as its trigger.
SelectContentStyler _contentStyle() => SelectContentStyler()
    .color(PlaygroundTokens.popover())
    .border(
      .color(PlaygroundTokens.border()).width(PlaygroundTokens.strokeHairline),
    )
    .borderRadius(.all(PlaygroundTokens.radiusMd()))
    .padding(.all(PlaygroundTokens.s1))
    .minWidth(PlaygroundTokens.panelMinWidth)
    // A second minimum on a modifier: the trigger's width still holds where a
    // caller replaces the 128px floor through `style`.
    .wrap(.box(BoxStyler().minWidth(remixAnchorWidth())))
    .maxHeight(_panelMaxHeight)
    .containerEffects(.behindContent(PlaygroundShadow.md.effects));

/// One option row: 8px in from either side, 6px above and below, with
/// `radiusSm` corners.
///
/// Remix lays the selected option's check mark out in the row after the label
/// rather than positioning it inside a right padding gutter, so symmetric 8px
/// horizontal padding places the check mark 8px from the trailing edge.
/// `accent` marks the row under the pointer *and* the row the arrow keys are
/// on, because a select is as often driven by the keyboard as by the mouse.
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
    // The check mark on the chosen option stays `mutedForeground`, highlighted
    // or not: it marks the row without competing with its label. 10px sizes
    // Remix's edge-to-edge 9×9 check path.
    .icon(
      .size(PlaygroundTokens.s2_5).color(PlaygroundTokens.mutedForeground()),
    )
    .onHovered(_highlighted())
    .onFocused(_highlighted())
    .onDisabled(
      SelectMenuItemStyler().wrap(.opacity(PlaygroundTokens.disabledOpacity)),
    );

/// The option under the pointer or the keyboard cursor.
SelectMenuItemStyler _highlighted() => SelectMenuItemStyler()
    .color(PlaygroundTokens.accent())
    .label(.color(PlaygroundTokens.accentForeground()));
