import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'effects.dart';
import 'tokens.dart';

/// `.label`: `text-sm font-medium text-foreground` (label.css).
final heroUiLabelText = TextStyler()
    .style(HeroUiTokens.textSm.mix())
    .fontWeight(.w500)
    .color(HeroUiTokens.foreground());

/// `.description`: `text-xs text-muted` (description.css).
final heroUiDescriptionText = TextStyler()
    .style(HeroUiTokens.textXs.mix())
    .color(HeroUiTokens.muted());

/// `.field-error`: `text-xs text-danger px-1` (field-error.css).
final heroUiErrorText = heroUiDescriptionText
    .color(HeroUiTokens.danger())
    .wrap(.padding(.horizontal(_errorPaddingX)));

const _errorPaddingX = 4.0;

/// The color of a disabled field's label: `status-disabled` dims the whole
/// field, and `.label` in a disabled field dims its text again (`label.css`).
///
/// Pair it with the field's own `opacity(disabledOpacity)` wrap. [danger] is the
/// label of an invalid field.
ContextToken<Color> heroUiDisabledLabelColor({bool danger = false}) =>
    danger ? _dimmedDanger : _dimmedForeground;

final _dimmedForeground = heroUiAlpha(
  HeroUiTokens.foreground,
  HeroUiTokens.disabledOpacity,
);
final _dimmedDanger = heroUiAlpha(
  HeroUiTokens.danger,
  HeroUiTokens.disabledOpacity,
);

/// The text of an input, a select value, or a placeholder: `text-base`, then
/// `sm:text-sm` from 640px up.
TextStyler heroUiFieldText(ColorToken color) => TextStyler()
    .style(HeroUiTokens.textBase.mix())
    .color(color())
    .onBreakpoint(
      const Breakpoint.minWidth(HeroUiTokens.breakpointSm),
      TextStyler().style(HeroUiTokens.textSm.mix()),
    );

/// The fill of a field-like control at rest, hovered, and focused.
typedef HeroUiFieldFill = ({
  ColorToken rest,
  ColorToken hover,
  ColorToken focus,
});

/// `--field-background`, `--field-hover`, `--field-focus`: the `primary`
/// variant of the input, select, checkbox, and radio.
const HeroUiFieldFill heroUiPrimaryFieldFill = (
  rest: HeroUiTokens.fieldBackground,
  hover: HeroUiTokens.fieldHover,
  focus: HeroUiTokens.fieldFocus,
);

/// `--default` and `--default-hover`: the `secondary` variant of the same
/// controls.
const HeroUiFieldFill heroUiSecondaryFieldFill = (
  rest: HeroUiTokens.defaultColor,
  hover: HeroUiTokens.defaultHover,
  focus: HeroUiTokens.defaultColor,
);
