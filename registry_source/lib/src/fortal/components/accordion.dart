import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'accordion.g.dart';

/// The sizes an accordion comes in. Pixel values are at 100% theme scaling.
enum FortalAccordionSize {
  /// 14px title, 16px icons and 8px padding.
  size1,

  /// 14px title, 20px icons and 12px padding. The default.
  size2,

  /// 16px title, 24px icons and 16px padding.
  size3,
}

/// The looks an accordion comes in.
enum FortalAccordionVariant {
  /// The `gray2` panel inside a 1px gray frame.
  surface,

  /// An accent-tinted panel inside a 1px accent frame.
  soft,
}

/// The Fortal Accordion recipe.
///
/// It reads top to bottom: what every accordion shares, then the size, then
/// the variant's panel colors for rest, hover, press, focus and disabled.
@MixWidget(target: RemixAccordion.new)
AccordionStyler fortalAccordionStyle({
  FortalAccordionVariant variant = .surface,
  FortalAccordionSize size = .size2,
  AccordionStyler style = const AccordionStyler.create(),
}) => _base(size)
    .merge(_scale(size))
    .merge(switch (variant) {
      .surface => _surface(size),
      .soft => _soft(size),
    })
    // The container does not clip, so each part's effects can extend beyond the
    // panel; the parts clip themselves.
    .container(BoxStyler().clipBehavior(.none))
    .merge(style);

/// The trigger and content shapes every accordion shares: the corners, the
/// gray text and icons, and the open state's flat joint and turned chevron.
///
/// The container owns the fill and the frame. Each part clips its own content,
/// leaving trigger effects free to paint outside the panel's edges.
AccordionStyler _base(FortalAccordionSize size) {
  final radius = _radius(size);

  return AccordionStyler()
      .trigger(
        FlexBoxStyler()
            .direction(.horizontal)
            .minHeight(FortalTokens.touchTargetMin())
            .borderRadius(.all(radius))
            .clipBehavior(.antiAlias),
      )
      .leadingIcon(.color(FortalTokens.gray11()))
      .title(
        .fontWeight(
          FortalTokens.fontWeightMedium(),
        ).color(FortalTokens.gray12()),
      )
      .trailingIcon(.color(FortalTokens.gray11()))
      .content(
        BoxStyler()
            .width(.infinity)
            .clipBehavior(.antiAlias)
            .borderRadius(
              BorderRadiusMix(bottomLeft: radius, bottomRight: radius),
            ),
      )
      .onExpanded(
        AccordionStyler()
            .trigger(
              FlexBoxStyler().borderRadius(
                BorderRadiusMix(
                  topLeft: radius,
                  topRight: radius,
                  bottomLeft: Radius.zero,
                  bottomRight: Radius.zero,
                ),
              ),
            )
            .trailingIcon(
              IconStyler().wrap(
                WidgetModifierConfig.transform(
                  transform: Matrix4.rotationZ(math.pi),
                  alignment: .center,
                ),
              ),
            ),
      );
}

/// The icon size, padding and title size of each step.
AccordionStyler _scale(FortalAccordionSize size) => switch (size) {
  .size1 => AccordionStyler(
    trigger: FlexBoxStyler().padding(.all(FortalTokens.space2())),
    leadingIcon: .size(FortalTokens.space4()),
    title: .style(FortalTokens.text2.mix()),
    trailingIcon: .size(FortalTokens.space4()),
    content: .padding(.all(FortalTokens.space2())),
  ),
  .size2 => AccordionStyler(
    trigger: FlexBoxStyler().padding(.all(FortalTokens.space3())),
    leadingIcon: .size(FortalTokens.spinnerSize3()),
    title: .style(FortalTokens.text2.mix()),
    trailingIcon: .size(FortalTokens.spinnerSize3()),
    content: .padding(.all(FortalTokens.space3())),
  ),
  .size3 => AccordionStyler(
    trigger: FlexBoxStyler().padding(.all(FortalTokens.space4())),
    leadingIcon: .size(FortalTokens.space5()),
    title: .style(FortalTokens.text3.mix()),
    trailingIcon: .size(FortalTokens.space5()),
    content: .padding(.all(FortalTokens.space4())),
  ),
};

AccordionStyler _surface(FortalAccordionSize size) => AccordionStyler()
    .container(
      fortalSurfaceFrame(
        fillColor: FortalTokens.gray2(),
        borderColor: FortalTokens.gray6(),
        borderWidth: FortalTokens.borderWidth1(),
        radius: _radius(size),
      ),
    )
    .trigger(.color(FortalTokens.gray1()))
    .content(
      BoxStyler()
          .foregroundDecoration(_dividerAbove(FortalTokens.gray6()))
          .wrap(_contentText(FortalTokens.gray12())),
    )
    .onHovered(.trigger(.color(FortalTokens.gray2())))
    .onPressed(.trigger(.color(FortalTokens.gray3())))
    .onFocusVisible(.triggerEffects(fortalFocusOutline()))
    .onDisabled(_disabled());

AccordionStyler _soft(FortalAccordionSize size) => AccordionStyler()
    .container(
      fortalSurfaceFrame(
        fillColor: FortalTokens.accent2(),
        borderColor: FortalTokens.accent6(),
        borderWidth: FortalTokens.borderWidth1(),
        radius: _radius(size),
      ),
    )
    .trigger(.color(FortalTokens.accent2()))
    .title(.color(FortalTokens.accent12()))
    .trailingIcon(.color(FortalTokens.accentContent()))
    .content(
      BoxStyler()
          .foregroundDecoration(_dividerAbove(FortalTokens.accent6()))
          .wrap(_contentText(FortalTokens.accent12())),
    )
    .onHovered(.trigger(.color(FortalTokens.accent3())))
    .onPressed(.trigger(.color(FortalTokens.accent4())))
    .onFocusVisible(.triggerEffects(fortalFocusOutline()))
    .onDisabled(_disabled());

AccordionStyler _disabled() => AccordionStyler()
    .triggerEffects(RemixBoxEffectsMix(outline: BorderSideMix(style: .none)))
    .trigger(.color(FortalTokens.grayA3()))
    .leadingIcon(.color(FortalTokens.gray8()))
    .title(.color(FortalTokens.gray8()))
    .trailingIcon(.color(FortalTokens.gray8()));

/// The 1px line between the trigger and the content.
///
/// It uses the same edge as the panel's frame, so the seam reads as a
/// continuation of the frame rather than an unrelated line.
BoxDecorationMix _dividerAbove(Color color) => BoxDecorationMix(
  border: BoxBorderMix.top(
    BorderSideMix(color: color, width: FortalTokens.borderWidth1()),
  ),
);

/// Pins bare [Text] accordion content to the 14px type-scale step (`text2`)
/// regardless of accordion size, so content never renders larger than its own
/// trigger's title. This design system's text children pin their own run.
/// [color] supplies the variant's own content tint.
WidgetModifierConfig _contentText(Color color) =>
    WidgetModifierConfig.defaultTextStyle(
      style: FortalTokens.text2.mix(),
    ).defaultTextStyle(style: TextStyleMix().color(color));

Radius _radius(FortalAccordionSize size) => switch (size) {
  .size1 => FortalTokens.radius3(),
  .size2 => FortalTokens.radius4(),
  .size3 => FortalTokens.radius5(),
};
