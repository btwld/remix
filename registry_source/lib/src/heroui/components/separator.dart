import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'separator.g.dart';

/// HeroUI separator shades, from `separator` to the faintest, `tertiary`.
enum HeroUiSeparatorVariant { defaultSeparator, secondary, tertiary }

/// HeroUI recipe for [RemixDivider]: a 1px line that spans its container.
@MixWidget(target: RemixDivider.new)
DividerStyler heroUiSeparatorStyle({
  HeroUiSeparatorVariant variant = .defaultSeparator,
  Axis orientation = Axis.horizontal,
  DividerStyler style = const DividerStyler.create(),
}) {
  final result = DividerStyler()
      .borderRadius(.all(HeroUiTokens.radiusSm()))
      .color(switch (variant) {
        .defaultSeparator => HeroUiTokens.separator(),
        .secondary => HeroUiTokens.separatorSecondary(),
        .tertiary => HeroUiTokens.separatorTertiary(),
      });
  return switch (orientation) {
    // `h-px w-full`.
    Axis.horizontal =>
      result
          .height(_thickness)
          .wrap(WidgetModifierConfig.fractionallySizedBox(widthFactor: 1)),
    // `h-auto min-h-2 w-px self-stretch`.
    Axis.vertical =>
      result
          .width(_thickness)
          .minHeight(_minLength)
          .wrap(WidgetModifierConfig.fractionallySizedBox(heightFactor: 1)),
  }.merge(style);
}

const _thickness = 1.0;
const _minLength = 8.0;
