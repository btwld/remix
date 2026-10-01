import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/scale.dart';
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
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it. State fragments merge by state, not
/// by depth: an override that must beat the trigger's focus ring has to be
/// declared as a focus fragment too.
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
    .animate(PlaygroundMotion.standard)
    .direction(.horizontal)
    .crossAxisAlignment(.center)
    .mainAxisAlignment(.spaceBetween)
    .minHeight(PlaygroundSize.controlMd)
    .padding(
      .symmetric(horizontal: PlaygroundSpace.s3, vertical: PlaygroundSpace.s2),
    )
    .spacing(PlaygroundSpace.s2)
    .color(_triggerFill())
    .border(.color(PlaygroundTokens.input()).width(PlaygroundStroke.hairline))
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
    .icon(.size(PlaygroundSize.icon).color(PlaygroundTokens.mutedForeground()))
    .indicator(
      .size(PlaygroundSize.icon).color(PlaygroundTokens.mutedForeground()),
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
          .wrap(.opacity(PlaygroundOpacity.disabled)),
    );

/// The floating panel the options live in: `popover` inside a `border`
/// hairline, `radiusMd` corners, a 4px inset, and the `md` shadow.
SelectContentStyler _contentStyle() => SelectContentStyler()
    .color(PlaygroundTokens.popover())
    .border(.color(PlaygroundTokens.border()).width(PlaygroundStroke.hairline))
    .borderRadius(.all(PlaygroundTokens.radiusMd()))
    .padding(.all(PlaygroundSpace.s1))
    .minWidth(PlaygroundSize.panelMinWidth)
    .maxHeight(_panelMaxHeight)
    .containerEffects(.behindContent(PlaygroundShadow.md.effects));

/// One option row: 8px in from the leading edge, 32px from the trailing one,
/// 6px above and below, with `radiusSm` corners.
///
/// The trailing inset leaves room for the check mark Remix draws on the
/// chosen option. `accent` marks the row under the pointer *and* the row the
/// arrow keys are on, because a select is as often driven by the keyboard as
/// by the mouse.
SelectMenuItemStyler _itemStyle() => SelectMenuItemStyler()
    .animate(PlaygroundMotion.standard)
    .direction(.horizontal)
    .crossAxisAlignment(.center)
    .minHeight(PlaygroundSize.controlSm)
    .padding(
      .only(
        left: PlaygroundSpace.s2,
        right: PlaygroundSpace.s8,
        top: PlaygroundSpace.s1_5,
        bottom: PlaygroundSpace.s1_5,
      ),
    )
    .spacing(PlaygroundSpace.s2)
    .borderRadius(.all(PlaygroundTokens.radiusSm()))
    .label(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).color(PlaygroundTokens.popoverForeground()),
    )
    // The check mark on the chosen option stays `mutedForeground`, highlighted
    // or not: it marks the row without competing with its label.
    .icon(.size(PlaygroundSize.icon).color(PlaygroundTokens.mutedForeground()))
    .onHovered(_highlighted())
    .onFocused(_highlighted())
    .onDisabled(
      SelectMenuItemStyler().wrap(.opacity(PlaygroundOpacity.disabled)),
    );

/// The option under the pointer or the keyboard cursor.
SelectMenuItemStyler _highlighted() => SelectMenuItemStyler()
    .color(PlaygroundTokens.accent())
    .label(.color(PlaygroundTokens.accentForeground()));
