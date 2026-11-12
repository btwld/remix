import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/tokens.dart';

part 'accordion.g.dart';

/// The application's Accordion recipe.
///
/// Sections are separated by a bottom hairline rather than a box, so a stack
/// reads as one list.
///
/// `RemixAccordionGroup`, which owns which values are expanded, has no styler
/// and no recipe. Wrap the sections in it directly:
///
/// ```dart
/// RemixAccordionGroup<String>(
///   controller: RemixAccordionController<String>(),
///   child: Column(children: const [
///     VanillaAccordion(
///       value: 'shipping',
///       title: 'Shipping',
///       child: Text('Two to four business days.'),
///     ),
///   ]),
/// )
/// ```
///
/// The generated widget omits `builder`: its type comes from `package:naked_ui`,
/// which this layer does not import. Use `RemixAccordion` for a custom trigger.
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
AccordionStyler vanillaAccordionStyle({
  AccordionStyler style = const AccordionStyler.create(),
}) => AccordionStyler()
    .animate(VanillaTokens.motion)
    // By name: the box shorthand below is forwarded to `trigger`, so a bare
    // `.border(...)` would outline the clickable row, not the section.
    .container(
      .border(
        .bottom(
          .color(VanillaTokens.border()).width(VanillaTokens.strokeHairline),
        ),
      ),
    )
    // Forwarded to `trigger`: the row that opens the section, 16px above and
    // below with no side inset, so the title aligns with the content around it.
    .direction(.horizontal)
    .crossAxisAlignment(.center)
    .padding(.vertical(VanillaTokens.s4))
    .spacing(VanillaTokens.s4)
    .borderRadius(.all(VanillaTokens.radiusMd()))
    .title(
      .style(
        VanillaTokens.textSm.mix(),
      ).fontWeight(FontWeight.w500).color(VanillaTokens.foreground()),
    )
    .leadingIcon(
      .size(VanillaTokens.icon).color(VanillaTokens.mutedForeground()),
    )
    .trailingIcon(
      .size(VanillaTokens.icon).color(VanillaTokens.mutedForeground()),
    )
    .content(.padding(.bottom(VanillaTokens.s4)))
    .onHovered(.title(.decoration(TextDecoration.underline)))
    .onExpanded(_open())
    .onSelected(_open())
    // On the trigger, not the section: the section also holds the revealed
    // panel, and a ring there would grow with it.
    .onFocusVisible(.triggerEffects(vanillaFocusRing()))
    .onDisabled(_disabled())
    .merge(style);

/// The open section promotes its icons to `foreground` and flips the chevron.
AccordionStyler _open() => AccordionStyler()
    .leadingIcon(.color(VanillaTokens.foreground()))
    .trailingIcon(
      IconStyler()
          .color(VanillaTokens.foreground())
          .wrap(
            WidgetModifierConfig.transform(
              transform: Matrix4.rotationZ(math.pi),
              alignment: .center,
            ),
          ),
    );

/// Declared last so it wins over every other state fragment.
AccordionStyler _disabled() => AccordionStyler()
    .triggerEffects(.outline(.style(.none)))
    .wrap(.opacity(VanillaTokens.disabledOpacity));
