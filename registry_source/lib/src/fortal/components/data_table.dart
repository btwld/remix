import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'checkbox.dart';
import 'icon_button.dart';
import 'select.dart';

part 'data_table.g.dart';

/// Fortal Table size presets.
enum FortalDataTableSize { size1, size2, size3 }

/// Fortal Table variants.
enum FortalDataTableVariant { surface, ghost }

typedef _FortalDataTableMetrics = ({
  double paddingX,
  double paddingY,
  double minHeight,
  double sortIconSize,
  Radius radius,
  TextStyleToken text,
});

/// Fortal recipe for [RemixDataTable].
@MixWidget(target: RemixDataTable.new)
DataTableStyler fortalDataTableStyle({
  FortalDataTableSize size = .size2,
  FortalDataTableVariant variant = .ghost,
  DataTableStyler style = const DataTableStyler.create(),
}) {
  final metrics = _fortalDataTableMetrics(size);
  final base = DataTableStyler()
      .cellText(
        TextStyler(style: metrics.text.mix()).color(FortalTokens.gray12()),
      )
      .headerLabel(
        TextStyler(style: metrics.text.mix())
            .fontWeight(FortalTokens.fontWeightBold())
            .color(FortalTokens.gray12()),
      )
      .footerLabel(
        TextStyler(style: FortalTokens.text1.mix())
            .fontWeight(FortalTokens.fontWeightRegular())
            .color(FortalTokens.gray11()),
      )
      .headerCell(_fortalDataTableCell(metrics))
      .bodyCell(_fortalDataTableCell(metrics))
      .selectionCell(BoxStyler().alignment(Alignment.center))
      .headerMinHeight(metrics.minHeight)
      .rowMinHeight(metrics.minHeight)
      .selectionColumnWidth(FortalTokens.space8())
      .sortIconSpacing(FortalTokens.space1())
      .sortIcon(
        IconStyler(color: FortalTokens.gray11(), size: metrics.sortIconSize),
      )
      .headerRow(_fortalDataTableRowDivider())
      .bodyRow(
        _fortalDataTableRowDivider()
            .color(const Color(0x00000000))
            // Hover and selection are Fortal extensions. Both are pure color
            // layers, so a row never changes geometry when either applies.
            .onHovered(.color(FortalTokens.grayA3()))
            .onSelected(
              .color(
                FortalTokens.accentA3(),
              ).onHovered(.color(FortalTokens.accentA4())),
            ),
      )
      .footer(_fortalDataTableFooter())
      .selectionCheckbox(fortalCheckboxStyle(size: .size1))
      .pageButton(fortalIconButtonStyle(variant: .ghost, size: .size1))
      .pageSizeSelect(fortalSelectStyle(variant: .ghost, size: .size1));

  return (switch (variant) {
    .surface => _fortalDataTableSurface(base, metrics.radius),
    .ghost => base.color(const Color(0x00000000)),
  }).merge(style);
}

_FortalDataTableMetrics _fortalDataTableMetrics(FortalDataTableSize size) =>
    switch (size) {
      .size1 => (
        paddingX: FortalTokens.space2(),
        paddingY: FortalTokens.space2(),
        minHeight: FortalTokens.space7(),
        sortIconSize: FortalTokens.dataTableSortIconSize1(),
        radius: FortalTokens.radius3(),
        text: FortalTokens.text2,
      ),
      .size2 => (
        paddingX: FortalTokens.space3(),
        paddingY: FortalTokens.space3(),
        minHeight: FortalTokens.space8(),
        sortIconSize: FortalTokens.space4(),
        radius: FortalTokens.radius4(),
        text: FortalTokens.text2,
      ),
      .size3 => (
        paddingX: FortalTokens.space4(),
        paddingY: FortalTokens.space3(),
        minHeight: FortalTokens.space8(),
        sortIconSize: FortalTokens.dataTableSortIconSize3(),
        radius: FortalTokens.radius4(),
        text: FortalTokens.text3,
      ),
    };

BoxStyler _fortalDataTableCell(_FortalDataTableMetrics metrics) => BoxStyler()
    .padding(.horizontal(metrics.paddingX))
    .padding(.vertical(metrics.paddingY));

BoxStyler _fortalDataTableRowDivider() => BoxStyler().foregroundDecoration(
  BoxDecorationMix(border: BoxBorderMix.bottom(_fortalDataTableDividerSide())),
);

/// The `gray-a5` 1px edge shared by the row divider and the footer's top
/// border, so the footer reads as a continuation of the last row's divider.
BorderSideMix _fortalDataTableDividerSide() =>
    BorderSideMix(color: FortalTokens.grayA5(), width: 1);

FlexBoxStyler _fortalDataTableFooter() => FlexBoxStyler()
    .direction(.horizontal)
    // The compact pager keeps full touch targets without crowding its labels.
    .spacing(FortalTokens.space1())
    .padding(.horizontal(FortalTokens.space4()))
    .padding(.vertical(FortalTokens.space2()))
    .foregroundDecoration(
      BoxDecorationMix(border: BoxBorderMix.top(_fortalDataTableDividerSide())),
    );

DataTableStyler _fortalDataTableSurface(DataTableStyler base, Radius radius) {
  return base
      .container(
        fortalSurfaceFrame(
          fillColor: FortalTokens.colorPanel(),
          borderColor: FortalTokens.dataTableBorder(),
          borderWidth: FortalTokens.borderWidth1(),
          radius: radius,
        ),
      )
      .containerEffects(
        RemixBoxEffectsMix.backdropBlur(FortalTokens.panelBlur()),
      )
      .headerRow(.color(FortalTokens.grayA2()))
      .lastBodyRow(
        BoxStyler().foregroundDecoration(
          BoxDecorationMix(border: BoxBorderMix.bottom(BorderSideMix.none)),
        ),
      );
}
