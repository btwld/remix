import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'tokens.dart';

/// A token-width CSS outline that does not affect layout.
///
/// Every ring is [UiTokens.focusRingWidth] wide. The classic and solid
/// buttons and icon buttons, checkboxes, radios, switches, and links draw it
/// outside at Radix's 2px gap and pass [UiTokens.focusRingOffset]. The
/// other offsets are literals that do not follow that token: `-1` for fields,
/// cards, selects, segmented control items, and the soft, surface, outline, and
/// ghost buttons and icon buttons, `-2` for [uiTabFocusOutline], and the
/// slider thumb's 3px halo.
RemixBoxEffectsMix uiFocusOutline(Color color, {required double offset}) =>
    RemixBoxEffectsMix(
      outline: BorderSideMix(
        color: color,
        width: UiTokens.focusRingWidth(),
        strokeAlign: BorderSide.strokeAlignInside,
      ),
      outlineOffset: offset,
    );

/// The ring of a Radix tab: `outline: 2px solid var(--focus-8)` at
/// `outline-offset: -2px` (`base-tab-list.css:126-129`).
///
/// Toggles, toggle-group items, accordion and disclosure triggers, and sidebar
/// destinations have no Radix counterpart and share it. At the default width it
/// lies inside the box, so the clip of a toggle group or an accordion or
/// disclosure panel does not crop it.
RemixBoxEffectsMix uiTabFocusOutline() =>
    uiFocusOutline(UiTokens.focus8(), offset: -2);

/// The `focus-8` ring as a foreground decoration, for a box that takes no box
/// effects: a data-table header row and the content of a menu trigger. It is
/// null at a ring width of zero, because a zero-width [BorderSide] is a
/// hairline.
BoxDecorationMix? uiFocusRingDecoration(BuildContext context) {
  final width = UiTokens.focusRingWidth.resolve(context);
  if (width <= 0) return null;
  return BoxDecorationMix(
    border: BoxBorderMix.all(
      BorderSideMix(
        color: UiTokens.focus8(),
        width: width,
        strokeAlign: BorderSide.strokeAlignInside,
      ),
    ),
  );
}

/// A one-pixel inset stroke, optionally layered over a fill.
RemixBoxEffectLayerMix uiInsetSurface({required List<Color> strokes}) =>
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
