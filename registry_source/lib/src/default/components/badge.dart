import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/effects.dart';
import '../theme/scale.dart';
import '../theme/tokens.dart';

part 'badge.g.dart';

/// The visual weights this application offers for a badge.
enum VanillaBadgeVariant {
  /// Highest emphasis: a solid `primary` fill.
  primary,

  /// Medium emphasis: a solid `secondary` fill.
  secondary,

  /// Low emphasis: no fill, with the `border` hairline around it.
  outline,

  /// Highest emphasis for a problem the reader must notice.
  destructive,
}

/// The application's Badge recipe.
///
/// A badge is a static label: no interaction, no states. That is why this
/// recipe has no hover, focus, or disabled fragments — there is nothing to
/// report.
///
/// It takes no size. A badge sits inline beside other content and reads at
/// one scale; a size axis would have to be threaded through every call site
/// for no gain.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it. Because [variant] is a non-nullable
/// enum, the generator also emits one named constructor per enum value:
///
/// ```dart
/// VanillaBadge.destructive(label: 'Failing')
/// ```
@MixWidget(target: RemixBadge.new)
BadgeStyler vanillaBadgeStyle({
  VanillaBadgeVariant variant = .primary,
  BadgeStyler style = const BadgeStyler.create(),
}) => _base().merge(_variantStyle(variant)).merge(style);

/// A radius that rounds any badge into a pill.
const _pill = Radius.circular(VanillaSize.pill);

/// A fill that paints nothing, used by `outline` and by every other variant's
/// outline.
const _noFill = Color(0x00000000);

/// The destructive fill, at 60% in the dark theme: the dark `destructive` is
/// too light to carry a white label as a solid fill.
final _destructiveFill = vanillaTint(
  VanillaTokens.destructive,
  1,
  dark: _darkDestructiveAlpha,
);

/// See [_destructiveFill].
const _darkDestructiveAlpha = 0.6;

/// Geometry and typography shared by every variant: a pill with an 8px side
/// inset and 2px above and below, set in `textXs` at medium weight.
BadgeStyler _base() => BadgeStyler()
    .padding(
      .symmetric(horizontal: VanillaSpace.s2, vertical: VanillaSpace.s0_5),
    )
    .borderRadius(.all(_pill))
    .label(.style(VanillaTokens.textXs.mix()).fontWeight(FontWeight.w500));

BadgeStyler _variantStyle(VanillaBadgeVariant variant) => switch (variant) {
  .primary => _filled(
    fill: VanillaTokens.primary(),
    foreground: VanillaTokens.primaryForeground(),
  ),
  .secondary => _filled(
    fill: VanillaTokens.secondary(),
    foreground: VanillaTokens.secondaryForeground(),
  ),
  .destructive => _filled(
    fill: _destructiveFill(),
    foreground: VanillaTokens.destructiveForeground(),
  ),
  .outline => _filled(
    fill: _noFill,
    foreground: VanillaTokens.foreground(),
    outline: VanillaTokens.border(),
  ),
};

/// One surface, one content color, and the outline.
///
/// Every variant draws the same 1px outline, transparent unless the variant is
/// `outline`: badges of different variants side by side then share one height
/// and one text line.
BadgeStyler _filled({
  required Color fill,
  required Color foreground,
  Color outline = _noFill,
}) => BadgeStyler()
    .color(fill)
    .border(.color(outline).width(VanillaStroke.hairline))
    .label(.color(foreground));
