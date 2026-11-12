import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'card.g.dart';

/// The looks a card comes in.
enum FortalCardVariant {
  /// A panel fill inside a 1px gray frame.
  surface,

  /// No fill or frame until hovered. It sits in a negative margin equal to its
  /// padding, so its content lines up with the content around it.
  ghost,
}

/// The sizes a card comes in. Pixel values are at 100% theme scaling.
enum FortalCardSize {
  /// 12px padding.
  size1,

  /// 16px padding.
  size2,

  /// 24px padding.
  size3,

  /// 32px padding.
  size4,

  /// 48px padding.
  size5,
}

/// The Fortal Card recipe: a flat panel. Elevation is reserved for floating
/// layers, never cards.
///
/// It reads top to bottom: the size and focus ring, then the variant's colors
/// for rest, hover, press and selected, then disabled.
@MixWidget(target: RemixCard.new)
CardStyler fortalCardStyle({
  FortalCardVariant variant = .surface,
  FortalCardSize size = .size1,
  CardStyler style = const CardStyler.create(),
}) => _base(size)
    .merge(switch (variant) {
      .surface => _surface(),
      .ghost => _ghost(size),
    })
    .onDisabled(.containerEffects(.outline(.style(.none))))
    .merge(style);

/// The padding, corner size and clipping of each step, and the focus ring.
CardStyler _base(FortalCardSize size) {
  final (:padding, :radius) = switch (size) {
    .size1 => (padding: FortalTokens.space3(), radius: FortalTokens.radius4()),
    .size2 => (padding: FortalTokens.space4(), radius: FortalTokens.radius4()),
    .size3 => (padding: FortalTokens.space5(), radius: FortalTokens.radius5()),
    .size4 => (padding: FortalTokens.space6(), radius: FortalTokens.radius5()),
    .size5 => (padding: FortalTokens.space8(), radius: FortalTokens.radius6()),
  };

  return CardStyler()
      .padding(.all(padding))
      .borderRadius(.all(radius))
      .clipBehavior(.antiAlias)
      .onFocusVisible(.containerEffects(fortalFocusOutline()));
}

CardStyler _surface() => CardStyler()
    .color(FortalTokens.colorPanel())
    .border(
      .all(.color(FortalTokens.gray6()).width(FortalTokens.borderWidth1())),
    )
    .containerEffects(.backdropBlur(FortalTokens.panelBlur()))
    .onHovered(.border(.all(.color(FortalTokens.gray7()))))
    .onPressed(.color(FortalTokens.gray3()))
    .onSelected(.color(FortalTokens.gray3()));

CardStyler _ghost(FortalCardSize size) => CardStyler()
    .margin(.all(_ghostMargin(size)))
    .color(const Color(0x00000000))
    .onHovered(.color(FortalTokens.grayA3()))
    .onPressed(.color(FortalTokens.grayA4()))
    .onSelected(.color(FortalTokens.grayA3()));

/// The negative margin that cancels a ghost card's padding.
double _ghostMargin(FortalCardSize size) => switch (size) {
  .size1 => FortalTokens.cardGhostMargin1(),
  .size2 => FortalTokens.cardGhostMargin2(),
  .size3 => FortalTokens.cardGhostMargin3(),
  .size4 => FortalTokens.cardGhostMargin4(),
  .size5 => FortalTokens.cardGhostMargin5(),
};
