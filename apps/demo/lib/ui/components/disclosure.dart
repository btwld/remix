import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'disclosure.g.dart';

/// Fortal disclosure size presets.
enum FortalDisclosureSize { size1, size2, size3 }

/// Fortal disclosure color variants.
enum FortalDisclosureVariant { surface, soft }

/// Fortal-themed preset for [RemixDisclosure].
@MixWidget(target: RemixDisclosure.new)
DisclosureStyler fortalDisclosureStyle({
  FortalDisclosureVariant variant = .surface,
  FortalDisclosureSize size = .size2,
  DisclosureStyler style = const DisclosureStyler.create(),
}) {
  return (switch (variant) {
    .surface => _fortalDisclosureSurfaceStyler(size),
    .soft => _fortalDisclosureSoftStyler(size),
  }).container(BoxStyler().clipBehavior(.none)).merge(style);
}

// The frame paints above the parts, whose own clips leave focus outlines free
// to extend outside the container without changing layout.
DisclosureStyler _fortalDisclosureBaseStyler(FortalDisclosureSize size) {
  final metrics = _fortalDisclosureMetrics(size);

  return DisclosureStyler()
      .trigger(
        BoxStyler()
            .width(.infinity)
            .borderRadius(.all(metrics.radius))
            .clipBehavior(.antiAlias)
            .minHeight(FortalTokens.touchTargetMin())
            .alignment(.centerLeft)
            .padding(.all(metrics.padding))
            .wrap(
              _fortalDisclosureTypography(
                style: metrics.triggerText,
                color: FortalTokens.gray12(),
                iconColor: FortalTokens.gray11(),
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
              _fortalDisclosureTypography(
                style: FortalTokens.text2,
                color: FortalTokens.gray12(),
                iconColor: FortalTokens.gray11(),
                iconSize: metrics.iconSize,
              ),
            ),
      );
}

DisclosureStyler _fortalDisclosureSurfaceStyler(FortalDisclosureSize size) {
  final metrics = _fortalDisclosureMetrics(size);
  return _fortalDisclosureBaseStyler(size)
      .container(
        fortalSurfaceFrame(
          fillColor: FortalTokens.gray2(),
          borderColor: FortalTokens.gray6(),
          borderWidth: FortalTokens.borderWidth1(),
          radius: metrics.radius,
        ),
      )
      .trigger(.color(FortalTokens.gray1()))
      .content(
        .foregroundDecoration(
          BoxDecorationMix(
            border: BoxBorderMix.top(
              _fortalDisclosureBorderSide(FortalTokens.gray6()),
            ),
          ),
        ),
      )
      .onHovered(.trigger(.color(FortalTokens.gray2())))
      .onPressed(.trigger(.color(FortalTokens.gray3())))
      .onFocusVisible(DisclosureStyler().triggerEffects(fortalFocusOutline()))
      .onDisabled(_fortalDisclosureDisabledStyler());
}

DisclosureStyler _fortalDisclosureSoftStyler(FortalDisclosureSize size) {
  final metrics = _fortalDisclosureMetrics(size);
  return _fortalDisclosureBaseStyler(size)
      .container(
        fortalSurfaceFrame(
          fillColor: FortalTokens.accent2(),
          borderColor: FortalTokens.accent6(),
          borderWidth: FortalTokens.borderWidth1(),
          radius: metrics.radius,
        ),
      )
      .trigger(
        BoxStyler()
            .color(FortalTokens.accent2())
            .wrap(
              _fortalDisclosureForeground(
                color: FortalTokens.accent12(),
                iconColor: FortalTokens.accent11(),
              ),
            ),
      )
      .content(
        BoxStyler()
            .foregroundDecoration(
              BoxDecorationMix(
                border: BoxBorderMix.top(
                  _fortalDisclosureBorderSide(FortalTokens.accent6()),
                ),
              ),
            )
            .wrap(
              _fortalDisclosureForeground(
                color: FortalTokens.accent12(),
                iconColor: FortalTokens.accent11(),
              ),
            ),
      )
      .onHovered(.trigger(.color(FortalTokens.accent3())))
      .onPressed(.trigger(.color(FortalTokens.accent4())))
      .onFocusVisible(DisclosureStyler().triggerEffects(fortalFocusOutline()))
      .onDisabled(_fortalDisclosureDisabledStyler());
}

DisclosureStyler _fortalDisclosureDisabledStyler() {
  return DisclosureStyler()
      .triggerEffects(RemixBoxEffectsMix(outline: BorderSideMix(style: .none)))
      .trigger(
        BoxStyler()
            .color(FortalTokens.grayA3())
            .wrap(
              _fortalDisclosureForeground(
                color: FortalTokens.gray8(),
                iconColor: FortalTokens.gray8(),
              ),
            ),
      );
}

BorderSideMix _fortalDisclosureBorderSide(Color color) =>
    BorderSideMix(color: color, width: FortalTokens.borderWidth1());

WidgetModifierConfig _fortalDisclosureTypography({
  required TextStyleToken style,
  required Color color,
  required Color iconColor,
  required double iconSize,
}) {
  return WidgetModifierConfig.defaultTextStyle(style: style.mix())
      .defaultTextStyle(style: TextStyleMix().color(color))
      .merge(WidgetModifierConfig.iconTheme(color: iconColor, size: iconSize));
}

WidgetModifierConfig _fortalDisclosureForeground({
  required Color color,
  required Color iconColor,
}) {
  return WidgetModifierConfig.defaultTextStyle(
    style: TextStyleMix().color(color),
  ).merge(WidgetModifierConfig.iconTheme(color: iconColor));
}

({double padding, Radius radius, TextStyleToken triggerText, double iconSize})
_fortalDisclosureMetrics(FortalDisclosureSize size) {
  return switch (size) {
    .size1 => (
      padding: FortalTokens.space2(),
      radius: FortalTokens.radius3(),
      triggerText: FortalTokens.text2,
      iconSize: FortalTokens.space4(),
    ),
    .size2 => (
      padding: FortalTokens.space3(),
      radius: FortalTokens.radius4(),
      triggerText: FortalTokens.text2,
      iconSize: FortalTokens.spinnerSize3(),
    ),
    .size3 => (
      padding: FortalTokens.space4(),
      radius: FortalTokens.radius5(),
      triggerText: FortalTokens.text3,
      iconSize: FortalTokens.space5(),
    ),
  };
}
