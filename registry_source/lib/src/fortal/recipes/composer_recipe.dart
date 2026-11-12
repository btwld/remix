import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/composer.dart';

import '../components/card.dart';
import '../components/icon_button.dart';
import '../components/textfield.dart';
import '../theme/theme.dart';

@immutable
final class FortalAgentComposerRecipe {
  const FortalAgentComposerRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.fieldStyle,
    required this.submitStyle,
    required this.stopStyle,
  });
  final AgentComposerStyler style;
  final CardStyler surfaceStyle;
  final TextFieldStyler fieldStyle;
  final IconButtonStyler submitStyle;
  final IconButtonStyler stopStyle;
}

FortalAgentComposerRecipe fortalAgentComposerRecipe({
  AgentComposerStyler style = const AgentComposerStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  TextFieldStyler fieldStyle = const TextFieldStyler.create(),
  IconButtonStyler submitStyle = const IconButtonStyler.create(),
  IconButtonStyler stopStyle = const IconButtonStyler.create(),
}) => FortalAgentComposerRecipe(
  style: AgentComposerStyler(
    toolbar: FlexBoxStyler()
        .direction(.horizontal)
        .mainAxisSize(.max)
        .crossAxisAlignment(.center)
        .spacing(FortalTokens.space2())
        .padding(.top(FortalTokens.space2())),
  ).merge(style),
  // The card is the field's frame: it rings while the field has focus, as a
  // text input rings its own frame.
  surfaceStyle: fortalCardStyle(
    size: .size2,
    style: CardStyler()
        .padding(.all(FortalTokens.space3()))
        .onFocused(.containerEffects(fortalFocusOutline()))
        .merge(surfaceStyle),
  ),
  // So the field inside draws no frame of its own: the text area's inset
  // stroke, focus ring and disabled well would nest a second frame inside
  // the card.
  fieldStyle: fortalTextAreaStyle(
    style: TextFieldStyler()
        .color(const Color(0x00000000))
        .border(.style(.none))
        .containerEffects(_noFieldFrame)
        .minHeight(FortalTokens.composerFieldMinHeight())
        .padding(.all(FortalTokens.space1()))
        .onFocused(
          .containerEffects(
            RemixBoxEffectsMix(outline: BorderSideMix(style: .none)),
          ),
        )
        .onDisabled(
          TextFieldStyler()
              .color(const Color(0x00000000))
              .containerEffects(_noFieldFrame),
        )
        .merge(fieldStyle),
  ),
  submitStyle: fortalIconButtonStyle(
    size: .size2,
    style: IconButtonStyler()
        .size(FortalTokens.space7(), FortalTokens.space7())
        .merge(submitStyle),
  ),
  stopStyle: fortalIconButtonStyle(
    size: .size2,
    // Stop is the send button's neutral twin: red would read as delete and
    // outshout every decision on screen while a run works.
    style: IconButtonStyler()
        .size(FortalTokens.space7(), FortalTokens.space7())
        .merge(stopStyle),
  ),
);

final _noFieldFrame = RemixBoxEffectsMix(
  behindContent: RemixBoxEffectLayerMix(gradients: const []),
  overContent: RemixBoxEffectLayerMix(shadows: const []),
);
