import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../components/disclosure.dart';
import '../theme/theme.dart';

/// Styles for a tool call: the quiet row, its output well and the approval
/// card.
@immutable
final class HeroUiAgentToolCallRecipe {
  const HeroUiAgentToolCallRecipe({
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
HeroUiAgentToolCallRecipe heroUiAgentToolCallRecipe({
  AgentToolCallStyler style = const AgentToolCallStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
  DataListStyler inputStyle = const DataListStyler.create(),
  ButtonStyler allowOnceStyle = const ButtonStyler.create(),
  ButtonStyler alwaysAllowStyle = const ButtonStyler.create(),
  ButtonStyler denyStyle = const ButtonStyler.create(),
}) => HeroUiAgentToolCallRecipe(
  style: _row().merge(_status()).merge(_well()).merge(_card()).merge(style),
  disclosureStyle: _quietDisclosure().merge(disclosureStyle),
  inputStyle: DataListStyler()
      .label(.style(HeroUiTokens.textSm.mix()).color(HeroUiTokens.muted()))
      .value(_mono(HeroUiTokens.textSm).color(HeroUiTokens.foreground()))
      .rowSpacing(4)
      .columnSpacing(24)
      .labelValueSpacing(8)
      .minLabelWidth(88)
      .merge(inputStyle),
  allowOnceStyle: heroUiButtonStyle(
    variant: .primary,
    size: .sm,
    style: allowOnceStyle,
  ),
  alwaysAllowStyle: heroUiButtonStyle(
    variant: .ghost,
    size: .sm,
    style: ButtonStyler()
        .label(.color(HeroUiTokens.muted()))
        .merge(alwaysAllowStyle),
  ),
  denyStyle: heroUiButtonStyle(variant: .outline, size: .sm, style: denyStyle),
);

/// The row: tool icon, summary, then the meta with the tool id in monospace.
AgentToolCallStyler _row() => AgentToolCallStyler(
  row: FlexBoxStyler().spacing(8).crossAxisAlignment(.center).minHeight(32),
  icon: _glyph(),
  summary: TextStyler()
      .style(HeroUiTokens.textSm.mix())
      .fontWeight(FontWeight.w500)
      .color(HeroUiTokens.foreground()),
  meta: TextStyler()
      .style(HeroUiTokens.textXs.mix())
      .color(HeroUiTokens.muted()),
  toolId: _mono(HeroUiTokens.textXs),
  indicator: _glyph(),
);

/// The status word and glyph: quiet gray, red when the call failed, and a
/// badge on the approval card.
AgentToolCallStyler _status() =>
    AgentToolCallStyler(
          status: FlexBoxStyler().spacing(4).crossAxisAlignment(.center),
          statusIcon: _glyph(size: 12),
          statusLabel: TextStyler()
              .style(HeroUiTokens.textXs.mix())
              .fontWeight(FontWeight.w500)
              .color(HeroUiTokens.muted()),
        )
        .onStatus(
          .failed,
          AgentToolCallStyler(
            statusIcon: _glyph(size: 12, color: HeroUiTokens.danger()),
            statusLabel: TextStyler().color(HeroUiTokens.danger()),
          ),
        )
        .onStatus(
          .awaitingApproval,
          AgentToolCallStyler(
            status: FlexBoxStyler()
                .color(HeroUiTokens.accentSoft())
                .borderRadius(.all(HeroUiTokens.radiusSm()))
                .padding(.symmetric(horizontal: 8))
                .minHeight(24),
            statusLabel: TextStyler().color(
              HeroUiTokens.accentSoftForeground(),
            ),
          ),
        );

/// The output well. Its padding sits on the text, so the tinted failing lines
/// reach the well's edges.
AgentToolCallStyler _well() =>
    AgentToolCallStyler(
      output: BoxStyler()
          .margin(.only(left: 24, top: 4))
          .padding(.vertical(8))
          .color(HeroUiTokens.surfaceSecondary())
          .borderRadius(.all(HeroUiTokens.radiusMd()))
          .border(.all(.color(HeroUiTokens.separator()).width(1))),
      outputMaxHeight: _wellMaxHeight,
      outputContent: BoxStyler().padding(.horizontal(12)),
      outputText: _mono(
        HeroUiTokens.textXs,
      ).color(HeroUiTokens.foreground()).height(_wellLineHeight),
      error: BoxStyler()
          .color(HeroUiTokens.dangerSoft())
          .padding(.horizontal(12)),
      errorText: _mono(
        HeroUiTokens.textXs,
      ).color(HeroUiTokens.danger()).height(_wellLineHeight),
    ).onStatus(
      .failed,
      AgentToolCallStyler(
        output: BoxStyler().border(.all(.color(HeroUiTokens.danger()))),
      ),
    );

/// The approval card: a flat panel with no shadow, an icon tile beside the
/// question, tool id, description and inputs, and a footer rule above the
/// actions.
AgentToolCallStyler _card() => AgentToolCallStyler(
  card: BoxStyler()
      .color(HeroUiTokens.surface())
      .borderRadius(.all(HeroUiTokens.radiusXl()))
      .clipBehavior(.antiAlias)
      .border(.all(.color(HeroUiTokens.border()).width(1))),
  cardBody: FlexBoxStyler().spacing(12).padding(.all(16)),
  cardIcon: BoxStyler()
      .width(32)
      .height(32)
      .color(HeroUiTokens.defaultColor())
      .borderRadius(.all(HeroUiTokens.radiusLg()))
      .alignment(.center),
  cardGlyph: _glyph(color: HeroUiTokens.foreground()),
  cardContent: FlexBoxStyler().spacing(8),
  cardTitleRow: FlexBoxStyler().spacing(8).crossAxisAlignment(.center),
  title: TextStyler()
      .style(HeroUiTokens.textSm.mix())
      .fontWeight(FontWeight.w600)
      .color(HeroUiTokens.foreground()),
  description: TextStyler()
      .style(HeroUiTokens.textSm.mix())
      .color(HeroUiTokens.muted()),
  footer: FlexBoxStyler()
      .spacing(8)
      .crossAxisAlignment(.center)
      .padding(.symmetric(horizontal: 16, vertical: 12))
      .border(.top(.color(HeroUiTokens.separator()).width(1))),
);

/// The well's line box is 18px at 12px type.
const _wellLineHeight = 1.5;

/// The tallest the output well grows before it scrolls.
const _wellMaxHeight = 200.0;

/// A 16px glyph in quiet gray, unless [size] or [color] say otherwise.
IconStyler _glyph({double? size, Color? color}) =>
    IconStyler().size(size ?? 16).color(color ?? HeroUiTokens.muted());

/// Tool ids, commands and output in the HeroUi monospace face.
TextStyler _mono(TextStyleToken size) => TextStyler()
    .style(size.mix())
    .fontFamily('Menlo')
    .fontFamilyFallback(const ['Consolas', 'monospace'])
    .color(HeroUiTokens.muted());

/// A disclosure with no frame, fill or padding of its own.
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
            .padding(.all(0))
            .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
      )
      .onHovered(.trigger(.color(const Color(0x00000000))))
      .onPressed(.trigger(.color(const Color(0x00000000)))),
);
