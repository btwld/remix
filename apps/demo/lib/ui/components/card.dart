import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'card.g.dart';

enum FortalCardVariant { surface, ghost }

enum FortalCardSize { size1, size2, size3, size4, size5 }

/// Flat panels. Elevation is reserved for floating layers, never cards.
@MixWidget(target: RemixCard.new)
CardStyler fortalCardStyle({
  FortalCardVariant variant = .surface,
  FortalCardSize size = .size1,
  CardStyler style = const CardStyler.create(),
}) {
  final metrics = _fortalCardMetrics(size);
  final base = CardStyler()
      .padding(.all(metrics.padding))
      .borderRadius(.all(metrics.radius))
      .clipBehavior(.antiAlias)
      .onFocusVisible(.containerEffects(fortalFocusOutline()));

  return (switch (variant) {
        .surface =>
          base
              .color(FortalTokens.colorPanel())
              .border(
                .all(
                  .color(
                    FortalTokens.gray6(),
                  ).width(FortalTokens.borderWidth1()),
                ),
              )
              .containerEffects(
                RemixBoxEffectsMix.backdropBlur(FortalTokens.panelBlur()),
              )
              .onHovered(.border(.all(.color(FortalTokens.gray7()))))
              .onPressed(.color(FortalTokens.gray3()))
              .onSelected(.color(FortalTokens.gray3())),
        .ghost =>
          base
              .margin(.all(metrics.ghostMargin))
              .color(const Color(0x00000000))
              .onHovered(.color(FortalTokens.grayA3()))
              .onPressed(.color(FortalTokens.grayA4()))
              .onSelected(.color(FortalTokens.grayA3())),
      })
      .onDisabled(
        CardStyler().containerEffects(
          RemixBoxEffectsMix(outline: BorderSideMix(style: .none)),
        ),
      )
      .merge(style);
}

({double padding, double ghostMargin, Radius radius}) _fortalCardMetrics(
  FortalCardSize size,
) => switch (size) {
  .size1 => (
    padding: FortalTokens.space3(),
    ghostMargin: FortalTokens.cardGhostMargin1(),
    radius: FortalTokens.radius4(),
  ),
  .size2 => (
    padding: FortalTokens.space4(),
    ghostMargin: FortalTokens.cardGhostMargin2(),
    radius: FortalTokens.radius4(),
  ),
  .size3 => (
    padding: FortalTokens.space5(),
    ghostMargin: FortalTokens.cardGhostMargin3(),
    radius: FortalTokens.radius5(),
  ),
  .size4 => (
    padding: FortalTokens.space6(),
    ghostMargin: FortalTokens.cardGhostMargin4(),
    radius: FortalTokens.radius5(),
  ),
  .size5 => (
    padding: FortalTokens.space8(),
    ghostMargin: FortalTokens.cardGhostMargin5(),
    radius: FortalTokens.radius6(),
  ),
};
