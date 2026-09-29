import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/scale.dart';
import '../theme/tokens.dart';

part 'spinner.g.dart';

/// The application's Spinner recipe.
///
/// The spinner is the one component here that is pure motion: Remix owns the
/// eight-leaf geometry, the animation, and the progress semantics, and this
/// recipe supplies only its size, color, and tempo.
///
/// The content color is `foreground` rather than `primary`. A spinner most
/// often replaces text while something loads, so it should read at the same
/// weight as the text it stands in for.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it.
@MixWidget(target: RemixSpinner.new)
SpinnerStyler vanillaSpinnerStyle({
  SpinnerStyler style = const SpinnerStyler.create(),
}) => SpinnerStyler()
    .size(_diameter)
    .color(VanillaTokens.foreground())
    .duration(_duration)
    .merge(style);

/// One full revolution.
const _duration = Duration(milliseconds: 800);

/// The spinner's diameter, shadcn's `size-4`.
///
/// One size, not a scale. A button draws its own spinner from the button
/// recipe, so this is the standalone case — inline beside a label, or centred
/// in a panel — and 16 is the size of the icons it sits among. A call site
/// that needs another sets `.size(...)` through [style].
const _diameter = VanillaSize.icon;
