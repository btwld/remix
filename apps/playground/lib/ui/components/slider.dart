import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';
import '../theme/theme_scope.dart';

part 'slider.g.dart';

/// The application's Slider recipe.
///
/// A pill-shaped rail (`mutedForeground`, `ring` in the dark theme) with a
/// `primary` range and a white thumb in both themes, outlined in `primary`
/// (`primaryForeground` in the dark theme) so overlapping handles stay
/// distinct. Both slider recipes reserve a 48px interaction height.
///
/// Set [surfaceColor] to the enclosing surface on cards or tinted panels (for
/// example `PlaygroundTokens.card.resolve(context)`); the hover and press halos
/// are opaque and blend against it, defaulting to the page background.
///
/// The generated widget omits `semanticFormatterCallback`: its type comes from
/// `package:naked_ui`, which this layer does not import. Use `RemixSlider` to
/// reword the announced value.
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
      .thickness(PlaygroundTokens.s1_5)
      .trackColor(_railColor())
      .rangeColor(PlaygroundTokens.primary())
      .track(.borderRadius(.all(_circular)))
      .range(.borderRadius(.all(_circular)))
      .thumbSize(const Size.square(PlaygroundTokens.icon))
      .thumbColor(const Color(0xFFFFFFFF))
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
      // `thumbFocusEffects`: Remix paints it only on visible focus.
      .onFocusVisible(
        SliderStyler().thumbFocusEffects(
          _thumbRing(PlaygroundTokens.primary, PlaygroundTokens.strokeRing),
        ),
      )
      // Declared last so it wins. There is no ring to clear: the focus effects
      // are already conditional on focus.
      .onDisabled(
        SliderStyler()
            .thumbEffects(RemixBoxEffectsMix.outline(.style(.none)))
            .wrap(.opacity(PlaygroundTokens.disabledOpacity)),
      )
      .merge(style);
}

const _circular = Radius.circular(PlaygroundTokens.pill);

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

// Opaque, so the halo stays visible over the filled interval. It blends
// against the caller's surface rather than a baked-in page color.
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

// ContextToken equality is resolver identity, as in playgroundTint: cache per
// argument set so rebuilding the recipe keeps style equality.
final _ringColors = <(double, Color?), ContextToken<Color>>{};

RemixBoxEffectsMix _thumbRing(MixToken<Color> color, double width) =>
    RemixBoxEffectsMix(
      outline: BorderSideMix(color: color(), width: width),
    );
