// `DragStartBehavior` and `MaxLengthEnforcement` appear in the generated
// DeuiTextField constructor, so they must be visible from this library even
// though nothing here references them directly.
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'textfield.g.dart';

/// Deui recipe for [RemixTextField]: label, input, and description or error.
///
/// Pass [RemixTextField.error] for the error treatment, and the error message
/// as `helperText`; validation stays with the app.
///
/// [minLines] and [maxLines] reach the field itself and the placeholder's line
/// budget, which is why they are named here: see [deuiHintLines].
/// Deui recipe for [RemixTextField]: a 44px pill with a hairline border that
/// darkens to `foreground` at 40% on focus.
///
/// A field with more than one line takes a 16px corner instead of the pill.
/// [style] merges last.
@MixWidget(target: RemixTextField.new)
TextFieldStyler deuiTextFieldStyle({
  int? maxLines = 1,
  int? minLines,
  TextFieldStyler style = const TextFieldStyler.create(),
}) {
  final single = maxLines == 1;

  return TextFieldStyler()
      .layout(FlexBoxStyler().spacing(_fieldGap))
      .padding(.symmetric(horizontal: _paddingX, vertical: _paddingY))
      .minHeight(single ? _minHeight : 0)
      .borderRadius(.circular(single ? _pill : _panel))
      .color(DeuiTokens.fieldBackground())
      .border(.color(DeuiTokens.border()).width(1))
      .text(deuiFieldText(DeuiTokens.fieldForeground))
      .hintText(
        deuiFieldText(
          DeuiTokens.fieldPlaceholder,
          lines: deuiHintLines(minLines: minLines, maxLines: maxLines),
        ),
      )
      .cursorColor(DeuiTokens.fieldForeground())
      .label(deuiLabelText)
      .helperText(deuiDescriptionText)
      .onHovered(.color(DeuiTokens.fieldHover()))
      .onFocused(
        TextFieldStyler().border(
          .color(DeuiTokens.fieldBorderFocus()).width(1),
        ),
      )
      .animate(DeuiTokens.smoothMotion)
      .variant(
        ContextVariant.widgetState(.error),
        TextFieldStyler()
            .border(.color(DeuiTokens.danger()).width(1))
            .label(.color(DeuiTokens.danger()))
            .helperText(deuiErrorText),
      )
      .onDisabled(
        TextFieldStyler()
            .text(TextStyler().color(DeuiTokens.muted()))
            .wrap(.opacity(DeuiTokens.disabledOpacity)),
      )
      .merge(style);
}

const _paddingX = 14.0;
const _paddingY = 9.0;
const _minHeight = 44.0;
const _pill = 999.0;
const _panel = 16.0;
const _fieldGap = 4.0;
