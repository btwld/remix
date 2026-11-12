import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../components/disclosure.dart';
import '../theme/theme.dart';

/// Styles for a tool call: the quiet row, its output well and the approval
/// card.
@immutable
final class UiAgentToolCallRecipe {
  const UiAgentToolCallRecipe({
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
/// The 32px row opens an output well capped at 200px. A failed call colors
/// the well's frame and tints only the failing lines, preserving the output.
UiAgentToolCallRecipe uiAgentToolCallRecipe({
  AgentToolCallStyler style = const AgentToolCallStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
  DataListStyler inputStyle = const DataListStyler.create(),
  ButtonStyler allowOnceStyle = const ButtonStyler.create(),
  ButtonStyler alwaysAllowStyle = const ButtonStyler.create(),
  ButtonStyler denyStyle = const ButtonStyler.create(),
}) => UiAgentToolCallRecipe(
  style: _row().merge(_status()).merge(_well()).merge(_card()).merge(style),
  disclosureStyle: _quietDisclosure().merge(disclosureStyle),
  inputStyle: DataListStyler()
      .label(.style(UiTokens.textSm.mix()).color(UiTokens.muted()))
      .value(_mono(UiTokens.textSm).color(UiTokens.foreground()))
      .rowSpacing(4)
      .columnSpacing(24)
      .labelValueSpacing(8)
      .minLabelWidth(88)
      .merge(inputStyle),
  allowOnceStyle: uiButtonStyle(
    variant: .primary,
    size: .sm,
    style: allowOnceStyle,
  ),
  alwaysAllowStyle: uiButtonStyle(
    variant: .ghost,
    size: .sm,
    style: ButtonStyler()
        .label(.color(UiTokens.muted()))
        .merge(alwaysAllowStyle),
  ),
  denyStyle: uiButtonStyle(variant: .outline, size: .sm, style: denyStyle),
);

/// The row: tool icon, summary, then the meta with the tool id in monospace.
AgentToolCallStyler _row() =>
    AgentToolCallStyler(
          row: FlexBoxStyler()
              .spacing(8)
              .crossAxisAlignment(.center)
              .minHeight(32)
              .padding(.horizontal(8))
              .transform(Matrix4.translationValues(-8, 0, 0))
              .borderRadius(.all(UiTokens.radiusMd())),
          icon: _glyph(),
          summary: TextStyler()
              .style(UiTokens.textSm.mix())
              .fontWeight(FontWeight.w500)
              .color(UiTokens.foreground()),
          meta: TextStyler()
              .style(UiTokens.textXs.mix())
              .color(UiTokens.muted()),
          toolId: _mono(UiTokens.textXs),
          indicator: _glyph(),
        )
        .onFocused(.row(.color(UiTokens.defaultColor())))
        .onHovered(.row(.color(UiTokens.defaultColor())))
        .onPressed(.row(.color(UiTokens.defaultHover())));

/// The status word and glyph: quiet gray, red when the call failed, and a
/// badge on the approval card.
AgentToolCallStyler _status() =>
    AgentToolCallStyler(
          status: FlexBoxStyler().spacing(4).crossAxisAlignment(.center),
          statusIcon: _glyph(size: 12),
          statusLabel: TextStyler()
              .style(UiTokens.textXs.mix())
              .fontWeight(FontWeight.w500)
              .color(UiTokens.muted()),
        )
        .onStatus(
          .failed,
          AgentToolCallStyler(
            statusIcon: _glyph(size: 12, color: UiTokens.danger()),
            statusLabel: TextStyler().color(UiTokens.danger()),
          ),
        )
        .onStatus(
          .awaitingApproval,
          AgentToolCallStyler(
            status: FlexBoxStyler()
                .color(UiTokens.accentSoft())
                .borderRadius(.all(UiTokens.radiusSm()))
                .padding(.symmetric(horizontal: 8))
                .minHeight(24),
            statusLabel: TextStyler().color(UiTokens.accentSoftForeground()),
          ),
        );

/// The output well. Its padding sits on the text, so the tinted failing lines
/// reach the well's edges.
AgentToolCallStyler _well() =>
    AgentToolCallStyler(
          output: BoxStyler()
              .margin(.only(left: 24, top: 4))
              .padding(.vertical(8))
              .color(UiTokens.surfaceSecondary())
              .borderRadius(.all(UiTokens.radiusMd()))
              .border(.all(.color(UiTokens.separator()).width(1))),
          outputToggle: FlexBoxStyler()
              .minHeight(32)
              .padding(.horizontal(8))
              .borderRadius(.all(UiTokens.radiusMd())),
          outputToggleLabel: TextStyler()
              .style(UiTokens.textXs.mix())
              .color(UiTokens.muted()),
          outputMaxHeight: _wellMaxHeight,
          outputContent: BoxStyler().padding(.horizontal(12)),
          outputText: _mono(
            UiTokens.textXs,
          ).color(UiTokens.foreground()).height(_wellLineHeight),
          error: BoxStyler()
              .color(UiTokens.dangerSoft())
              .padding(.horizontal(12)),
          errorText: _mono(
            UiTokens.textXs,
          ).color(UiTokens.danger()).height(_wellLineHeight),
        )
        .onHovered(
          AgentToolCallStyler(
            outputToggle: FlexBoxStyler().color(UiTokens.defaultColor()),
            outputToggleLabel: TextStyler().color(UiTokens.foreground()),
          ),
        )
        .onPressed(
          AgentToolCallStyler(
            outputToggle: FlexBoxStyler().color(UiTokens.defaultHover()),
            outputToggleLabel: TextStyler().color(UiTokens.foreground()),
          ),
        )
        .onFocused(.outputToggleLabel(.decoration(TextDecoration.underline)))
        .onStatus(
          .failed,
          AgentToolCallStyler(
            output: BoxStyler().border(.all(.color(UiTokens.danger()))),
          ),
        );

/// The approval card: a flat panel with no shadow, an icon tile beside the
/// question, tool id, description and inputs, and a footer rule above the
/// actions.
AgentToolCallStyler _card() => AgentToolCallStyler(
  card: BoxStyler()
      .color(UiTokens.surface())
      .borderRadius(.all(UiTokens.radiusXl()))
      .clipBehavior(.antiAlias)
      .border(.all(.color(UiTokens.border()).width(1))),
  cardBody: FlexBoxStyler().spacing(12).padding(.all(16)),
  cardIcon: BoxStyler()
      .width(32)
      .height(32)
      .color(UiTokens.defaultColor())
      .borderRadius(.all(UiTokens.radiusLg()))
      .alignment(.center),
  cardGlyph: _glyph(color: UiTokens.foreground()),
  cardContent: FlexBoxStyler().spacing(8),
  cardTitleRow: FlexBoxStyler().spacing(8).crossAxisAlignment(.center),
  title: TextStyler()
      .style(UiTokens.textSm.mix())
      .fontWeight(FontWeight.w600)
      .color(UiTokens.foreground()),
  description: TextStyler()
      .style(UiTokens.textSm.mix())
      .color(UiTokens.muted()),
  footer: FlexBoxStyler()
      .spacing(8)
      .crossAxisAlignment(.center)
      .padding(.symmetric(horizontal: 16, vertical: 12))
      .border(.top(.color(UiTokens.separator()).width(1))),
);

/// The well's line box is 18px at 12px type.
const _wellLineHeight = 1.5;

/// The tallest the output well grows before it scrolls.
const _wellMaxHeight = 200.0;

/// A 16px glyph in quiet gray, unless [size] or [color] say otherwise.
IconStyler _glyph({double? size, Color? color}) =>
    IconStyler().size(size ?? 16).color(color ?? UiTokens.muted());

/// Tool ids, commands and output in the platform monospace stack.
TextStyler _mono(TextStyleToken size) => TextStyler()
    .style(size.mix())
    .fontFamily('Menlo')
    .fontFamilyFallback(const ['Consolas', 'monospace'])
    .color(UiTokens.muted());

/// A disclosure with no frame, fill or padding of its own.
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
            .padding(.all(0))
            .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
      )
      .onHovered(.trigger(.color(const Color(0x00000000))))
      .onPressed(.trigger(.color(const Color(0x00000000)))),
);
