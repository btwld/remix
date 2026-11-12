import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/card.dart';
import '../components/composer.dart';
import '../components/icon_button.dart';
import '../components/textfield.dart';

/// Styles for the composer: a card around a text area with no fill of its own,
/// a submit icon button, and a stop icon button.
@immutable
final class PlaygroundAgentComposerRecipe {
  const PlaygroundAgentComposerRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.fieldStyle,
    required this.submitStyle,
    required this.stopStyle,
  });

  /// Styles for the composer toolbar.
  final PlaygroundComposerStyler style;

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
PlaygroundAgentComposerRecipe playgroundAgentComposerRecipe({
  PlaygroundComposerStyler style = const PlaygroundComposerStyler.create(),
  CardStyler surfaceStyle = const CardStyler.create(),
  TextFieldStyler fieldStyle = const TextFieldStyler.create(),
  IconButtonStyler submitStyle = const IconButtonStyler.create(),
  IconButtonStyler stopStyle = const IconButtonStyler.create(),
}) => PlaygroundAgentComposerRecipe(
  style: PlaygroundComposerStyler(
    toolbar: FlexBoxStyler()
        .direction(.horizontal)
        .mainAxisSize(.max)
        .crossAxisAlignment(.center)
        .spacing(8)
        .padding(.top(8)),
  ).merge(style),
  surfaceStyle: playgroundCardStyle(
    style: CardStyler().padding(.all(12)).merge(surfaceStyle),
  ),
  fieldStyle: playgroundTextAreaStyle(
    style: TextFieldStyler()
        .color(const Color(0x00000000))
        .border(.style(.none))
        .minHeight(56)
        .padding(.all(4))
        .merge(fieldStyle),
  ),
  submitStyle: playgroundIconButtonStyle(
    size: .small,
    style: IconButtonStyler().size(36, 36).merge(submitStyle),
  ),
  stopStyle: playgroundIconButtonStyle(
    variant: .destructive,
    size: .small,
    style: IconButtonStyler().size(36, 36).merge(stopStyle),
  ),
);
