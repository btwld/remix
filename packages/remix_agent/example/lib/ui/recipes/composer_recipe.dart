import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/card.dart';
import '../components/composer.dart';
import '../components/icon_button.dart';
import '../components/textfield.dart';

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
        .padding(.only(top: 8)),
  ).merge(style),
  surfaceStyle: uiCardStyle(
    style: CardStyler().padding(.all(12)).merge(surfaceStyle),
  ),
  fieldStyle: uiTextAreaStyle(
    style: TextFieldStyler()
        .color(const Color(0x00000000))
        .border(.style(.none))
        .minHeight(56)
        .padding(.all(4))
        .merge(fieldStyle),
  ),
  submitStyle: uiIconButtonStyle(
    size: .small,
    style: IconButtonStyler().size(48, 48).merge(submitStyle),
  ),
  stopStyle: uiIconButtonStyle(
    variant: .destructive,
    size: .small,
    style: IconButtonStyler().size(48, 48).merge(stopStyle),
  ),
);
