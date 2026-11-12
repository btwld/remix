import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'data_list.g.dart';

/// The sizes a data list comes in. Pixel values are at 100% theme scaling.
enum FortalDataListSize {
  /// 12px text with 12px between rows.
  size1,

  /// 14px text with 16px between rows. The default.
  size2,

  /// 16px text with a wider gap between rows.
  size3,
}

/// The Fortal DataList recipe: gray labels beside values in gray 12.
///
/// [highContrast] moves the labels to gray 12.
@MixWidget(target: RemixDataList.new)
DataListStyler fortalDataListStyle({
  FortalDataListSize size = .size2,
  bool highContrast = false,
  DataListStyler style = const DataListStyler.create(),
}) {
  final metrics = _fortalDataListMetrics(size);

  return DataListStyler()
      .label(
        TextStyler()
            .style(metrics.text.mix())
            .fontWeight(FortalTokens.fontWeightRegular())
            .color(
              highContrast ? FortalTokens.gray12() : FortalTokens.grayA11(),
            ),
      )
      .value(
        TextStyler()
            .style(metrics.text.mix())
            .fontWeight(FortalTokens.fontWeightRegular())
            .color(FortalTokens.gray12()),
      )
      .rowSpacing(metrics.rowSpacing)
      .columnSpacing(metrics.rowSpacing)
      .labelValueSpacing(FortalTokens.space1())
      .minLabelWidth(FortalTokens.dataListLabelMinWidth())
      .merge(style);
}

({TextStyleToken text, double rowSpacing}) _fortalDataListMetrics(
  FortalDataListSize size,
) => switch (size) {
  .size1 => (text: FortalTokens.text1, rowSpacing: FortalTokens.space3()),
  .size2 => (text: FortalTokens.text2, rowSpacing: FortalTokens.space4()),
  .size3 => (
    text: FortalTokens.text3,
    rowSpacing: FortalTokens.dataListRowGap3(),
  ),
};
