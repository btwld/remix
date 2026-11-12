import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../components/disclosure.dart';
import '../theme/theme.dart';

/// Styles for the sources of an answer: a quiet line that opens a list of
/// chips.
@immutable
final class FortalAgentSourcesRecipe {
  const FortalAgentSourcesRecipe({
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
FortalAgentSourcesRecipe fortalAgentSourcesRecipe({
  AgentSourcesStyler style = const AgentSourcesStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
  ButtonStyler sourceStyle = const ButtonStyler.create(),
}) => FortalAgentSourcesRecipe(
  style: AgentSourcesStyler(
    trigger: FlexBoxStyler()
        .spacing(FortalTokens.space2())
        .crossAxisAlignment(.center),
    icon: _glyph(),
    label: TextStyler()
        .style(FortalTokens.text2.mix())
        .color(FortalTokens.gray11()),
    indicator: _glyph(),
    list: WrapBoxStyler()
        .spacing(FortalTokens.space2())
        .runSpacing(FortalTokens.space2()),
    source: BoxStyler()
        .color(FortalTokens.gray3())
        .borderRadius(.circular(_pill))
        .padding(
          .symmetric(
            horizontal: FortalTokens.space2(),
            vertical: FortalTokens.space1(),
          ),
        ),
    sourceLabel: TextStyler()
        .style(FortalTokens.text1.mix())
        .color(FortalTokens.gray11()),
  ).merge(style),
  disclosureStyle: _quietDisclosure().merge(disclosureStyle),
  sourceStyle: fortalButtonStyle(
    variant: .soft,
    size: .size1,
    style: sourceStyle,
  ),
);

/// A 16px glyph in quiet gray.
IconStyler _glyph() =>
    IconStyler().size(FortalTokens.space4()).color(FortalTokens.gray11());

/// A disclosure with no frame, fill or padding of its own, 8px above the list.
DisclosureStyler _quietDisclosure() => fortalDisclosureStyle(
  style: DisclosureStyler()
      .container(
        BoxStyler()
            .color(const Color(0x00000000))
            .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
      )
      .trigger(BoxStyler().color(const Color(0x00000000)).padding(.all(0)))
      .content(
        BoxStyler()
            .padding(.only(top: FortalTokens.space2()))
            .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
      )
      .onHovered(.trigger(.color(const Color(0x00000000))))
      .onPressed(.trigger(.color(const Color(0x00000000)))),
);

/// Pill corners, whatever radius the theme chooses.
const _pill = 999.0;
