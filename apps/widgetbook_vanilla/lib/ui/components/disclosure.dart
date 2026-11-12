import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'disclosure.g.dart';

/// The application's Disclosure recipe.
///
/// A single collapsible section. It is the accordion's trigger without the
/// frame: 16px above and below, `textSm` at medium weight, underlined under the
/// pointer. A lone disclosure has no neighbors to separate, so it draws no rule.
///
/// The spec carries plain boxes, not text, so the trigger's type is a default
/// text style: a bare `Text` trigger takes it and one with its own style keeps
/// it.
///
/// The generated widget omits `triggerBuilder` and `transitionBuilder`: their
/// types come from `package:naked_ui`, which this layer does not import. Use
/// `RemixDisclosure` for a state-aware trigger or a custom transition.
@MixWidget(
  target: RemixDisclosure.new,
  widgetParameters: .only({
    'trigger',
    'content',
    'expanded',
    'defaultExpanded',
    'onExpandedChanged',
    'enabled',
    'mouseCursor',
    'enableFeedback',
    'focusNode',
    'autofocus',
    'onFocusChange',
    'onHoverChange',
    'onPressChange',
    'semanticLabel',
    'semanticHint',
    'excludeSemantics',
    'animationStyle',
  }),
)
DisclosureStyler vanillaDisclosureStyle({
  DisclosureStyler style = const DisclosureStyler.create(),
}) => DisclosureStyler()
    .animate(VanillaTokens.motion)
    // Forwarded to `trigger`, the row that opens the section.
    .width(double.infinity)
    .alignment(.centerLeft)
    .padding(.vertical(VanillaTokens.s4))
    .borderRadius(.all(VanillaTokens.radiusMd()))
    .trigger(
      BoxStyler().wrap(
        .defaultText(
          TextStyler()
              .style(VanillaTokens.textSm.mix())
              .fontWeight(FontWeight.w500)
              .color(VanillaTokens.foreground()),
        ),
      ),
    )
    // By name: a bare `.padding(...)` would inset the trigger.
    .content(.padding(.bottom(VanillaTokens.s4)))
    .onHovered(
      DisclosureStyler().trigger(
        BoxStyler().wrap(
          .defaultText(TextStyler().decoration(TextDecoration.underline)),
        ),
      ),
    )
    // On the trigger alone: a container ring would claim the revealed content
    // is focused too, and grow with it.
    .onFocusVisible(.triggerEffects(vanillaFocusRing()))
    // Declared last so it wins; the ring is cleared because a disabled control
    // that still rings reads as reachable.
    .onDisabled(
      DisclosureStyler()
          .triggerEffects(.outline(.style(.none)))
          .wrap(.opacity(VanillaTokens.disabledOpacity)),
    )
    .merge(style);
