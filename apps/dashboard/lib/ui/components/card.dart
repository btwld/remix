import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'card.g.dart';

/// The looks a card comes in.
enum UiCardVariant {
  /// A panel fill inside a 1px gray frame.
  surface,

  /// No fill or frame until hovered. It sits in a negative margin equal to its
  /// padding, so its content lines up with the content around it.
  ghost,
}

/// The sizes a card comes in. Pixel values are at 100% theme scaling.
enum UiCardSize {
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

/// The Ui Card recipe: a flat panel. Elevation is reserved for floating
/// layers, never cards.
///
/// It reads top to bottom: the size and focus ring, then the variant's colors
/// for rest, hover, press and selected, then disabled.
@MixWidget(target: RemixCard.new)
CardStyler uiCardStyle({
  UiCardVariant variant = .surface,
  UiCardSize size = .size1,
  CardStyler style = const CardStyler.create(),
}) => _base(size)
    .merge(switch (variant) {
      .surface => _surface(),
      .ghost => _ghost(size),
    })
    .onDisabled(.containerEffects(.outline(.style(.none))))
    .merge(style);

/// The padding, corner size and clipping of each step, and the focus ring.
CardStyler _base(UiCardSize size) {
  final (:padding, :radius) = switch (size) {
    .size1 => (padding: UiTokens.space3(), radius: UiTokens.radius4()),
    .size2 => (padding: UiTokens.space4(), radius: UiTokens.radius4()),
    .size3 => (padding: UiTokens.space5(), radius: UiTokens.radius5()),
    .size4 => (padding: UiTokens.space6(), radius: UiTokens.radius5()),
    .size5 => (padding: UiTokens.space8(), radius: UiTokens.radius6()),
  };

  return CardStyler()
      .padding(.all(padding))
      .borderRadius(.all(radius))
      .clipBehavior(.antiAlias)
      .onFocusVisible(.containerEffects(uiFocusOutline()));
}

CardStyler _surface() => CardStyler()
    .color(UiTokens.colorPanel())
    .border(.all(.color(UiTokens.gray6()).width(UiTokens.borderWidth1())))
    .containerEffects(.backdropBlur(UiTokens.panelBlur()))
    .onHovered(.border(.all(.color(UiTokens.gray7()))))
    .onPressed(.color(UiTokens.gray3()))
    .onSelected(.color(UiTokens.gray3()));

CardStyler _ghost(UiCardSize size) => CardStyler()
    .margin(.all(_ghostMargin(size)))
    .color(const Color(0x00000000))
    .onHovered(.color(UiTokens.grayA3()))
    .onPressed(.color(UiTokens.grayA4()))
    .onSelected(.color(UiTokens.grayA3()));

/// The negative margin that cancels a ghost card's padding.
double _ghostMargin(UiCardSize size) => switch (size) {
  .size1 => UiTokens.cardGhostMargin1(),
  .size2 => UiTokens.cardGhostMargin2(),
  .size3 => UiTokens.cardGhostMargin3(),
  .size4 => UiTokens.cardGhostMargin4(),
  .size5 => UiTokens.cardGhostMargin5(),
};
