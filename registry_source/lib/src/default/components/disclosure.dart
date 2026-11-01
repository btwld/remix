import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'disclosure.g.dart';

/// The application's Disclosure recipe.
///
/// A single collapsible section: a trigger row and the content it reveals.
/// Remix owns the rendering, the expand and collapse animation, keyboard
/// activation, and the accessibility semantics — including announcing the
/// expanded state; this recipe supplies the trigger row, the content inset,
/// and the state fragments.
///
/// It is the accordion's trigger without the accordion's frame: 16px above and
/// below with no side inset, `textSm` at medium weight, underlined under the
/// pointer. The accordion draws a rule under each section because its rows have
/// neighbours to separate; a lone disclosure has none, so a frame would only
/// box in whatever the caller already placed it inside.
///
/// The spec carries plain boxes (`trigger`, `content`), not text: the caller
/// passes whole widgets for both. The recipe sets the trigger's type through a
/// default text style instead, so a bare `Text` trigger takes it and a caller
/// who styles their own text keeps theirs.
///
/// Two constructor parameters are deliberately not forwarded to the generated
/// `VanillaDisclosure`: `triggerBuilder` and `transitionBuilder`. Both
/// are typed by `package:naked_ui`, which this layer does not depend on.
/// Reach for `RemixDisclosure` directly on the rare call site that needs a
/// state-aware trigger or a custom transition.
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
    // These are the forwarded box shorthand, so they land on `trigger`: the
    // row a reader clicks to open the section.
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
    // `content` has to be reached by name; a bare `.padding(...)` would inset
    // the trigger instead. It has no side inset either, so the revealed
    // content lines up under the trigger's own text.
    .content(.padding(.bottom(VanillaTokens.s4)))
    .onHovered(
      DisclosureStyler().trigger(
        BoxStyler().wrap(
          .defaultText(TextStyler().decoration(TextDecoration.underline)),
        ),
      ),
    )
    .onFocusVisible(_focusVisibleStyle())
    .onDisabled(_disabledStyle())
    .merge(style);

/// The keyboard focus ring, drawn on the trigger alone.
///
/// Not on the container, whose effects cover the trigger *plus* everything it
/// revealed: a ring there claims the content is focused too, and grows with
/// it. `triggerEffects` is an outline around the trigger, so it takes no
/// layout space and opening the section never reflows the page. The ring is a
/// 3px band of `ring` at half strength.
DisclosureStyler _focusVisibleStyle() =>
    DisclosureStyler().triggerEffects(vanillaFocusRing());

/// Declared last so it wins over every other state fragment.
///
/// The ring is cleared as well as faded: a disabled control that still draws
/// a focus ring reads as reachable.
DisclosureStyler _disabledStyle() => DisclosureStyler()
    .triggerEffects(.outline(.style(.none)))
    .wrap(.opacity(VanillaTokens.disabledOpacity));
