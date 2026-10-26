// `DragStartBehavior` and `MaxLengthEnforcement` appear in the generated
// HeroUiTextField constructor, so they must be visible from this library even
// though nothing here references them directly.
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'textfield.g.dart';

/// HeroUI field variants: `primary` on the field surface with its shadow,
/// `secondary` on the default fill.
enum HeroUiTextFieldVariant { primary, secondary }

/// HeroUI recipe for [RemixTextField]: label, input, and description or error.
///
/// Pass [RemixTextField.error] for the error treatment, and the error message
/// as `helperText`; validation stays with the app.
@MixWidget(target: RemixTextField.new)
TextFieldStyler heroUiTextFieldStyle({
  HeroUiTextFieldVariant variant = .primary,
  TextFieldStyler style = const TextFieldStyler.create(),
}) {
  final field = switch (variant) {
    .primary => heroUiPrimaryFieldFill,
    .secondary => heroUiSecondaryFieldFill,
  };

  var result = TextFieldStyler()
      .layout(FlexBoxStyler().spacing(_fieldGap))
      .padding(.horizontal(_paddingX))
      .padding(.vertical(_paddingY))
      .borderRadius(.all(HeroUiTokens.radiusField()))
      .color(field.rest())
      .text(heroUiFieldText(HeroUiTokens.fieldForeground))
      .hintText(heroUiFieldText(HeroUiTokens.fieldPlaceholder))
      // A browser draws the caret in the text color.
      .cursorColor(HeroUiTokens.fieldForeground())
      .label(heroUiLabelText)
      .helperText(heroUiDescriptionText)
      .onHovered(.color(field.hover()))
      .onFocused(
        TextFieldStyler()
            .color(field.focus())
            .containerEffects(heroUiFocusRing(offset: 0)),
      )
      .animate(HeroUiTokens.smoothMotion);

  if (variant == .primary) {
    result = result.containerEffects(heroUiSurfaceEffects());
  }

  return result
      .variant(
        ContextVariant.widgetState(.error),
        TextFieldStyler()
            .color(field.focus())
            .containerEffects(heroUiInvalidRing())
            .label(.color(HeroUiTokens.danger()))
            .helperText(heroUiErrorText)
            // `.input:hover:not(:focus)` (0,4,0) beats `.input[data-invalid]`
            // (0,2,0): a hovered invalid field keeps the hover fill.
            .onHovered(.color(field.hover()))
            .onFocused(
              TextFieldStyler()
                  .color(field.focus())
                  .containerEffects(heroUiInvalidRing(focused: true)),
            ),
      )
      // `status-disabled` dims the input and its label, not the description.
      .onDisabled(
        TextFieldStyler()
            .container(BoxStyler().wrap(.opacity(HeroUiTokens.disabledOpacity)))
            .label(TextStyler().wrap(.opacity(HeroUiTokens.disabledOpacity))),
      )
      .merge(style);
}

/// `.input`: `px-3 py-2`.
const _paddingX = 12.0;
const _paddingY = 8.0;

/// `.textfield`: `gap-1` between label, input, and description.
const _fieldGap = 4.0;
