import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../components/icon_button.dart';
import '../components/textfield.dart';
import '../theme/tokens.dart';

/// Styles for the composer: a rounded surface holding a text area over a
/// toolbar.
@immutable
final class VanillaAgentComposerRecipe {
  const VanillaAgentComposerRecipe({
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
VanillaAgentComposerRecipe vanillaAgentComposerRecipe({
  AgentComposerStyler style = const AgentComposerStyler.create(),
  TextFieldStyler fieldStyle = const TextFieldStyler.create(),
  IconButtonStyler submitStyle = const IconButtonStyler.create(),
  IconButtonStyler stopStyle = const IconButtonStyler.create(),
}) => VanillaAgentComposerRecipe(
  style:
      AgentComposerStyler(
            container: BoxStyler()
                .color(VanillaTokens.muted())
                .borderRadius(.all(VanillaTokens.radiusXl()))
                .padding(.all(VanillaTokens.s3))
                .border(
                  .all(
                    .color(
                      VanillaTokens.input(),
                    ).width(VanillaTokens.strokeHairline),
                  ),
                ),
            field: BoxStyler().padding(.horizontal(VanillaTokens.s1)),
            fieldMaxHeight: _fieldMaxHeight,
            toolbar: FlexBoxStyler()
                .spacing(VanillaTokens.s2)
                .crossAxisAlignment(.center)
                .padding(.top(VanillaTokens.s3)),
          )
          .onFocused(
            AgentComposerStyler(
              container: BoxStyler().border(.all(.color(VanillaTokens.ring()))),
            ),
          )
          .merge(style),
  fieldStyle: vanillaTextAreaStyle(
    style: TextFieldStyler()
        .color(const Color(0x00000000))
        .border(.style(.none))
        .padding(.all(0))
        .minHeight(VanillaTokens.s6)
        .merge(fieldStyle),
  ),
  submitStyle: _round(submitStyle),
  stopStyle: _round(stopStyle),
);

/// The tallest the field grows before it scrolls.
const _fieldMaxHeight = 240.0;

/// A solid, round 32px icon button.
IconButtonStyler _round(IconButtonStyler style) => vanillaIconButtonStyle(
  variant: .primary,
  size: .small,
  style: IconButtonStyler()
      .borderRadius(.circular(VanillaTokens.pill))
      .merge(style),
);
