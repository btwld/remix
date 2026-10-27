import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'select.g.dart';

/// HeroUI select variants: `primary` on the field surface with its shadow,
/// `secondary` on the default fill.
enum HeroUiSelectVariant { primary, secondary }

/// HeroUI recipe for [RemixSelect]: a field trigger over an overlay list.
///
/// [invalid] paints the error treatment; validation stays with the app.
@MixWidget(target: RemixSelect.new)
SelectStyler heroUiSelectStyle({
  HeroUiSelectVariant variant = .primary,
  bool invalid = false,
  SelectStyler style = const SelectStyler.create(),
}) => SelectStyler()
    .trigger(_trigger(variant, invalid: invalid))
    .content(_content)
    .menuContainer(
      FlexBoxStyler().padding(.all(_listPadding)).spacing(_listGap),
    )
    .item(_item)
    .merge(style);

SelectTriggerStyler _trigger(
  HeroUiSelectVariant variant, {
  required bool invalid,
}) {
  final field = switch (variant) {
    .primary => heroUiPrimaryFieldFill,
    .secondary => heroUiSecondaryFieldFill,
  };

  var result = SelectTriggerStyler()
      .direction(.horizontal)
      .minHeight(_minHeight)
      .padding(.fromLTRB(_paddingX, _paddingY, _indicatorEnd, _paddingY))
      .spacing(_valueGap)
      .borderRadius(.all(HeroUiTokens.radiusField()))
      .color(field.rest())
      .label(heroUiFieldText(HeroUiTokens.fieldForeground))
      .placeholder(heroUiFieldText(HeroUiTokens.fieldPlaceholder))
      .indicator(.size(_indicator).color(HeroUiTokens.fieldPlaceholder()))
      .onHovered(.color(field.hover()))
      .onFocusVisible(
        SelectTriggerStyler()
            .color(field.focus())
            .containerEffects(heroUiFocusRing()),
      )
      .onDisabled(
        SelectTriggerStyler().wrap(.opacity(HeroUiTokens.disabledOpacity)),
      )
      .animate(HeroUiTokens.smoothMotion);

  if (variant == .primary) {
    result = result.containerEffects(heroUiSurfaceEffects());
  }
  if (invalid) {
    result = result
        .color(field.focus())
        .containerEffects(heroUiInvalidRing())
        .onFocusVisible(.containerEffects(heroUiInvalidRing(focused: true)));
  }
  return result;
}

/// `.select__popover`: `bg-overlay`, `min(32px, var(--radius-3xl))`.
final _content = SelectContentStyler()
    .color(HeroUiTokens.overlay())
    .borderRadius(.all(HeroUiTokens.radiusPanel()))
    .containerEffects(heroUiSurfaceEffects(overlay: true));

/// `.list-box-item` inside the select popover (`px-2.5`).
final _item = SelectMenuItemStyler()
    .minHeight(_minHeight)
    .padding(.horizontal(_itemPaddingX))
    .padding(.vertical(_itemPaddingY))
    .spacing(_itemGap)
    .borderRadius(.all(HeroUiTokens.radius2xl()))
    .text(.style(HeroUiTokens.textSm.mix()).color(HeroUiTokens.foreground()))
    // The selected check mark: `text-default-foreground`.
    .icon(.size(_itemMark).color(HeroUiTokens.defaultForeground()))
    .onHovered(.color(HeroUiTokens.defaultColor()))
    .onPressed(SelectMenuItemStyler().scale(_itemPressedScale))
    .onFocusVisible(SelectMenuItemStyler().containerEffects(heroUiFocusRing()))
    .onDisabled(
      SelectMenuItemStyler().wrap(.opacity(HeroUiTokens.disabledOpacity)),
    );

/// `.select__trigger` and `.list-box-item`: `min-h-9`.
const _minHeight = 36.0;

/// `.select__trigger`: `px-3 py-2`, and `pe-7` reserved for the indicator.
const _paddingX = 12.0;
const _paddingY = 8.0;
const _reservedEnd = 28.0;

/// `.select__indicator` is a `size-4` slot at `end-2`, centered on its chevron,
/// which inks 10.5px wide (`IconChevronDown` in react `icons.js`). Remix's
/// chevron fills the width of its box, so an 11px glyph centered in the same
/// slot matches it.
const _indicator = 11.0;
const _indicatorEnd = 8 + (16 - _indicator) / 2;

/// The value still ends at `pe-7`.
const _valueGap = _reservedEnd - _indicatorEnd - _indicator;

/// `.select__popover`'s list box: `p-1.5`, and `.list-box`'s `mt-1` between
/// items.
const _listPadding = 6.0;
const _listGap = 4.0;

/// `.list-box-item`: `gap-3`, `px-2` widened to `px-2.5` by the select popover,
/// `py-1.5`, and the selected mark's `size-4`.
const _itemGap = 12.0;
const _itemPaddingX = 10.0;
const _itemPaddingY = 6.0;
const _itemMark = 16.0;

/// `transform: scale(0.98)` on a pressed row (`list-box-item.css`).
const _itemPressedScale = .98;
