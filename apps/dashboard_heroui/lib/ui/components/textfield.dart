// `DragStartBehavior` and `MaxLengthEnforcement` appear in the generated
// UiTextField constructor, so they must be visible from this library even
// though nothing here references them directly.
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'textfield.g.dart';

/// HeroUI field variants.
enum UiTextFieldVariant {
  /// The field surface fill, with its shadow.
  primary,

  /// The `default` fill.
  secondary,
}

/// HeroUI recipe for [RemixTextField]: label, input, and description or error.
///
/// Pass [RemixTextField.error] for the error treatment, and the error message
/// as `helperText`; validation stays with the app.
///
/// [minLines] and [maxLines] reach the field itself and the placeholder's line
/// budget, which is why they are named here: see [uiHintLines].
@MixWidget(target: RemixTextField.new)
TextFieldStyler uiTextFieldStyle({
  UiTextFieldVariant variant = .primary,
  int? maxLines = 1,
  int? minLines,
  TextFieldStyler style = const TextFieldStyler.create(),
}) {
  final field = switch (variant) {
    .primary => uiPrimaryFieldFill,
    .secondary => uiSecondaryFieldFill,
  };

  return TextFieldStyler()
      .layout(FlexBoxStyler().spacing(_fieldGap))
      .padding(.horizontal(_paddingX))
      .padding(.vertical(_paddingY))
      .borderRadius(.all(UiTokens.radiusField()))
      .color(field.rest())
      .text(uiFieldText(UiTokens.fieldForeground))
      .hintText(
        uiFieldText(
          UiTokens.fieldPlaceholder,
          lines: uiHintLines(minLines: minLines, maxLines: maxLines),
        ),
      )
      // A browser draws the caret in the text color.
      .cursorColor(UiTokens.fieldForeground())
      .label(uiLabelText)
      .helperText(uiDescriptionText)
      .onHovered(.color(field.hover()))
      .onFocused(
        TextFieldStyler()
            .color(field.focus())
            .containerEffects(uiFocusRing(offset: 0)),
      )
      .animate(UiTokens.smoothMotion)
      .merge(
        variant == .primary
            ? TextFieldStyler().containerEffects(uiSurfaceEffects())
            : null,
      )
      .variant(
        ContextVariant.widgetState(.error),
        TextFieldStyler()
            .color(field.focus())
            .containerEffects(uiInvalidRing())
            .label(.color(UiTokens.danger()))
            .helperText(uiErrorText)
            // `.input:hover:not(:focus)` (0,4,0) beats `.input[data-invalid]`
            // (0,2,0): a hovered invalid field keeps the hover fill.
            .onHovered(.color(field.hover()))
            .onFocused(
              TextFieldStyler()
                  .color(field.focus())
                  .containerEffects(uiInvalidRing(focused: true)),
            ),
      )
      // `status-disabled` dims the input and its label, not the description.
      .onDisabled(
        TextFieldStyler()
            .container(BoxStyler().wrap(.opacity(UiTokens.disabledOpacity)))
            .label(TextStyler().wrap(.opacity(UiTokens.disabledOpacity))),
      )
      .merge(style);
}

/// `.input`: `px-3 py-2`.
const _paddingX = 12.0;
const _paddingY = 8.0;

/// `.textfield`: `gap-1` between label, input, and description.
const _fieldGap = 4.0;
