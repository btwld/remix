import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'accordion.g.dart';

/// HeroUI accordion looks: on the page, or on a `surface` card.
enum UiAccordionVariant {
  /// Items sit directly on the page, each with a 1px `separator` rule
  /// under it.
  defaultAccordion,

  /// Items share one `surface` card; see [UiAccordionGroup].
  surface,
}

/// HeroUI recipe for [RemixAccordion], one item.
///
/// The indicator is [RemixAccordion.trailingIcon]; pass a chevron to get
/// HeroUI's, which this recipe turns over while the item is expanded. Wrap the
/// items of a `surface` accordion in [UiAccordionGroup], which paints the
/// card.
@MixWidget(target: RemixAccordion.new)
AccordionStyler uiAccordionStyle({
  UiAccordionVariant variant = .defaultAccordion,
  AccordionStyler style = const AccordionStyler.create(),
}) {
  final surface = variant == .surface;
  final (hoverFill, separator) = surface
      ? (UiTokens.defaultColor(), _surfaceSeparator())
      : (_hoverFill(), UiTokens.separator());

  return AccordionStyler()
      .container(
        // `.accordion__item::after`: a 1px rule under the item.
        BoxStyler().foregroundDecoration(
          BoxDecorationMix(
            border: BoxBorderMix.bottom(
              BorderSideMix(color: separator, width: _ruleWidth),
            ),
          ),
        ),
      )
      .trigger(
        FlexBoxStyler()
            .direction(.horizontal)
            .mainAxisAlignment(.spaceBetween)
            .crossAxisAlignment(.center)
            .padding(.all(_padding)),
      )
      .title(.style(UiTokens.textSm.mix()).fontWeight(.w500))
      .trailingIcon(.size(_indicator).color(UiTokens.muted()))
      // `.accordion__body-inner`: `px-4 pb-4 text-muted` in `text-sm`.
      .content(
        BoxStyler()
            .padding(.horizontal(_padding).bottom(_padding))
            .wrap(
              .defaultTextStyle(
                style: UiTokens.textSm.mix(),
              ).defaultTextStyle(style: TextStyleMix().color(UiTokens.muted())),
            ),
      )
      // The hover fill is for collapsed items only.
      .onCollapsed(
        AccordionStyler().onHovered(
          AccordionStyler().trigger(.color(hoverFill)),
        ),
      )
      .onExpanded(
        AccordionStyler().trailingIcon(
          IconStyler().wrap(
            .transform(
              transform: Matrix4.rotationZ(-math.pi),
              alignment: .center,
            ),
          ),
        ),
      )
      // The surface card clips, so its trigger rings inside.
      .onFocusVisible(
        AccordionStyler().triggerEffects(
          surface ? uiInsetFocusRing : uiFocusRing(),
        ),
      )
      .animate(_indicatorMotion)
      .onDisabled(
        AccordionStyler().trigger(
          FlexBoxStyler().wrap(.opacity(UiTokens.disabledOpacity)),
        ),
      )
      .merge(style);
}

/// `.accordion__trigger` `px-4 py-4`, and the body's `px-4 pb-4`.
const _padding = 16.0;

/// `.accordion__item::after`: `h-px`.
const _ruleWidth = 1.0;

/// `.accordion__indicator` `size-4`.
const _indicator = 16.0;

/// `.accordion__indicator` `transition duration-250`, Tailwind's default curve.
const _indicatorMotion = CurveAnimationConfig(
  duration: Duration(milliseconds: 250),
  curve: UiTokens.easeDefault,
);

/// `color-mix(in oklab, var(--foreground) 3%, transparent 90%)`.
final _hoverFill = uiAlpha(UiTokens.foreground, .03);

/// `bg-surface-foreground/6`.
final _surfaceSeparator = uiAlpha(UiTokens.surfaceForeground, .06);

/// HeroUI's accordion group: the card of a `surface` accordion, or the plain
/// stack of the default one.
///
/// A thin wrapper over [RemixAccordionGroup]; the controller and expansion
/// stay Remix's. `surface` paints `bg-surface` and `min(32px, radius-3xl)`,
/// clipped, so the items read as one card.
class UiAccordionGroup<T> extends StatelessWidget {
  const UiAccordionGroup({
    super.key,
    required this.controller,
    required this.child,
    this.initialExpandedValues = const [],
    this.variant = .defaultAccordion,
    this.style = const BoxStyler.create(),
  });

  final RemixAccordionController<T> controller;
  final Widget child;
  final List<T> initialExpandedValues;
  final UiAccordionVariant variant;

  /// Merged last into the card.
  final BoxStyler style;

  @override
  Widget build(BuildContext context) => Box(
    style: BoxStyler()
        .merge(
          variant == .surface
              ? BoxStyler()
                    .color(UiTokens.surface())
                    .borderRadius(.all(UiTokens.radiusPanel()))
                    .clipBehavior(.antiAlias)
              : null,
        )
        .merge(style),
    child: RemixAccordionGroup<T>(
      controller: controller,
      initialExpandedValues: initialExpandedValues,
      child: child,
    ),
  );
}
