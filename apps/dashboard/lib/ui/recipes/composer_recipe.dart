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
  surfaceStyle: uiCardStyle(
    size: .size2,
    style: CardStyler().padding(.all(UiTokens.space3())).merge(surfaceStyle),
  ),
  fieldStyle: uiTextAreaStyle(
    style: TextFieldStyler()
        .color(const Color(0x00000000))
        .border(.style(.none))
        .minHeight(UiTokens.composerFieldMinHeight())
        .padding(.all(UiTokens.space1()))
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
