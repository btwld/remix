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
/// `.textarea` repeats `.input` and adds `min-height: 38px`.
@MixWidget(target: RemixTextArea.new)
TextFieldStyler heroUiTextAreaStyle({
  HeroUiTextFieldVariant variant = .primary,
  TextFieldStyler style = const TextFieldStyler.create(),
}) => heroUiTextFieldStyle(
  variant: variant,
).minHeight(_minHeight).crossAxisAlignment(.start).merge(style);

/// `.textarea`: `min-height: 38px`; `items-start` is `.input-group:has(textarea)`.
const _minHeight = 38.0;
