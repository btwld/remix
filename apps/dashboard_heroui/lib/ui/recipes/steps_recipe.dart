import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/disclosure.dart';
import '../theme/theme.dart';

/// Styles for the steps of a run: one summary line over a rail of steps.
@immutable
final class UiAgentStepsRecipe {
  const UiAgentStepsRecipe({
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
UiAgentStepsRecipe uiAgentStepsRecipe({
  AgentStepsStyler style = const AgentStepsStyler.create(),
  AgentStepStyler stepStyle = const AgentStepStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
}) => UiAgentStepsRecipe(
  style: AgentStepsStyler(
    trigger: FlexBoxStyler().spacing(8).crossAxisAlignment(.center),
    icon: _glyph(),
    label: TextStyler()
        .style(UiTokens.textSm.mix())
        .fontWeight(FontWeight.w500)
        .color(UiTokens.muted()),
    indicator: _glyph(),
    rail: FlexBoxStyler()
        .direction(.vertical)
        .spacing(4)
        .margin(.left(_railInset))
        .padding(.left(16))
        .border(.left(.color(UiTokens.separator()).width(1))),
  ).merge(style),
  stepStyle:
      AgentStepStyler(
            container: FlexBoxStyler().spacing(8).crossAxisAlignment(.center),
            icon: _glyph(color: UiTokens.muted()),
            title: TextStyler()
                .style(UiTokens.textSm.mix())
                .color(UiTokens.muted()),
            detail: TextStyler()
                .style(UiTokens.textXs.mix())
                .color(UiTokens.muted()),
          )
          .onStatus(
            .active,
            AgentStepStyler(
              icon: _glyph(color: UiTokens.foreground()),
              title: TextStyler().color(UiTokens.foreground()),
            ),
          )
          .merge(stepStyle),
  disclosureStyle: _quietDisclosure().merge(disclosureStyle),
);

/// Puts the rail's left edge under the center of the line's 16px glyph.
const _railInset = 7.0;

/// A 16px glyph in quiet gray.
IconStyler _glyph({Color? color}) =>
    IconStyler().size(16).color(color ?? UiTokens.muted());

/// A disclosure with no frame, fill or padding of its own, 12px above the rail.
DisclosureStyler _quietDisclosure() => uiDisclosureStyle(
  style: DisclosureStyler()
      .container(
        BoxStyler()
            .color(const Color(0x00000000))
            .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
      )
      .trigger(BoxStyler().color(const Color(0x00000000)).padding(.all(0)))
      .content(
        BoxStyler()
            .padding(.only(top: 12))
            .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
      )
      .onHovered(.trigger(.color(const Color(0x00000000))))
      .onPressed(.trigger(.color(const Color(0x00000000)))),
);
