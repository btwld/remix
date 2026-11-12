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
DataTableStyler playgroundDataTableStyle({
  DataTableStyler style = const DataTableStyler.create(),
}) => DataTableStyler()
    .color(PlaygroundTokens.background())
    .border(
      .color(PlaygroundTokens.border()).width(PlaygroundTokens.strokeHairline),
    )
    .borderRadius(.all(_frameRadius()))
    .clipBehavior(Clip.antiAlias)
    .headerRow(.border(_rowRule()))
    .bodyRow(
      BoxStyler()
          .border(_rowRule())
          .onHovered(.color(playgroundTint(PlaygroundTokens.muted, 0.5)()))
          .onSelected(.color(PlaygroundTokens.muted())),
    )
    // Otherwise the last rule doubles up with the frame's bottom edge.
    .lastBodyRow(.border(.bottom(.style(.none))))
    // A header cell insets from the sides only; a body cell on every side.
    .headerCell(.padding(.horizontal(PlaygroundTokens.s2)))
    .bodyCell(_cell())
    .selectionCell(_cell())
    .headerMinHeight(PlaygroundTokens.controlLg)
    .rowMinHeight(PlaygroundTokens.controlMd)
    .selectionColumnWidth(PlaygroundTokens.controlLg)
    // Medium weight is what makes a column name read as a label, not data.
    .headerLabel(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).fontWeight(FontWeight.w500).color(PlaygroundTokens.foreground()),
    )
    .cellText(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).color(PlaygroundTokens.foreground()),
    )
    .footerLabel(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).color(PlaygroundTokens.mutedForeground()),
    )
    .sortIcon(
      .size(PlaygroundTokens.iconSm).color(PlaygroundTokens.mutedForeground()),
    )
    .sortIconSpacing(PlaygroundTokens.s1)
    .footer(
      FlexBoxStyler()
          .direction(.horizontal)
          .crossAxisAlignment(.center)
          .mainAxisAlignment(.end)
          .minHeight(PlaygroundTokens.controlLg)
          .padding(
            .symmetric(
              horizontal: PlaygroundTokens.s3,
              vertical: PlaygroundTokens.s2,
            ),
          )
          .spacing(PlaygroundTokens.s3)
          .border(.top(_rule())),
    )
    .selectionCheckbox(playgroundCheckboxStyle())
    .pageButton(playgroundIconButtonStyle(variant: .ghost, size: .small))
    .pageSizeSelect(playgroundSelectStyle())
    .merge(style);

/// The theme's control radius, clamped to half the header height.
///
/// The frame clips its rows, and the corner arc is carved out of the first and
/// last rows, whose leading cell is the selection checkbox. Past this radius
/// the clip would start cutting into the checkbox instead of trimming a fill.
///
/// A top-level final because `ContextToken` equality is resolver identity.
final _frameRadius = ContextToken<Radius>((context) {
  final radius = PlaygroundTokens.radiusMd.resolve(context);
  const maximum = PlaygroundTokens.controlLg / 2;

  return Radius.elliptical(
    math.min(radius.x, maximum),
    math.min(radius.y, maximum),
  );
});

/// One `border` hairline, shared by every rule the table draws.
BorderSideMix _rule() => BorderSideMix(
  color: PlaygroundTokens.border(),
  width: PlaygroundTokens.strokeHairline,
);

BoxBorderMix _rowRule() => .bottom(_rule());

/// An 8px inset on every side, shared with the selection column so the
/// columns line up.
BoxStyler _cell() => BoxStyler().padding(.all(PlaygroundTokens.s2));
