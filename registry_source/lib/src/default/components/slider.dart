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
/// `primary` range and a white thumb with a `primary` outline, a dark one in
/// the dark theme so overlapping handles stay distinct. Both slider recipes
/// reserve a 48px interaction height.
///
/// Set [surfaceColor] to the enclosing surface on cards or tinted panels (for
/// example `VanillaTokens.card.resolve(context)`); the hover and press halos
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
SliderStyler vanillaSliderStyle({
  Color? surfaceColor,
  SliderStyler style = const SliderStyler.create(),
}) {
  return SliderStyler()
      .wrap(.sizedBox(height: VanillaTokens.s12))
      .animate(VanillaTokens.motion)
      .thickness(VanillaTokens.s1_5)
      .trackColor(_railColor())
      .rangeColor(VanillaTokens.primary())
      .track(.borderRadius(.all(_circular)))
      .range(.borderRadius(.all(_circular)))
      .thumbSize(const Size.square(VanillaTokens.icon))
      .thumbColor(const Color(0xFFFFFFFF))
      .thumb(
        BoxStyler()
            .borderRadius(.all(_circular))
            .border(
              .color(_thumbBorderColor()).width(VanillaTokens.strokeHairline),
            )
            .shadows(VanillaShadow.sm.box),
      )
      .onHovered(
        SliderStyler().thumbEffects(
          _thumbRing(_ringColor(0.4, surfaceColor), VanillaTokens.s0_5),
        ),
      )
      .onPressed(
        SliderStyler().thumbEffects(
          _thumbRing(_ringColor(0.65, surfaceColor), VanillaTokens.s1_5),
        ),
      )
      // `thumbFocusEffects`: Remix paints it only on visible focus.
      .onFocusVisible(
        SliderStyler().thumbFocusEffects(
          _thumbRing(VanillaTokens.primary, VanillaTokens.strokeRing),
        ),
      )
      // Declared last so it wins. There is no ring to clear: the focus effects
      // are already conditional on focus.
      .onDisabled(
        SliderStyler()
            .thumbEffects(RemixBoxEffectsMix.outline(.style(.none)))
            .wrap(.opacity(VanillaTokens.disabledOpacity)),
      )
      .merge(style);
}

const _circular = Radius.circular(VanillaTokens.pill);

final _railColor = ContextToken<Color>(
  (context) =>
      (VanillaTheme.of(context).brightness == Brightness.dark
              ? VanillaTokens.ring
              : VanillaTokens.mutedForeground)
          .resolve(context),
);

final _thumbBorderColor = ContextToken<Color>(
  (context) =>
      (VanillaTheme.of(context).brightness == Brightness.dark
              ? VanillaTokens.primaryForeground
              : VanillaTokens.primary)
          .resolve(context),
);

// Opaque, so the halo stays visible over the filled interval. It blends
// against the caller's surface rather than a baked-in page color.
ContextToken<Color> _ringColor(double alpha, Color? surfaceColor) =>
    _ringColors.putIfAbsent(
      (alpha, surfaceColor),
      () => ContextToken<Color>(
        (context) => Color.alphaBlend(
          VanillaTokens.mutedForeground
              .resolve(context)
              .withValues(alpha: alpha),
          surfaceColor ?? VanillaTokens.background.resolve(context),
        ),
      ),
    );

// ContextToken equality is resolver identity, as in vanillaTint: cache per
// argument set so rebuilding the recipe keeps style equality.
final _ringColors = <(double, Color?), ContextToken<Color>>{};

RemixBoxEffectsMix _thumbRing(MixToken<Color> color, double width) =>
    RemixBoxEffectsMix(
      outline: BorderSideMix(color: color(), width: width),
    );
