import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

part 'badge.g.dart';

/// The sizes a badge comes in. Pixel values are at 100% theme scaling.
enum UiBadgeSize {
  /// 12px text with 8px by 2px padding. The default.
  size1,

  /// 12px text with 8px by 4px padding.
  size2,

  /// 14px text with 12px by 4px padding.
  size3,
}

/// The visual weights a badge comes in, from most to least emphasis.
enum UiBadgeVariant {
  /// The accent's solid fill under its contrast label.
  solid,

  /// A tinted accent fill under accent text.
  soft,

  /// A faint accent surface inside a 1px accent frame.
  surface,

  /// No fill inside a 1px accent frame.
  outline,
}

/// The Ui Badge recipe.
///
/// It reads top to bottom: the size, then the variant's colors.
///
/// [highContrast] strengthens a variant: the solid fill, and the text of every
/// other variant, move to accent step 12.
@MixWidget(target: RemixBadge.new)
BadgeStyler uiBadgeStyle({
  UiBadgeVariant variant = .soft,
  UiBadgeSize size = .size1,
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
BadgeStyler _scale(UiBadgeSize size) {
  final (:text, :padding, :radius) = switch (size) {
    .size1 => (
      text: UiTokens.text1,
      padding: EdgeInsetsGeometryMix.symmetric(
        horizontal: UiTokens.space2(),
        vertical: UiTokens.badgePaddingY1(),
      ),
      radius: UiTokens.radius1OrFull(),
    ),
    .size2 => (
      text: UiTokens.text1,
      padding: EdgeInsetsGeometryMix.symmetric(
        horizontal: UiTokens.space2(),
        vertical: UiTokens.space1(),
      ),
      radius: UiTokens.radius2OrFull(),
    ),
    .size3 => (
      text: UiTokens.text2,
      padding: EdgeInsetsGeometryMix.symmetric(
        horizontal: UiTokens.space3(),
        vertical: UiTokens.space1(),
      ),
      radius: UiTokens.radius2OrFull(),
    ),
  };

  return BadgeStyler(
    container: .padding(padding),
    label: .style(text.mix()).fontWeight(UiTokens.fontWeightMedium()),
  ).borderRadius(.all(radius));
}

BadgeStyler _solid(bool highContrast) => BadgeStyler()
    .color(highContrast ? UiTokens.accent12() : UiTokens.accentSolid())
    .labelColor(highContrast ? UiTokens.accent1() : UiTokens.accentContrast());

// Step 11 is this design system's secondary text, not WCAG AA 4.5:1 on
// accentA3 over colorPanelSolid. highContrast promotes accent12.
BadgeStyler _soft(bool highContrast) =>
    BadgeStyler().color(UiTokens.accentA3()).labelColor(_text(highContrast));

BadgeStyler _surface(bool highContrast) => BadgeStyler()
    .color(UiTokens.accentSurface())
    .containerEffects(
      .behindContent(uiInsetSurface(strokes: [UiTokens.accentA6()])),
    )
    .labelColor(_text(highContrast));

BadgeStyler _outline(bool highContrast) => BadgeStyler()
    .containerEffects(
      .behindContent(
        uiInsetSurface(
          strokes: [
            highContrast ? UiTokens.accentA7() : UiTokens.accentA8(),
            if (highContrast) UiTokens.grayA11(),
          ],
        ),
      ),
    )
    .labelColor(_text(highContrast));

/// The label color of every variant but solid.
Color _text(bool highContrast) =>
    highContrast ? UiTokens.accent12() : UiTokens.accentContentAlpha();
