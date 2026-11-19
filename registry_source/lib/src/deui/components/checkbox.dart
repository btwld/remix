import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'checkbox.g.dart';

/// Deui recipe for [RemixCheckbox]: a 20px box with 6px corners and a 2px
/// edge that fills `accent` when checked or mixed.
///
/// [invalid] draws the edge and label in `danger`. The check mark is Remix's
/// indicator at 12px. [style] merges last.
@MixWidget(target: RemixCheckbox.new)
CheckboxStyler deuiCheckboxStyle({
  bool invalid = false,
  Size minimumTapTargetSize = deuiCheckboxTapTarget,
  CheckboxStyler style = const CheckboxStyler.create(),
}) {
  final label = invalid ? DeuiTokens.danger : DeuiTokens.foreground;
  final edge = invalid ? DeuiTokens.danger() : _edge();

  return CheckboxStyler()
      .size(_control, _control)
      .alignment(.center)
      .borderRadius(.circular(_radius))
      .color(DeuiTokens.background())
      .border(.color(edge).width(_edgeWidth))
      .indicator(.size(_checkmark).color(DeuiTokens.accentForeground()))
      .label(deuiLabelText.color(label()))
      .labelSpacing(_labelGap)
      .onHovered(
        CheckboxStyler().border(.color(DeuiTokens.muted()).width(_edgeWidth)),
      )
      .onSelected(
        CheckboxStyler()
            .color(DeuiTokens.accent())
            .border(.color(DeuiTokens.accent()).width(_edgeWidth)),
      )
      .onIndeterminate(
        CheckboxStyler()
            .color(DeuiTokens.accent())
            .border(.color(DeuiTokens.accent()).width(_edgeWidth)),
      )
      .onPressed(CheckboxStyler().scale(.92))
      .onFocusVisible(.containerEffects(deuiFocusRing()))
      .animate(DeuiTokens.selectionMotion)
      .onDisabled(
        CheckboxStyler()
            .label(.color(deuiDisabledLabelColor(danger: invalid)()))
            .wrap(.opacity(DeuiTokens.disabledOpacity)),
      )
      .merge(style);
}

/// The 20px box needs no more than itself as a tap target.
const deuiCheckboxTapTarget = Size.square(20);

const _control = 20.0;
const _radius = 6.0;
const _edgeWidth = 2.0;
const _labelGap = 8.0;
const _checkmark = 12.0;

/// `muted` at 50%: the box's resting edge.
final _edge = deuiAlpha(DeuiTokens.muted, .5);
