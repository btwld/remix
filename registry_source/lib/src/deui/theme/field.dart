import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'effects.dart';
import 'tokens.dart';

/// `.label`: `text-sm font-medium text-foreground` (label.css).
final deuiLabelText = TextStyler()
    .style(DeuiTokens.textSm.mix())
    .fontWeight(.w500)
    .color(DeuiTokens.foreground());

/// `.description`: `text-xs text-muted` (description.css).
final deuiDescriptionText = TextStyler()
    .style(DeuiTokens.textXs.mix())
    .color(DeuiTokens.muted());

/// `.field-error`: `text-xs text-danger px-1` (field-error.css).
final deuiErrorText = deuiDescriptionText
    .color(DeuiTokens.danger())
    .wrap(.padding(.horizontal(_errorPaddingX)));

const _errorPaddingX = 4.0;

/// `.checkbox__content`, `.radio__content`, `.switch__content`: `gap-3` between
/// a control and its label.
const deuiControlGap = 12.0;

/// The color of a disabled field's label: `status-disabled` dims the whole
/// field, and `.label` in a disabled field dims its text again (`label.css`).
///
/// Pair it with the field's own `opacity(disabledOpacity)` wrap. [danger] is the
/// label of an invalid field.
ContextToken<Color> deuiDisabledLabelColor({bool danger = false}) =>
    danger ? _dimmedDanger : _dimmedForeground;

final _dimmedForeground = deuiAlpha(
  DeuiTokens.foreground,
  DeuiTokens.disabledOpacity,
);
final _dimmedDanger = deuiAlpha(DeuiTokens.danger, DeuiTokens.disabledOpacity);

/// The text of an input, a select value, or a placeholder: `text-base`, then
/// `sm:text-sm` from 640px up.
///
/// `.input` and `.select__value` never wrap upstream, so a value or
/// placeholder longer than the field keeps [lines] = 1 and ellipsizes, the
/// same one-line policy the toggle button's label follows. A text area shows
/// several lines and passes the count its editor does, which is where its
/// placeholder ellipsizes instead of laying out lines its box then clips.
TextStyler deuiFieldText(ColorToken color, {int lines = 1}) => TextStyler()
    .style(DeuiTokens.textBase.mix())
    .color(color())
    .maxLines(lines)
    .softWrap(lines > 1)
    .overflow(TextOverflow.ellipsis)
    .onBreakpoint(
      const Breakpoint.minWidth(DeuiTokens.breakpointSm),
      TextStyler().style(DeuiTokens.textSm.mix()),
    );

/// The lines a placeholder may fill in a field whose editor shows [minLines]
/// to [maxLines] lines.
///
/// The placeholder is only visible while the editor is empty, where the editor
/// is as tall as the lines it reserves: [minLines], or the single line a field
/// without one shows. A [maxLines] below that caps the editor and the
/// placeholder with it. Stopping there is what keeps the ellipsis on the last
/// visible line instead of laying out lines the field's box clips away.
int deuiHintLines({int? minLines, int? maxLines}) {
  final lines = minLines ?? 1;
  return maxLines != null && maxLines < lines ? maxLines : lines;
}

/// The fill of a field-like control at rest, hovered, and focused.
typedef DeuiFieldFill = ({ColorToken rest, ColorToken hover, ColorToken focus});

/// `--field-background`, `--field-hover`, `--field-focus`: the `primary`
/// variant of the input, select, checkbox, and radio.
const DeuiFieldFill deuiPrimaryFieldFill = (
  rest: DeuiTokens.fieldBackground,
  hover: DeuiTokens.fieldHover,
  focus: DeuiTokens.fieldFocus,
);

/// `--default` and `--default-hover`: the `secondary` variant of the same
/// controls.
const DeuiFieldFill deuiSecondaryFieldFill = (
  rest: DeuiTokens.defaultColor,
  hover: DeuiTokens.defaultHover,
  focus: DeuiTokens.defaultColor,
);
