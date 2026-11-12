import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';

part 'divider.g.dart';

/// The application's Divider recipe.
///
/// A `border` hairline, the same color and weight as every control outline. It
/// fills the axis it runs along; a shorter rule is a layout decision, made with
/// padding.
///
/// [orientation] is Flutter's [Axis] and is not named `variant`, so the
/// generator emits no named constructors for it.
@MixWidget(target: RemixDivider.new)
DividerStyler vanillaDividerStyle({
  Axis orientation = Axis.horizontal,
  DividerStyler style = const DividerStyler.create(),
}) => DividerStyler()
    .color(VanillaTokens.border())
    .merge(_extent(orientation))
    .merge(style);

/// A hairline across the axis, stretched along the main axis with a
/// `FractionallySizedBox` because the parent's length is not known here. It
/// centers on the cross axis by itself.
DividerStyler _extent(Axis orientation) => switch (orientation) {
  .horizontal =>
    DividerStyler()
        .height(VanillaTokens.strokeHairline)
        .wrap(.fractionallySizedBox(widthFactor: 1)),
  .vertical =>
    DividerStyler()
        .width(VanillaTokens.strokeHairline)
        .wrap(.fractionallySizedBox(heightFactor: 1)),
};
