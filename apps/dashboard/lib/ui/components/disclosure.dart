import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'disclosure.g.dart';

/// The sizes a disclosure comes in. Pixel values are at 100% theme scaling.
enum UiDisclosureSize {
  /// 14px trigger text, 16px icons and 8px padding.
  size1,

  /// 14px trigger text, 20px icons and 12px padding. The default.
  size2,

  /// 16px trigger text, 24px icons and 16px padding.
  size3,
}

/// The looks a disclosure comes in.
enum UiDisclosureVariant {
  /// The `gray2` panel inside a 1px gray frame.
  surface,

  /// An accent-tinted panel inside a 1px accent frame.
  soft,
}

/// The Ui Disclosure recipe.
///
/// It reads top to bottom: what every disclosure shares, then the variant's
/// panel colors for rest, hover, press, focus and disabled.
@MixWidget(target: RemixDisclosure.new)
DisclosureStyler uiDisclosureStyle({
  UiDisclosureVariant variant = .surface,
  UiDisclosureSize size = .size2,
  DisclosureStyler style = const DisclosureStyler.create(),
}) => _base(size)
    .merge(switch (variant) {
      .surface => _surface(size),
      .soft => _soft(size),
    })
    .container(BoxStyler().clipBehavior(.none))
    .merge(style);

/// The trigger and content shapes every disclosure shares, with the gray text
/// and icons, and the open state's flat joint.
///
/// The frame paints above the parts, whose own clips leave focus outlines free
/// to extend outside the container without changing layout.
DisclosureStyler _base(UiDisclosureSize size) {
  final (:padding, :triggerText, :iconSize) = switch (size) {
    .size1 => (
      padding: UiTokens.space2(),
      triggerText: UiTokens.text2,
      iconSize: UiTokens.space4(),
    ),
    .size2 => (
      padding: UiTokens.space3(),
      triggerText: UiTokens.text2,
      iconSize: UiTokens.spinnerSize3(),
    ),
    .size3 => (
      padding: UiTokens.space4(),
      triggerText: UiTokens.text3,
      iconSize: UiTokens.space5(),
    ),
  };

  final radius = _radius(size);

  return DisclosureStyler()
      .trigger(
        BoxStyler()
            .width(.infinity)
            .borderRadius(.all(radius))
            .clipBehavior(.antiAlias)
            .minHeight(UiTokens.touchTargetMin())
            .alignment(.centerLeft)
            .padding(.all(padding))
            .wrap(_text(triggerText, iconSize: iconSize)),
      )
      .onExpanded(
        DisclosureStyler().trigger(
          BoxStyler().borderRadius(
            BorderRadiusMix(
              topLeft: radius,
              topRight: radius,
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
              BorderRadiusMix(bottomLeft: radius, bottomRight: radius),
            )
            .clipBehavior(.antiAlias)
            .padding(.all(padding))
            .wrap(_text(UiTokens.text2, iconSize: iconSize)),
      );
}

DisclosureStyler _surface(UiDisclosureSize size) => DisclosureStyler()
    .container(
      uiSurfaceFrame(
        fillColor: UiTokens.gray2(),
        borderColor: UiTokens.gray6(),
        borderWidth: UiTokens.borderWidth1(),
        radius: _radius(size),
      ),
    )
    .trigger(.color(UiTokens.gray1()))
    .content(.foregroundDecoration(_dividerAbove(UiTokens.gray6())))
    .onHovered(.trigger(.color(UiTokens.gray2())))
    .onPressed(.trigger(.color(UiTokens.gray3())))
    .onFocusVisible(.triggerEffects(uiFocusOutline()))
    .onDisabled(_disabled());

DisclosureStyler _soft(UiDisclosureSize size) => DisclosureStyler()
    .container(
      uiSurfaceFrame(
        fillColor: UiTokens.accent2(),
        borderColor: UiTokens.accent6(),
        borderWidth: UiTokens.borderWidth1(),
        radius: _radius(size),
      ),
    )
    .trigger(
      BoxStyler()
          .color(UiTokens.accent2())
          .wrap(
            _tint(
              color: UiTokens.accent12(),
              iconColor: UiTokens.accentContent(),
            ),
          ),
    )
    .content(
      BoxStyler()
          .foregroundDecoration(_dividerAbove(UiTokens.accent6()))
          .wrap(
            _tint(
              color: UiTokens.accent12(),
              iconColor: UiTokens.accentContent(),
            ),
          ),
    )
    .onHovered(.trigger(.color(UiTokens.accent3())))
    .onPressed(.trigger(.color(UiTokens.accent4())))
    .onFocusVisible(.triggerEffects(uiFocusOutline()))
    .onDisabled(_disabled());

DisclosureStyler _disabled() => DisclosureStyler()
    .triggerEffects(RemixBoxEffectsMix(outline: BorderSideMix(style: .none)))
    .trigger(
      BoxStyler()
          .color(UiTokens.grayA3())
          .wrap(_tint(color: UiTokens.gray8(), iconColor: UiTokens.gray8())),
    );

/// The 1px line between the trigger and the content.
BoxDecorationMix _dividerAbove(Color color) => BoxDecorationMix(
  border: BoxBorderMix.top(
    BorderSideMix(color: color, width: UiTokens.borderWidth1()),
  ),
);

/// A text style, the gray text color and gray icons of a part's default look.
WidgetModifierConfig _text(TextStyleToken style, {required double iconSize}) =>
    WidgetModifierConfig.defaultTextStyle(style: style.mix())
        .defaultTextStyle(style: TextStyleMix().color(UiTokens.gray12()))
        .merge(
          WidgetModifierConfig.iconTheme(
            color: UiTokens.gray11(),
            size: iconSize,
          ),
        );

/// Text and icon colors, leaving the size alone.
WidgetModifierConfig _tint({required Color color, required Color iconColor}) =>
    WidgetModifierConfig.defaultTextStyle(
      style: TextStyleMix().color(color),
    ).merge(WidgetModifierConfig.iconTheme(color: iconColor));

Radius _radius(UiDisclosureSize size) => switch (size) {
  .size1 => UiTokens.radius3(),
  .size2 => UiTokens.radius4(),
  .size3 => UiTokens.radius5(),
};
