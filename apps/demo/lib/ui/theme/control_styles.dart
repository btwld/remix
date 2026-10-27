import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'tokens.dart';

/// A token-width CSS outline that does not affect layout.
///
/// Outward rings at Radix's 2px gap pass [FortalTokens.focusRingOffset]. Every
/// other offset is a Radix literal and does not follow that token: the inset
/// `-1` of fields, cards, selects and soft buttons, the inset `-2` of tabs, and
/// the slider thumb's 3px halo.
RemixBoxEffectsMix fortalFocusOutline(Color color, {required double offset}) =>
    RemixBoxEffectsMix(
      outline: BorderSideMix(
        color: color,
        width: FortalTokens.focusRingWidth(),
        strokeAlign: BorderSide.strokeAlignInside,
      ),
      outlineOffset: offset,
    );

/// The ring drawn inside the box of a toggle, toggle-group item, disclosure or
/// accordion trigger.
///
/// Radix Themes ships none of these, so they share the inset `-2` ring of its
/// tabs, in `focus-a8`. It stays inside the box because toggle groups and
/// accordion and disclosure panels clip an outside ring.
RemixBoxEffectsMix fortalInsetFocusOutline() =>
    fortalFocusOutline(FortalTokens.focusA8(), offset: -2);

/// A one-pixel inset stroke, optionally layered over a fill.
RemixBoxEffectLayerMix fortalInsetSurface({required List<Color> strokes}) =>
    RemixBoxEffectLayerMix(
      shadows: [
        for (final stroke in strokes)
          RemixBoxShadowMix(
            kind: RemixBoxShadowKind.inset,
            color: stroke,
            spreadRadius: 1,
          ),
      ],
    );
