import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/composer.dart';

import '../components/card.dart';
import '../components/icon_button.dart';
import '../components/textfield.dart';
import '../theme/theme.dart';

/// Styles for the composer: a card around a text area with no fill of its own,
/// a submit icon button, and a stop icon button.
@immutable
final class FortalAgentComposerRecipe {
  const FortalAgentComposerRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.fieldStyle,
    required this.submitStyle,
    required this.stopStyle,
  });

  /// Styles for the composer toolbar.
  final AgentComposerStyler style;

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
  surfaceStyle: fortalCardStyle(
    size: .size2,
    style: CardStyler()
        .padding(.all(FortalTokens.space3()))
        .merge(surfaceStyle),
  ),
  fieldStyle: fortalTextAreaStyle(
    style: TextFieldStyler()
        .color(const Color(0x00000000))
        .border(.style(.none))
        .minHeight(FortalTokens.composerFieldMinHeight())
        .padding(.all(FortalTokens.space1()))
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
    style: IconButtonStyler()
        .color(FortalTokens.error9())
        .size(FortalTokens.space7(), FortalTokens.space7())
        .merge(stopStyle),
  ),
);
