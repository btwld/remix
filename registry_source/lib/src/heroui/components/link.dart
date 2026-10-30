import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'link.g.dart';

/// HeroUI recipe for [RemixLink].
///
/// The label inherits its size from the surrounding text, as `.link` does.
@MixWidget(target: RemixLink.new)
LinkStyler heroUiLinkStyle({LinkStyler style = const LinkStyler.create()}) =>
    LinkStyler()
        .borderRadius(.all(HeroUiTokens.radiusXl()))
        .label(
          .fontWeight(.w500)
              .color(HeroUiTokens.link())
              .decoration(.none)
              .decorationThickness(_underlineThickness),
        )
        .onHovered(
          LinkStyler().label(
            .decoration(.underline).decorationColor(_hoverUnderline()),
          ),
        )
        .onPressed(
          LinkStyler().label(
            .decoration(.underline).decorationColor(HeroUiTokens.muted()),
          ),
        )
        .onFocusVisible(.containerEffects(heroUiFocusRing()))
        .animate(_colorMotion)
        .onDisabled(LinkStyler().wrap(.opacity(HeroUiTokens.disabledOpacity)))
        .merge(style);

/// `decoration-[1.5px]`.
const _underlineThickness = 1.5;

/// `decoration-muted/50` while hovered.
final _hoverUnderline = heroUiAlpha(HeroUiTokens.muted, .5);

/// `color 100ms var(--ease-smooth)`.
const _colorMotion = CurveAnimationConfig(
  duration: Duration(milliseconds: 100),
  curve: HeroUiTokens.easeSmooth,
);
