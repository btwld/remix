import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../components/data_list.dart';
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
/// It reads top to bottom: the row, the status for each outcome, the output
/// well, then the approval card. The row paints 32px tall inside the
/// disclosure's 40px touch target. The well is a `gray2` panel with a `gray5`
/// edge that scrolls past `activityMaxHeight`; a failed call frames it in
/// `errorA7` and tints only the failing lines, which the call reports as its
/// error.
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
  inputStyle: uiDataListStyle(
    style: DataListStyler()
        .rowSpacing(UiTokens.space1())
        .value(_mono(UiTokens.text2))
        .merge(inputStyle),
  ),
  allowOnceStyle: uiButtonStyle(
    variant: .solid,
    size: .size2,
    style: allowOnceStyle,
  ),
  alwaysAllowStyle: uiButtonStyle(
    variant: .ghost,
    size: .size2,
    style: ButtonStyler()
        .label(.color(UiTokens.gray11()))
        .merge(alwaysAllowStyle),
  ),
  denyStyle: uiButtonStyle(variant: .outline, size: .size2, style: denyStyle),
);

/// The row: tool icon, summary, then the meta with the tool id in monospace.
AgentToolCallStyler _row() => AgentToolCallStyler(
  row: FlexBoxStyler()
      .spacing(UiTokens.space2())
      .crossAxisAlignment(.center)
      .minHeight(UiTokens.space6()),
  icon: _glyph(),
  summary: TextStyler()
      .style(UiTokens.text2.mix())
      .fontWeight(UiTokens.fontWeightMedium())
      .color(UiTokens.gray12()),
  meta: TextStyler().style(UiTokens.text1.mix()).color(UiTokens.gray11()),
  toolId: _mono(UiTokens.text1),
  indicator: _glyph(),
);

/// The status word and glyph: quiet gray, red when the call failed, and a
/// badge on the approval card.
AgentToolCallStyler _status() =>
    AgentToolCallStyler(
          status: FlexBoxStyler()
              .spacing(UiTokens.space1())
              .crossAxisAlignment(.center),
          statusIcon: _glyph(size: UiTokens.space3()),
          statusLabel: TextStyler()
              .style(UiTokens.text1.mix())
              .fontWeight(UiTokens.fontWeightMedium())
              .color(UiTokens.gray11()),
        )
        .onStatus(
          .failed,
          AgentToolCallStyler(
            statusIcon: _glyph(
              size: UiTokens.space3(),
              color: UiTokens.error11(),
            ),
            statusLabel: TextStyler().color(UiTokens.error11()),
          ),
        )
        .onStatus(
          .awaitingApproval,
          AgentToolCallStyler(
            status: FlexBoxStyler()
                .color(UiTokens.accentA3())
                .borderRadius(.all(UiTokens.radius1OrFull()))
                .padding(.symmetric(horizontal: UiTokens.space2()))
                .minHeight(UiTokens.space5()),
            statusLabel: TextStyler().color(UiTokens.accent11()),
          ),
        );

/// The output well. Its padding sits on the text, so the tinted failing lines
/// reach the well's edges.
AgentToolCallStyler _well() =>
    AgentToolCallStyler(
      output: BoxStyler()
          .margin(.only(left: UiTokens.space5(), top: UiTokens.space1()))
          .padding(.vertical(UiTokens.space2()))
          .color(UiTokens.gray2())
          .borderRadius(.all(UiTokens.radius3()))
          .border(
            .all(.color(UiTokens.gray5()).width(UiTokens.borderWidth1())),
          ),
      outputMaxHeight: UiTokens.activityMaxHeight(),
      outputContent: BoxStyler().padding(.horizontal(UiTokens.space3())),
      outputText: _mono(
        UiTokens.text1,
      ).color(UiTokens.gray12()).height(_wellLineHeight),
      error: BoxStyler()
          .color(UiTokens.error3())
          .padding(.horizontal(UiTokens.space3())),
      errorText: _mono(
        UiTokens.text1,
      ).color(UiTokens.error11()).height(_wellLineHeight),
    ).onStatus(
      .failed,
      AgentToolCallStyler(
        output: BoxStyler().border(.all(.color(UiTokens.errorA7()))),
      ),
    );

/// The approval card: a flat panel with no shadow, an icon tile beside the
/// question, tool id, description and inputs, and a footer rule above the
/// actions.
AgentToolCallStyler _card() => AgentToolCallStyler(
  card: BoxStyler()
      .color(UiTokens.colorPanel())
      .borderRadius(.all(UiTokens.radius5()))
      .clipBehavior(.antiAlias)
      .border(.all(.color(UiTokens.gray6()).width(UiTokens.borderWidth1()))),
  cardBody: FlexBoxStyler()
      .crossAxisAlignment(.start)
      .spacing(UiTokens.space3())
      .padding(.all(UiTokens.space4())),
  cardIcon: BoxStyler()
      .width(UiTokens.space6())
      .height(UiTokens.space6())
      .color(UiTokens.grayA3())
      .borderRadius(.all(UiTokens.radius4()))
      .alignment(.center),
  cardGlyph: _glyph(color: UiTokens.gray12()),
  cardContent: FlexBoxStyler().spacing(UiTokens.space2()),
  cardTitleRow: FlexBoxStyler()
      .spacing(UiTokens.space2())
      .crossAxisAlignment(.center),
  title: TextStyler()
      .style(UiTokens.text2.mix())
      .fontWeight(UiTokens.fontWeightSemibold())
      .color(UiTokens.gray12()),
  description: TextStyler()
      .style(UiTokens.text2.mix())
      .color(UiTokens.gray11()),
  footer: FlexBoxStyler()
      .spacing(UiTokens.space2())
      .crossAxisAlignment(.center)
      .padding(
        .symmetric(horizontal: UiTokens.space4(), vertical: UiTokens.space3()),
      )
      .border(.top(.color(UiTokens.gray5()).width(UiTokens.borderWidth1()))),
);

/// The well's line box is 18px at 12px type.
const _wellLineHeight = 1.5;

/// A 16px glyph in quiet gray, unless [size] or [color] say otherwise.
IconStyler _glyph({double? size, Color? color}) => IconStyler()
    .size(size ?? UiTokens.space4())
    .color(color ?? UiTokens.gray11());

/// Tool ids, commands and output in the Ui monospace face.
TextStyler _mono(TextStyleToken size) => TextStyler()
    .style(size.mix())
    .fontFamily('Menlo')
    .fontFamilyFallback(const ['Consolas', 'monospace'])
    .color(UiTokens.gray11());

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
