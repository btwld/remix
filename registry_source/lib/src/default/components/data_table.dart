import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';
import 'checkbox.dart';
import 'icon_button.dart';
import 'select.dart';

part 'data_table.g.dart';

/// The application's DataTable recipe.
///
/// A table in a frame: `background` fill, `border` hairline and `radiusMd`
/// corners around a header with no surface of its own. A row under the pointer
/// sits on `muted` at half strength and a selected row on `muted`.
///
/// This recipe depends on other items (`checkbox`, `icon_button`, `select`):
/// the selection column is a checkbox, the pager a pair of icon buttons and the
/// page-size control a select, so the table is handed the application's own
/// recipes rather than restating them.
@MixWidget(target: RemixDataTable.new)
DataTableStyler vanillaDataTableStyle({
  DataTableStyler style = const DataTableStyler.create(),
}) => DataTableStyler()
    .color(VanillaTokens.background())
    .border(.color(VanillaTokens.border()).width(VanillaTokens.strokeHairline))
    .borderRadius(.all(_frameRadius()))
    .clipBehavior(Clip.antiAlias)
    .headerRow(.border(_rowRule()))
    .bodyRow(
      BoxStyler()
          .border(_rowRule())
          .onHovered(.color(vanillaTint(VanillaTokens.muted, 0.5)()))
          .onSelected(.color(VanillaTokens.muted())),
    )
    // Otherwise the last rule doubles up with the frame's bottom edge.
    .lastBodyRow(.border(.bottom(.style(.none))))
    // A header cell insets from the sides only; a body cell on every side.
    .headerCell(.padding(.horizontal(VanillaTokens.s2)))
    .bodyCell(_cell())
    .selectionCell(_cell())
    .headerMinHeight(VanillaTokens.controlLg)
    .rowMinHeight(VanillaTokens.controlMd)
    .selectionColumnWidth(VanillaTokens.controlLg)
    // Medium weight is what makes a column name read as a label, not data.
    .headerLabel(
      .style(
        VanillaTokens.textSm.mix(),
      ).fontWeight(FontWeight.w500).color(VanillaTokens.foreground()),
    )
    .cellText(
      .style(VanillaTokens.textSm.mix()).color(VanillaTokens.foreground()),
    )
    .footerLabel(
      .style(VanillaTokens.textSm.mix()).color(VanillaTokens.mutedForeground()),
    )
    .sortIcon(
      .size(VanillaTokens.iconSm).color(VanillaTokens.mutedForeground()),
    )
    .sortIconSpacing(VanillaTokens.s1)
    .footer(
      FlexBoxStyler()
          .direction(.horizontal)
          .crossAxisAlignment(.center)
          .mainAxisAlignment(.end)
          .minHeight(VanillaTokens.controlLg)
          .padding(
            .symmetric(
              horizontal: VanillaTokens.s3,
              vertical: VanillaTokens.s2,
            ),
          )
          .spacing(VanillaTokens.s3)
          .border(.top(_rule())),
    )
    .selectionCheckbox(vanillaCheckboxStyle())
    .pageButton(vanillaIconButtonStyle(variant: .ghost, size: .small))
    .pageSizeSelect(vanillaSelectStyle())
    .merge(style);

/// The theme's control radius, clamped to half the header height.
///
/// The frame clips its rows, and the corner arc is carved out of the first and
/// last rows, whose leading cell is the selection checkbox. Past this radius
/// the clip would start cutting into the checkbox instead of trimming a fill.
///
/// A top-level final because `ContextToken` equality is resolver identity.
final _frameRadius = ContextToken<Radius>((context) {
  final radius = VanillaTokens.radiusMd.resolve(context);
  const maximum = VanillaTokens.controlLg / 2;

  return Radius.elliptical(
    math.min(radius.x, maximum),
    math.min(radius.y, maximum),
  );
});

/// One `border` hairline, shared by every rule the table draws.
BorderSideMix _rule() => BorderSideMix(
  color: VanillaTokens.border(),
  width: VanillaTokens.strokeHairline,
);

BoxBorderMix _rowRule() => .bottom(_rule());

/// An 8px inset on every side, shared with the selection column so the
/// columns line up.
BoxStyler _cell() => BoxStyler().padding(.all(VanillaTokens.s2));
