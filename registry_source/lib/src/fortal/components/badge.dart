import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'badge.g.dart';

/// The sizes a badge comes in. Pixel values are at 100% theme scaling.
enum FortalBadgeSize {
  /// 12px text with 8px by 2px padding. The default.
  size1,

  /// 12px text with 8px by 4px padding.
  size2,

  /// 14px text with 12px by 4px padding.
  size3,
}

/// The visual weights a badge comes in, from most to least emphasis.
enum FortalBadgeVariant {
  /// The accent's solid fill under its contrast label.
  solid,

  /// A tinted accent fill under accent text.
  soft,

  /// A faint accent surface inside a 1px accent frame.
  surface,

  /// No fill inside a 1px accent frame.
  outline,
}

/// The Fortal Badge recipe.
///
/// It reads top to bottom: the size, then the variant's colors.
///
/// [highContrast] strengthens a variant: the solid fill, and the text of every
/// other variant, move to accent step 12.
@MixWidget(target: RemixBadge.new)
BadgeStyler fortalBadgeStyle({
  FortalBadgeVariant variant = .soft,
  FortalBadgeSize size = .size1,
  bool highContrast = false,
  BadgeStyler style = const BadgeStyler.create(),
}) => _scale(size)
    .merge(switch (variant) {
      .solid => _solid(highContrast),
      .soft => _soft(highContrast),
      .surface => _surface(highContrast),
      .outline => _outline(highContrast),
    })
    .merge(style);

/// The text, padding and corner size of each step.
BadgeStyler _scale(FortalBadgeSize size) {
  final (:text, :padding, :radius) = switch (size) {
    .size1 => (
      text: FortalTokens.text1,
      padding: EdgeInsetsGeometryMix.symmetric(
        horizontal: FortalTokens.space2(),
        vertical: FortalTokens.badgePaddingY1(),
      ),
      radius: FortalTokens.radius1OrFull(),
    ),
    .size2 => (
      text: FortalTokens.text1,
      padding: EdgeInsetsGeometryMix.symmetric(
        horizontal: FortalTokens.space2(),
        vertical: FortalTokens.space1(),
      ),
      radius: FortalTokens.radius2OrFull(),
    ),
    .size3 => (
      text: FortalTokens.text2,
      padding: EdgeInsetsGeometryMix.symmetric(
        horizontal: FortalTokens.space3(),
        vertical: FortalTokens.space1(),
      ),
      radius: FortalTokens.radius2OrFull(),
    ),
  };

  return BadgeStyler(
    container: .padding(padding),
    label: .style(text.mix()).fontWeight(FortalTokens.fontWeightMedium()),
  ).borderRadius(.all(radius));
}

BadgeStyler _solid(bool highContrast) => BadgeStyler()
    .color(highContrast ? FortalTokens.accent12() : FortalTokens.accentSolid())
    .labelColor(
      highContrast ? FortalTokens.accent1() : FortalTokens.accentContrast(),
    );

// Step 11 is this design system's secondary text, not WCAG AA 4.5:1 on
// accentA3 over colorPanelSolid. highContrast promotes accent12.
BadgeStyler _soft(bool highContrast) => BadgeStyler()
    .color(FortalTokens.accentA3())
    .labelColor(_text(highContrast));

BadgeStyler _surface(bool highContrast) => BadgeStyler()
    .color(FortalTokens.accentSurface())
    .containerEffects(
      .behindContent(fortalInsetSurface(strokes: [FortalTokens.accentA6()])),
    )
    .labelColor(_text(highContrast));

BadgeStyler _outline(bool highContrast) => BadgeStyler()
    .containerEffects(
      .behindContent(
        fortalInsetSurface(
          strokes: [
            highContrast ? FortalTokens.accentA7() : FortalTokens.accentA8(),
            if (highContrast) FortalTokens.grayA11(),
          ],
        ),
      ),
    )
    .labelColor(_text(highContrast));

/// The label color of every variant but solid.
Color _text(bool highContrast) =>
    highContrast ? FortalTokens.accent12() : FortalTokens.accentContentAlpha();
