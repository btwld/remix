import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'checkbox.dart';
import 'icon_button.dart';
import 'select.dart';

part 'data_table.g.dart';

/// The sizes a data table comes in. Pixel values are at 100% theme scaling.
enum FortalDataTableSize {
  /// 8px cell padding and 14px text, in rows at least 40px tall.
  size1,

  /// 12px cell padding and 14px text, in rows at least 48px tall. The default.
  size2,

  /// 16px by 12px cell padding and 16px text, in rows at least 48px tall.
  size3,
}

/// The looks a data table comes in.
enum FortalDataTableVariant {
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

/// The Fortal DataTable recipe.
///
/// It reads top to bottom: the cells, rows, footer and the controls inside
/// them at the size, then the variant's panel.
@MixWidget(target: RemixDataTable.new)
DataTableStyler fortalDataTableStyle({
  FortalDataTableSize size = .size2,
  FortalDataTableVariant variant = .ghost,
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
    .cellText(
      TextStyler(style: metrics.text.mix()).color(FortalTokens.gray12()),
    )
    .headerLabel(
      TextStyler(
        style: metrics.text.mix(),
      ).fontWeight(FortalTokens.fontWeightBold()).color(FortalTokens.gray12()),
    )
    .footerLabel(
      TextStyler(style: FortalTokens.text1.mix())
          .fontWeight(FortalTokens.fontWeightRegular())
          .color(FortalTokens.gray11()),
    )
    .headerCell(
      _cell(metrics)
          // Keep the painter mounted so focusing a custom header preserves
          // its element and state.
          .wrap(
            fortalFocusRingModifier(
              visible: false,
              inset: FortalTokens.space2(),
            ),
          )
          .onFocusVisible(
            // Keep the common outline inside the padding of clipped tables.
            BoxStyler().fortalFocusRing(inset: FortalTokens.space2()),
          ),
    )
    .bodyCell(_cell(metrics))
    .selectionCell(BoxStyler().alignment(Alignment.center))
    .headerMinHeight(metrics.minHeight)
    .rowMinHeight(metrics.minHeight)
    .selectionColumnWidth(FortalTokens.space8())
    .sortIconSpacing(FortalTokens.space1())
    .sortIcon(
      IconStyler(color: FortalTokens.gray11(), size: metrics.sortIconSize),
    )
    .headerRow(_rowDivider())
    .bodyRow(
      _rowDivider()
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
    .footer(_footer())
    .selectionCheckbox(fortalCheckboxStyle(size: .size1))
    .pageButton(fortalIconButtonStyle(variant: .ghost, size: .size1))
    .pageSizeSelect(fortalSelectStyle(variant: .ghost, size: .size1));

_Scale _scale(FortalDataTableSize size) => switch (size) {
  .size1 => (
    paddingX: FortalTokens.space2(),
    paddingY: FortalTokens.space2(),
    minHeight: FortalTokens.touchTargetMin(),
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

BoxStyler _cell(_Scale metrics) => BoxStyler()
    .padding(.horizontal(metrics.paddingX))
    .padding(.vertical(metrics.paddingY));

BoxStyler _rowDivider() => BoxStyler().foregroundDecoration(
  BoxDecorationMix(border: BoxBorderMix.bottom(_dividerSide())),
);

/// The `gray-a5` 1px edge shared by the row divider and the footer's top
/// border, so the footer reads as a continuation of the last row's divider.
BorderSideMix _dividerSide() => BorderSideMix(
  color: FortalTokens.grayA5(),
  width: FortalTokens.borderWidth1(),
);

FlexBoxStyler _footer() => FlexBoxStyler()
    .direction(.horizontal)
    // The compact pager keeps full touch targets without crowding its labels.
    .spacing(FortalTokens.space1())
    .padding(.horizontal(FortalTokens.space4()))
    .padding(.vertical(FortalTokens.space2()))
    .foregroundDecoration(
      BoxDecorationMix(border: BoxBorderMix.top(_dividerSide())),
    );

DataTableStyler _surface(Radius radius) {
  return DataTableStyler()
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
