import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'card.g.dart';

enum UiCardVariant { surface, ghost }

enum UiCardSize { size1, size2, size3, size4, size5 }

/// Flat panels. Elevation is reserved for floating layers, never cards.
@MixWidget(target: RemixCard.new)
CardStyler uiCardStyle({
  UiCardVariant variant = .surface,
  UiCardSize size = .size1,
  CardStyler style = const CardStyler.create(),
}) {
  final metrics = _uiCardMetrics(size);
  final base = CardStyler()
      .padding(.all(metrics.padding))
      .borderRadius(.all(metrics.radius))
      .clipBehavior(.antiAlias)
      .onFocusVisible(.containerEffects(uiFocusOutline()));

  return (switch (variant) {
        .surface =>
          base
              .color(UiTokens.colorPanel())
              .border(
                .all(.color(UiTokens.gray6()).width(UiTokens.borderWidth1())),
              )
              .containerEffects(
                RemixBoxEffectsMix.backdropBlur(UiTokens.panelBlur()),
              )
              .onHovered(.border(.all(.color(UiTokens.gray7()))))
              .onPressed(.color(UiTokens.gray3()))
              .onSelected(.color(UiTokens.gray3())),
        .ghost =>
          base
              .margin(.all(metrics.ghostMargin))
              .color(const Color(0x00000000))
              .onHovered(.color(UiTokens.grayA3()))
              .onPressed(.color(UiTokens.grayA4()))
              .onSelected(.color(UiTokens.grayA3())),
      })
      .onDisabled(
        CardStyler().containerEffects(
          RemixBoxEffectsMix(outline: BorderSideMix(style: .none)),
        ),
      )
      .merge(style);
}

({double padding, double ghostMargin, Radius radius}) _uiCardMetrics(
  UiCardSize size,
) => switch (size) {
  .size1 => (
    padding: UiTokens.space3(),
    ghostMargin: UiTokens.cardGhostMargin1(),
    radius: UiTokens.radius4(),
  ),
  .size2 => (
    padding: UiTokens.space4(),
    ghostMargin: UiTokens.cardGhostMargin2(),
    radius: UiTokens.radius4(),
  ),
  .size3 => (
    padding: UiTokens.space5(),
    ghostMargin: UiTokens.cardGhostMargin3(),
    radius: UiTokens.radius5(),
  ),
  .size4 => (
    padding: UiTokens.space6(),
    ghostMargin: UiTokens.cardGhostMargin4(),
    radius: UiTokens.radius5(),
  ),
  .size5 => (
    padding: UiTokens.space8(),
    ghostMargin: UiTokens.cardGhostMargin5(),
    radius: UiTokens.radius6(),
  ),
};
