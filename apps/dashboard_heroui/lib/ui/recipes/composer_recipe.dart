import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../components/card.dart';
import '../components/composer.dart';
import '../components/textarea.dart';
import '../theme/theme.dart';

/// Styles for the composer: a HeroUI card around a text area with no fill of
/// its own, a primary submit icon button, and a danger stop icon button.
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
        .spacing(8)
        .padding(.top(8)),
  ).merge(style),
  surfaceStyle: uiCardStyle(
    style: CardStyler().padding(.all(12)).merge(surfaceStyle),
  ),
  // The card is the field's surface: the secondary text area, which carries
  // no shadow, with its fill cleared in every state. It keeps its focus ring.
  fieldStyle: uiTextAreaStyle(
    variant: .secondary,
    style: TextFieldStyler()
        .color(UiTokens.transparent)
        .minHeight(56)
        .padding(.all(4))
        .onHovered(.color(UiTokens.transparent))
        .onFocused(.color(UiTokens.transparent))
        .merge(fieldStyle),
  ),
  submitStyle: uiIconButtonStyle(style: submitStyle),
  stopStyle: uiIconButtonStyle(variant: .danger, style: stopStyle),
);
