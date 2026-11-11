import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';
import '../theme/theme_scope.dart';

part 'slider.g.dart';

/// The application's Slider recipe.
///
/// Remix owns the rendering, the drag and keyboard behavior, the mapping from
/// a 0-1 value onto the filled range, and the slider accessibility semantics;
/// this recipe supplies the rail, the filled range, and the thumb.
///
/// The pill-shaped rail is `mutedForeground` in light and `ring` in dark;
/// the range is `primary`.
/// Both slider recipes reserve a 48px interaction height. The thumb is a white disc
/// with a `primary` outline and a small shadow, which keeps it a distinct
/// handle on either page. In dark mode a dark outline separates overlapping
/// white handles.
///
/// Set [surfaceColor] to the actual enclosing surface on cards or tinted panels
/// (for example, `PlaygroundTokens.card.resolve(context)`). It defaults to the page
/// background. Hover and press halos blend against that surface so the range
/// does not show through them.
///
/// `semanticFormatterCallback` is deliberately not forwarded to the generated
/// `PlaygroundSlider`. Its type is
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
SliderStyler playgroundSliderStyle({
  Color? surfaceColor,
  SliderStyler style = const SliderStyler.create(),
}) {
  return SliderStyler()
      .wrap(.sizedBox(height: PlaygroundTokens.s12))
      .animate(PlaygroundTokens.motion)
      .thickness(_rail)
      .trackColor(_railColor())
      .rangeColor(PlaygroundTokens.primary())
      .track(.borderRadius(.all(_circular)))
      .range(.borderRadius(.all(_circular)))
      .thumbSize(const Size.square(PlaygroundTokens.icon))
      // The dark outline also separates white handles when they overlap.
      .thumbColor(_thumbFill)
      .thumb(
        BoxStyler()
            .borderRadius(.all(_circular))
            .border(
              .color(
                _thumbBorderColor(),
              ).width(PlaygroundTokens.strokeHairline),
            )
            .shadows(PlaygroundShadow.sm.box),
      )
      .onHovered(
        SliderStyler().thumbEffects(
          _thumbRing(_ringColor(0.4, surfaceColor), PlaygroundTokens.s0_5),
        ),
      )
      .onPressed(
        SliderStyler().thumbEffects(
          _thumbRing(_ringColor(0.65, surfaceColor), PlaygroundTokens.s1_5),
        ),
      )
      .onFocusVisible(_focusVisibleStyle())
      .onDisabled(_disabledStyle())
      .merge(style);
}

/// A radius large enough to round the thumb into a circle.
const _circular = Radius.circular(PlaygroundTokens.pill);

/// The thumb's fill: white, in both themes.
const _thumbFill = Color(0xFFFFFFFF);

/// The rail's thickness: 6px.
///
/// One size, not a scale. A call site that needs another sets `.thickness(...)`
/// through [style].
const _rail = PlaygroundTokens.s1_5;

final _railColor = ContextToken<Color>(
  (context) =>
      (PlaygroundTheme.of(context).brightness == Brightness.dark
              ? PlaygroundTokens.ring
              : PlaygroundTokens.mutedForeground)
          .resolve(context),
);

final _thumbBorderColor = ContextToken<Color>(
  (context) =>
      (PlaygroundTheme.of(context).brightness == Brightness.dark
              ? PlaygroundTokens.primaryForeground
              : PlaygroundTokens.primary)
          .resolve(context),
);

// An opaque halo stays even over the filled interval. Use the caller's actual
// surface on cards instead of baking the page colour into every instance.
ContextToken<Color> _ringColor(double alpha, Color? surfaceColor) =>
    _ringColors.putIfAbsent(
      (alpha, surfaceColor),
      () => ContextToken<Color>(
        (context) => Color.alphaBlend(
          PlaygroundTokens.mutedForeground
              .resolve(context)
              .withValues(alpha: alpha),
          surfaceColor ?? PlaygroundTokens.background.resolve(context),
        ),
      ),
    );

// ContextToken equality is resolver identity, as in playgroundTint. Cache per
// argument set so rebuilding the same recipe preserves style equality.
final _ringColors = <(double, Color?), ContextToken<Color>>{};

RemixBoxEffectsMix _thumbRing(MixToken<Color> color, double width) =>
    RemixBoxEffectsMix(
      outline: BorderSideMix(color: color(), width: width),
    );

/// The keyboard focus ring, drawn around the thumb.
///
/// `thumbFocusEffects` rather than `thumbEffects`: Remix paints the former
/// only while the slider has visible focus, which is the state a ring is for.
SliderStyler _focusVisibleStyle() => SliderStyler().thumbFocusEffects(
  _thumbRing(PlaygroundTokens.primary, PlaygroundTokens.strokeRing),
);

/// Declared last so it wins over every other state fragment.
///
/// A disabled slider keeps its rail and range and simply fades; there is no
/// ring to clear because the focus effects are already conditional on focus.
SliderStyler _disabledStyle() => SliderStyler()
    .thumbEffects(RemixBoxEffectsMix.outline(.style(.none)))
    .wrap(.opacity(PlaygroundTokens.disabledOpacity));
