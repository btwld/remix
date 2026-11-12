import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../components/card.dart';
import '../components/composer.dart';
import '../components/icon_button.dart';
import '../components/textfield.dart';
import '../theme/effects.dart';

@immutable
final class PlaygroundAgentComposerRecipe {
  const PlaygroundAgentComposerRecipe({
    required this.style,
    required this.surfaceStyle,
    required this.fieldStyle,
    required this.submitStyle,
    required this.stopStyle,
  });
  final PlaygroundComposerStyler style;
  final CardStyler surfaceStyle;
  final TextFieldStyler fieldStyle;
  final IconButtonStyler submitStyle;
  final IconButtonStyler stopStyle;
}

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
  // The card is the field's frame: it takes the field's focus border and ring
  // while the field has focus, as shadcn's InputGroup does.
  surfaceStyle: playgroundCardStyle(
    style: CardStyler()
        .padding(.all(12))
        .onFocused(
          CardStyler()
              .border(playgroundFocusBorder())
              .containerEffects(playgroundFocusRing()),
        )
        .merge(surfaceStyle),
  ),
  // So the field inside draws no frame of its own: no border, shadow or ring.
  fieldStyle: playgroundTextAreaStyle(
    style: TextFieldStyler()
        .color(const Color(0x00000000))
        .border(.style(.none))
        .containerEffects(
          .behindContent(RemixBoxEffectLayerMix(shadows: const [])),
        )
        .minHeight(28)
        .padding(.all(4))
        .onFocused(
          .containerEffects(
            RemixBoxEffectsMix(outline: BorderSideMix(style: .none)),
          ),
        )
        .merge(fieldStyle),
  ),
  submitStyle: playgroundIconButtonStyle(
    size: .small,
    style: IconButtonStyler().size(36, 36).merge(submitStyle),
  ),
  // Stop is the send button's neutral twin: red would read as delete and
  // outshout every decision on screen while a run works.
  stopStyle: playgroundIconButtonStyle(
    size: .small,
    style: IconButtonStyler().size(36, 36).merge(stopStyle),
  ),
);
