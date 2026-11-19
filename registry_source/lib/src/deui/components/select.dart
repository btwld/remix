import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'select.g.dart';

/// Deui recipe for [RemixSelect]: a field trigger over an overlay list.
///
/// [invalid] paints the error treatment; validation stays with the app.
@MixWidget(target: RemixSelect.new)
SelectStyler deuiSelectStyle({
  bool invalid = false,
  SelectStyler style = const SelectStyler.create(),
}) => SelectStyler()
    .trigger(_trigger(invalid: invalid))
    .content(_content)
    .menuContainer(
      FlexBoxStyler().padding(.all(_listPadding)).spacing(_listGap),
    )
    .item(_item)
    .merge(style);

/// Deui's trigger is the text field's 44px pill: hairline border, no fill.
SelectTriggerStyler _trigger({required bool invalid}) => SelectTriggerStyler()
    .direction(.horizontal)
    .minHeight(_triggerHeight)
    .padding(.symmetric(horizontal: _paddingX))
    .spacing(_valueGap)
    .borderRadius(.circular(_pill))
    .color(DeuiTokens.fieldBackground())
    .border(
      .color(invalid ? DeuiTokens.danger() : DeuiTokens.border()).width(1),
    )
    .label(deuiFieldText(DeuiTokens.fieldForeground))
    .placeholder(deuiFieldText(DeuiTokens.fieldPlaceholder))
    .indicator(.size(_indicator).color(DeuiTokens.muted()))
    .onHovered(.color(DeuiTokens.fieldHover()))
    .onFocusVisible(
      SelectTriggerStyler().border(
        .color(DeuiTokens.fieldBorderFocus()).width(1),
      ),
    )
    .onDisabled(
      SelectTriggerStyler().wrap(.opacity(DeuiTokens.disabledOpacity)),
    )
    .animate(DeuiTokens.smoothMotion);

final _content = SelectContentStyler()
    .minWidth(remixAnchorWidth())
    .color(DeuiTokens.overlay())
    .borderRadius(.all(DeuiTokens.radiusLg()))
    .border(deuiHairline());

final _item = SelectMenuItemStyler()
    .minHeight(_itemHeight)
    .padding(.symmetric(horizontal: _itemPaddingX, vertical: _itemPaddingY))
    .spacing(_itemGap)
    .borderRadius(.circular(_itemRadius))
    .text(.style(DeuiTokens.textSm.mix()).color(DeuiTokens.foreground()))
    .icon(.size(_itemMark).color(DeuiTokens.foreground()))
    .onHovered(.color(deuiRowHover()))
    .onFocusVisible(.color(deuiRowHover()))
    .onDisabled(
      SelectMenuItemStyler().wrap(.opacity(DeuiTokens.disabledOpacity)),
    );

const _triggerHeight = 44.0;
const _paddingX = 14.0;
const _pill = 999.0;
const _indicator = 14.0;
const _valueGap = 8.0;

const _listPadding = 6.0;
const _listGap = 2.0;

const _itemHeight = 36.0;
const _itemGap = 10.0;
const _itemPaddingX = 10.0;
const _itemPaddingY = 8.0;
const _itemRadius = 8.0;
const _itemMark = 16.0;
