import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/card.dart';
import '../components/composer.dart';
import '../components/icon_button.dart';
import '../components/textfield.dart';
import '../theme/theme.dart';

@immutable
final class UiAgentComposerRecipe {
  const UiAgentComposerRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.fieldStyle,
    required this.submitStyle,
    required this.stopStyle,
  });
  final UiComposerStyler style;
  final CardStyler surfaceStyle;
  final TextFieldStyler fieldStyle;
  final IconButtonStyler submitStyle;
  final IconButtonStyler stopStyle;
}

UiAgentComposerRecipe uiAgentComposerRecipe({
  UiComposerStyler style = const UiComposerStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  TextFieldStyler fieldStyle = const TextFieldStyler.create(),
  IconButtonStyler submitStyle = const IconButtonStyler.create(),
  IconButtonStyler stopStyle = const IconButtonStyler.create(),
}) => UiAgentComposerRecipe(
  style: UiComposerStyler(
    toolbar: FlexBoxStyler()
        .direction(.horizontal)
        .mainAxisSize(.max)
        .crossAxisAlignment(.center)
        .spacing(UiTokens.space2())
        .padding(.top(UiTokens.space2())),
  ).merge(style),
  // The card is the field's frame: it rings while the field has focus, as a
  // text input rings its own frame.
  surfaceStyle: uiCardStyle(
    size: .size2,
    style: CardStyler()
        .padding(.all(UiTokens.space3()))
        .onFocused(.containerEffects(uiFocusOutline()))
        .merge(surfaceStyle),
  ),
  // So the field inside draws no frame of its own: the text area's inset
  // stroke, focus ring and disabled well would nest a second frame inside
  // the card.
  fieldStyle: uiTextAreaStyle(
    style: TextFieldStyler()
        .color(const Color(0x00000000))
        .border(.style(.none))
        .containerEffects(_noFieldFrame)
        .minHeight(UiTokens.composerFieldMinHeight())
        .padding(.all(UiTokens.space1()))
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
  submitStyle: uiIconButtonStyle(
    size: .size2,
    style: IconButtonStyler()
        .size(UiTokens.space7(), UiTokens.space7())
        .merge(submitStyle),
  ),
  stopStyle: uiIconButtonStyle(
    size: .size2,
    style: IconButtonStyler()
        .color(UiTokens.error9())
        .size(UiTokens.space7(), UiTokens.space7())
        .merge(stopStyle),
  ),
);

final _noFieldFrame = RemixBoxEffectsMix(
  behindContent: RemixBoxEffectLayerMix(gradients: const []),
  overContent: RemixBoxEffectLayerMix(shadows: const []),
);
