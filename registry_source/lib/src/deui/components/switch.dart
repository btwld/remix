import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'switch.g.dart';

/// Deui recipe for [RemixSwitch]: a 40 by 24 pill whose track is `muted` at
/// 60% off and `accent` on, with a 16px `background` thumb that presses in.
///
/// [invalid] colours the label `danger`. Remix keeps the keyboard, semantics
/// and selection; the thumb travel and its press are Remix's. [style] merges
/// last.
@MixWidget(target: RemixSwitch.new)
SwitchStyler deuiSwitchStyle({
  bool invalid = false,
  SwitchStyler style = const SwitchStyler.create(),
}) {
  final label = invalid ? DeuiTokens.danger : DeuiTokens.foreground;
  return SwitchStyler(
        container: BoxStyler()
            .size(_trackWidth, _trackHeight)
            .padding(.all(_inset))
            .borderRadius(.circular(_pill)),
        thumb: BoxStyler().size(_thumb, _thumb).borderRadius(.circular(_pill)),
      )
      .label(deuiLabelText.color(label()))
      .labelSpacing(deuiControlGap)
      .trackColor(_trackOff())
      .thumbColor(DeuiTokens.background())
      .thumbEffects(_thumbShadow)
      .onSelected(SwitchStyler().trackColor(DeuiTokens.accent()))
      .onPressed(SwitchStyler().thumb(BoxStyler().scale(.9)))
      .onFocusVisible(.trackEffects(deuiFocusRing()))
      .onDisabled(
        SwitchStyler()
            .label(.color(deuiDisabledLabelColor(danger: invalid)()))
            .wrap(.opacity(DeuiTokens.disabledOpacity)),
      )
      .animate(_motion)
      .merge(style);
}

const _trackWidth = 40.0;
const _trackHeight = 24.0;
const _thumb = 16.0;
const _inset = 4.0;
const _pill = 999.0;

final _trackOff = deuiAlpha(DeuiTokens.muted, .6);

/// Deui's thumb shadow: `0 4 6 -1` and `0 2 4 -2` at 10% black.
final _thumbShadow = RemixBoxEffectsMix.behindContent(
  RemixBoxEffectLayerMix(
    shadows: [
      RemixBoxShadowMix(
        color: const Color.fromRGBO(0, 0, 0, .1),
        offset: const Offset(0, 4),
        blurRadius: 6,
        spreadRadius: -1,
      ),
      RemixBoxShadowMix(
        color: const Color.fromRGBO(0, 0, 0, .1),
        offset: const Offset(0, 2),
        blurRadius: 4,
        spreadRadius: -2,
      ),
    ],
  ),
);

/// The spring that carries the thumb: Deui's control spring.
final _motion = AnimationConfig.springDescription(
  mass: .6,
  stiffness: 500,
  damping: 30,
);
