import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'spinner.g.dart';

/// The sizes a spinner comes in. Pixel values are at 100% theme scaling.
enum UiSpinnerSize {
  /// 12px.
  size1,

  /// 16px. The default.
  size2,

  /// 20px.
  size3,
}

/// The Ui Spinner recipe, drawn in the inherited foreground color.
@MixWidget(target: RemixSpinner.new)
SpinnerStyler uiSpinnerStyle({
  UiSpinnerSize size = .size2,
  SpinnerStyler style = const SpinnerStyler.create(),
}) {
  return SpinnerStyler(
    opacity: 0.65,
    leafRadius: UiTokens.radius1(),
    duration: const Duration(milliseconds: 800),
  ).merge(_scale(size)).merge(style);
}

SpinnerStyler _scale(UiSpinnerSize size) {
  return switch (size) {
    .size1 => SpinnerStyler(size: UiTokens.space3()),
    .size2 => SpinnerStyler(size: UiTokens.space4()),
    .size3 => SpinnerStyler(size: UiTokens.spinnerSize3()),
  };
}
