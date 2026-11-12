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
final class FortalAgentToolCallRecipe {
  const FortalAgentToolCallRecipe({
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
FortalAgentToolCallRecipe fortalAgentToolCallRecipe({
  AgentToolCallStyler style = const AgentToolCallStyler.create(),
  DisclosureStyler disclosureStyle = const DisclosureStyler.create(),
  DataListStyler inputStyle = const DataListStyler.create(),
  ButtonStyler allowOnceStyle = const ButtonStyler.create(),
  ButtonStyler alwaysAllowStyle = const ButtonStyler.create(),
  ButtonStyler denyStyle = const ButtonStyler.create(),
}) => FortalAgentToolCallRecipe(
  style: _row().merge(_status()).merge(_well()).merge(_card()).merge(style),
  disclosureStyle: _quietDisclosure().merge(disclosureStyle),
  inputStyle: fortalDataListStyle(
    style: DataListStyler()
        .rowSpacing(FortalTokens.space1())
        .value(_mono(FortalTokens.text2))
        .merge(inputStyle),
  ),
  allowOnceStyle: fortalButtonStyle(
    variant: .solid,
    size: .size2,
    style: allowOnceStyle,
  ),
  alwaysAllowStyle: fortalButtonStyle(
    variant: .ghost,
    size: .size2,
    style: ButtonStyler()
        .label(.color(FortalTokens.gray11()))
        .merge(alwaysAllowStyle),
  ),
  denyStyle: fortalButtonStyle(
    variant: .outline,
    size: .size2,
    style: denyStyle,
  ),
);

/// The row: tool icon, summary, then the meta with the tool id in monospace.
AgentToolCallStyler _row() => AgentToolCallStyler(
  row: FlexBoxStyler()
      .spacing(FortalTokens.space2())
      .crossAxisAlignment(.center)
      .minHeight(FortalTokens.space6()),
  icon: _glyph(),
  summary: TextStyler()
      .style(FortalTokens.text2.mix())
      .fontWeight(FortalTokens.fontWeightMedium())
      .color(FortalTokens.gray12()),
  meta: TextStyler()
      .style(FortalTokens.text1.mix())
      .color(FortalTokens.gray11()),
  toolId: _mono(FortalTokens.text1),
  indicator: _glyph(),
);

/// The status word and glyph: quiet gray, red when the call failed, and a
/// badge on the approval card.
AgentToolCallStyler _status() =>
    AgentToolCallStyler(
          status: FlexBoxStyler()
              .spacing(FortalTokens.space1())
              .crossAxisAlignment(.center),
          statusIcon: _glyph(size: FortalTokens.space3()),
          statusLabel: TextStyler()
              .style(FortalTokens.text1.mix())
              .fontWeight(FortalTokens.fontWeightMedium())
              .color(FortalTokens.gray11()),
        )
        .onStatus(
          .failed,
          AgentToolCallStyler(
            statusIcon: _glyph(
              size: FortalTokens.space3(),
              color: FortalTokens.error11(),
            ),
            statusLabel: TextStyler().color(FortalTokens.error11()),
          ),
        )
        .onStatus(
          .awaitingApproval,
          AgentToolCallStyler(
            status: FlexBoxStyler()
                .color(FortalTokens.accentA3())
                .borderRadius(.all(FortalTokens.radius1OrFull()))
                .padding(.symmetric(horizontal: FortalTokens.space2()))
                .minHeight(FortalTokens.space5()),
            statusLabel: TextStyler().color(FortalTokens.accent11()),
          ),
        );

/// The output well. Its padding sits on the text, so the tinted failing lines
/// reach the well's edges.
AgentToolCallStyler _well() =>
    AgentToolCallStyler(
      output: BoxStyler()
          .margin(
            .only(left: FortalTokens.space5(), top: FortalTokens.space1()),
          )
          .padding(.vertical(FortalTokens.space2()))
          .color(FortalTokens.gray2())
          .borderRadius(.all(FortalTokens.radius3()))
          .border(
            .all(
              .color(FortalTokens.gray5()).width(FortalTokens.borderWidth1()),
            ),
          ),
      outputMaxHeight: FortalTokens.activityMaxHeight(),
      outputContent: BoxStyler().padding(.horizontal(FortalTokens.space3())),
      outputText: _mono(
        FortalTokens.text1,
      ).color(FortalTokens.gray12()).height(_wellLineHeight),
      error: BoxStyler()
          .color(FortalTokens.error3())
          .padding(.horizontal(FortalTokens.space3())),
      errorText: _mono(
        FortalTokens.text1,
      ).color(FortalTokens.error11()).height(_wellLineHeight),
    ).onStatus(
      .failed,
      AgentToolCallStyler(
        output: BoxStyler().border(.all(.color(FortalTokens.errorA7()))),
      ),
    );

/// The approval card: a flat panel with no shadow, an icon tile beside the
/// question, tool id, description and inputs, and a footer rule above the
/// actions.
AgentToolCallStyler _card() => AgentToolCallStyler(
  card: BoxStyler()
      .color(FortalTokens.colorPanel())
      .borderRadius(.all(FortalTokens.radius5()))
      .clipBehavior(.antiAlias)
      .border(
        .all(.color(FortalTokens.gray6()).width(FortalTokens.borderWidth1())),
      ),
  cardBody: FlexBoxStyler()
      .crossAxisAlignment(.start)
      .spacing(FortalTokens.space3())
      .padding(.all(FortalTokens.space4())),
  cardIcon: BoxStyler()
      .width(FortalTokens.space6())
      .height(FortalTokens.space6())
      .color(FortalTokens.grayA3())
      .borderRadius(.all(FortalTokens.radius4()))
      .alignment(.center),
  cardGlyph: _glyph(color: FortalTokens.gray12()),
  cardContent: FlexBoxStyler().spacing(FortalTokens.space2()),
  cardTitleRow: FlexBoxStyler()
      .spacing(FortalTokens.space2())
      .crossAxisAlignment(.center),
  title: TextStyler()
      .style(FortalTokens.text2.mix())
      .fontWeight(FortalTokens.fontWeightSemibold())
      .color(FortalTokens.gray12()),
  description: TextStyler()
      .style(FortalTokens.text2.mix())
      .color(FortalTokens.gray11()),
  footer: FlexBoxStyler()
      .spacing(FortalTokens.space2())
      .crossAxisAlignment(.center)
      .padding(
        .symmetric(
          horizontal: FortalTokens.space4(),
          vertical: FortalTokens.space3(),
        ),
      )
      .border(
        .top(.color(FortalTokens.gray5()).width(FortalTokens.borderWidth1())),
      ),
);

/// The well's line box is 18px at 12px type.
const _wellLineHeight = 1.5;

/// A 16px glyph in quiet gray, unless [size] or [color] say otherwise.
IconStyler _glyph({double? size, Color? color}) => IconStyler()
    .size(size ?? FortalTokens.space4())
    .color(color ?? FortalTokens.gray11());

/// Tool ids, commands and output in the Fortal monospace face.
TextStyler _mono(TextStyleToken size) => TextStyler()
    .style(size.mix())
    .fontFamily('Menlo')
    .fontFamilyFallback(const ['Consolas', 'monospace'])
    .color(FortalTokens.gray11());

/// A disclosure with no frame, fill or padding of its own.
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
            .padding(.all(0))
            .foregroundDecoration(BoxDecorationMix.border(.style(.none))),
      )
      .onHovered(.trigger(.color(const Color(0x00000000))))
      .onPressed(.trigger(.color(const Color(0x00000000)))),
);
