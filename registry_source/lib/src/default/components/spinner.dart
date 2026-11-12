import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';

part 'spinner.g.dart';

/// The application's Spinner recipe.
///
/// The standalone spinner: 16px, the size of the icons it sits among (a button
/// draws its own). It is `foreground`, not `primary`, because it usually
/// replaces text and should read at that weight. Set `.size(...)` through
/// [style] for another size.
@MixWidget(target: RemixSpinner.new)
SpinnerStyler vanillaSpinnerStyle({
  SpinnerStyler style = const SpinnerStyler.create(),
}) => SpinnerStyler()
    .size(VanillaTokens.icon)
    .color(VanillaTokens.foreground())
    .duration(const Duration(milliseconds: 800))
    .merge(style);
