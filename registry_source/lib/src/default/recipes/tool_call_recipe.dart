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
final class VanillaAgentToolCallRecipe {
  const VanillaAgentToolCallRecipe({
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
VanillaAgentToolCallRecipe vanillaAgentToolCallRecipe({
  AgentToolCallStyler style = const AgentToolCallStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
  DataListStyler inputStyle = const DataListStyler.create(),
  ButtonStyler allowOnceStyle = const ButtonStyler.create(),
  ButtonStyler alwaysAllowStyle = const ButtonStyler.create(),
  ButtonStyler denyStyle = const ButtonStyler.create(),
}) => VanillaAgentToolCallRecipe(
  style: _row().merge(_status()).merge(_well()).merge(_card()).merge(style),
  disclosureStyle: _quietDisclosure().merge(disclosureStyle),
  inputStyle: vanillaDataListStyle(
    style: DataListStyler()
        .rowSpacing(VanillaTokens.s1)
        .value(_mono(13))
        .merge(inputStyle),
  ),
  allowOnceStyle: vanillaButtonStyle(
    variant: .primary,
    size: .small,
    style: allowOnceStyle,
  ),
  alwaysAllowStyle: vanillaButtonStyle(
    variant: .ghost,
    size: .small,
    style: ButtonStyler()
        .label(.color(VanillaTokens.mutedForeground()))
        .merge(alwaysAllowStyle),
  ),
  denyStyle: vanillaButtonStyle(
    variant: .outline,
    size: .small,
    style: denyStyle,
  ),
);

/// The row: tool icon, summary, then the meta with the tool id in monospace.
AgentToolCallStyler _row() => AgentToolCallStyler(
  row: FlexBoxStyler()
      .spacing(VanillaTokens.s2)
      .crossAxisAlignment(.center)
      .minHeight(VanillaTokens.s8),
  icon: _glyph(),
  summary: TextStyler()
      .style(VanillaTokens.textSm.mix())
      .fontWeight(FontWeight.w500)
      .color(VanillaTokens.foreground()),
  meta: TextStyler()
      .style(VanillaTokens.textXs.mix())
      .color(VanillaTokens.mutedForeground()),
  toolId: _mono(12),
  indicator: _glyph(),
);

/// The status word and glyph: quiet gray, red when the call failed, and a
/// badge on the approval card.
AgentToolCallStyler _status() =>
    AgentToolCallStyler(
          status: FlexBoxStyler()
              .spacing(VanillaTokens.s1)
              .crossAxisAlignment(.center),
          statusIcon: _glyph(size: VanillaTokens.s3),
          statusLabel: TextStyler()
              .style(VanillaTokens.textXs.mix())
              .fontWeight(FontWeight.w500)
              .color(VanillaTokens.mutedForeground()),
        )
        .onStatus(
          .failed,
          AgentToolCallStyler(
            statusIcon: _glyph(
              size: VanillaTokens.s3,
              color: VanillaTokens.destructive(),
            ),
            statusLabel: TextStyler().color(VanillaTokens.destructive()),
          ),
        )
        .onStatus(
          .awaitingApproval,
          AgentToolCallStyler(
            status: FlexBoxStyler()
                .color(VanillaTokens.accent())
                .borderRadius(.all(VanillaTokens.radiusSm()))
                .padding(.symmetric(horizontal: VanillaTokens.s2))
                .minHeight(VanillaTokens.s6),
            statusLabel: TextStyler().color(VanillaTokens.accentForeground()),
          ),
        );

/// The output well. Its padding sits on the text, so the tinted failing lines
/// reach the well's edges.
AgentToolCallStyler _well() =>
    AgentToolCallStyler(
      output: BoxStyler()
          .margin(.only(left: VanillaTokens.s6, top: VanillaTokens.s1))
          .padding(.vertical(VanillaTokens.s2))
          .color(VanillaTokens.muted())
          .borderRadius(.all(VanillaTokens.radiusMd()))
          .border(
            .all(
              .color(
                VanillaTokens.border(),
              ).width(VanillaTokens.strokeHairline),
            ),
          ),
      outputMaxHeight: _wellMaxHeight,
      outputContent: BoxStyler().padding(.horizontal(VanillaTokens.s3)),
      outputText: _mono(
        12,
      ).color(VanillaTokens.foreground()).height(_wellLineHeight),
      error: BoxStyler()
          .color(vanillaTint(VanillaTokens.destructive, 0.1, dark: 0.2)())
          .padding(.horizontal(VanillaTokens.s3)),
      errorText: _mono(
        12,
      ).color(VanillaTokens.destructive()).height(_wellLineHeight),
    ).onStatus(
      .failed,
      AgentToolCallStyler(
        output: BoxStyler().border(.all(.color(VanillaTokens.destructive()))),
      ),
    );

/// The approval card: a flat panel with no shadow, an icon tile beside the
/// question, tool id, description and inputs, and a footer rule above the
/// actions.
AgentToolCallStyler _card() => AgentToolCallStyler(
  card: BoxStyler()
      .color(VanillaTokens.card())
      .borderRadius(.all(VanillaTokens.radiusLg()))
      .clipBehavior(.antiAlias)
      .border(
        .all(
          .color(VanillaTokens.border()).width(VanillaTokens.strokeHairline),
        ),
      ),
  cardBody: FlexBoxStyler()
      .spacing(VanillaTokens.s3)
      .padding(.all(VanillaTokens.s4)),
  cardIcon: BoxStyler()
      .width(VanillaTokens.s8)
      .height(VanillaTokens.s8)
      .color(VanillaTokens.muted())
      .borderRadius(.all(VanillaTokens.radiusMd()))
      .alignment(.center),
  cardGlyph: _glyph(color: VanillaTokens.foreground()),
  cardContent: FlexBoxStyler().spacing(VanillaTokens.s2),
  cardTitleRow: FlexBoxStyler()
      .spacing(VanillaTokens.s2)
      .crossAxisAlignment(.center),
  title: TextStyler()
      .style(VanillaTokens.textSm.mix())
      .fontWeight(FontWeight.w600)
      .color(VanillaTokens.foreground()),
  description: TextStyler()
      .style(VanillaTokens.textSm.mix())
      .color(VanillaTokens.mutedForeground()),
  footer: FlexBoxStyler()
      .spacing(VanillaTokens.s2)
      .crossAxisAlignment(.center)
      .padding(
        .symmetric(horizontal: VanillaTokens.s4, vertical: VanillaTokens.s3),
      )
      .border(
        .top(
          .color(VanillaTokens.border()).width(VanillaTokens.strokeHairline),
        ),
      ),
);

/// The well's line box is 18px at 12px type.
const _wellLineHeight = 1.5;

/// The tallest the output well grows before it scrolls.
const _wellMaxHeight = 200.0;

/// A 16px glyph in quiet gray, unless [size] or [color] say otherwise.
IconStyler _glyph({double? size, Color? color}) => IconStyler()
    .size(size ?? VanillaTokens.s4)
    .color(color ?? VanillaTokens.mutedForeground());

/// Tool ids, commands and output in the Vanilla monospace face at [size].
TextStyler _mono(double size) => TextStyler()
    .style(VanillaTokens.textMono.mix())
    .fontSize(size)
    .color(VanillaTokens.mutedForeground());

/// A disclosure with no frame, fill or padding of its own.
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
            .padding(.all(0))
            .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
      )
      .onHovered(.trigger(.color(const Color(0x00000000))))
      .onPressed(.trigger(.color(const Color(0x00000000)))),
);
