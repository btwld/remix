import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/scale.dart';
import '../theme/tokens.dart';

part 'data_list.g.dart';

/// The application's DataList recipe.
///
/// A data list is a set of label/value pairs — the "Status: Active" block on a
/// detail page. Remix owns the rendering, the two layout orientations, the
/// label-column alignment, and the accessibility semantics; this recipe
/// supplies the two text roles and the spacing between them.
///
/// Both roles are body text, `textSm`. The label is `mutedForeground` and the
/// value is `foreground`, which is the pairing that makes a list scannable: the
/// eye lands on the answers, and the questions stay legible without competing.
///
/// It takes no size and no variant. A data list is typography and spacing, and
/// both are decided by the page it sits on — a caller who wants a denser block
/// overrides the spacings through [style].
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it:
///
/// ```dart
/// VanillaDataList(
///   items: const [
///     RemixDataListItem(label: 'Status', value: 'Active'),
///     RemixDataListItem(label: 'Plan', value: 'Pro'),
///   ],
/// )
/// ```
@MixWidget(target: RemixDataList.new)
DataListStyler vanillaDataListStyle({
  DataListStyler style = const DataListStyler.create(),
}) => DataListStyler()
    .label(
      .style(VanillaTokens.textSm.mix()).color(VanillaTokens.mutedForeground()),
    )
    .value(.style(VanillaTokens.textSm.mix()).color(VanillaTokens.foreground()))
    // One pair from the next, 12px; side by side, 24px; a label from its own
    // value, 8px.
    .rowSpacing(VanillaSpace.s3)
    .columnSpacing(VanillaSpace.s6)
    .labelValueSpacing(VanillaSpace.s2)
    // A floor rather than a fixed width: the labels line up into a column,
    // but a long one is still allowed to be as long as it needs to be.
    .minLabelWidth(_minLabelWidth)
    .merge(style);

/// The narrowest the label column gets, so short labels still line their
/// values up instead of leaving a ragged edge.
const _minLabelWidth = 96.0;
