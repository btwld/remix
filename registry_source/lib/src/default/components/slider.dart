import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'slider.g.dart';

/// The application's Slider recipe.
///
/// Remix owns the rendering, the drag and keyboard behavior, the mapping from
/// a 0-1 value onto the filled range, and the slider accessibility semantics;
/// this recipe supplies the rail, the filled range, and the thumb.
///
/// The pill-shaped rail is `mutedForeground` and the range is `primary`.
/// Both slider recipes reserve a 48px interaction height. The thumb is a white disc
/// with a `primary` outline and a small shadow, which keeps it a distinct
/// handle on either page.
///
/// `semanticFormatterCallback` is deliberately not forwarded to the generated
/// `VanillaSlider`. Its type is
/// `NakedSliderSemanticFormatterCallback`, which comes from
/// `package:naked_ui` — a package this layer does not depend on. Reach for
/// `RemixSlider` directly on the rare call site that needs to reword the
/// announced value.
@MixWidget(
  target: RemixSlider.new,
  widgetParameters: .only({
    'value',
    'onChanged',
    'onChangeStart',
    'onChangeEnd',
    'min',
    'max',
    'enabled',
    'enableFeedback',
    'focusNode',
    'autofocus',
    'snapDivisions',
    'semanticLabel',
    'excludeSemantics',
  }),
)
SliderStyler vanillaSliderStyle({
  SliderStyler style = const SliderStyler.create(),
}) {
  return SliderStyler()
      .wrap(.sizedBox(height: VanillaTokens.s12))
      .animate(VanillaTokens.motion)
      .thickness(_rail)
      .trackColor(VanillaTokens.mutedForeground())
      .rangeColor(VanillaTokens.primary())
      .track(.borderRadius(.all(_circular)))
      .range(.borderRadius(.all(_circular)))
      .thumbSize(const Size.square(VanillaTokens.icon))
      // White in both themes: the thumb is a physical-looking handle, and its
      // `primary` outline and small shadow are what separate it from the range
      // it sits on.
      .thumbColor(_thumbFill)
      .thumb(
        BoxStyler()
            .borderRadius(.all(_circular))
            .border(
              .color(
                VanillaTokens.primary(),
              ).width(VanillaTokens.strokeHairline),
            )
            .shadows(VanillaShadow.sm.box),
      )
      .onHovered(
        SliderStyler().thumbEffects(
          _thumbRing(_hoverRingColor, VanillaTokens.s0_5),
        ),
      )
      .onPressed(
        SliderStyler().thumbEffects(
          _thumbRing(_pressedRingColor, VanillaTokens.s1_5),
        ),
      )
      .onFocusVisible(_focusVisibleStyle())
      .onDisabled(_disabledStyle())
      .merge(style);
}

/// A radius large enough to round the thumb into a circle.
const _circular = Radius.circular(VanillaTokens.pill);

/// The thumb's fill: white, in both themes.
const _thumbFill = Color(0xFFFFFFFF);

/// The rail's thickness: 6px.
///
/// One size, not a scale. A call site that needs another sets `.thickness(...)`
/// through [style].
const _rail = VanillaTokens.s1_5;

// Pre-blend against the page, rather than painting translucent over the rail
// and interval: a halo must read as one even colour around the whole handle.
final _hoverRingColor = _opaqueRingColor(0.25);
final _pressedRingColor = _opaqueRingColor(0.5);

ContextToken<Color> _opaqueRingColor(double alpha) => ContextToken<Color>(
  (context) => Color.alphaBlend(
    VanillaTokens.mutedForeground.resolve(context).withValues(alpha: alpha),
    VanillaTokens.background.resolve(context),
  ),
);

RemixBoxEffectsMix _thumbRing(MixToken<Color> color, double width) =>
    RemixBoxEffectsMix(
      outline: BorderSideMix(color: color(), width: width),
    );

/// The keyboard focus ring, drawn around the thumb.
///
/// `thumbFocusEffects` rather than `thumbEffects`: Remix paints the former
/// only while the slider has visible focus, which is the state a ring is for.
SliderStyler _focusVisibleStyle() => SliderStyler().thumbFocusEffects(
  _thumbRing(
    VanillaTokens.mutedForeground,
    VanillaTokens.strokeRing,
  ).outlineOffset(VanillaTokens.s0_5),
);

/// Declared last so it wins over every other state fragment.
///
/// A disabled slider keeps its rail and range and simply fades; there is no
/// ring to clear because the focus effects are already conditional on focus.
SliderStyler _disabledStyle() => SliderStyler()
    .thumbEffects(RemixBoxEffectsMix.outline(.style(.none)))
    .wrap(.opacity(VanillaTokens.disabledOpacity));
