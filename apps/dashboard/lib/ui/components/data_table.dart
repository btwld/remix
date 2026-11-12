import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'checkbox.dart';
import 'icon_button.dart';
import 'select.dart';

part 'data_table.g.dart';

/// The sizes a data table comes in. Pixel values are at 100% theme scaling.
enum UiDataTableSize {
  /// 8px cell padding and 14px text, in rows at least 40px tall.
  size1,

  /// 12px cell padding and 14px text, in rows at least 48px tall. The default.
  size2,

  /// 16px by 12px cell padding and 16px text, in rows at least 48px tall.
  size3,
}

/// The looks a data table comes in.
enum UiDataTableVariant {
  /// A panel with a 1px frame and a tinted header.
  surface,

  /// No panel or frame: rows on the page.
  ghost,
}

typedef _Scale = ({
  double paddingX,
  double paddingY,
  double minHeight,
  double sortIconSize,
  Radius radius,
  TextStyleToken text,
});

/// The Ui DataTable recipe.
///
/// It reads top to bottom: the cells, rows, footer and the controls inside
/// them at the size, then the variant's panel.
@MixWidget(target: RemixDataTable.new)
DataTableStyler uiDataTableStyle({
  UiDataTableSize size = .size2,
  UiDataTableVariant variant = .ghost,
  DataTableStyler style = const DataTableStyler.create(),
}) {
  final metrics = _scale(size);

  return _base(metrics)
      .merge(switch (variant) {
        .surface => _surface(metrics.radius),
        .ghost => DataTableStyler().color(const Color(0x00000000)),
      })
      .merge(style);
}

/// The cells, rows, footer and controls every data table shares.
DataTableStyler _base(_Scale metrics) => DataTableStyler()
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
      _cell(metrics)
          // Keep the painter mounted so focusing a custom header preserves
          // its element and state.
          .wrap(uiFocusRingModifier(visible: false, inset: UiTokens.space2()))
          .onFocusVisible(
            // Keep the common outline inside the padding of clipped tables.
            BoxStyler().uiFocusRing(inset: UiTokens.space2()),
          ),
    )
    .bodyCell(_cell(metrics))
    .selectionCell(BoxStyler().alignment(Alignment.center))
    .headerMinHeight(metrics.minHeight)
    .rowMinHeight(metrics.minHeight)
    .selectionColumnWidth(UiTokens.space8())
    .sortIconSpacing(UiTokens.space1())
    .sortIcon(IconStyler(color: UiTokens.gray11(), size: metrics.sortIconSize))
    .headerRow(_rowDivider())
    .bodyRow(
      _rowDivider()
          .color(const Color(0x00000000))
          // Hover and selection are Ui extensions. Both are pure color
          // layers, so a row never changes geometry when either applies.
          .onHovered(.color(UiTokens.grayA3()))
          .onSelected(
            .color(UiTokens.accentA3()).onHovered(.color(UiTokens.accentA4())),
          ),
    )
    .footer(_footer())
    .selectionCheckbox(uiCheckboxStyle(size: .size1))
    .pageButton(uiIconButtonStyle(variant: .ghost, size: .size1))
    .pageSizeSelect(uiSelectStyle(variant: .ghost, size: .size1));

_Scale _scale(UiDataTableSize size) => switch (size) {
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

BoxStyler _cell(_Scale metrics) => BoxStyler()
    .padding(.horizontal(metrics.paddingX))
    .padding(.vertical(metrics.paddingY));

BoxStyler _rowDivider() => BoxStyler().foregroundDecoration(
  BoxDecorationMix(border: BoxBorderMix.bottom(_dividerSide())),
);

/// The `gray-a5` 1px edge shared by the row divider and the footer's top
/// border, so the footer reads as a continuation of the last row's divider.
BorderSideMix _dividerSide() =>
    BorderSideMix(color: UiTokens.grayA5(), width: UiTokens.borderWidth1());

FlexBoxStyler _footer() => FlexBoxStyler()
    .direction(.horizontal)
    // The compact pager keeps full touch targets without crowding its labels.
    .spacing(UiTokens.space1())
    .padding(.horizontal(UiTokens.space4()))
    .padding(.vertical(UiTokens.space2()))
    .foregroundDecoration(
      BoxDecorationMix(border: BoxBorderMix.top(_dividerSide())),
    );

DataTableStyler _surface(Radius radius) {
  return DataTableStyler()
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
