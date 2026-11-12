import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import '../../agent/components/composer.dart';

import '../components/button.dart';
import '../components/card.dart';
import '../components/textarea.dart';
import '../theme/theme.dart';

/// Styles for the composer: a HeroUI card around a text area with no fill of
/// its own, a primary submit icon button, and a danger stop icon button.
@immutable
final class HeroUiAgentComposerRecipe {
  const HeroUiAgentComposerRecipe({
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
HeroUiAgentComposerRecipe heroUiAgentComposerRecipe({
  AgentComposerStyler style = const AgentComposerStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  TextFieldStyler fieldStyle = const TextFieldStyler.create(),
  IconButtonStyler submitStyle = const IconButtonStyler.create(),
  IconButtonStyler stopStyle = const IconButtonStyler.create(),
}) => HeroUiAgentComposerRecipe(
  style: AgentComposerStyler(
    toolbar: FlexBoxStyler()
        .direction(.horizontal)
        .mainAxisSize(.max)
        .crossAxisAlignment(.center)
        .spacing(8)
        .padding(.top(8)),
  ).merge(style),
  surfaceStyle: heroUiCardStyle(
    style: CardStyler().padding(.all(12)).merge(surfaceStyle),
  ),
  // The card is the field's surface: the secondary text area, which carries
  // no shadow, with its fill cleared in every state. It keeps its focus ring.
  fieldStyle: heroUiTextAreaStyle(
    variant: .secondary,
    style: TextFieldStyler()
        .color(HeroUiTokens.transparent)
        .minHeight(56)
        .padding(.all(4))
        .onHovered(.color(HeroUiTokens.transparent))
        .onFocused(.color(HeroUiTokens.transparent))
        .merge(fieldStyle),
  ),
  submitStyle: heroUiIconButtonStyle(style: submitStyle),
  stopStyle: heroUiIconButtonStyle(variant: .danger, style: stopStyle),
);
