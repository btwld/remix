import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/disclosure.dart';
import '../theme/tokens.dart';

/// Styles for the steps of a run: one summary line over a rail of steps.
@immutable
final class PlaygroundAgentStepsRecipe {
  const PlaygroundAgentStepsRecipe({
    required this.style,
    required this.stepStyle,
    required this.disclosureStyle,
  });

  /// Styles for the summary line and the rail.
  final AgentStepsStyler style;

  /// Styles for one step; it resolves with the step's status.
  final AgentStepStyler stepStyle;

  /// Styles for the disclosure that opens and closes the rail.
  final DisclosureStyler disclosureStyle;
}

/// Builds the recipe; each argument is merged last, so callers can override.
///
/// The line is quiet gray text with a 16px glyph. The rail hangs 7px in, under
/// the center of that glyph, with 4px between steps.
PlaygroundAgentStepsRecipe playgroundAgentStepsRecipe({
  AgentStepsStyler style = const AgentStepsStyler.create(),
  AgentStepStyler stepStyle = const AgentStepStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
}) => PlaygroundAgentStepsRecipe(
  style: AgentStepsStyler(
    trigger: FlexBoxStyler()
        .spacing(PlaygroundTokens.s2)
        .crossAxisAlignment(.center),
    icon: _glyph(),
    label: TextStyler()
        .style(PlaygroundTokens.textSm.mix())
        .fontWeight(FontWeight.w500)
        .color(PlaygroundTokens.mutedForeground()),
    indicator: _glyph(),
    rail: FlexBoxStyler()
        .direction(.vertical)
        .spacing(PlaygroundTokens.s1)
        .margin(.left(_railInset))
        .padding(.left(PlaygroundTokens.s4))
        .border(
          .left(
            .color(
              PlaygroundTokens.border(),
            ).width(PlaygroundTokens.strokeHairline),
          ),
        ),
  ).merge(style),
  stepStyle:
      AgentStepStyler(
            container: FlexBoxStyler()
                .spacing(PlaygroundTokens.s2)
                .crossAxisAlignment(.center),
            icon: _glyph(color: PlaygroundTokens.mutedForeground()),
            title: TextStyler()
                .style(PlaygroundTokens.textSm.mix())
                .color(PlaygroundTokens.mutedForeground()),
            detail: TextStyler()
                .style(PlaygroundTokens.textXs.mix())
                .color(PlaygroundTokens.mutedForeground()),
          )
          .onStatus(
            .active,
            AgentStepStyler(
              icon: _glyph(color: PlaygroundTokens.foreground()),
              title: TextStyler().color(PlaygroundTokens.foreground()),
            ),
          )
          .merge(stepStyle),
  disclosureStyle: _quietDisclosure().merge(disclosureStyle),
);

/// Puts the rail's left edge under the center of the line's 16px glyph.
const _railInset = 7.0;

/// A 16px glyph in quiet gray.
IconStyler _glyph({Color? color}) => IconStyler()
    .size(PlaygroundTokens.s4)
    .color(color ?? PlaygroundTokens.mutedForeground());

/// A disclosure with no frame, fill or padding of its own, 12px above the rail.
DisclosureStyler _quietDisclosure() => playgroundDisclosureStyle(
  style: DisclosureStyler()
      .container(
        BoxStyler()
            .color(const Color(0x00000000))
            .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
      )
      .trigger(BoxStyler().color(const Color(0x00000000)).padding(.all(0)))
      .content(
        BoxStyler()
            .padding(.only(top: PlaygroundTokens.s3))
            .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
      )
      .onHovered(.trigger(.color(const Color(0x00000000))))
      .onPressed(.trigger(.color(const Color(0x00000000)))),
);
