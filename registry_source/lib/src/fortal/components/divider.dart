import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'divider.g.dart';

/// The lengths a divider comes in. Pixel values are at 100% theme scaling.
enum FortalDividerSize {
  /// 16px long.
  size1,

  /// 32px long.
  size2,

  /// 64px long.
  size3,

  /// As long as the space it sits in.
  size4,
}

/// The Fortal Divider recipe: a 1px gray line, horizontal or vertical.
@MixWidget(target: RemixDivider.new)
DividerStyler fortalDividerStyle({
  FortalDividerSize size = .size1,
  Axis orientation = Axis.horizontal,
  DividerStyler style = const DividerStyler.create(),
}) => DividerStyler()
    .color(FortalTokens.gray6())
    .merge(_line(size, orientation))
    .merge(style);

/// A line [orientation] wide or tall by one border width, and as long as
/// [size].
DividerStyler _line(FortalDividerSize size, Axis orientation) {
  final length = switch (size) {
    .size1 => FortalTokens.space4(),
    .size2 => FortalTokens.space6(),
    .size3 => FortalTokens.space9(),
    .size4 => null,
  };

  if (orientation == Axis.horizontal) {
    final line = DividerStyler().height(FortalTokens.borderWidth1());

    return length == null
        ? line.wrap(
            WidgetModifierConfig.fractionallySizedBox(widthFactor: 1).align(),
          )
        : line.width(length);
  }

  final line = DividerStyler().width(FortalTokens.borderWidth1());

  return length == null
      ? line.wrap(
          WidgetModifierConfig.fractionallySizedBox(heightFactor: 1).align(),
        )
      : line.height(length);
}
