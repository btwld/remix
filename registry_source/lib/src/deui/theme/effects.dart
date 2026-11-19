import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'tokens.dart';

/// `focus-ring`: a ring with a background-colored separation.
RemixBoxEffectsMix deuiFocusRing({
  Color? color,
  double offset = DeuiTokens.ringOffset,
  double width = DeuiTokens.focusWidth,
}) => RemixBoxEffectsMix(
  outline: BorderSideMix(color: color ?? DeuiTokens.focus(), width: width),
  outlineOffset: offset,
  // CSS ring-offset paints background, not transparent space. Outer shadows
  // are clipped to the outside of the shape by Remix's effect renderer.
  overContent: offset > 0
      ? RemixBoxEffectLayerMix(
          shadows: [
            RemixBoxShadowMix(
              color: DeuiTokens.background(),
              spreadRadius: offset,
            ),
          ],
        )
      : null,
);

/// `focus-ring` with `ring-inset`: the ring drawn inside the part, for parts
/// whose parent clips an outside ring, such as the items of a joined toggle
/// group.
final deuiInsetFocusRing = deuiFocusRing(offset: -DeuiTokens.focusWidth);

/// `invalid-field-ring`: a 1px danger outline with no offset.
///
/// [focused] is the 2px ring of a field that takes focus itself (a select
/// trigger, a text input). Controls focused through a parent, like a checkbox,
/// keep the ordinary focus ring.
RemixBoxEffectsMix deuiInvalidRing({bool focused = false}) =>
    RemixBoxEffectsMix(
      outline: BorderSideMix(
        color: DeuiTokens.danger(),
        width: focused ? DeuiTokens.focusWidth : DeuiTokens.invalidWidth,
      ),
      outlineOffset: 0,
      overContent: RemixBoxEffectLayerMix(shadows: const []),
    );

/// `--surface-shadow` and `--overlay-shadow` per mode, alphas as in the CSS.
/// Preserves layered CSS shadows and the dark overlay's inset hairline.
RemixBoxEffectsMix deuiSurfaceEffects({bool overlay = false}) =>
    RemixBoxEffectsMix.behindContent(
      RemixBoxEffectLayerMix(
        shadowToken: overlay ? deuiOverlayShadow : deuiSurfaceShadow,
      ),
    );

const deuiSurfaceShadow = RemixBoxShadowListToken('deui.shadow.surface');

/// `--overlay-shadow` for stylers without an effects slot (tooltip).
///
/// Dark mode adds a 1px inset hairline that a box shadow cannot draw, so the
/// light layers serve both modes.
final deuiOverlayBoxShadows = _boxShadows(
  deuiShadows(Brightness.light, overlay: true),
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

const deuiOverlayShadow = RemixBoxShadowListToken('deui.shadow.overlay');

/// Deui draws its surfaces and overlays with a hairline border and no shadow,
/// so both shadow lists are empty. The tokens stay so an app can add layers.
List<RemixBoxShadow> deuiShadows(
  Brightness brightness, {
  bool overlay = false,
}) => const [];

/// [source] at [alpha] of its own opacity: Tailwind `bg-x/N` and
/// `color-mix(in srgb, x N%, transparent)`.
///
/// Keep the result in a top-level final; a [ContextToken] compares by
/// identity.
ContextToken<Color> deuiAlpha(ColorToken source, double alpha) =>
    ContextToken<Color>((context) {
      final color = source.resolve(context);
      return color.withValues(alpha: color.a * alpha);
    });

/// `min(max, calc(var(--radius-N) * scale))`: Deui caps its large surfaces
/// at 32px. `DeuiTokens.radiusPanel` is the `radius-3xl` case.
///
/// Keep the result in a top-level final.
ContextToken<Radius> deuiRadius(
  RadiusToken base, {
  double scale = 1,
  double max = double.infinity,
}) => ContextToken<Radius>(
  (context) => Radius.circular(math.min(max, base.resolve(context).x * scale)),
);

/// The row fill of a hovered menu, select or list item: `foreground` at 6%,
/// visible on `overlay` in both modes.
final deuiRowHover = deuiAlpha(DeuiTokens.foreground, .06);

/// The 1px hairline Deui draws around a raised surface instead of a shadow.
BoxBorderMix deuiHairline() => .color(DeuiTokens.border()).width(1);
