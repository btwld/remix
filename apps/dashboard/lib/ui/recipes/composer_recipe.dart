import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/card.dart';
import '../components/composer.dart';
import '../components/icon_button.dart';
import '../components/textfield.dart';
import '../theme/theme.dart';

/// Styles for the composer: a card around a text area with no fill of its own,
/// a submit icon button, and a stop icon button.
@immutable
final class UiAgentComposerRecipe {
  const UiAgentComposerRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.fieldStyle,
    required this.submitStyle,
    required this.stopStyle,
  });

  /// Styles for the composer toolbar.
  final UiComposerStyler style;

  /// Styles for the card around the field and toolbar.
  final CardStyler surfaceStyle;

  /// Styles for the message text area.
  final TextFieldStyler fieldStyle;

  /// Styles for the icon button that sends the message.
  final IconButtonStyler submitStyle;

  /// Styles for the icon button that stops a running response.
  final IconButtonStyler stopStyle;
}

/// Builds the recipe; each argument is merged last, so callers can override.
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
