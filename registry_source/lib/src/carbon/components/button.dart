// Adapted from remix_carbon at commit 606bfbb36 and from the IBM Carbon Design
// System Button. Copyright 2026 the Remix authors; IBM Carbon Design System
// copyright IBM Corp. and the Carbon authors. Apache-2.0.
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'button.g.dart';

/// Carbon Button kinds.
enum CarbideButtonKind {
  primary,
  secondary,
  tertiary,
  ghost,
  danger,
  dangerTertiary,
  dangerGhost,
}

const _carbideButtonFocusBorder = ContextToken(
  _resolveCarbideButtonFocusBorder,
);

const _carbideButtonHeight = ContextToken(_resolveCarbideButtonHeight);

double _resolveCarbideButtonHeight(BuildContext context) =>
    (CarbideLayoutScope.maybeSizeOf(context) ?? CarbideSize.lg)
        .clampTo(.sm, .x2l)
        .height;

ShapeBorder _resolveCarbideButtonFocusBorder(BuildContext context) {
  final outer = RoundedRectangleBorder(
    side: BorderSide(color: CarbideTokens.focus.resolve(context), width: 2.0),
  );
  final inner = RoundedRectangleBorder(
    side: BorderSide(
      color: CarbideTokens.focusInset.resolve(context),
      width: 1.0,
    ),
  );

  // Flutter lists compound shape borders outside-in. The left operand is the
  // inner border and the right operand is the outer border.
  return inner + outer;
}

/// A Carbon Button recipe and generated [RemixButton] wrapper.
///
/// When [size] is null, height comes from [CarbideLayoutScope], falling back to
/// Carbon's large 48px default and clamping to the supported small–2xl range.
/// Loading is non-interactive but retains the selected kind's treatment rather
/// than taking the ordinary disabled colors.
@MixWidget(
  target: RemixButton.new,
  widgetParameters: .only({
    'label',
    'trailingIcon',
    'loading',
    'enabled',
    'onPressed',
    'onLongPress',
    'focusNode',
    'autofocus',
    'enableFeedback',
    'semanticLabel',
    'semanticHint',
    'excludeSemantics',
    'mouseCursor',
  }),
)
ButtonStyler carbideButtonStyle({
  CarbideButtonKind kind = .primary,
  CarbideSize? size,
  bool loading = false,
}) {
  final height = size == null
      ? _carbideButtonHeight()
      : size.clampTo(.sm, .x2l).height;
  final base = _carbideButtonBaseStyle(height, kind);

  return switch (kind) {
    .primary => _fillStyle(
      base,
      fill: CarbideComponentTokens.buttonPrimary,
      hover: CarbideComponentTokens.buttonPrimaryHover,
      active: CarbideComponentTokens.buttonPrimaryActive,
      loading: loading,
    ),
    .secondary => _fillStyle(
      base,
      fill: CarbideComponentTokens.buttonSecondary,
      hover: CarbideComponentTokens.buttonSecondaryHover,
      active: CarbideComponentTokens.buttonSecondaryActive,
      loading: loading,
    ),
    .danger => _fillStyle(
      base,
      fill: CarbideComponentTokens.buttonDangerPrimary,
      hover: CarbideComponentTokens.buttonDangerHover,
      active: CarbideComponentTokens.buttonDangerActive,
      loading: loading,
    ),
    .tertiary => _outlineStyle(
      base,
      line: CarbideComponentTokens.buttonTertiary,
      hover: CarbideComponentTokens.buttonTertiaryHover,
      active: CarbideComponentTokens.buttonTertiaryActive,
      interactionText: CarbideTokens.textInverse,
      focusFill: CarbideComponentTokens.buttonTertiary,
      focusText: CarbideTokens.textInverse,
      loading: loading,
    ),
    .dangerTertiary => _outlineStyle(
      base,
      line: CarbideComponentTokens.buttonDangerSecondary,
      hover: CarbideComponentTokens.buttonDangerHover,
      active: CarbideComponentTokens.buttonDangerActive,
      interactionText: CarbideTokens.textOnColor,
      focusFill: CarbideComponentTokens.buttonDangerPrimary,
      focusText: CarbideTokens.textOnColor,
      loading: loading,
    ),
    .ghost => _ghostStyle(
      base,
      text: CarbideTokens.linkPrimary,
      hoverFill: CarbideTokens.backgroundHover,
      hoverText: CarbideTokens.linkPrimaryHover,
      activeFill: CarbideTokens.backgroundActive,
      activeText: CarbideTokens.linkPrimaryHover,
      loading: loading,
    ),
    .dangerGhost => _ghostStyle(
      base,
      text: CarbideComponentTokens.buttonDangerSecondary,
      hoverFill: CarbideComponentTokens.buttonDangerHover,
      hoverText: CarbideTokens.textOnColor,
      activeFill: CarbideComponentTokens.buttonDangerActive,
      activeText: CarbideTokens.textOnColor,
      loading: loading,
    ),
  };
}

ButtonStyler _carbideButtonBaseStyle(double height, CarbideButtonKind kind) {
  return ButtonStyler()
      .height(height)
      .padding(.horizontal(CarbideTokens.spacing05()))
      .spacing(switch (kind) {
        .ghost || .dangerGhost => CarbideTokens.spacing03(),
        .primary ||
        .secondary ||
        .tertiary ||
        .danger ||
        .dangerTertiary => CarbideTokens.spacing07(),
      })
      .mainAxisAlignment(.spaceBetween)
      .borderRadius(.all(.zero))
      .label(TextStyler().style(CarbideTokens.bodyCompact01.mix()))
      .icon(IconStyler().size(CarbideTokens.iconSize01()))
      .spinner(.size(CarbideTokens.iconSize01()).strokeWidth(2.0))
      .onFocusVisible(
        .foregroundDecoration(
          ShapeDecorationMix.create(
            shape: Prop.token(_carbideButtonFocusBorder),
          ),
        ),
      );
}

ButtonStyler _fillStyle(
  ButtonStyler base, {
  required ColorToken fill,
  required ColorToken hover,
  required ColorToken active,
  required bool loading,
}) {
  final disabledStyle = loading
      ? ButtonStyler()
            .color(fill())
            .spinner(.indicatorColor(CarbideTokens.textOnColor()))
      : _disabledFill();

  return _foreground(base, CarbideTokens.textOnColor())
      .color(fill())
      .spinner(.indicatorColor(CarbideTokens.textOnColor()))
      .onHovered(.color(hover()))
      .onPressed(.color(active()))
      .onDisabled(disabledStyle);
}

ButtonStyler _outlineStyle(
  ButtonStyler base, {
  required ColorToken line,
  required ColorToken hover,
  required ColorToken active,
  required ColorToken interactionText,
  required ColorToken focusFill,
  required ColorToken focusText,
  required bool loading,
}) {
  final disabledStyle = loading
      ? ButtonStyler()
            .color(const Color(0x00000000))
            .border(.color(line()).width(1.0))
            .spinner(.indicatorColor(line()))
      : _foreground(
          ButtonStyler()
              .color(const Color(0x00000000))
              .border(.color(CarbideTokens.borderDisabled()).width(1.0)),
          CarbideTokens.textDisabled(),
        );

  return _foreground(base, line())
      .color(const Color(0x00000000))
      .border(.color(line()).width(1.0))
      .spinner(.indicatorColor(line()))
      .onHovered(_foreground(.color(hover()), interactionText()))
      .onPressed(_foreground(.color(active()), interactionText()))
      .onFocusVisible(_foreground(.color(focusFill()), focusText()))
      .onDisabled(disabledStyle);
}

ButtonStyler _ghostStyle(
  ButtonStyler base, {
  required ColorToken text,
  required ColorToken hoverFill,
  required ColorToken hoverText,
  required ColorToken activeFill,
  required ColorToken activeText,
  required bool loading,
}) {
  final disabledStyle = loading
      ? ButtonStyler().spinner(.indicatorColor(text()))
      : _foreground(ButtonStyler(), CarbideTokens.textDisabled());

  return _foreground(base, text())
      .color(const Color(0x00000000))
      .spinner(.indicatorColor(text()))
      .onHovered(_foreground(.color(hoverFill()), hoverText()))
      .onPressed(_foreground(.color(activeFill()), activeText()))
      .onDisabled(disabledStyle);
}

ButtonStyler _disabledFill() => _foreground(
  ButtonStyler()
      .color(CarbideComponentTokens.buttonDisabled())
      .spinner(
        .indicatorColor(CarbideTokens.textOnColorDisabled()).strokeWidth(1.0),
      ),
  CarbideTokens.textOnColorDisabled(),
);

ButtonStyler _foreground(ButtonStyler style, Color color) =>
    style.label(.color(color)).icon(.color(color));
