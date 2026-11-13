import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../components/disclosure.dart';
import '../theme/theme.dart';

/// Styles for the sources of an answer: a quiet line that opens a list of
/// chips.
@immutable
final class HeroUiAgentSourcesRecipe {
  const HeroUiAgentSourcesRecipe({
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
HeroUiAgentSourcesRecipe heroUiAgentSourcesRecipe({
  AgentSourcesStyler style = const AgentSourcesStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
  ButtonStyler sourceStyle = const ButtonStyler.create(),
}) => HeroUiAgentSourcesRecipe(
  style: AgentSourcesStyler(
    trigger: FlexBoxStyler().spacing(8).crossAxisAlignment(.center),
    icon: _glyph(),
    label: TextStyler()
        .style(HeroUiTokens.textSm.mix())
        .color(HeroUiTokens.muted()),
    indicator: _glyph(),
    list: WrapBoxStyler().spacing(8).runSpacing(8),
    source: BoxStyler()
        .color(HeroUiTokens.surfaceSecondary())
        .borderRadius(.all(HeroUiTokens.radius4xl()))
        .padding(.symmetric(horizontal: 8, vertical: 4)),
    sourceLabel: TextStyler()
        .style(HeroUiTokens.textXs.mix())
        .color(HeroUiTokens.muted()),
  ).merge(style),
  disclosureStyle: _quietDisclosure().merge(disclosureStyle),
  sourceStyle: heroUiButtonStyle(
    variant: .secondary,
    size: .sm,
    style: sourceStyle,
  ),
);

/// A 16px glyph in quiet gray.
IconStyler _glyph() => IconStyler().size(16).color(HeroUiTokens.muted());

/// A disclosure with no frame, fill or padding of its own, 8px above the list.
DisclosureStyler _quietDisclosure() => heroUiDisclosureStyle(
  style: DisclosureStyler()
      .container(
        BoxStyler()
            .color(const Color(0x00000000))
            .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
      )
      .trigger(BoxStyler().color(const Color(0x00000000)).padding(.all(0)))
      .content(
        BoxStyler()
            .padding(.only(top: 8))
            .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
      )
      .onHovered(.trigger(.color(const Color(0x00000000))))
      .onPressed(.trigger(.color(const Color(0x00000000)))),
);
