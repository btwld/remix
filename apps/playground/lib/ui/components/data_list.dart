import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';

part 'data_list.g.dart';

/// The application's DataList recipe.
///
/// Label/value pairs in `textSm`: the label in `mutedForeground` and the value
/// in `foreground`, so the eye lands on the answers. It has no size or variant;
/// override the spacings through [style] for a denser block.
///
/// ```dart
/// PlaygroundDataList(
///   items: const [
///     RemixDataListItem(label: 'Status', value: 'Active'),
///     RemixDataListItem(label: 'Plan', value: 'Pro'),
///   ],
/// )
/// ```
@MixWidget(target: RemixDataList.new)
DataListStyler playgroundDataListStyle({
  DataListStyler style = const DataListStyler.create(),
}) => DataListStyler()
    .label(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).color(PlaygroundTokens.mutedForeground()),
    )
    .value(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).color(PlaygroundTokens.foreground()),
    )
    .rowSpacing(PlaygroundTokens.s3)
    .columnSpacing(PlaygroundTokens.s6)
    .labelValueSpacing(PlaygroundTokens.s2)
    // A floor, not a fixed width: short labels still line their values up,
    // and a long one may grow.
    .minLabelWidth(96)
    .merge(style);
