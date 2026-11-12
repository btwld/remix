import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'link.g.dart';

/// The application's Link recipe.
///
/// `textSm` at medium weight in `primary`, underlined under the pointer and
/// ringed on keyboard focus. That suits a link that stands alone; a link inside
/// running prose should stay identifiable without the pointer, so underline it
/// at rest through [style]:
///
/// ```dart
/// VanillaLink(
///   label: 'terms of service',
///   style: LinkStyler().label(.decoration(TextDecoration.underline)),
///   onPressed: openTerms,
/// )
/// ```
///
/// There is no pressed fragment: a link replaces the page, and the destination
/// arriving is the feedback.
@MixWidget(target: RemixLink.new)
LinkStyler vanillaLinkStyle({LinkStyler style = const LinkStyler.create()}) =>
    LinkStyler()
        .animate(VanillaTokens.motion)
        .label(
          .style(
            VanillaTokens.textSm.mix(),
          ).fontWeight(FontWeight.w500).color(VanillaTokens.primary()),
        )
        .onHovered(.label(.decoration(TextDecoration.underline)))
        .onFocusVisible(.containerEffects(vanillaFocusRing()))
        // Declared last so it wins. Remix disables a link with no `onPressed`,
        // so this is also how a decorative link looks.
        .onDisabled(
          LinkStyler()
              .containerEffects(.outline(.style(.none)))
              .wrap(.opacity(VanillaTokens.disabledOpacity)),
        )
        .merge(style);
