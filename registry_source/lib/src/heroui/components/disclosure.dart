import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'disclosure.g.dart';

/// HeroUI recipe for [RemixDisclosure].
///
/// [animationStyle] defaults to the panel's `200ms var(--ease-out-quad)`.
@MixWidget(target: RemixDisclosure.new)
DisclosureStyler heroUiDisclosureStyle({
  AnimationStyle animationStyle = const AnimationStyle(
    curve: HeroUiTokens.easeOutQuad,
    duration: _panelDuration,
    reverseDuration: _panelDuration,
  ),
  DisclosureStyler style = const DisclosureStyler.create(),
}) => DisclosureStyler()
    .content(BoxStyler().padding(.all(_bodyPadding)))
    .onFocusVisible(DisclosureStyler().triggerEffects(heroUiFocusRing()))
    .onDisabled(
      DisclosureStyler().trigger(
        BoxStyler().wrap(.opacity(HeroUiTokens.disabledOpacity)),
      ),
    )
    .merge(style);

/// `.disclosure__content` `height 200ms`, `opacity 200ms`.
const _panelDuration = Duration(milliseconds: 200);

/// `.disclosure__body`: `p-2`.
const _bodyPadding = 8.0;
