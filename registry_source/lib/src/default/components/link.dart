import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/scale.dart';
import '../theme/tokens.dart';

part 'link.g.dart';

/// The application's Link recipe.
///
/// Remix owns the link role, the destination, focus, activation, and the rule
/// that a link with no callback is a disabled link; this recipe supplies its
/// type, its color, and its states.
///
/// It is shadcn's link button: `textSm` at medium weight in `primary`,
/// underlined while the pointer is on it, and ringed like every other control
/// when it has keyboard focus. That suits a link standing on its own — "Forgot
/// password?", "View all" — which is what shadcn's link variant is for. A
/// link set inside running prose should stay identifiable without the
/// pointer; give that call site an underline at rest through [style]:
///
/// ```dart
/// VanillaLink(
///   label: 'terms of service',
///   style: LinkStyler().label(.decoration(TextDecoration.underline)),
///   onPressed: openTerms,
/// )
/// ```
///
/// There is no pressed fragment. A link's press is over in the time it takes
/// to navigate, and the destination arriving is the feedback — the same reason
/// the checkbox has none, arrived at from the other direction: a checkbox
/// flips its own state, and a link replaces the page.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it. State fragments merge by state, not
/// by depth: an override that must beat the recipe's hover underline has to be
/// declared as a hover fragment too (`LinkStyler().onHovered(...)`).
@MixWidget(target: RemixLink.new)
LinkStyler vanillaLinkStyle({LinkStyler style = const LinkStyler.create()}) =>
    LinkStyler()
        .animate(VanillaMotion.standard)
        .label(
          .style(
            VanillaTokens.textSm.mix(),
          ).fontWeight(FontWeight.w500).color(VanillaTokens.primary()),
        )
        .onHovered(.label(.decoration(TextDecoration.underline)))
        .onFocusVisible(.containerEffects(vanillaFocusRing()))
        .onDisabled(_disabledStyle())
        .merge(style);

/// Declared last so it wins over every other state fragment.
///
/// A link with no `onPressed` is disabled by Remix, which is the same meaning
/// `onPressed: null` carries on every other Flutter control, so this fragment
/// is also what a decorative link looks like.
LinkStyler _disabledStyle() => LinkStyler()
    .containerEffects(.outline(.style(.none)))
    .wrap(.opacity(VanillaOpacity.disabled));
