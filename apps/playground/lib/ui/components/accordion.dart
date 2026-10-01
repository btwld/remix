import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/scale.dart';
import '../theme/tokens.dart';

part 'accordion.g.dart';

/// The application's Accordion recipe.
///
/// Remix owns the rendering, the expand and collapse animation, the group
/// coordination, keyboard activation, and the accessibility semantics; this
/// recipe supplies the row, the two icons, the title, and the panel.
///
/// `RemixAccordionGroup` — the behavioral coordinator that owns which values
/// are expanded — carries no styler and therefore no recipe. Compose it
/// directly around these:
///
/// ```dart
/// // `RemixAccordionController` is Remix's alias for the Naked UI type, so
/// // the controller does not pull `package:naked_ui` into this layer.
/// RemixAccordionGroup<String>(
///   controller: RemixAccordionController<String>(),
///   child: Column(children: const [
///     PlaygroundAccordion(
///       value: 'shipping',
///       title: 'Shipping',
///       child: Text('Two to four business days.'),
///     ),
///   ]),
/// )
/// ```
///
/// Each section is separated by a rule along its bottom edge rather than by a
/// box of its own, so a stack of them reads as one list. The `border` token
/// is the same hairline the divider draws, which is what makes a divider
/// between sections indistinguishable from the sections' own edges.
///
/// `builder` is deliberately not forwarded to the generated
/// `PlaygroundAccordion`. Its type is `NakedAccordionTriggerBuilder`,
/// which comes from `package:naked_ui` — a package this layer does not depend
/// on. Use `title` with the icons, or reach for `RemixAccordion` directly on
/// the rare call site that needs to build its own trigger row.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it. State fragments merge by state, not
/// by depth: an override that must beat the recipe's open title has to be
/// declared as a selected fragment too (`AccordionStyler().onSelected(...)`).
@MixWidget(
  target: RemixAccordion.new,
  widgetParameters: .only({
    'value',
    'child',
    'title',
    'leadingIcon',
    'trailingIcon',
    'enabled',
    'mouseCursor',
    'enableFeedback',
    'autofocus',
    'focusNode',
    'onFocusChange',
    'onHoverChange',
    'onPressChange',
    'semanticLabel',
    'transitionBuilder',
  }),
)
AccordionStyler playgroundAccordionStyle({
  AccordionStyler style = const AccordionStyler.create(),
}) => AccordionStyler()
    .animate(PlaygroundMotion.standard)
    // `container` has to be reached by name. `AccordionStyler` forwards its
    // box shorthand to `trigger`, so a bare `.border(...)` would outline the
    // clickable row rather than the section, and the rule between sections
    // would move with the panel as it opens.
    .container(
      .border(
        .bottom(
          .color(PlaygroundTokens.border()).width(PlaygroundStroke.hairline),
        ),
      ),
    )
    // These *are* the forwarded shorthand, so they land on `trigger`: the row a
    // reader clicks to open the section, 16px above and below with a 16px gap
    // and no side inset, so the title lines up with the content above and below
    // the list.
    .direction(.horizontal)
    .crossAxisAlignment(.center)
    .padding(.vertical(PlaygroundSpace.s4))
    .spacing(PlaygroundSpace.s4)
    .borderRadius(.all(PlaygroundTokens.radiusMd()))
    .title(
      .style(
        PlaygroundTokens.textSm.mix(),
      ).fontWeight(FontWeight.w500).color(PlaygroundTokens.foreground()),
    )
    .leadingIcon(
      .size(PlaygroundSize.icon).color(PlaygroundTokens.mutedForeground()),
    )
    // Both icons are markers, not the state: Remix renders whatever
    // `IconData` the caller passes and does not rotate it, so a chevron that
    // turns is a caller passing a different glyph when the section is open.
    .trailingIcon(
      .size(PlaygroundSize.icon).color(PlaygroundTokens.mutedForeground()),
    )
    .content(.padding(.only(bottom: PlaygroundSpace.s4)))
    .onHovered(_hoverStyle())
    .onSelected(_openStyle())
    .onFocusVisible(_focusVisibleStyle())
    .onDisabled(_disabledStyle())
    .merge(style);

/// Hovering underlines the title.
AccordionStyler _hoverStyle() =>
    AccordionStyler().title(.decoration(TextDecoration.underline));

/// The open section promotes its icons to `foreground`.
///
/// Remix renders the glyph it is given and does not rotate it, so the recipe
/// marks the state with the icons' strength, and a caller who wants the turn
/// passes the other chevron while the section is open.
AccordionStyler _openStyle() => AccordionStyler()
    .leadingIcon(.color(PlaygroundTokens.foreground()))
    .trailingIcon(.color(PlaygroundTokens.foreground()));

/// The keyboard focus ring: a 3px band of `ring` at half strength.
///
/// An outline rather than a border: `RemixBoxEffects` paints it outside the
/// section without taking layout space, and the section's own border is
/// already carrying the rule between rows.
AccordionStyler _focusVisibleStyle() =>
    AccordionStyler().containerEffects(playgroundFocusRing());

/// Declared last so it wins over every other state fragment.
AccordionStyler _disabledStyle() => AccordionStyler()
    .containerEffects(.outline(.style(.none)))
    .wrap(.opacity(PlaygroundOpacity.disabled));
