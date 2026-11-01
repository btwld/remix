// `DragStartBehavior` and `MaxLengthEnforcement` appear in the generated
// HeroUiInputGroup constructor, so they must be visible from this library even
// though nothing here references them directly.
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';
import 'textfield.dart';

part 'input_group.g.dart';

/// HeroUI recipe for [RemixTextField] with a prefix and suffix, passed as
/// `leading` and `trailing`.
///
/// `.input-group` shares the text field chrome; the prefix and suffix are
/// `px-3` boxes whose `text-field-placeholder` color reaches text and icons.
@MixWidget(target: RemixTextField.new)
TextFieldStyler heroUiInputGroupStyle({
  HeroUiTextFieldVariant variant = .primary,
  int? maxLines = 1,
  int? minLines,
  TextFieldStyler style = const TextFieldStyler.create(),
}) =>
    heroUiTextFieldStyle(
          variant: variant,
          maxLines: maxLines,
          minLines: minLines,
        )
        .minHeight(_minHeight)
        .spacing(_accessoryGap)
        .wrap(
          .defaultText(
            TextStyler()
                .style(HeroUiTokens.textSm.mix())
                .color(HeroUiTokens.fieldPlaceholder()),
          ),
        )
        .wrap(.iconTheme(color: HeroUiTokens.fieldPlaceholder()))
        .merge(style);

/// `.input-group`: `min-h-9`.
const _minHeight = 36.0;

/// The prefix and suffix's `px-3` against the input's `ps-0` and `pe-0`.
const _accessoryGap = 12.0;
