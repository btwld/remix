import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'disclosure.g.dart';

/// Ui disclosure size presets.
enum UiDisclosureSize { size1, size2, size3 }

/// Ui disclosure color variants.
enum UiDisclosureVariant { surface, soft }

/// Ui-themed preset for [RemixDisclosure].
@MixWidget(target: RemixDisclosure.new)
DisclosureStyler uiDisclosureStyle({
  UiDisclosureVariant variant = .surface,
  UiDisclosureSize size = .size2,
  DisclosureStyler style = const DisclosureStyler.create(),
}) {
  return (switch (variant) {
    .surface => _uiDisclosureSurfaceStyler(size),
    .soft => _uiDisclosureSoftStyler(size),
  }).container(BoxStyler().clipBehavior(.none)).merge(style);
}

// The frame paints above the parts, whose own clips leave focus outlines free
// to extend outside the container without changing layout.
DisclosureStyler _uiDisclosureBaseStyler(UiDisclosureSize size) {
  final metrics = _uiDisclosureMetrics(size);

  return DisclosureStyler()
      .trigger(
        BoxStyler()
            .width(.infinity)
            .borderRadius(.all(metrics.radius))
            .clipBehavior(.antiAlias)
            .minHeight(UiTokens.touchTargetMin())
            .alignment(.centerLeft)
            .padding(.all(metrics.padding))
            .wrap(
              _uiDisclosureTypography(
                style: metrics.triggerText,
                color: UiTokens.gray12(),
                iconColor: UiTokens.gray11(),
                iconSize: metrics.iconSize,
              ),
            ),
      )
      .onExpanded(
        DisclosureStyler().trigger(
          BoxStyler().borderRadius(
            BorderRadiusMix(
              topLeft: metrics.radius,
              topRight: metrics.radius,
              bottomLeft: Radius.zero,
              bottomRight: Radius.zero,
            ),
          ),
        ),
      )
      .content(
        BoxStyler()
            .width(.infinity)
            .borderRadius(
              BorderRadiusMix(
                bottomLeft: metrics.radius,
                bottomRight: metrics.radius,
              ),
            )
            .clipBehavior(.antiAlias)
            .padding(.all(metrics.padding))
            .wrap(
              _uiDisclosureTypography(
                style: UiTokens.text2,
                color: UiTokens.gray12(),
                iconColor: UiTokens.gray11(),
                iconSize: metrics.iconSize,
              ),
            ),
      );
}

DisclosureStyler _uiDisclosureSurfaceStyler(UiDisclosureSize size) {
  final metrics = _uiDisclosureMetrics(size);
  return _uiDisclosureBaseStyler(size)
      .container(
        uiSurfaceFrame(
          fillColor: UiTokens.gray2(),
          borderColor: UiTokens.gray6(),
          borderWidth: UiTokens.borderWidth1(),
          radius: metrics.radius,
        ),
      )
      .trigger(.color(UiTokens.gray1()))
      .content(
        .foregroundDecoration(
          BoxDecorationMix(
            border: BoxBorderMix.top(_uiDisclosureBorderSide(UiTokens.gray6())),
          ),
        ),
      )
      .onHovered(.trigger(.color(UiTokens.gray2())))
      .onPressed(.trigger(.color(UiTokens.gray3())))
      .onFocusVisible(DisclosureStyler().triggerEffects(uiFocusOutline()))
      .onDisabled(_uiDisclosureDisabledStyler());
}

DisclosureStyler _uiDisclosureSoftStyler(UiDisclosureSize size) {
  final metrics = _uiDisclosureMetrics(size);
  return _uiDisclosureBaseStyler(size)
      .container(
        uiSurfaceFrame(
          fillColor: UiTokens.accent2(),
          borderColor: UiTokens.accent6(),
          borderWidth: UiTokens.borderWidth1(),
          radius: metrics.radius,
        ),
      )
      .trigger(
        BoxStyler()
            .color(UiTokens.accent2())
            .wrap(
              _uiDisclosureForeground(
                color: UiTokens.accent12(),
                iconColor: UiTokens.accent11(),
              ),
            ),
      )
      .content(
        BoxStyler()
            .foregroundDecoration(
              BoxDecorationMix(
                border: BoxBorderMix.top(
                  _uiDisclosureBorderSide(UiTokens.accent6()),
                ),
              ),
            )
            .wrap(
              _uiDisclosureForeground(
                color: UiTokens.accent12(),
                iconColor: UiTokens.accent11(),
              ),
            ),
      )
      .onHovered(.trigger(.color(UiTokens.accent3())))
      .onPressed(.trigger(.color(UiTokens.accent4())))
      .onFocusVisible(DisclosureStyler().triggerEffects(uiFocusOutline()))
      .onDisabled(_uiDisclosureDisabledStyler());
}

DisclosureStyler _uiDisclosureDisabledStyler() {
  return DisclosureStyler()
      .triggerEffects(RemixBoxEffectsMix(outline: BorderSideMix(style: .none)))
      .trigger(
        BoxStyler()
            .color(UiTokens.grayA3())
            .wrap(
              _uiDisclosureForeground(
                color: UiTokens.gray8(),
                iconColor: UiTokens.gray8(),
              ),
            ),
      );
}

BorderSideMix _uiDisclosureBorderSide(Color color) =>
    BorderSideMix(color: color, width: UiTokens.borderWidth1());

WidgetModifierConfig _uiDisclosureTypography({
  required TextStyleToken style,
  required Color color,
  required Color iconColor,
  required double iconSize,
}) {
  return WidgetModifierConfig.defaultTextStyle(style: style.mix())
      .defaultTextStyle(style: TextStyleMix().color(color))
      .merge(WidgetModifierConfig.iconTheme(color: iconColor, size: iconSize));
}

WidgetModifierConfig _uiDisclosureForeground({
  required Color color,
  required Color iconColor,
}) {
  return WidgetModifierConfig.defaultTextStyle(
    style: TextStyleMix().color(color),
  ).merge(WidgetModifierConfig.iconTheme(color: iconColor));
}

({double padding, Radius radius, TextStyleToken triggerText, double iconSize})
_uiDisclosureMetrics(UiDisclosureSize size) {
  return switch (size) {
    .size1 => (
      padding: UiTokens.space2(),
      radius: UiTokens.radius3(),
      triggerText: UiTokens.text2,
      iconSize: UiTokens.space4(),
    ),
    .size2 => (
      padding: UiTokens.space3(),
      radius: UiTokens.radius4(),
      triggerText: UiTokens.text2,
      iconSize: UiTokens.spinnerSize3(),
    ),
    .size3 => (
      padding: UiTokens.space4(),
      radius: UiTokens.radius5(),
      triggerText: UiTokens.text3,
      iconSize: UiTokens.space5(),
    ),
  };
}
