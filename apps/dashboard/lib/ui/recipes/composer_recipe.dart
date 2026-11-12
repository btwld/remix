import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/icon_button.dart';
import '../components/textfield.dart';
import '../theme/theme.dart';

/// Styles for the composer: a rounded surface holding a text area over a
/// toolbar.
@immutable
final class UiAgentComposerRecipe {
  const UiAgentComposerRecipe({
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
/// The surface is a `gray2` panel inside a `controlBorder` frame, with no
/// shadow. It takes the focus color while the field has focus. The field
/// grows from one line to 240px.
UiAgentComposerRecipe uiAgentComposerRecipe({
  AgentComposerStyler style = const AgentComposerStyler.create(),
  TextFieldStyler fieldStyle = const TextFieldStyler.create(),
  IconButtonStyler submitStyle = const IconButtonStyler.create(),
  IconButtonStyler stopStyle = const IconButtonStyler.create(),
}) => UiAgentComposerRecipe(
  style:
      AgentComposerStyler(
            container: BoxStyler()
                .color(UiTokens.gray2())
                .borderRadius(.all(UiTokens.radius6()))
                .padding(.all(UiTokens.space3()))
                .border(
                  .all(
                    .color(
                      UiTokens.controlBorder(),
                    ).width(UiTokens.borderWidth1()),
                  ),
                ),
            field: BoxStyler().padding(.horizontal(UiTokens.space1())),
            fieldMaxHeight: _fieldMaxHeight,
            toolbar: FlexBoxStyler()
                .spacing(UiTokens.space2())
                .crossAxisAlignment(.center)
                .padding(.top(UiTokens.space3())),
          )
          .onFocused(
            AgentComposerStyler(
              container: BoxStyler().border(.all(.color(UiTokens.focus8()))),
            ),
          )
          .merge(style),
  fieldStyle: uiTextAreaStyle(
    size: .size3,
    style: TextFieldStyler()
        .color(const Color(0x00000000))
        .border(.style(.none))
        .padding(.all(0))
        .minHeight(UiTokens.space5())
        // The surface draws the frame and the focus ring, not the field.
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
IconButtonStyler _round(IconButtonStyler style) => uiIconButtonStyle(
  variant: .solid,
  size: .size2,
  style: IconButtonStyler().borderRadius(.circular(_pill)).merge(style),
);

/// Pill corners, whatever radius the theme chooses.
const _pill = 999.0;

/// Empty layers behind and over the field: an explicit empty list replaces the
/// text area's frame, where an unset layer would leave it.
final _noEffects = RemixBoxEffectsMix(
  behindContent: _emptyLayer,
  overContent: _emptyLayer,
);

final _emptyLayer = RemixBoxEffectLayerMix(
  gradients: const [],
  gradientInsets: const [],
  shadows: const [],
);
