import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'popover.g.dart';

/// The sizes a popover comes in, from its padding and corners. Pixel values
/// are at 100% theme scaling.
enum FortalPopoverSize {
  /// 12px padding.
  size1,

  /// 16px padding. The default.
  size2,

  /// 24px padding.
  size3,

  /// 32px padding.
  size4,
}

/// The Fortal Popover recipe: a raised, blurred panel in a 1px frame.
///
/// The generated [FortalPopover] defaults to [FortalPopoverSize.size2], a
/// 480-pixel maximum width, and no arrow.
@MixWidget(target: RemixPopover.new)
PopoverStyler fortalPopoverStyle({
  FortalPopoverSize size = .size2,
  PopoverStyler style = const PopoverStyler.create(),
}) {
  final radius = switch (size) {
    .size1 || .size2 => FortalTokens.radius4(),
    .size3 || .size4 => FortalTokens.radius5(),
  };
  final padding = switch (size) {
    .size1 => FortalTokens.space3(),
    .size2 => FortalTokens.space4(),
    .size3 => FortalTokens.space5(),
    .size4 => FortalTokens.space6(),
  };

  return PopoverStyler()
      .border(.color(FortalTokens.gray7()).width(FortalTokens.borderWidth1()))
      .maxWidth(FortalTokens.popoverMaxWidth())
      .padding(.all(padding))
      .borderRadius(.all(radius))
      .color(FortalTokens.colorPanel())
      .decoration(
        BoxDecorationMix.create(boxShadow: FortalTokens.shadow5.mix()),
      )
      .containerEffects(
        RemixBoxEffectsMix.backdropBlur(FortalTokens.panelBlur()),
      )
      .merge(style);
}
