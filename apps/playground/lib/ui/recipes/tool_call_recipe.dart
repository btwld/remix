import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../components/data_list.dart';
import '../components/disclosure.dart';
import '../theme/effects.dart';
import '../theme/tokens.dart';

/// Styles for a tool call: the quiet row, its output well and the approval
/// card.
@immutable
final class PlaygroundAgentToolCallRecipe {
  const PlaygroundAgentToolCallRecipe({
    required this.style,
    required this.disclosureStyle,
    required this.inputStyle,
    required this.allowOnceStyle,
    required this.alwaysAllowStyle,
    required this.denyStyle,
  });

  /// Styles for the row, the output well and the approval card.
  final AgentToolCallStyler style;

  /// Styles for the disclosure that opens and closes the output well.
  final DisclosureStyler disclosureStyle;

  /// Styles for the list of inputs on the approval card.
  final DataListStyler inputStyle;

  /// Styles for the card's primary action.
  final ButtonStyler allowOnceStyle;

  /// Styles for the card's scoped action.
  final ButtonStyler alwaysAllowStyle;

  /// Styles for the card's refusal.
  final ButtonStyler denyStyle;
}

/// Builds the recipe; each argument is merged last, so callers can override.
///
/// It reads top to bottom: the row, the status for each outcome, the output
/// well, then the approval card. The row paints 32px tall inside the
/// disclosure's 40px touch target. The well is a `gray2` panel with a `gray5`
/// edge that scrolls past `activityMaxHeight`; a failed call frames it in
/// `errorA7` and tints only the failing lines, which the call reports as its
/// error.
PlaygroundAgentToolCallRecipe playgroundAgentToolCallRecipe({
  AgentToolCallStyler style = const AgentToolCallStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
  DataListStyler inputStyle = const DataListStyler.create(),
  ButtonStyler allowOnceStyle = const ButtonStyler.create(),
  ButtonStyler alwaysAllowStyle = const ButtonStyler.create(),
  ButtonStyler denyStyle = const ButtonStyler.create(),
}) => PlaygroundAgentToolCallRecipe(
  style: _row().merge(_status()).merge(_well()).merge(_card()).merge(style),
  disclosureStyle: _quietDisclosure().merge(disclosureStyle),
  inputStyle: playgroundDataListStyle(
    style: DataListStyler()
        .rowSpacing(PlaygroundTokens.s1)
        .value(_mono(13))
        .merge(inputStyle),
  ),
  allowOnceStyle: playgroundButtonStyle(
    variant: .primary,
    size: .small,
    style: allowOnceStyle,
  ),
  alwaysAllowStyle: playgroundButtonStyle(
    variant: .ghost,
    size: .small,
    style: ButtonStyler()
        .label(.color(PlaygroundTokens.mutedForeground()))
        .merge(alwaysAllowStyle),
  ),
  denyStyle: playgroundButtonStyle(
    variant: .outline,
    size: .small,
    style: denyStyle,
  ),
);

/// The row: tool icon, summary, then the meta with the tool id in monospace.
AgentToolCallStyler _row() =>
    AgentToolCallStyler(
          row: FlexBoxStyler()
              .spacing(PlaygroundTokens.s2)
              .crossAxisAlignment(.center)
              .minHeight(PlaygroundTokens.s8)
              .padding(.horizontal(PlaygroundTokens.s2))
              .transform(Matrix4.translationValues(-PlaygroundTokens.s2, 0, 0))
              .borderRadius(.all(PlaygroundTokens.radiusMd())),
          icon: _glyph(),
          summary: TextStyler()
              .style(PlaygroundTokens.textSm.mix())
              .fontWeight(FontWeight.w500)
              .color(PlaygroundTokens.foreground()),
          meta: TextStyler()
              .style(PlaygroundTokens.textXs.mix())
              .color(PlaygroundTokens.mutedForeground()),
          toolId: _mono(12),
          indicator: _glyph(),
        )
        .onFocused(.row(.color(PlaygroundTokens.accent())))
        .onHovered(.row(.color(PlaygroundTokens.accent())))
        .onPressed(.row(.color(PlaygroundTokens.accent())));

/// The status word and glyph: quiet gray, red when the call failed, and a
/// badge on the approval card.
AgentToolCallStyler _status() =>
    AgentToolCallStyler(
          status: FlexBoxStyler()
              .spacing(PlaygroundTokens.s1)
              .crossAxisAlignment(.center),
          statusIcon: _glyph(size: PlaygroundTokens.s3),
          statusLabel: TextStyler()
              .style(PlaygroundTokens.textXs.mix())
              .fontWeight(FontWeight.w500)
              .color(PlaygroundTokens.mutedForeground()),
        )
        .onStatus(
          .failed,
          AgentToolCallStyler(
            statusIcon: _glyph(
              size: PlaygroundTokens.s3,
              color: PlaygroundTokens.destructive(),
            ),
            statusLabel: TextStyler().color(PlaygroundTokens.destructive()),
          ),
        )
        .onStatus(
          .awaitingApproval,
          AgentToolCallStyler(
            status: FlexBoxStyler()
                .color(PlaygroundTokens.accent())
                .borderRadius(.all(PlaygroundTokens.radiusSm()))
                .padding(.symmetric(horizontal: PlaygroundTokens.s2))
                .minHeight(PlaygroundTokens.s6),
            statusLabel: TextStyler().color(
              PlaygroundTokens.accentForeground(),
            ),
          ),
        );

/// The output well. Its padding sits on the text, so the tinted failing lines
/// reach the well's edges.
AgentToolCallStyler _well() =>
    AgentToolCallStyler(
          output: BoxStyler()
              .margin(
                .only(left: PlaygroundTokens.s6, top: PlaygroundTokens.s1),
              )
              .padding(.vertical(PlaygroundTokens.s2))
              .color(PlaygroundTokens.muted())
              .borderRadius(.all(PlaygroundTokens.radiusMd()))
              .border(
                .all(
                  .color(
                    PlaygroundTokens.border(),
                  ).width(PlaygroundTokens.strokeHairline),
                ),
              ),
          outputToggle: FlexBoxStyler()
              .minHeight(PlaygroundTokens.s8)
              .padding(.horizontal(PlaygroundTokens.s2))
              .borderRadius(.all(PlaygroundTokens.radiusMd())),
          outputToggleLabel: TextStyler()
              .style(PlaygroundTokens.textXs.mix())
              .color(PlaygroundTokens.mutedForeground()),
          outputMaxHeight: _wellMaxHeight,
          outputContent: BoxStyler().padding(.horizontal(PlaygroundTokens.s3)),
          outputText: _mono(
            12,
          ).color(PlaygroundTokens.foreground()).height(_wellLineHeight),
          error: BoxStyler()
              .color(
                playgroundTint(PlaygroundTokens.destructive, 0.1, dark: 0.2)(),
              )
              .padding(.horizontal(PlaygroundTokens.s3)),
          errorText: _mono(
            12,
          ).color(PlaygroundTokens.destructive()).height(_wellLineHeight),
        )
        .onHovered(
          AgentToolCallStyler(
            outputToggle: FlexBoxStyler().color(PlaygroundTokens.accent()),
            outputToggleLabel: TextStyler().color(
              PlaygroundTokens.foreground(),
            ),
          ),
        )
        .onPressed(
          AgentToolCallStyler(
            outputToggle: FlexBoxStyler().color(PlaygroundTokens.accent()),
            outputToggleLabel: TextStyler().color(
              PlaygroundTokens.foreground(),
            ),
          ),
        )
        .onFocused(.outputToggleLabel(.decoration(TextDecoration.underline)))
        .onStatus(
          .failed,
          AgentToolCallStyler(
            output: BoxStyler().border(
              .all(.color(PlaygroundTokens.destructive())),
            ),
          ),
        );

/// The approval card: a flat panel with no shadow, an icon tile beside the
/// question, tool id, description and inputs, and a footer rule above the
/// actions.
AgentToolCallStyler _card() => AgentToolCallStyler(
  card: BoxStyler()
      .color(PlaygroundTokens.card())
      .borderRadius(.all(PlaygroundTokens.radiusLg()))
      .clipBehavior(.antiAlias)
      .border(
        .all(
          .color(
            PlaygroundTokens.border(),
          ).width(PlaygroundTokens.strokeHairline),
        ),
      ),
  cardBody: FlexBoxStyler()
      .spacing(PlaygroundTokens.s3)
      .padding(.all(PlaygroundTokens.s4)),
  cardIcon: BoxStyler()
      .width(PlaygroundTokens.s8)
      .height(PlaygroundTokens.s8)
      .color(PlaygroundTokens.muted())
      .borderRadius(.all(PlaygroundTokens.radiusMd()))
      .alignment(.center),
  cardGlyph: _glyph(color: PlaygroundTokens.foreground()),
  cardContent: FlexBoxStyler().spacing(PlaygroundTokens.s2),
  cardTitleRow: FlexBoxStyler()
      .spacing(PlaygroundTokens.s2)
      .crossAxisAlignment(.center),
  title: TextStyler()
      .style(PlaygroundTokens.textSm.mix())
      .fontWeight(FontWeight.w600)
      .color(PlaygroundTokens.foreground()),
  description: TextStyler()
      .style(PlaygroundTokens.textSm.mix())
      .color(PlaygroundTokens.mutedForeground()),
  footer: FlexBoxStyler()
      .spacing(PlaygroundTokens.s2)
      .crossAxisAlignment(.center)
      .padding(
        .symmetric(
          horizontal: PlaygroundTokens.s4,
          vertical: PlaygroundTokens.s3,
        ),
      )
      .border(
        .top(
          .color(
            PlaygroundTokens.border(),
          ).width(PlaygroundTokens.strokeHairline),
        ),
      ),
);

/// The well's line box is 18px at 12px type.
const _wellLineHeight = 1.5;

/// The tallest the output well grows before it scrolls.
const _wellMaxHeight = 200.0;

/// A 16px glyph in quiet gray, unless [size] or [color] say otherwise.
IconStyler _glyph({double? size, Color? color}) => IconStyler()
    .size(size ?? PlaygroundTokens.s4)
    .color(color ?? PlaygroundTokens.mutedForeground());

/// Tool ids, commands and output in the theme monospace face at [size].
TextStyler _mono(double size) => TextStyler()
    .style(PlaygroundTokens.textMono.mix())
    .fontSize(size)
    .color(PlaygroundTokens.mutedForeground());

/// A disclosure with no frame, fill or padding of its own.
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
            .padding(.all(0))
            .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
      )
      .onHovered(.trigger(.color(const Color(0x00000000))))
      .onPressed(.trigger(.color(const Color(0x00000000)))),
);
