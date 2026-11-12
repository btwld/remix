import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';
import '../components/textarea.dart';
import '../theme/theme.dart';

/// Styles for the composer: a rounded surface holding a text area over a
/// toolbar.
@immutable
final class HeroUiAgentComposerRecipe {
  const HeroUiAgentComposerRecipe({
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
HeroUiAgentComposerRecipe heroUiAgentComposerRecipe({
  AgentComposerStyler style = const AgentComposerStyler.create(),
  TextFieldStyler fieldStyle = const TextFieldStyler.create(),
  IconButtonStyler submitStyle = const IconButtonStyler.create(),
  IconButtonStyler stopStyle = const IconButtonStyler.create(),
}) => HeroUiAgentComposerRecipe(
  style:
      AgentComposerStyler(
            container: BoxStyler()
                .color(HeroUiTokens.surfaceSecondary())
                .borderRadius(.all(HeroUiTokens.radius2xl()))
                .padding(.all(12))
                .border(.all(.color(HeroUiTokens.fieldBorder()).width(1))),
            field: BoxStyler().padding(.horizontal(4)),
            fieldMaxHeight: _fieldMaxHeight,
            toolbar: FlexBoxStyler()
                .spacing(8)
                .crossAxisAlignment(.center)
                .padding(.top(12)),
          )
          .onFocused(
            AgentComposerStyler(
              container: BoxStyler().border(.all(.color(HeroUiTokens.focus()))),
            ),
          )
          .merge(style),
  fieldStyle: heroUiTextAreaStyle(
    variant: .secondary,
    minLines: 1,
    style: TextFieldStyler()
        .color(const Color(0x00000000))
        .border(.style(.none))
        .padding(.all(0))
        .minHeight(24)
        // The composer owns the surface, including the field's shadow and ring.
        .containerEffects(_noEffects)
        .onHovered(.color(const Color(0x00000000)))
        .onFocused(
          TextFieldStyler()
              .color(const Color(0x00000000))
              .containerEffects(.outline(.style(.none))),
        )
        .merge(fieldStyle),
  ),
  submitStyle: _round(submitStyle),
  stopStyle: _round(stopStyle),
);

/// The tallest the field grows before it scrolls.
const _fieldMaxHeight = 240.0;

/// A solid, round 32px icon button.
IconButtonStyler _round(IconButtonStyler style) => heroUiIconButtonStyle(
  variant: .primary,
  size: .sm,
  style: IconButtonStyler()
      .borderRadius(.all(HeroUiTokens.radius4xl()))
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
