import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'spinner.g.dart';

/// The sizes a spinner comes in. Pixel values are at 100% theme scaling.
enum FortalSpinnerSize {
  /// 12px.
  size1,

  /// 16px. The default.
  size2,

  /// 20px.
  size3,
}

/// The Fortal Spinner recipe, drawn in the inherited foreground color.
@MixWidget(target: RemixSpinner.new)
SpinnerStyler fortalSpinnerStyle({
  FortalSpinnerSize size = .size2,
  SpinnerStyler style = const SpinnerStyler.create(),
}) {
  return SpinnerStyler(
    opacity: 0.65,
    leafRadius: FortalTokens.radius1(),
    duration: const Duration(milliseconds: 800),
  ).merge(_scale(size)).merge(style);
}

SpinnerStyler _scale(FortalSpinnerSize size) {
  return switch (size) {
    .size1 => SpinnerStyler(size: FortalTokens.space3()),
    .size2 => SpinnerStyler(size: FortalTokens.space4()),
    .size3 => SpinnerStyler(size: FortalTokens.spinnerSize3()),
  };
}
