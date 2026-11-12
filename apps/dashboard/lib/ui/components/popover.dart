import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'popover.g.dart';

/// The sizes a popover comes in, from its padding and corners. Pixel values
/// are at 100% theme scaling.
enum UiPopoverSize {
  /// 12px padding.
  size1,

  /// 16px padding. The default.
  size2,

  /// 24px padding.
  size3,

  /// 32px padding.
  size4,
}

/// The Ui Popover recipe: a raised, blurred panel in a 1px frame.
///
/// The generated [UiPopover] defaults to [UiPopoverSize.size2], a
/// 480-pixel maximum width, and no arrow.
@MixWidget(target: RemixPopover.new)
PopoverStyler uiPopoverStyle({
  UiPopoverSize size = .size2,
  PopoverStyler style = const PopoverStyler.create(),
}) {
  final radius = switch (size) {
    .size1 || .size2 => UiTokens.radius4(),
    .size3 || .size4 => UiTokens.radius5(),
  };
  final padding = switch (size) {
    .size1 => UiTokens.space3(),
    .size2 => UiTokens.space4(),
    .size3 => UiTokens.space5(),
    .size4 => UiTokens.space6(),
  };

  return PopoverStyler()
      .border(.color(UiTokens.gray7()).width(UiTokens.borderWidth1()))
      .maxWidth(UiTokens.popoverMaxWidth())
      .padding(.all(padding))
      .borderRadius(.all(radius))
      .color(UiTokens.colorPanel())
      .decoration(BoxDecorationMix.create(boxShadow: UiTokens.shadow5.mix()))
      .containerEffects(RemixBoxEffectsMix.backdropBlur(UiTokens.panelBlur()))
      .merge(style);
}
