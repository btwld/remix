// `DragStartBehavior` and `MaxLengthEnforcement` appear in the generated
// HeroUiTextArea constructor, so they must be visible from this library even
// though nothing here references them directly.
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import 'textfield.dart';

part 'textarea.g.dart';

/// HeroUI recipe for [RemixTextArea]: the text field chrome over several lines.
///
/// `.textarea` repeats `.input` and adds `min-height: 38px`. Unlike the text
/// field, the placeholder wraps: [minLines] and [maxLines] give it the lines
/// the editor shows, so it ellipsizes on the last of them rather than laying
/// out lines the field's box clips away. See [heroUiHintLines].
@MixWidget(target: RemixTextArea.new)
TextFieldStyler heroUiTextAreaStyle({
  HeroUiTextFieldVariant variant = .primary,
  int? maxLines,
  int? minLines = 2,
  TextFieldStyler style = const TextFieldStyler.create(),
}) => heroUiTextFieldStyle(
  variant: variant,
  maxLines: maxLines,
  minLines: minLines,
).minHeight(_minHeight).crossAxisAlignment(.start).merge(style);

/// `.textarea`: `min-height: 38px`; `items-start` is `.input-group:has(textarea)`.
const _minHeight = 38.0;
