import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'scale.dart';
import 'theme_scope.dart';
import 'tokens.dart';

/// [token] at [alpha] of its own opacity, resolved from the active scope.
///
/// This is shadcn's `bg-primary/90`: `vanillaTint(VanillaTokens.primary, 0.9)`.
/// The alpha multiplies rather than replaces, because some tokens are already
/// translucent — the dark theme's `border` is white at 10%, and half of it is
/// white at 5%, not at 50%.
///
/// [dark], when given, is the alpha used while a dark theme is active. It
/// exists for the handful of fills shadcn lightens differently in the dark
/// theme, such as `dark:bg-destructive/60`.
///
/// The obvious spelling would be `VanillaTokens.primary().withValues(...)`,
/// but that records a Mix *directive*, and directives accumulate through
/// every later merge: a caller who replaced the fill would still get this
/// alpha applied on top of their own color. A `ContextToken` does the
/// arithmetic during resolution instead, so a state fragment holds one plain
/// color that a caller can replace outright.
///
/// Tokens are cached per argument set, because `ContextToken` equality is
/// resolver identity: building a fresh one per call would make two identical
/// recipes compare unequal.
ContextToken<Color> vanillaTint(
  ColorToken token,
  double alpha, {
  double? dark,
}) => _tints.putIfAbsent(
  (token, alpha, dark),
  () => ContextToken<Color>((context) {
    final color = token.resolve(context);
    final isDark = VanillaTheme.maybeOf(context)?.brightness == Brightness.dark;

    return color.withValues(alpha: color.a * (isDark ? dark ?? alpha : alpha));
  }),
);

final _tints = <(ColorToken, double, double?), ContextToken<Color>>{};

/// [light] while a light theme is active and [dark] while a dark one is.
///
/// For the few places shadcn switches between two tokens rather than between
/// two strengths of one, such as a switch thumb that is `background` in the
/// light theme and `foreground` in the dark. Either side may be a
/// [vanillaTint]. Cached per pair, for the same reason [vanillaTint] is.
ContextToken<Color> vanillaByBrightness({
  required MixToken<Color> light,
  required MixToken<Color> dark,
}) => _byBrightness.putIfAbsent(
  (light, dark),
  () => ContextToken<Color>(
    (context) =>
        (VanillaTheme.maybeOf(context)?.brightness == Brightness.dark
                ? dark
                : light)
            .resolve(context),
  ),
);

final _byBrightness =
    <(MixToken<Color>, MixToken<Color>), ContextToken<Color>>{};

/// shadcn's keyboard focus ring, `focus-visible:ring-[3px] ring-ring/50`.
///
/// A 3px band of [color] at [alpha] (or [dark] in a dark theme), drawn
/// outside the control with no offset, for a spec's Remix effects slot:
/// `containerEffects`, a switch's `trackEffects`, or a slider's
/// `thumbFocusEffects`. An outline takes no layout space, so focusing a
/// control never reflows the row it sits in.
///
/// A destructive control rings in its own color, as shadcn's does:
/// `vanillaFocusRing(color: VanillaTokens.destructive, alpha: 0.2, dark: 0.4)`.
RemixBoxEffectsMix vanillaFocusRing({
  ColorToken color = VanillaTokens.ring,
  double alpha = _ringAlpha,
  double? dark,
  double width = VanillaStroke.ring,
}) => RemixBoxEffectsMix(
  outline: BorderSideMix(
    color: vanillaTint(color, alpha, dark: dark)(),
    width: width,
  ),
  outlineOffset: 0,
);

/// [vanillaFocusRing] as a foreground decoration, for the specs that have no
/// effects slot: a toggle, a toggle group's items, a tab, a menu trigger.
///
/// The border is stroked outside the box, so the ring sits where the effects
/// outline would and still takes no layout space. [radius] is the control's
/// own corner radius, which the ring follows.
///
/// A control clipped by its container (a toggle group's option) would have
/// that outside stroke cut off at the container's edge; pass [inset] to
/// stroke the ring inside the control instead.
BoxDecorationMix vanillaFocusRingDecoration({
  Radius? radius,
  bool inset = false,
}) => BoxDecorationMix(
  border: .all(
    BorderSideMix(
      color: vanillaTint(VanillaTokens.ring, _ringAlpha)(),
      width: VanillaStroke.ring,
      strokeAlign: inset
          ? BorderSide.strokeAlignInside
          : BorderSide.strokeAlignOutside,
    ),
  ),
  borderRadius: .all(radius ?? VanillaTokens.radiusMd()),
);

/// A focused control's own border, turned `ring`: shadcn's
/// `focus-visible:border-ring`.
///
/// Only the color changes, so merge it over a control that already draws a
/// border; one with no border would gain a hairline and shift its content.
BoxBorderMix vanillaFocusBorder() => .all(.color(VanillaTokens.ring()));

/// The strength of the focus ring, `ring-ring/50`.
const _ringAlpha = 0.5;

/// shadcn's shadow scale, `shadow-xs` through `shadow-lg`.
///
/// Each level is one table of layers, handed out in the shapes recipes need:
/// [box] for a styler's `shadows`, and [effects] for a Remix
/// `containerEffects` layer.
///
/// They differ in one way that matters. Flutter paints a decoration shadow
/// under the whole box, so behind a transparent or translucent fill it shows
/// through as a gray wash; the effects layer cuts the box out of its shadows,
/// as CSS does. Use [effects] for a control whose fill is not opaque, and
/// [box] only under an opaque fill or where the spec has no effects slot.
enum VanillaShadow {
  /// A barely-there lift for controls that sit on the page: an outline
  /// button, a text field.
  xs([(y: 1, blur: 2, spread: 0, alpha: 0.05)]),

  /// A card or a raised segment.
  sm([
    (y: 1, blur: 3, spread: 0, alpha: 0.1),
    (y: 1, blur: 2, spread: -1, alpha: 0.1),
  ]),

  /// A floating panel: a menu, a select's options, a popover.
  md([
    (y: 4, blur: 6, spread: -1, alpha: 0.1),
    (y: 2, blur: 4, spread: -2, alpha: 0.1),
  ]),

  /// A surface that interrupts: a dialog, a toast.
  lg([
    (y: 10, blur: 15, spread: -3, alpha: 0.1),
    (y: 4, blur: 6, spread: -4, alpha: 0.1),
  ]);

  const VanillaShadow(this._layers);

  final List<({double y, double blur, double spread, double alpha})> _layers;

  /// This level as plain shadows, for a decoration built by hand.
  List<BoxShadow> get shadows => [
    for (final layer in _layers)
      BoxShadow(
        color: const Color(0xFF000000).withValues(alpha: layer.alpha),
        offset: Offset(0, layer.y),
        blurRadius: layer.blur,
        spreadRadius: layer.spread,
      ),
  ];

  /// This level as decoration shadows, for a styler's `shadows`.
  List<BoxShadowMix> get box => [for (final shadow in shadows) .value(shadow)];

  /// This level as a Remix effects layer, for a `containerEffects` slot.
  RemixBoxEffectLayerMix get effects => .shadows([
    for (final shadow in shadows)
      RemixBoxShadowMix(
        color: shadow.color,
        offset: shadow.offset,
        blurRadius: shadow.blurRadius,
        spreadRadius: shadow.spreadRadius,
      ),
  ]);
}
