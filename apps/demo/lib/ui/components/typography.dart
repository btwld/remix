import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../theme/theme.dart';

/// The nine steps of this design system's text scale, from [FortalTokens].
/// Pixel values are at 100% theme scaling.
enum FortalTextSize {
  /// 12px.
  size1,

  /// 14px.
  size2,

  /// 16px. The default for body text.
  size3,

  /// 18px.
  size4,

  /// 20px.
  size5,

  /// 24px.
  size6,

  /// 28px.
  size7,

  /// 36px.
  size8,

  /// 60px.
  size9,
}

/// The font weights of the text scale.
enum FortalTextWeight {
  /// Light, 300. For large display text.
  light,

  /// Body text.
  regular,

  /// Labels and emphasis.
  medium,

  /// Headings.
  bold,
}

/// The text style token of a [size] on the scale.
TextStyleToken fortalTextSizeToken(FortalTextSize size) => switch (size) {
  .size1 => FortalTokens.text1,
  .size2 => FortalTokens.text2,
  .size3 => FortalTokens.text3,
  .size4 => FortalTokens.text4,
  .size5 => FortalTokens.text5,
  .size6 => FortalTokens.text6,
  .size7 => FortalTokens.text7,
  .size8 => FortalTokens.text8,
  .size9 => FortalTokens.text9,
};

/// The font weight token of a [weight].
FontWeightToken fortalTextWeightToken(FortalTextWeight weight) =>
    switch (weight) {
      .light => FortalTokens.fontWeightLight,
      .regular => FortalTokens.fontWeightRegular,
      .medium => FortalTokens.fontWeightMedium,
      .bold => FortalTokens.fontWeightBold,
    };

/// [truncate] deliberately wins over [softWrap], forcing one ellipsized line.
TextStyler fortalApplyTextFlow(
  TextStyler style, {
  TextAlign? align,
  required bool softWrap,
  required bool truncate,
}) {
  if (align != null) style = style.textAlign(align);
  if (truncate) {
    return style.maxLines(1).softWrap(false).overflow(TextOverflow.ellipsis);
  }

  return style.softWrap(softWrap);
}

/// [style] with the accent's text color, or accent step 12 under
/// [highContrast].
TextStyler fortalAccentForeground(
  TextStyler style, {
  required bool highContrast,
}) => style.color(
  highContrast ? FortalTokens.accent12() : FortalTokens.accentContentAlpha(),
);

/// The text style of [size], resolved against [context].
///
/// Code, Kbd, and Link derive em-relative geometry from the resolved font size,
/// so unlike the other recipes they cannot stay context-free.
TextStyle fortalResolveTextToken(BuildContext context, FortalTextSize size) =>
    MixScope.tokenOf(fortalTextSizeToken(size), context);

Color fortalResolveColor(BuildContext context, ColorToken token) =>
    MixScope.tokenOf(token, context);

/// The theme's radius factor, read back from the resolved `radius1`.
///
/// Derived from the resolved `radius1` rather than duplicating this design
/// system's radius table, so theme radius and scaling changes flow through.
double fortalRadiusFactor(BuildContext context) {
  final scaling = FortalTheme.of(context).scaling.factor;
  final radius = MixScope.tokenOf(FortalTokens.radius1, context);

  return radius.x / (3 * scaling);
}
