import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/icon_button.dart';
import '../components/textfield.dart';
import '../theme/tokens.dart';

/// Styles for the composer: a rounded surface holding a text area over a
/// toolbar.
@immutable
final class PlaygroundAgentComposerRecipe {
  const PlaygroundAgentComposerRecipe({
    required this.style,
    required this.fieldStyle,
    required this.submitStyle,
    required this.stopStyle,
  });

  /// Styles for the surface, the field's frame and the toolbar.
  final AgentComposerStyler style;

  /// Styles for the text area, which has no frame of its own.
  final TextFieldStyler fieldStyle;

  /// Styles for the button that sends the message.
  final IconButtonStyler submitStyle;

  /// Styles for the button that stops a running response.
  final IconButtonStyler stopStyle;
}

/// Builds the recipe; each argument is merged last, so callers can override.
///
/// The field grows from one line to 240px inside the shared composer surface.
/// Only that surface draws a frame and responds to focus.
PlaygroundAgentComposerRecipe playgroundAgentComposerRecipe({
  AgentComposerStyler style = const AgentComposerStyler.create(),
  TextFieldStyler fieldStyle = const TextFieldStyler.create(),
  IconButtonStyler submitStyle = const IconButtonStyler.create(),
  IconButtonStyler stopStyle = const IconButtonStyler.create(),
}) => PlaygroundAgentComposerRecipe(
  style:
      AgentComposerStyler(
            container: BoxStyler()
                .color(PlaygroundTokens.muted())
                .borderRadius(.all(PlaygroundTokens.radiusXl()))
                .padding(.all(PlaygroundTokens.s3))
                .border(
                  .all(
                    .color(
                      PlaygroundTokens.input(),
                    ).width(PlaygroundTokens.strokeHairline),
                  ),
                ),
            field: BoxStyler().padding(.horizontal(PlaygroundTokens.s1)),
            fieldMaxHeight: _fieldMaxHeight,
            toolbar: FlexBoxStyler()
                .spacing(PlaygroundTokens.s2)
                .crossAxisAlignment(.center)
                .padding(.top(PlaygroundTokens.s3)),
          )
          .onFocused(
            AgentComposerStyler(
              container: BoxStyler().border(
                .all(.color(PlaygroundTokens.ring())),
              ),
            ),
          )
          .merge(style),
  fieldStyle: playgroundTextAreaStyle(
    style: TextFieldStyler()
        .color(const Color(0x00000000))
        .border(.style(.none))
        .padding(.all(0))
        .minHeight(PlaygroundTokens.s6)
        // The composer owns the surface, including the field's shadow and ring.
        .containerEffects(_noEffects)
        .onFocused(.containerEffects(.outline(.style(.none))))
        .merge(fieldStyle),
  ),
  submitStyle: _round(submitStyle),
  stopStyle: _round(stopStyle),
);

/// The tallest the field grows before it scrolls.
const _fieldMaxHeight = 240.0;

/// A solid, round 32px icon button.
IconButtonStyler _round(IconButtonStyler style) => playgroundIconButtonStyle(
  variant: .primary,
  size: .small,
  style: IconButtonStyler()
      .borderRadius(.circular(PlaygroundTokens.pill))
      .merge(style),
);

/// Empty lists replace the inherited layers rather than merging with them.
final _noEffects = RemixBoxEffectsMix(
  behindContent: _emptyLayer,
  overContent: _emptyLayer,
);

final _emptyLayer = RemixBoxEffectLayerMix(
  gradients: const [],
  gradientInsets: const [],
  shadows: const [],
);
