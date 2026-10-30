import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'checkbox.dart';
import 'select.dart';

part 'table.g.dart';

/// HeroUI table looks: `primary` is a white card on a gray frame, `secondary`
/// has a gray header over bare rows.
enum HeroUiTableVariant { primary, secondary }

/// HeroUI recipe for [RemixDataTable].
///
/// Sorting, selection, and paging stay with Remix; the composed selection
/// checkbox and page-size select take their HeroUI recipes.
@MixWidget(target: RemixDataTable.new)
DataTableStyler heroUiTableStyle({
  HeroUiTableVariant variant = .primary,
  DataTableStyler style = const DataTableStyler.create(),
}) {
  final primary = variant == .primary;
  final frame = primary
      ? DataTableStyler()
            .color(HeroUiTokens.surfaceSecondary())
            .padding(.horizontal(_framePadding).bottom(_framePadding))
            .borderRadius(.all(_frameRadius()))
            .clipBehavior(.antiAlias)
      : DataTableStyler()
            .borderRadius(.all(_cardRadius()))
            .clipBehavior(.antiAlias);

  final hover = primary ? _hoverFill : _secondaryHoverFill;

  return DataTableStyler()
      .cellText(
        TextStyler(
          style: HeroUiTokens.textSm.mix(),
        ).color(HeroUiTokens.foreground()),
      )
      // `.table__column`: `text-xs font-medium text-muted`, foreground when a
      // sortable header is hovered.
      .headerLabel(
        TextStyler(style: HeroUiTokens.textXs.mix())
            .fontWeight(.w500)
            .color(HeroUiTokens.muted())
            .onHovered(TextStyler().color(HeroUiTokens.foreground())),
      )
      .headerCell(_cell(_columnPaddingY))
      .bodyCell(_cell(_cellPaddingY))
      .sortIcon(.size(_sortIcon))
      // The control sits alone in its cell; the row heights below size its
      // tap target to the cell, so a selectable row stays as tall as any other.
      .selectionCell(BoxStyler().alignment(.center))
      .headerMinHeight(_headerHeight)
      .rowMinHeight(_rowHeight)
      // `.table__header` and `.table__row` borders do not paint under
      // `border-separate`; only the cells' own rule does (`table-primary-header`).
      .headerRow(BoxStyler().color(HeroUiTokens.surfaceSecondary()))
      .bodyRow(
        // A real border, so every row is 45px tall, the last included
        // (`table-primary-row-last`).
        BoxStyler()
            .border(.bottom(.color(_cellDivider()).width(_dividerWidth)))
            .color(primary ? HeroUiTokens.surface() : HeroUiTokens.transparent)
            .onHovered(BoxStyler().color(hover()))
            // Hover beats selected, selected or not (`table-primary-select-hover-cell`).
            .onSelected(
              BoxStyler()
                  .color(_selectedFill())
                  .onHovered(BoxStyler().color(hover())),
            ),
      )
      .footer(
        FlexBoxStyler()
            .crossAxisAlignment(.center)
            .padding(.horizontal(_paddingX).vertical(_columnPaddingY)),
      )
      .selectionCheckbox(heroUiCheckboxStyle())
      .pageSizeSelect(heroUiSelectStyle())
      .merge(frame)
      .merge(style);
}

BoxStyler _cell(double paddingY) =>
    BoxStyler().padding(.horizontal(_paddingX).vertical(paddingY));

/// `.table__column` `px-4 py-2.5` (also `.table__footer`), `.table__cell`
/// `px-4 py-3`, and the sort indicator's `size-3`.
const _paddingX = 16.0;
const _columnPaddingY = 10.0;
const _cellPaddingY = 12.0;
const _sortIcon = 12.0;

/// A header row is `py-2.5` around a 16px line; a body row is `py-3` around a
/// 20px line, before its 1px rule.
const _headerHeight = 36.0;
const _rowHeight = 44.0;
const _dividerWidth = 1.0;

/// `.table-root--primary` `px-1 pb-1`.
const _framePadding = 4.0;

/// `min(32px, calc(var(--radius) * 2.5))` for the primary frame.
final _frameRadius = heroUiRadius(HeroUiTokens.radiusLg, scale: 2.5, max: 32);

/// `min(32px, var(--radius-2xl))` for the secondary header card.
final _cardRadius = heroUiRadius(HeroUiTokens.radius2xl, max: 32);

/// `border-separator-tertiary/50` under cells, `bg-surface/40` on hover,
/// `bg-surface/10` when selected, and `bg-default/50` on a secondary row.
final _cellDivider = heroUiAlpha(HeroUiTokens.separatorTertiary, .5);
final _hoverFill = heroUiAlpha(HeroUiTokens.surface, .4);
final _selectedFill = heroUiAlpha(HeroUiTokens.surface, .1);
final _secondaryHoverFill = heroUiAlpha(HeroUiTokens.defaultColor, .5);
