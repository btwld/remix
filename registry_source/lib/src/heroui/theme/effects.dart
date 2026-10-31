import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'tokens.dart';

/// `focus-ring`: a ring with a background-colored separation.
RemixBoxEffectsMix heroUiFocusRing({
  Color? color,
  double offset = HeroUiTokens.ringOffset,
  double width = HeroUiTokens.focusWidth,
}) => RemixBoxEffectsMix(
  outline: BorderSideMix(color: color ?? HeroUiTokens.focus(), width: width),
  outlineOffset: offset,
  // CSS ring-offset paints background, not transparent space. Outer shadows
  // are clipped to the outside of the shape by Remix's effect renderer.
  overContent: offset > 0
      ? RemixBoxEffectLayerMix(
          shadows: [
            RemixBoxShadowMix(
              color: HeroUiTokens.background(),
              spreadRadius: offset,
            ),
          ],
        )
      : null,
);

/// `focus-ring` with `ring-inset`: the ring drawn inside the part, for parts
/// whose parent clips an outside ring, such as the items of a joined toggle
/// group.
final heroUiInsetFocusRing = heroUiFocusRing(offset: -HeroUiTokens.focusWidth);

/// `invalid-field-ring`: a 1px danger outline with no offset.
///
/// [focused] is the 2px ring of a field that takes focus itself (a select
/// trigger, a text input). Controls focused through a parent, like a checkbox,
/// keep the ordinary focus ring.
RemixBoxEffectsMix heroUiInvalidRing({bool focused = false}) =>
    RemixBoxEffectsMix(
      outline: BorderSideMix(
        color: HeroUiTokens.danger(),
        width: focused ? HeroUiTokens.focusWidth : HeroUiTokens.invalidWidth,
      ),
      outlineOffset: 0,
      overContent: RemixBoxEffectLayerMix(shadows: const []),
    );

/// `--surface-shadow` and `--overlay-shadow` per mode, alphas as in the CSS.
/// Preserves layered CSS shadows and the dark overlay's inset hairline.
RemixBoxEffectsMix heroUiSurfaceEffects({bool overlay = false}) =>
    RemixBoxEffectsMix.behindContent(
      RemixBoxEffectLayerMix(
        shadowToken: overlay ? heroUiOverlayShadow : heroUiSurfaceShadow,
      ),
    );

const heroUiSurfaceShadow = RemixBoxShadowListToken('heroUi.shadow.surface');

/// `--overlay-shadow` for stylers without an effects slot (tooltip).
///
/// Dark mode adds a 1px inset hairline that a box shadow cannot draw, so the
/// light layers serve both modes.
final heroUiOverlayBoxShadows = _boxShadows(
  heroUiShadows(Brightness.light, overlay: true),
);

List<BoxShadowMix> _boxShadows(List<RemixBoxShadow> shadows) => [
  for (final shadow in shadows)
    BoxShadowMix(
      color: shadow.color,
      offset: shadow.offset,
      blurRadius: shadow.blurRadius,
      spreadRadius: shadow.spreadRadius,
    ),
];

const heroUiOverlayShadow = RemixBoxShadowListToken('heroUi.shadow.overlay');

/// The layers of `--surface-shadow`, or of `--overlay-shadow` when [overlay]
/// is set, in [brightness].
List<RemixBoxShadow> heroUiShadows(
  Brightness brightness, {
  bool overlay = false,
}) {
  if (brightness == Brightness.dark) {
    return overlay
        ? const [
            RemixBoxShadow(
              kind: RemixBoxShadowKind.inset,
              color: Color.fromRGBO(255, 255, 255, .3),
              blurRadius: 1,
            ),
          ]
        : const [];
  }
  return overlay
      ? const [
          RemixBoxShadow(
            color: Color.fromRGBO(0, 0, 0, .06),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
          RemixBoxShadow(
            color: Color.fromRGBO(0, 0, 0, .03),
            offset: Offset(0, -6),
            blurRadius: 12,
          ),
          RemixBoxShadow(
            color: Color.fromRGBO(0, 0, 0, .08),
            offset: Offset(0, 14),
            blurRadius: 28,
          ),
        ]
      : const [
          RemixBoxShadow(
            color: Color.fromRGBO(0, 0, 0, .04),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
          RemixBoxShadow(
            color: Color.fromRGBO(0, 0, 0, .06),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
          RemixBoxShadow(color: Color.fromRGBO(0, 0, 0, .06), blurRadius: 1),
        ];
}

/// [source] at [alpha] of its own opacity: Tailwind `bg-x/N` and
/// `color-mix(in srgb, x N%, transparent)`.
///
/// Keep the result in a top-level final; a [ContextToken] compares by
/// identity.
ContextToken<Color> heroUiAlpha(ColorToken source, double alpha) =>
    ContextToken<Color>((context) {
      final color = source.resolve(context);
      return color.withValues(alpha: color.a * alpha);
    });

/// `min(max, calc(var(--radius-N) * scale))`: HeroUI caps its large surfaces
/// at 32px. `HeroUiTokens.radiusPanel` is the `radius-3xl` case.
///
/// Keep the result in a top-level final.
ContextToken<Radius> heroUiRadius(
  RadiusToken base, {
  double scale = 1,
  double max = double.infinity,
}) => ContextToken<Radius>(
  (context) => Radius.circular(math.min(max, base.resolve(context).x * scale)),
);
