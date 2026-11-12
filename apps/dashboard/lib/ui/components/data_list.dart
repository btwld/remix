import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'data_list.g.dart';

/// The sizes a data list comes in. Pixel values are at 100% theme scaling.
enum UiDataListSize {
  /// 12px text with 12px between rows.
  size1,

  /// 14px text with 16px between rows. The default.
  size2,

  /// 16px text with 20px between rows.
  size3,
}

/// The Ui DataList recipe: gray labels beside values in gray 12.
///
/// [highContrast] moves the labels to gray 12.
@MixWidget(target: RemixDataList.new)
DataListStyler uiDataListStyle({
  UiDataListSize size = .size2,
  bool highContrast = false,
  DataListStyler style = const DataListStyler.create(),
}) {
  final metrics = _metrics(size);

  return DataListStyler()
      .label(
        TextStyler()
            .style(metrics.text.mix())
            .fontWeight(UiTokens.fontWeightRegular())
            .color(highContrast ? UiTokens.gray12() : UiTokens.grayA11()),
      )
      .value(
        TextStyler()
            .style(metrics.text.mix())
            .fontWeight(UiTokens.fontWeightRegular())
            .color(UiTokens.gray12()),
      )
      .rowSpacing(metrics.rowSpacing)
      .columnSpacing(metrics.rowSpacing)
      .labelValueSpacing(UiTokens.space1())
      .minLabelWidth(UiTokens.dataListLabelMinWidth())
      .merge(style);
}

({TextStyleToken text, double rowSpacing}) _metrics(UiDataListSize size) =>
    switch (size) {
      .size1 => (text: UiTokens.text1, rowSpacing: UiTokens.space3()),
      .size2 => (text: UiTokens.text2, rowSpacing: UiTokens.space4()),
      .size3 => (text: UiTokens.text3, rowSpacing: UiTokens.dataListRowGap3()),
    };
