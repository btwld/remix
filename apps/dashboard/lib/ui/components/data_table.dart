import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'checkbox.dart';
import 'icon_button.dart';
import 'select.dart';

part 'data_table.g.dart';

/// Ui Table size presets.
enum UiDataTableSize { size1, size2, size3 }

/// Ui Table variants.
enum UiDataTableVariant { surface, ghost }

typedef _UiDataTableMetrics = ({
  double paddingX,
  double paddingY,
  double minHeight,
  double sortIconSize,
  Radius radius,
  TextStyleToken text,
});

/// Ui recipe for [RemixDataTable].
@MixWidget(target: RemixDataTable.new)
DataTableStyler uiDataTableStyle({
  UiDataTableSize size = .size2,
  UiDataTableVariant variant = .ghost,
  DataTableStyler style = const DataTableStyler.create(),
}) {
  final metrics = _uiDataTableMetrics(size);
  final base = DataTableStyler()
      .cellText(TextStyler(style: metrics.text.mix()).color(UiTokens.gray12()))
      .headerLabel(
        TextStyler(
          style: metrics.text.mix(),
        ).fontWeight(UiTokens.fontWeightBold()).color(UiTokens.gray12()),
      )
      .footerLabel(
        TextStyler(
          style: UiTokens.text1.mix(),
        ).fontWeight(UiTokens.fontWeightRegular()).color(UiTokens.gray11()),
      )
      .headerCell(
        _uiDataTableCell(metrics)
            // Keep the painter mounted so focusing a custom header preserves
            // its element and state.
            .wrap(uiFocusRingModifier(visible: false, inset: UiTokens.space2()))
            .onFocusVisible(
              // Keep the common outline inside the padding of clipped tables.
              BoxStyler().uiFocusRing(inset: UiTokens.space2()),
            ),
      )
      .bodyCell(_uiDataTableCell(metrics))
      .selectionCell(BoxStyler().alignment(Alignment.center))
      .headerMinHeight(metrics.minHeight)
      .rowMinHeight(metrics.minHeight)
      .selectionColumnWidth(UiTokens.space8())
      .sortIconSpacing(UiTokens.space1())
      .sortIcon(
        IconStyler(color: UiTokens.gray11(), size: metrics.sortIconSize),
      )
      .headerRow(_uiDataTableRowDivider())
      .bodyRow(
        _uiDataTableRowDivider()
            .color(const Color(0x00000000))
            // Hover and selection are Ui extensions. Both are pure color
            // layers, so a row never changes geometry when either applies.
            .onHovered(.color(UiTokens.grayA3()))
            .onSelected(
              .color(
                UiTokens.accentA3(),
              ).onHovered(.color(UiTokens.accentA4())),
            ),
      )
      .footer(_uiDataTableFooter())
      .selectionCheckbox(uiCheckboxStyle(size: .size1))
      .pageButton(uiIconButtonStyle(variant: .ghost, size: .size1))
      .pageSizeSelect(uiSelectStyle(variant: .ghost, size: .size1));

  return (switch (variant) {
    .surface => _uiDataTableSurface(base, metrics.radius),
    .ghost => base.color(const Color(0x00000000)),
  }).merge(style);
}

_UiDataTableMetrics _uiDataTableMetrics(UiDataTableSize size) => switch (size) {
  .size1 => (
    paddingX: UiTokens.space2(),
    paddingY: UiTokens.space2(),
    minHeight: UiTokens.touchTargetMin(),
    sortIconSize: UiTokens.dataTableSortIconSize1(),
    radius: UiTokens.radius3(),
    text: UiTokens.text2,
  ),
  .size2 => (
    paddingX: UiTokens.space3(),
    paddingY: UiTokens.space3(),
    minHeight: UiTokens.space8(),
    sortIconSize: UiTokens.space4(),
    radius: UiTokens.radius4(),
    text: UiTokens.text2,
  ),
  .size3 => (
    paddingX: UiTokens.space4(),
    paddingY: UiTokens.space3(),
    minHeight: UiTokens.space8(),
    sortIconSize: UiTokens.dataTableSortIconSize3(),
    radius: UiTokens.radius4(),
    text: UiTokens.text3,
  ),
};

BoxStyler _uiDataTableCell(_UiDataTableMetrics metrics) => BoxStyler()
    .padding(.horizontal(metrics.paddingX))
    .padding(.vertical(metrics.paddingY));

BoxStyler _uiDataTableRowDivider() => BoxStyler().foregroundDecoration(
  BoxDecorationMix(border: BoxBorderMix.bottom(_uiDataTableDividerSide())),
);

/// The `gray-a5` 1px edge shared by the row divider and the footer's top
/// border, so the footer reads as a continuation of the last row's divider.
BorderSideMix _uiDataTableDividerSide() =>
    BorderSideMix(color: UiTokens.grayA5(), width: 1);

FlexBoxStyler _uiDataTableFooter() => FlexBoxStyler()
    .direction(.horizontal)
    // The compact pager keeps full touch targets without crowding its labels.
    .spacing(UiTokens.space1())
    .padding(.horizontal(UiTokens.space4()))
    .padding(.vertical(UiTokens.space2()))
    .foregroundDecoration(
      BoxDecorationMix(border: BoxBorderMix.top(_uiDataTableDividerSide())),
    );

DataTableStyler _uiDataTableSurface(DataTableStyler base, Radius radius) {
  return base
      .container(
        uiSurfaceFrame(
          fillColor: UiTokens.colorPanel(),
          borderColor: UiTokens.dataTableBorder(),
          borderWidth: UiTokens.borderWidth1(),
          radius: radius,
        ),
      )
      .containerEffects(RemixBoxEffectsMix.backdropBlur(UiTokens.panelBlur()))
      .headerRow(.color(UiTokens.grayA2()))
      .lastBodyRow(
        BoxStyler().foregroundDecoration(
          BoxDecorationMix(border: BoxBorderMix.bottom(BorderSideMix.none)),
        ),
      );
}
