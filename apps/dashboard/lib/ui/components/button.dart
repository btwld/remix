import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import 'base_button.dart';
import '../theme/theme.dart';

part 'button.g.dart';

/// Ui Button size presets.
enum UiButtonSize { size1, size2, size3, size4 }

/// Ui Button variants.
enum UiButtonVariant { solid, soft, surface, outline, ghost }

/// Ui-themed Button with Ui sizes, variants, and overrides.
///
/// Default icon slots use the preset's icon size, not the ambient IconTheme.
/// An explicit icon size in [style] overrides that default.
@MixWidget(target: RemixButton.new)
ButtonStyler uiButtonStyle({
  UiButtonVariant variant = .solid,
  UiButtonSize size = .size2,
  bool highContrast = false,
  ButtonStyler style = const ButtonStyler.create(),
}) {
  final base = _uiButtonBaseStyler(variant, _uiBaseButtonSize(size));
  final stateStyles = uiBaseButtonStateStyles(
    variant: _uiBaseButtonVariant(variant),
    highContrast: highContrast,
  );

  return _applyUiButtonStateStyles(base, stateStyles)
      .wrap(uiTouchTarget())
      .onDisabled(
        ButtonStyler().containerEffects(
          RemixBoxEffectsMix(outline: BorderSideMix(style: .none)),
        ),
      )
      .merge(style);
}

ButtonStyler _uiButtonBaseStyler(
  UiButtonVariant variant,
  UiBaseButtonSize size,
) {
  final metrics = uiBaseButtonMetrics(size);
  var style = ButtonStyler(
    icon: .size(uiBaseButtonIconSize(size)),
    container: .direction(.horizontal).mainAxisSize(.min).spacing(metrics.gap),
    label: .style(metrics.text.mix()).fontWeight(
      variant == .ghost
          ? UiTokens.fontWeightRegular()
          : UiTokens.fontWeightMedium(),
    ),
    spinner: .size(metrics.spinnerSize)
        .opacity(0.65)
        .leafRadius(UiTokens.radius1())
        .duration(const Duration(milliseconds: 800)),
  ).borderRadius(.all(metrics.radius));

  if (variant == .ghost) {
    final ghost = uiBaseButtonGhostMetrics(size);
    style = style
        .spacing(ghost.gap)
        .padding(
          .symmetric(horizontal: ghost.paddingX, vertical: ghost.paddingY),
        )
        .margin(.symmetric(horizontal: ghost.marginX, vertical: ghost.marginY));
  } else {
    style = style
        .minHeight(metrics.height)
        .padding(.horizontal(metrics.paddingX))
        .icon(.opacity(0.9));
  }
  return style;
}

UiBaseButtonVariant _uiBaseButtonVariant(UiButtonVariant variant) =>
    switch (variant) {
      .solid => .solid,
      .soft => .soft,
      .surface => .surface,
      .outline => .outline,
      .ghost => .ghost,
    };

UiBaseButtonSize _uiBaseButtonSize(UiButtonSize size) => switch (size) {
  .size1 => .size1,
  .size2 => .size2,
  .size3 => .size3,
  .size4 => .size4,
};

ButtonStyler _applyUiButtonStateStyles(
  ButtonStyler base,
  UiBaseButtonStateStyles stateStyles,
) {
  final pressed = _applyUiButtonState(
    ButtonStyler().animate(uiBaseButtonActiveMotion),
    stateStyles.pressed,
  );

  return _applyUiButtonState(
        base.animate(uiBaseButtonRestMotion),
        stateStyles.idle,
      )
      .onHovered(
        _applyUiButtonState(
          ButtonStyler().animate(uiBaseButtonActiveMotion),
          stateStyles.hovered,
        ),
      )
      .onPressed(pressed)
      .onDisabled(_applyUiButtonState(ButtonStyler(), stateStyles.disabled))
      .onFocusVisible(
        _applyUiButtonState(ButtonStyler(), stateStyles.focusVisible),
      )
      .onDisabled(
        _applyUiButtonState(ButtonStyler(), stateStyles.disabledFocus),
      );
}

ButtonStyler _applyUiButtonState(
  ButtonStyler style,
  UiBaseButtonStateStyle state,
) {
  var result = style;
  final foreground = state.foreground;
  if (foreground != null) {
    result = result
        .label(.color(foreground))
        .icon(.color(foreground))
        .spinner(.color(foreground));
  }
  if (state.background != null) {
    result = result.color(state.background!);
  }
  if (state.effects != null) {
    result = result.containerEffects(state.effects!);
  }
  if (state.spinnerOpacity != null) {
    result = result.spinner(.opacity(state.spinnerOpacity!));
  }
  if (state.modifier != null) {
    result = result.wrap(state.modifier!);
  }
  return result;
}
