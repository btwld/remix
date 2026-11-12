import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'link.g.dart';

/// HeroUI recipe for [RemixLink].
///
/// The label inherits its size from the surrounding text, as `.link` does.
@MixWidget(target: RemixLink.new)
LinkStyler uiLinkStyle({LinkStyler style = const LinkStyler.create()}) =>
    LinkStyler()
        .borderRadius(.all(UiTokens.radiusXl()))
        .label(
          .fontWeight(.w500)
              .color(UiTokens.link())
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
            .decoration(.underline).decorationColor(UiTokens.muted()),
          ),
        )
        .onFocusVisible(.containerEffects(uiFocusRing()))
        .animate(_colorMotion)
        .onDisabled(LinkStyler().wrap(.opacity(UiTokens.disabledOpacity)))
        .merge(style);

/// `decoration-[1.5px]`.
const _underlineThickness = 1.5;

/// `decoration-muted/50` while hovered.
final _hoverUnderline = uiAlpha(UiTokens.muted, .5);

/// `color 100ms var(--ease-smooth)`.
const _colorMotion = CurveAnimationConfig(
  duration: Duration(milliseconds: 100),
  curve: UiTokens.easeSmooth,
);
