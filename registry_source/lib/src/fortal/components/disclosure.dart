import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'disclosure.g.dart';

/// The sizes a disclosure comes in. Pixel values are at 100% theme scaling.
enum FortalDisclosureSize {
  /// 14px trigger text, 16px icons and 8px padding.
  size1,

  /// 14px trigger text, 20px icons and 12px padding. The default.
  size2,

  /// 16px trigger text, 24px icons and 16px padding.
  size3,
}

/// The looks a disclosure comes in.
enum FortalDisclosureVariant {
  /// A near-white panel inside a 1px gray frame.
  surface,

  /// An accent-tinted panel inside a 1px accent frame.
  soft,
}

/// The Fortal Disclosure recipe.
///
/// It reads top to bottom: what every disclosure shares, then the variant's
/// panel colors for rest, hover, press, focus and disabled.
@MixWidget(target: RemixDisclosure.new)
DisclosureStyler fortalDisclosureStyle({
  FortalDisclosureVariant variant = .surface,
  FortalDisclosureSize size = .size2,
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
DisclosureStyler _base(FortalDisclosureSize size) {
  final (:padding, :triggerText, :iconSize) = switch (size) {
    .size1 => (
      padding: FortalTokens.space2(),
      triggerText: FortalTokens.text2,
      iconSize: FortalTokens.space4(),
    ),
    .size2 => (
      padding: FortalTokens.space3(),
      triggerText: FortalTokens.text2,
      iconSize: FortalTokens.spinnerSize3(),
    ),
    .size3 => (
      padding: FortalTokens.space4(),
      triggerText: FortalTokens.text3,
      iconSize: FortalTokens.space5(),
    ),
  };

  final radius = _radius(size);

  return DisclosureStyler()
      .trigger(
        BoxStyler()
            .width(.infinity)
            .borderRadius(.all(radius))
            .clipBehavior(.antiAlias)
            .minHeight(FortalTokens.touchTargetMin())
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
            .wrap(_text(FortalTokens.text2, iconSize: iconSize)),
      );
}

DisclosureStyler _surface(FortalDisclosureSize size) => DisclosureStyler()
    .container(
      fortalSurfaceFrame(
        fillColor: FortalTokens.gray2(),
        borderColor: FortalTokens.gray6(),
        borderWidth: FortalTokens.borderWidth1(),
        radius: _radius(size),
      ),
    )
    .trigger(.color(FortalTokens.gray1()))
    .content(.foregroundDecoration(_dividerAbove(FortalTokens.gray6())))
    .onHovered(.trigger(.color(FortalTokens.gray2())))
    .onPressed(.trigger(.color(FortalTokens.gray3())))
    .onFocusVisible(.triggerEffects(fortalFocusOutline()))
    .onDisabled(_disabled());

DisclosureStyler _soft(FortalDisclosureSize size) => DisclosureStyler()
    .container(
      fortalSurfaceFrame(
        fillColor: FortalTokens.accent2(),
        borderColor: FortalTokens.accent6(),
        borderWidth: FortalTokens.borderWidth1(),
        radius: _radius(size),
      ),
    )
    .trigger(
      BoxStyler()
          .color(FortalTokens.accent2())
          .wrap(
            _tint(
              color: FortalTokens.accent12(),
              iconColor: FortalTokens.accentContent(),
            ),
          ),
    )
    .content(
      BoxStyler()
          .foregroundDecoration(_dividerAbove(FortalTokens.accent6()))
          .wrap(
            _tint(
              color: FortalTokens.accent12(),
              iconColor: FortalTokens.accentContent(),
            ),
          ),
    )
    .onHovered(.trigger(.color(FortalTokens.accent3())))
    .onPressed(.trigger(.color(FortalTokens.accent4())))
    .onFocusVisible(.triggerEffects(fortalFocusOutline()))
    .onDisabled(_disabled());

DisclosureStyler _disabled() => DisclosureStyler()
    .triggerEffects(RemixBoxEffectsMix(outline: BorderSideMix(style: .none)))
    .trigger(
      BoxStyler()
          .color(FortalTokens.grayA3())
          .wrap(
            _tint(color: FortalTokens.gray8(), iconColor: FortalTokens.gray8()),
          ),
    );

/// The 1px line between the trigger and the content.
BoxDecorationMix _dividerAbove(Color color) => BoxDecorationMix(
  border: BoxBorderMix.top(
    BorderSideMix(color: color, width: FortalTokens.borderWidth1()),
  ),
);

/// A text style, the gray text color and gray icons of a part's default look.
WidgetModifierConfig _text(TextStyleToken style, {required double iconSize}) =>
    WidgetModifierConfig.defaultTextStyle(style: style.mix())
        .defaultTextStyle(style: TextStyleMix().color(FortalTokens.gray12()))
        .merge(
          WidgetModifierConfig.iconTheme(
            color: FortalTokens.gray11(),
            size: iconSize,
          ),
        );

/// Text and icon colors, leaving the size alone.
WidgetModifierConfig _tint({required Color color, required Color iconColor}) =>
    WidgetModifierConfig.defaultTextStyle(
      style: TextStyleMix().color(color),
    ).merge(WidgetModifierConfig.iconTheme(color: iconColor));

Radius _radius(FortalDisclosureSize size) => switch (size) {
  .size1 => FortalTokens.radius3(),
  .size2 => FortalTokens.radius4(),
  .size3 => FortalTokens.radius5(),
};
