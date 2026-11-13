import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../components/disclosure.dart';
import '../theme/tokens.dart';

/// Styles for the sources of an answer: a quiet line that opens a list of
/// chips.
@immutable
final class VanillaAgentSourcesRecipe {
  const VanillaAgentSourcesRecipe({
    required this.style,
    required this.disclosureStyle,
    required this.sourceStyle,
  });

  /// Styles for the line and the list of sources.
  final AgentSourcesStyler style;

  /// Styles for the disclosure that opens and closes the list.
  final DisclosureStyler disclosureStyle;

  /// Styles for a source the reader can open.
  final ButtonStyler sourceStyle;
}

/// Builds the recipe; each argument is merged last, so callers can override.
VanillaAgentSourcesRecipe vanillaAgentSourcesRecipe({
  AgentSourcesStyler style = const AgentSourcesStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
  ButtonStyler sourceStyle = const ButtonStyler.create(),
}) => VanillaAgentSourcesRecipe(
  style: AgentSourcesStyler(
    trigger: FlexBoxStyler()
        .spacing(VanillaTokens.s2)
        .crossAxisAlignment(.center),
    icon: _glyph(),
    label: TextStyler()
        .style(VanillaTokens.textSm.mix())
        .color(VanillaTokens.mutedForeground()),
    indicator: _glyph(),
    list: WrapBoxStyler()
        .spacing(VanillaTokens.s2)
        .runSpacing(VanillaTokens.s2),
    source: BoxStyler()
        .color(VanillaTokens.muted())
        .borderRadius(.circular(VanillaTokens.pill))
        .padding(
          .symmetric(horizontal: VanillaTokens.s2, vertical: VanillaTokens.s1),
        ),
    sourceLabel: TextStyler()
        .style(VanillaTokens.textXs.mix())
        .color(VanillaTokens.mutedForeground()),
  ).merge(style),
  disclosureStyle: _quietDisclosure().merge(disclosureStyle),
  sourceStyle: vanillaButtonStyle(
    variant: .secondary,
    size: .small,
    style: sourceStyle,
  ),
);

/// A 16px glyph in quiet gray.
IconStyler _glyph() =>
    IconStyler().size(VanillaTokens.s4).color(VanillaTokens.mutedForeground());

/// A disclosure with no frame, fill or padding of its own, 8px above the list.
DisclosureStyler _quietDisclosure() => vanillaDisclosureStyle(
  style: DisclosureStyler()
      .container(
        BoxStyler()
            .color(const Color(0x00000000))
            .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
      )
      .trigger(BoxStyler().color(const Color(0x00000000)).padding(.all(0)))
      .content(
        BoxStyler()
            .padding(.only(top: VanillaTokens.s2))
            .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
      )
      .onHovered(.trigger(.color(const Color(0x00000000))))
      .onPressed(.trigger(.color(const Color(0x00000000)))),
);
