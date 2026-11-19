import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/tokens.dart';

part 'code.g.dart';

/// The application's Code recipe: a short run of inline code.
///
/// `textMono`, 14px on a 20px line, at semibold weight in `foreground`, on a
/// `muted` chip with 4px beside the text, 2px above and below, and corners of
/// at most 4px. In running text it sits in a `WidgetSpan`, which does not pass
/// its paragraph's style down, so the recipe sets every value itself:
///
/// ```dart
/// Text.rich(
///   TextSpan(
///     text: 'Install ',
///     children: [
///       WidgetSpan(
///         alignment: PlaceholderAlignment.middle,
///         child: PlaygroundCode('remix_ui_fonts'),
///       ),
///       TextSpan(text: ' first.'),
///     ],
///   ),
/// )
/// ```
///
/// Assistive technology reads the code as plain text: Flutter has no code
/// role.
@MixWidget()
TextStyler playgroundCodeStyle({
  TextStyler style = const TextStyler.create(),
}) => TextStyler()
    .style(PlaygroundTokens.textMono.mix())
    // Geist Mono ships 400 and 500, so the reference's 600 draws at 500
    // until the family has a semibold face.
    .fontWeight(FontWeight.w600)
    .color(PlaygroundTokens.foreground())
    .wrap(
      .box(
        BoxStyler()
            .padding(
              .symmetric(
                horizontal: PlaygroundTokens.s1,
                vertical: PlaygroundTokens.s0_5,
              ),
            )
            .borderRadius(.all(_chipRadius()))
            .color(PlaygroundTokens.muted()),
      ),
    )
    .merge(style);

/// The theme's small radius, clamped to 4px: the reference's `rounded` is a
/// fixed 4px, and following the theme below that keeps a square theme square.
///
/// A top-level final because `ContextToken` equality is resolver identity.
final _chipRadius = ContextToken<Radius>((context) {
  final radius = PlaygroundTokens.radiusSm.resolve(context);

  return Radius.elliptical(math.min(radius.x, 4), math.min(radius.y, 4));
});
